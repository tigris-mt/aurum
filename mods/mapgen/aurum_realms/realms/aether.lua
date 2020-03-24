local S = minetest.get_translator()

screalms.register("aurum:aether", {
	description = S"The Aether",
	size = vector.new(8000, 800, 8000),

	apply_player = function(player)
		local x = math.floor((math.sin(minetest.get_gametime() / 100) + 1) / 2 * 127) + 127
		player:set_sky{
			sky_color = {
				day_sky = ("#%x%xfa"):format(x, x),
				day_horizon = ("#%x%xfa"):format(x, x),
			},
		}
		player:set_clouds{
			speed = {x = 0, z = -40},
			color = ("#%02x%02x00e5"):format(x, x),
		}
		screalms.apply_underground(player)
	end,

	biome_default = {
		node_top = "aurum_base:aether_shell",
		node_filler = "aurum_base:aether_skin",
		node_stone = "aurum_base:aether_flesh",
		node_riverbed = "aurum_base:ground_ice",
		node_water = "aurum_base:aether_source",
		node_river_water = "aurum_base:aether_source",
		node_cave_liquid = "aurum_base:aether_source",
		node_dungeon = "aurum_base:aether_shell",
		node_dungeon_alt = "aurum_base:aether_skin",
		node_dungeon_stair = "aurum_base:aether_shell",
	},
})
