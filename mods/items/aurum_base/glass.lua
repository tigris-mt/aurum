local S = minetest.get_translator()

for _,row in ipairs(dye.dyes) do
	local dye = {name = row[1], desc = row[2], colorspec = b.color.convert(row[1])}
	local name = "aurum_base:" .. dye.name .. "_glass"

	minetest.register_node(name, {
		description = S("@1 Glass", dye.desc),
		tiles = {
			"aurum_base_glass.png^[colorize:" .. b.color.tostring(dye.colorspec) .. ":200",
			"aurum_base_glass_detail.png^[colorize:" .. b.color.tostring(dye.colorspec) .. ":200",
		},
		groups = {dig_dig = 3, dig_handle = 2, glass = 1},
		sounds = aurum.sounds.glass(),
		paramtype = "light",
		drawtype = "glasslike_framed_optional",
		sunlight_propagates = true,
		use_texture_alpha = true,
	})

	minetest.register_craft{
		output = name,
		type = "shapeless",
		recipe = {"group:glass", "group:dye,color_" .. dye.name},
	}
end

minetest.register_craft{
	type = "cooking",
	output = "aurum_base:white_glass",
	recipe = "aurum_base:sand",
}
