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

function aurum.trees.leafdecay.register_ref(def)
	-- Keep references for both leaves and trunk nodes.
	aurum.trees.leafdecay.types[def.leaves] = def
	aurum.trees.leafdecay.types[def.trunk] = def
end

function aurum.trees.leafdecay.trunk_after_destruct(pos, oldnode)
	local def = aurum.trees.leafdecay.types[oldnode.name]
	local box = aurum.box.new_radius(pos, def.leafdistance)

	for _,pos in ipairs(minetest.find_nodes_in_area(box.a, box.b, def.leaves)) do
		if minetest.get_node(pos).param2 ~= aurum.trees.leafdecay.PLACE_PARAM then
			local timer = minetest.get_node_timer(pos)
			if not timer:is_started() then
				timer:start(math.random() * aurum.trees.leafdecay.MAX_DELAY)
			end
		end
	end
end

function aurum.trees.leafdecay.leaf_on_timer(pos)
	local node = minetest.get_node(pos)
	local def = aurum.trees.leafdecay.types[node.name]

	-- If trunk nearby, do nothing.
	if minetest.find_node_near(pos, def.leafdistance, def.trunk) then
		return
	end

	-- Drop everything except leaf.
	local drops = minetest.get_node_drops(node.name)
	for _,item in ipairs(drops) do
		if item ~= node.name then
			aurum.drop_item(pos, item)
		end
	end

	-- Remove node and update position.
	minetest.remove_node(pos)
	minetest.check_for_falling(pos)
end
