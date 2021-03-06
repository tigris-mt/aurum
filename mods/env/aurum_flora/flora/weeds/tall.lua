local S = aurum.get_translator()

aurum.flora.register_grass("aurum_flora:tall_weed", 1, {
	description = S"Tall Weed",
	_texture = "aurum_flora_tall_grass",
	selection_box = {
		type = "fixed",
		fixed = {
			-4 / 16, -8 / 16, -4 / 16,
			4 / 16, 12 / 16, 4 / 16,
		},
	},
	visual_scale = 2,
}, {
	place_on = {"group:soil"},
	noise_params = {
		offset = 0,
		scale = 0.05,
		spread = vector.new(200, 200, 200),
		seed = 521,
		octaves = 3,
		persist = 0.5,
	},
	-- All green biomes except dark.
	biomes = b.set.to_array(b.set.subtract(
		b.set(aurum.biomes.get_all_group("green", {"base"})),
		b.set(aurum.biomes.get_all_group("dark", {"base"}))
	)),
})

aurum.flora.register_grass("aurum_flora:dark_tall_weed", 1, {
	description = S"Dark Tall Weed",
	_texture = "aurum_flora_tall_grass",
	_texture_append = "[colorize:#000000:127",
	visual_scale = 2.5,
	selection_box = {
		type = "fixed",
		fixed = {
			-4 / 16, -8 / 16, -4 / 16,
			4 / 16, 16 / 16, 4 / 16,
		},
	},
}, unpack(b.t.imap(b.t.duplicate(true, 5), function(_, i)
	return {
		place_on = {"group:soil"},
		noise_params = {
			offset = 0,
			scale = 0.05,
			spread = vector.new(200, 200, 200),
			seed = 520 + i,
			octaves = 3,
			persist = 0.5,
		},
		-- All dark green biomes.
		biomes = b.set.to_array(b.set._and(
			b.set(aurum.biomes.get_all_group("green", {"base"})),
			b.set(aurum.biomes.get_all_group("dark", {"base"}))
		)),
	}
end)))
