local S = minetest.get_translator()

for _,row in ipairs(dye.dyes) do
	local dye = {name = row[1], desc = row[2], colorspec = b.color.convert(row[1])}
	local clay_name = "aurum_clay:" .. dye.name .. "_clay"
	local brick_name = "aurum_clay:" .. dye.name .. "_brick"

	minetest.register_node(clay_name, {
		description = S("@1 Clay", dye.desc),
		tiles = {"aurum_clay_clay.png^[colorize:" .. b.color.tostring(dye.colorspec) .. ":200"},
		groups = {dig_dig = 3, clay = 1, cook_temp = 10, cook_xmana = 1},
		sounds = aurum.sounds.dirt(),
	})

	minetest.register_craft{
		output = clay_name,
		type = "shapeless",
		recipe = {"group:clay", "group:dye,color_" .. dye.name},
	}

	minetest.register_node(brick_name, {
		description = S("@1 Clay Brick", dye.desc),
		tiles = {"aurum_clay_brick.png^[colorize:" .. b.color.tostring(dye.colorspec) .. ":200"},
		groups = {dig_pick = 2},
		sounds = aurum.sounds.stone(),
		is_ground_content = false,
	})

	minetest.register_craft{
		type = "cooking",
		output = brick_name,
		recipe = clay_name,
		cooktime = 3,
	}
end
