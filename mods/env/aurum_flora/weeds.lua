local S = minetest.get_translator()

aurum.flora.register("aurum_flora:grass_spike", {
	description = S"Grass Spike",
	tiles = {"aurum_flora_grass_spike.png"},
	selection_box = {
		type = "fixed",
		fixed = {
			-2 / 16, -8 / 16, -2 / 16,
			2 / 16, 3 / 16, 2 / 16,
		},
	},
})

minetest.register_decoration({
	name = "aurum_flora:grass_spike",
	decoration = "aurum_flora:grass_spike",
	deco_type = "simple",
	place_on = {"group:soil"},
	sidelen = 16,
	noise_params = {
		offset = 0,
		scale = 0.01,
		spread = vector.new(200, 200, 200),
		seed = 266,
		octaves = 3,
		persist = 0.5,
	},
	biomes = aurum.biomes.get_all_group("green", {"base"}),
})
