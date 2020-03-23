local S = minetest.get_translator()

aurum.realms.register("aurum:aether", {
	description = S"The Aether",
	size = vector.new(8000, 800, 8000),
})

aurum.realms.register("aurum:aurum", {
	description = S("Aurum"),
	size = vector.new(16000, 1600, 16000),
})

aurum.realms.register("aurum:loom", {
	description = S("The Loom"),
	size = vector.new(8000, 800, 8000),

	apply_player = function(player)
		player:set_sky("#110000", "plain", {})
		player:set_clouds{
			color = "#550000ff",
			speed = {x = 0, z = -200},
			height = 600,
		}

		aurum.realms.check_underground(player, -100, function()
			player:set_sky(0, "plain", {})
			player:set_clouds{density = 0}
		end)
	end,

	biome_default = {
		node_top = "aurum_base:regret",
		node_filler = "aurum_base:regret",
		node_riverbed = "aurum_base:regret",
		node_stone = "aurum_base:regret",
		node_water = "aurum_base:lava_source",
		node_river_water = "aurum_base:lava_source",
		node_cave_liquid = {"aurum_base:lava_source"},
		node_dungeon = "aurum_base:regret_brick",
		node_dungeon_stair = "aurum_base:regret_brick",
	},
})

aurum.realms.register("aurum:primus", {
	description = S"Primus Hortum",
	size = vector.new(16000, 1600, 16000),

	apply_player = function(player)
		player:set_sky("#336633", "plain", {})
		player:set_clouds{
			color = "#004400bb",
			speed = {x = 0, z = -4},
			thickness = 32,
			density = 0.6,
			height = 400,
		}

		aurum.realms.check_underground(player, -100, function()
			player:set_sky(0, "plain", {})
			player:set_clouds{density = 0}
		end)
	end,
})

-- Spreading fire is snuffed out in Primus Hortum.
local old = fire.on_spread
function fire.on_spread(pos)
	if aurum.pos_to_realm(pos) == "aurum:primus" then
		local box = b.box.new_radius(pos, 3)
		for _,fpos in ipairs(minetest.find_nodes_in_area(box.a, box.b, "fire:basic_flame")) do
			minetest.remove_node(fpos)
		end
	end
	old(pos)
end