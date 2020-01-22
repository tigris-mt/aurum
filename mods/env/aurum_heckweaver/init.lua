local S = minetest.get_translator()

-- How often do heckweavers move?
local TICK = 2
-- How long can heckweavers trails get?
local LENGTH = 8
-- How rare (<RARITY>^3) are heckweavers in regret?
local RARITY = 28

minetest.register_node("aurum_heckweaver:heckweaver", {
	description = S"Heckweaver",
	_doc_items_longdesc = S"A native of the Loom, the Heckweaver swims within the regrets and consumes them.",

	tiles = {"aurum_heckweaver_heckweaver.png"},

	light_source = 5,
	paramtype = "light",

	groups = {dig_chop = 1, level = 3},
	sounds = aurum.sounds.wood(),

	on_construct = function(pos)
		minetest.get_node_timer(pos):start(TICK)
	end,

	on_timer = function(pos)
		local node = minetest.get_node(pos)

		local box = aurum.box.new_radius(pos, 1)

		local list = minetest.find_nodes_in_area(box.a, box.b, {"aurum_base:regret"})
		local filtered = b.t.imap(list, function(v)
			return minetest.find_node_near(v, 1, {"air"}) and v or nil
		end)

		local shuffled = b.t.shuffled(b.t.imap(#filtered > 0 and filtered or list, function(v)
			return vector.distance(pos, v) <= 1 and v or nil
		end))

		-- Find a nearby regret.
		local next = (#shuffled > 0) and shuffled[math.random(#shuffled)]
		if next then
			-- Move heckweaver there.
			minetest.set_node(next, node)
			-- Replace old position with heck.
			minetest.set_node(pos, {name = "aurum_heckweaver:heck"})
			-- Set heck timeout.
			minetest.get_node_timer(pos):start(TICK * LENGTH)
		else
			return true
		end
	end,
})

minetest.register_node("aurum_heckweaver:heck", {
	description = S"Heck",
	_doc_items_longdesc = S"The blindingly glowing excrement of the Heckweaver. In its natural state, it will quickly melt away.",

	tiles = {"aurum_heckweaver_heck.png"},

	light_source = 14,
	paramtype = "light",

	groups = {dig_dig = 2, level = 2},
	sounds = aurum.sounds.dirt(),

	-- Replace with regret on timeout.
	on_timer = function(pos)
		minetest.set_node(pos, {name = "aurum_base:regret"})
	end,
})

minetest.register_ore{
	ore_type = "scatter",
	ore = "aurum_heckweaver:heckweaver",
	wherein = "aurum_base:regret",
	clust_scarcity = math.pow(RARITY, 3),
	clust_num_ores = 1,
	clust_size = 1,
}

-- on_construct isn't naturally called for ore-generated nodes, so we must manually call it if the timer hasn't started.
minetest.register_lbm{
	label = "Activate New Heckweavers",
	name = "aurum_heckweaver:activate",
	nodenames = {"aurum_heckweaver:heckweaver"},
	-- Apparently it didn't get called when run_at_every_load is false.
	run_at_every_load = true,
	action = function(pos, node)
		if not minetest.get_node_timer(pos):is_started() then
			minetest.registered_nodes[node.name].on_construct(pos)
		end
	end,
}
