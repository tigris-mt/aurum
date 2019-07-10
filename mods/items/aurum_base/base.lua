local S = minetest.get_translator()

minetest.register_node("aurum_base:stone", {
	description = S("Stone"),
	tiles = {"aurum_base_stone.png"},
	is_ground_content = true,
})

minetest.register_node("aurum_base:dirt", {
	description = S("Dirt"),
	tiles = {"aurum_base_dirt.png"},
	is_ground_content = true,
})
