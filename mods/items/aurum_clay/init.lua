local S = minetest.get_translator()

for _,row in ipairs(dye.dyes) do
	local dye = {name = row[1], desc = row[2], colorspec = b.color.convert(row[1])}

	minetest.register_node("aurum_clay:" .. dye.name, {
		description = S("@1 Clay", dye.desc),
		tiles = {"aurum_clay_clay.png^[colorize:" .. b.color.tostring(dye.colorspec) .. ":200"},
		groups = {dig_dig = 3, clay = 1},
		sounds = aurum.sounds.dirt(),
	})

	minetest.register_craft{
		output = "aurum_clay:" .. dye.name,
		type = "shapeless",
		recipe = {"group:clay", "group:color_" .. dye.name},
	}
end