local S = aurum.get_translator()

minetest.register_craftitem("aurum_chef:salt", {
	description = S"Salt",
	inventory_image = "aurum_chef_salt.png",
})

minetest.register_node("aurum_chef:salt_in_stone", {
	description = S"Salt in Stone",
	tiles = {"aurum_base_stone.png^aurum_chef_salt.png"},
	groups = {dig_pick = 3},
	drop = "aurum_chef:salt",
	after_dig_node = function(pos, _, _, player)
		aurum.player.mana_sparks(player, pos, "digging", 1, 2)
	end,
})

minetest.register_node("aurum_chef:salt_in_regret", {
	description = S"Salt in Regret",
	tiles = {minetest.registered_nodes["aurum_base:regret"].tiles[1] .. "^aurum_chef_salt.png"},
	groups = {dig_pick = 2, level = 2},
	drop = "aurum_chef:salt",
	after_dig_node = function(pos, _, _, player)
		aurum.player.mana_sparks(player, pos, "digging", 1, 2)
	end,
})

minetest.register_ore{
	biomes = b.set.to_array(b.set._or(b.set(aurum.biomes.get_all_group("aurum:aurum")), b.set(aurum.biomes.get_all_group("aurum:primus")))),
	ore_type = "scatter",
	ore = "aurum_chef:salt_in_stone",
	wherein = "aurum_base:stone",
	clust_scarcity = 15 ^ 3,
	clust_num_ores = 6,
	clust_size = 3,
}

minetest.register_ore{
	biomes = aurum.biomes.get_all_group("aurum:regret"),
	ore_type = "scatter",
	ore = "aurum_chef:salt_in_regret",
	wherein = "aurum_base:regret",
	clust_scarcity = 11 ^ 3,
	clust_num_ores = 6,
	clust_size = 3,
}
