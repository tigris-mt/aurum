local S = minetest.get_translator()

local TICK = 15
local LENGTH = 8
local RARITY = 30

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
		local next = minetest.find_node_near(pos, 1, "aurum_base:regret")
		if next then
			minetest.set_node(next, node)
			minetest.set_node(pos, {name = "aurum_heckweaver:heck"})
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

minetest.register_lbm{
	label = "Activate New Heckweavers",
	name = "aurum_heckweaver:activate",
	nodenames = {"aurum_heckweaver:heckweaver"},
	run_at_every_load = true,
	action = function(pos, node)
		if not minetest.get_node_timer(pos):is_started() then
			minetest.registered_nodes[node.name].on_construct(pos)
		end
	end,
}
