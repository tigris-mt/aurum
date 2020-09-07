local S = minetest.get_translator()

aurum.effects.register("aurum_realms:aether", {
	description = S"Aether",
	hidden = true,
	groups = {"aurum_realms"},
	apply = function(player)
		player_monoids.gravity:add_change(player, 1.5, "aurum_realms:aether")
		player_monoids.jump:add_change(player, 2, "aurum_realms:aether")
		player_monoids.speed:add_change(player, 2, "aurum_realms:aether")
	end,
	cancel = function(player)
		player_monoids.gravity:del_change(player, "aurum_realms:aether")
		player_monoids.jump:del_change(player, "aurum_realms:aether")
		player_monoids.speed:del_change(player, "aurum_realms:aether")
	end,
})

screalms.register("aurum:aether", {
	description = S"The Aether",
	size = vector.new(8000, 1024, 8000),

	apply_player = function(player)
		local x = math.floor((math.sin(minetest.get_gametime() / 100) + 1) / 2 * 127) + 127
		player:set_sky{
			sky_color = {
				day_sky = "#ffffff",
				day_horizon = "#ffffff",
			},
		}
		player:set_clouds{
			speed = {x = 0, z = -40},
			color = ("#%02x%02xaae5"):format(x, x),
		}
		screalms.apply_underground(player)

		aurum.effects.add(player, "aurum_realms:aether", 1, -1)
	end,

	aurum_dungeon_loot = function(pos)
		return {
			count = math.random(1, 2),
			list = {
				{
					count = math.random(1, 2),
					preciousness = {0, 10},
					groups = {"magic"},
				},
			},
		}
	end,

	aurum_dungeon_chest = function(pos)
		return {
			node = "aurum_storage:shell_box",
			list = "main",
		}
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
		node_dungeon_stair = "aurum_base:aether_shell_sh_stairs",
	},
})
