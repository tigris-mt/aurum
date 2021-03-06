local S = aurum.get_translator()

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

aurum.flora.register_flower("aurum_flora:awaken_jonathan", 3944, {
	description = S"Awaken Jonathan",
	groups = {dye_source = 1, color_violet = 1},
	tiles = {"aurum_flora_awaken_jonathan.png"},
	selection_box = single,
}, {
	biomes = aurum.biomes.get_all_group("green", {"base"}),
})

aurum.flora.register_flower("aurum_flora:linkowar", 3944, {
	description = S"Link O' War",
	groups = {dye_source = 1, color_pink = 1},
	tiles = {"aurum_flora_linkowar.png"},
	selection_box = single,
}, {
	biomes = aurum.biomes.get_all_group("green", {"base"}),
})

local sdn = {"group:soil", "group:snow"}
aurum.flora.register_flower("aurum_flora:snow_blood", 8402, {
	description = S"Snow Blood",
	groups = {dye_source = 1, color_red = 1},
	tiles = {"aurum_flora_snow_blood.png"},
	selection_box = single,
	_flora_spread_node = sdn,
}, {
	place_on = sdn,
	biomes = b.set.to_array(b.set._or(
		b.set.subtract(
			b.set(aurum.biomes.get_all_group("frozen", {"base"})),
			b.set(aurum.biomes.get_all_group("barren", {"base"}))
		),
		b.set(aurum.biomes.get_all_group("green", {"base"}))
	)),
})

local nln = {"group:soil", "group:stone", "group:ore_block", "aurum_base:aether_shell", "aurum_base:aether_flesh"}
aurum.flora.register_flower("aurum_flora:night_light", 1956, {
	description = S"Night Light",
	_doc_items_longdesc = S"A living candle native to the Aether.",
	_flora_spread_node = nln,
	_flora_light = 0,
	groups = {dye_source = 1, color_white = 1},
	inventory_image = "[combine:16x16:0,0=aurum_flora_night_light.png",
	wield_image = "[combine:16x16:0,0=aurum_flora_night_light.png",
	tiles = {{
		image = "aurum_flora_night_light.png",
		animation = {
			type = "vertical_frames",
			aspect_w = 16,
			aspect_h = 16,
			length = 2,
		},
	}},
	selection_box = single,
	light_source = 10,
}, {
	place_on = nln,
	biomes = b.set.to_array(b.set._or(
		b.set(aurum.biomes.get_all_group("green", {"base"})),
		b.set(aurum.biomes.get_all_group("aurum:aether", {"base"}))
	)),
})

local shdn = {"group:sand", "group:clay", "aurum_base:gravel", "group:soil"}

aurum.flora.register_flower("aurum_flora:shilport", 1048, {
	description = S"Shilport",
	groups = {dye_source = 1, color_orange = 1},
	tiles = {"aurum_flora_shilport.png"},
	selection_box = single,
	_flora_spread_node = shdn,
}, {
	place_on = shdn,
	biomes = aurum.biomes.get_all_group("all", {"base"}),
})

aurum.flora.register_flower("aurum_flora:shaxal", 1049, {
	description = S"Shaxal",
	groups = {dye_source = 1, color_yellow = 1},
	tiles = {"aurum_flora_shaxal.png"},
	selection_box = single,
	_flora_spread_node = shdn,
}, {
	place_on = shdn,
	biomes = aurum.biomes.get_all_group("all", {"base"}),
})

aurum.flora.register_flower("aurum_flora:sholron", 1050, {
	description = S"Sholron",
	groups = {dye_source = 1, color_blue = 1},
	tiles = {"aurum_flora_sholron.png"},
	selection_box = single,
	_flora_spread_node = shdn,
}, {
	place_on = shdn,
	biomes = aurum.biomes.get_all_group("all", {"base"}),
})
