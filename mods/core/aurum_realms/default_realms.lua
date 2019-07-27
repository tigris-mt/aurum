local S = minetest.get_translator()

aurum.realms.register("aurum:aurum", {
	description = S("Aurum"),
	size = vector.new(8000, 1600, 8000),
})

aurum.realms.register("aurum:loom", {
	description = S("The Loom"),
	size = vector.new(8000, 1600, 8000),

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
