local S = aurum.get_translator()

minetest.register_craftitem("aurum_glee:glee_shard", {
	description = S"Glee Shard",
	inventory_image = "aurum_glee_glee_shard.png",
})

minetest.register_craftitem("aurum_glee:glee", {
	description = S"Glee Crystal",
	inventory_image = "aurum_glee_glee.png",
})

minetest.register_craft{
	output = "aurum_glee:glee",
	recipe = {
		{"aurum_glee:glee_shard", "aurum_glee:glee_shard", "aurum_glee:glee_shard"},
		{"aurum_glee:glee_shard", "aurum_glee:glee_shard", "aurum_glee:glee_shard"},
		{"aurum_glee:glee_shard", "aurum_glee:glee_shard", "aurum_glee:glee_shard"},
	},
}

minetest.register_craft{
	output = "aurum_glee:glee_shard 9",
	recipe = {
		{"aurum_glee:glee"},
	},
}

minetest.register_node("aurum_glee:glee_block", {
	description = S"Glee Block",
	tiles = {"aurum_glee_glee_block.png"},
	groups = {dig_pick = 3},
	sounds = aurum.sounds.stone(),
	light_source = 14,
	paramtype = "light",
})

minetest.register_craft{
	output = "aurum_glee:glee_block",
	recipe = {
		{"aurum_glee:glee", "aurum_glee:glee", "aurum_glee:glee"},
		{"aurum_glee:glee", "aurum_glee:glee", "aurum_glee:glee"},
		{"aurum_glee:glee", "aurum_glee:glee", "aurum_glee:glee"},
	},
}

minetest.register_craft{
	output = "aurum_glee:glee 9",
	recipe = {
		{"aurum_glee:glee_block"},
	},
}

minetest.register_node("aurum_glee:glee_shard_in_stone", {
	description = S"Glee Shard in Stone",
	tiles = {"aurum_base_stone.png^aurum_glee_glee_shard.png"},
	groups = {dig_pick = 3},
	sounds = aurum.sounds.stone(),
	drop = {
		items = {
			{items = {"aurum_glee:glee_shard"}, rarity = 1},
			{items = {"aurum_glee:glee_shard"}, rarity = 4},
			{items = {"aurum_glee:glee_shard"}, rarity = 9},
		},
	},
	light_source = 9,
	paramtype = "light",
	after_dig_node = function(pos, _, _, player)
		aurum.player.mana_sparks(player, pos, "digging", 1, 4)
	end,
})

minetest.register_node("aurum_glee:glee_shard_in_regret", {
	description = S"Glee Shard in Regret",
	tiles = {minetest.registered_nodes["aurum_base:regret"].tiles[1] .. "^aurum_glee_glee_shard.png"},
	groups = {dig_pick = 2, level = 2},
	sounds = aurum.sounds.stone(),
	drop = {
		items = {
			{items = {"aurum_glee:glee_shard"}, rarity = 1},
			{items = {"aurum_glee:glee_shard"}, rarity = 3},
			{items = {"aurum_glee:glee_shard"}, rarity = 5},
		},
	},
	light_source = 9,
	paramtype = "light",
	after_dig_node = function(pos, _, _, player)
		aurum.player.mana_sparks(player, pos, "digging", 2, 4)
	end,
})

minetest.register_node("aurum_glee:glee_in_aether_flesh", {
	description = S"Glee in Aether Flesh",
	tiles = {minetest.registered_nodes["aurum_base:aether_flesh"].tiles[1] .. "^aurum_glee_glee.png"},
	groups = minetest.registered_nodes["aurum_base:aether_flesh"].groups,
	sounds = aurum.sounds.flesh(),
	drop = {
		items = {
			{items = {"aurum_glee:glee_shard"}, rarity = 1},
			{items = {"aurum_glee:glee_shard"}, rarity = 2},
			{items = {"aurum_glee:glee_shard"}, rarity = 3},
		},
	},
	light_source = 10,
	paramtype = "light",
	after_dig_node = function(pos, _, _, player)
		aurum.player.mana_sparks(player, pos, "digging", 4, 6)
	end,
})

for realm,rdef in pairs{
	["aurum_base:aurum"] = {
		ore = "aurum_glee:glee_shard_in_stone",
		node_in = "aurum_base:stone",
		size = 3,
		layers = {
			{b.WORLD.max.y, 200, 20},
			{200, 100, 22},
			{100, 50, 25},
			{50, -50, 27},
			{-50, -100, 25},
			{-100, -300, 22},
			{-300, b.WORLD.min.y, 20},
		},
	},
	["aurum_base:primus"] = {
		ore = "aurum_glee:glee_shard_in_stone",
		node_in = "aurum_base:stone",
		size = 4,
		layers = {
			{b.WORLD.max.y, 200, 20},
			{200, 100, 22},
			{100, 50, 25},
			{50, -50, 27},
			{-50, -100, 25},
			{-100, -300, 22},
			{-300, b.WORLD.min.y, 20},
		},
	},
	["aurum_base:loom"] = {
		ore = "aurum_glee:glee_shard_in_regret",
		node_in = "aurum_base:regret",
		size = 4,
		layers = {
			{b.WORLD.max.y, 200, 20},
			{200, 100, 22},
			{100, 50, 25},
			{50, -50, 27},
			{-50, -100, 25},
			{-100, -300, 22},
			{-300, b.WORLD.min.y, 20},
		},
	},
	["aurum_base:aether"] = {
		ore = "aurum_glee:glee_in_aether_flesh",
		node_in = "aurum_base:aether_flesh",
		size = 4,
		layers = {
			{b.WORLD.max.y, b.WORLD.min.y, 20},
		},
	},
} do
	for _,layer in ipairs(rdef.layers) do
		minetest.register_ore{
			biomes = aurum.biomes.get_all_group(realm),
			ore_type = "scatter",
			ore = rdef.ore,
			wherein = rdef.node_in,
			y_max = layer[1],
			y_min = layer[2],
			clust_scarcity = layer[3] ^ 3,
			clust_num_ores = math.ceil(rdef.size ^ 2.5),
			clust_size = rdef.size,
		}
	end
end
