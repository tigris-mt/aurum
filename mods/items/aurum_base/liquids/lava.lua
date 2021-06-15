local S = aurum.get_translator()

aurum.base.register_liquid("aurum_base:lava", {
	description = S"Lava",
	tiles = {
		{
			name = "default_lava_source_animated.png",
			backface_culling = false,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 3,
			},
		},
		{
			name = "default_lava_source_animated.png",
			backface_culling = true,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 3,
			},
		},
	},
	light_source = 14,
	post_effect_color = {a = 200, r = 255, g = 48, b = 0},
	groups = {lava = 1, item_burn = 1, igniter = 1},
	liquid_viscosity = 7,
	damage_per_second = 40,
	_damage_type = "burn",
}, {
	special_tiles = {
		{
			name = "default_lava_flowing_animated.png",
			backface_culling = false,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 3,
			},
		},
		{
			name = "default_lava_flowing_animated.png",
			backface_culling = true,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 3,
			},
		},
	},
})

minetest.override_item("aurum_base:lava_source", {
	_lava_cool_node = "aurum_base:shimmer_stone",
})

minetest.override_item("aurum_base:lava_flowing", {
	_lava_cool_node = "aurum_base:sponge_stone",
})

bucket.register_liquid(
	"aurum_base:lava_source",
	"aurum_base:lava_flowing",
	"aurum_base:bucket_lava",
	"bucket_lava.png",
	S"Lava Bucket"
)
minetest.register_alias("bucket:bucket_lava", "aurum_base:bucket_lava")

minetest.register_craft({
	type = "fuel",
	recipe = "bucket:bucket_lava",
	burntime = 60,
	replacements = {{"bucket:bucket_lava", "bucket:bucket_empty"}},
})

