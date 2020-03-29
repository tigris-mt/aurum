local S = minetest.get_translator()

aurum.flora.register_grass("aurum_flora:grass_weed", 5, {
	description = S"Grass Weed",
	_texture = "aurum_flora_grass",
	selection_box = {
		type = "fixed",
		fixed = {
			-4 / 16, -8 / 16, -4 / 16,
			4 / 16, 4 / 16, 4 / 16,
		},
	},
}, {
	place_on = {"group:soil"},
	noise_params = {
		offset = 0,
		scale = 0.1,
		spread = vector.new(200, 200, 200),
		seed = 421,
		octaves = 3,
		persist = 0.5,
	},
	-- All green biomes except dark.
	biomes = b.set.to_array(b.set.subtract(
		b.set(aurum.biomes.get_all_group("green", {"base"})),
		b.set(aurum.biomes.get_all_group("dark", {"base"}))
	)),
})

aurum.flora.register_grass("aurum_flora:dark_grass_weed", 5, {
	description = S"Dark Grass Weed",
	_texture = "aurum_flora_grass",
	_texture_append = "[colorize:#000000:127",
	visual_scale = 1.5,
	selection_box = {
		type = "fixed",
		fixed = {
			-4 / 16, -8 / 16, -4 / 16,
			4 / 16, 8 / 16, 4 / 16,
		},
	},
}, unpack(b.t.imap(b.t.duplicate(true, 5), function(_, i)
	return {
		place_on = {"group:soil"},
		noise_params = {
			offset = 0,
			scale = 0.1,
			spread = vector.new(200, 200, 200),
			seed = 420 + i,
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

aurum.flora.register_grass("aurum_flora:desert_weed", 3, {
	description = S"Desert Weed",
	_texture = "aurum_flora_grass",
	_texture_append = "[colorize:#5c4030:200",
	_flora_spread_node = {"group:sand", "group:clay"},
	selection_box = {
		type = "fixed",
		fixed = {
			-4 / 16, -8 / 16, -4 / 16,
			4 / 16, 4 / 16, 4 / 16,
		},
	},
	groups = {dye_source = 1, color_brown = 1},
}, {
	place_on = {"group:sand", "group:clay"},
	noise_params = {
		offset = 0.005,
		scale = 0.01,
		spread = vector.new(200, 200, 200),
		seed = 421,
		octaves = 3,
		persist = 0.5,
	},
	biomes = aurum.biomes.get_all_group("desert"),
})
