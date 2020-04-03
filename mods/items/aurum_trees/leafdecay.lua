aurum.trees.leafdecay = {
	-- Param2 value used to indicate player-placed.
	PLACE_PARAM = 1,
	-- Maximum delay for leaves to decay.
	MAX_DELAY = 15,
	types = {},
}

-- Accepts table with keys, does not have to be registered Aurum tree
-- Trees should not spawn with leaf nodes further from trunk than the desired decay distance.
-- Keys:
--- trunk: name of trunk node
--- leaves: name of leaves node
--- leafdistance: distance leaves can be from a trunk
--- drop_all: optional, if set then even the node itself will drop, otherwise only alternate drops like saplings will drop

function aurum.trees.leafdecay.register(def)
	minetest.override_item(def.trunk, {
		after_destruct = aurum.trees.leafdecay.trunk_after_destruct,
	})

	minetest.override_item(def.leaves, {
		place_param2 = aurum.trees.leafdecay.PLACE_PARAM,
		on_timer = aurum.trees.leafdecay.leaf_on_timer,
	})

	aurum.trees.leafdecay.register_ref(def)
end

-- Keep references for both leaves and trunk nodes to refer to in callbacks.
function aurum.trees.leafdecay.register_ref(def)
	aurum.trees.leafdecay.types[def.leaves] = def
	aurum.trees.leafdecay.types[def.trunk] = aurum.trees.leafdecay.types[def.trunk] or {}
	table.insert(aurum.trees.leafdecay.types[def.trunk], def)
end

-- When trunk nodes are destroyed, search for leaves that might belong to this trunk and start their check timer.
function aurum.trees.leafdecay.trunk_after_destruct(pos, oldnode)
	for _,def in ipairs(aurum.trees.leafdecay.types[oldnode.name]) do
		local box = b.box.new_radius(pos, def.leafdistance)

		-- Search for all nearby leaves.
		for _,pos in ipairs(minetest.find_nodes_in_area(box.a, box.b, def.leaves)) do
			-- Only trigger when the node was naturally placed.
			if minetest.get_node(pos).param2 ~= aurum.trees.leafdecay.PLACE_PARAM then
				local timer = minetest.get_node_timer(pos)
				-- Don't restart running timers.
				if not timer:is_started() then
					timer:start(math.random() * aurum.trees.leafdecay.MAX_DELAY)
				end
			end
		end
	end
end

-- When leaf timers trigger, check if there is a supporting trunk nearby.
function aurum.trees.leafdecay.leaf_on_timer(pos)
	local node = minetest.get_node(pos)
	local def = aurum.trees.leafdecay.types[node.name]

	-- If trunk nearby, do nothing.
	if minetest.find_node_near(pos, def.leafdistance, def.trunk) then
		return
	end

	-- Drop apprioriate items.
	local drops = minetest.get_node_drops(node.name)
	for _,item in ipairs(drops) do
		if def.drop_all or item ~= node.name then
			aurum.drop_item(pos, item)
		end
	end

	-- Remove node and update position.
	minetest.remove_node(pos)
	minetest.check_for_falling(pos)
end
