local S = minetest.get_translator()

aurum.dye.register_node("aurum_clay:clay", {
	description = S"Clay",
	tiles = {"aurum_clay_clay.png"},
	groups = {dig_dig = 3, clay = 1, cook_temp = 10, cook_xmana = 1, shapable = 1},
	sounds = aurum.sounds.dirt(),
}, "group:clay", function(_, color, colored_name)
	minetest.register_craft{
		type = "cooking",
		output = "aurum_clay:brick_" .. color,
		recipe = colored_name,
		cooktime = 3,
	}
end)

aurum.dye.register_node("aurum_clay:brick", {
	description = S"Clay Brick",
	tiles = {"aurum_clay_brick.png"},
	groups = {dig_pick = 2, shapable = 1, clay_brick = 1},
	sounds = aurum.sounds.stone(),
	is_ground_content = false,
})
