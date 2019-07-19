-- Set up core mapgen aliases.
minetest.register_alias("mapgen_stone", "aurum_base:stone")
minetest.register_alias("mapgen_water_source", "aurum_base:water_source")
minetest.register_alias("mapgen_water_flowing", "aurum_base:water_flowing")

local biome_size = (tonumber(minetest.settings:get("aurum.biome_size")) or 1) * 0.4

minetest.set_mapgen_setting_noiseparams("mg_biome_np_heat", {
	offset = 50,
	scale = 50,
	spread = vector.multiply(vector.new(1000, 1000, 1000), biome_size),
	seed = 5349,
	octaves = 3,
	persistence = 0.5,
	lacunarity = 2.0,
	flags = "defaults"
}, true)

minetest.set_mapgen_setting_noiseparams("mg_biome_np_humidity", {
	offset = 50,
	scale = 50,
	spread = vector.multiply(vector.new(1000, 1000, 1000), biome_size),
	seed = 842,
	octaves = 3,
	persistence = 0.5,
	lacunarity = 2.0,
	flags = "defaults"
}, true)
