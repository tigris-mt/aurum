local S = minetest.get_translator()

for _,row in ipairs(dye.dyes) do
	local dye = {name = row[1], desc = row[2], colorspec = row[3]}

	minetest.register_node("aurum_clay:" .. dye.name, {
		description = S("@1 Clay", dye.desc),
		tiles = {"aurum_clay_clay.png^[colorize:" .. dye.colorspec .. ":200"},
		groups = {dig_dig = 2},
		sounds = aurum.sounds.dirt(),
	})

	if dye.name ~= "white" then
		minetest.register_craft{
			output = "aurum_clay:" .. dye.name,
			type = "shapeless",
			recipe = {"aurum_clay:white", "group:color_" .. dye.name},
		}
	end
end
