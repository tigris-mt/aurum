local S = minetest.get_translator()

local single = {
	type = "fixed",
	fixed = {
		-2 / 16, -8 / 16, -2 / 16,
		2 / 16, 3 / 16, 2 / 16,
	},
}

local double = {
	type = "fixed",
	fixed = {
		-4 / 16, -8 / 16, -4 / 16,
		4 / 16, 19 / 16, 4 / 16,
	},
}

function aurum.flora.register_flower(name, seed, def, decodef)
	aurum.flora.register(name, b.t.combine({
		selection_box = single,
	}, def))

	minetest.register_decoration(b.t.combine({
		name = name,
		decoration = name,
		deco_type = "simple",
		place_on = {"group:soil"},
		sidelen = 16,
		noise_params = {
			offset = -0.025,
			scale = 0.05,
			spread = vector.new(200, 200, 200),
			seed = seed,
			octaves = 3,
			persist = 0.5,
		},
		-- Flowers grow in all green biomes except dark ones.
		biomes = b.set.to_array(b.set.subtract(
			b.set(aurum.biomes.get_all_group("green", {"base"})),
			b.set(aurum.biomes.get_all_group("dark", {"base"}))
		)),
	}, decodef or {}))
end

aurum.flora.register_flower("aurum_flora:sunflower", 8011, {
	description = S"Sunflower",
	groups = {dye_source = 1, color_yellow = 1},
	tiles = {"aurum_flora_sunflower.png"},
	selection_box = double,
	visual_scale = 2,
})

aurum.flora.register_flower("aurum_flora:lupine", 8715, {
	description = S"Lupine",
	groups = {dye_source = 1, color_blue = 1},
	tiles = {"aurum_flora_lupine.png"},
	selection_box = double,
	visual_scale = 2,
})

aurum.flora.register_flower("aurum_flora:lily", 2756, {
	description = S"Lily",
	groups = {dye_source = 1, color_white = 1},
	tiles = {"aurum_flora_lily.png"},
	selection_box = single,
})

aurum.flora.register_flower("aurum_flora:black_rose", 7567, {
	description = S"Black Rose",
	groups = {dye_source = 1, color_black = 1},
	tiles = {"aurum_flora_black_rose.png"},
	selection_box = single,
})
