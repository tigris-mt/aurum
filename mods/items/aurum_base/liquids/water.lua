local S = aurum.get_translator()

aurum.base.register_liquid("aurum_base:water", {
	description = S"Water",
	tiles = {
		{
			name = "default_water_source_animated.png",
			backface_culling = false,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 2,
			},
		},
		{
			name = "default_water_source_animated.png",
			backface_culling = true,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 2,
			},
		},
	},
	post_effect_color = {a = 100, r = 30, g = 60, b = 90},
	groups = {water = 1, cools_lava = 1},
	use_texture_alpha = "blend",
	liquid_renewable = true,
}, {
	special_tiles = {
		{
			name = "default_water_flowing_animated.png",
			backface_culling = false,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 1,
			},
		},
		{
			name = "default_water_flowing_animated.png",
			backface_culling = true,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 1,
			},
		},
	},
})

bucket.register_liquid(
	"aurum_base:water_source",
	"aurum_base:water_flowing",
	"aurum_base:bucket_water",
	"bucket_water.png",
	S"Water Bucket"
)
minetest.register_alias("bucket:bucket_water", "aurum_base:bucket_water")

minetest.register_craft{
	output = "aurum_base:bucket_water",
	recipe = {
		{"aurum_base:ice"},
		{"bucket:bucket_empty"},
	},
}

minetest.register_craft{
	output = "aurum_base:bucket_water",
	recipe = {
		{"aurum_base:snow"},
		{"bucket:bucket_empty"},
	},
}

aurum.base.register_liquid("aurum_base:river_water", {
	description = S"River Water",
	tiles = {
		{
			name = "default_river_water_source_animated.png",
			backface_culling = false,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 2,
			},
		},
		{
			name = "default_river_water_source_animated.png",
			backface_culling = true,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 2,
			},
		},
	},
	post_effect_color = {a = 100, r = 30, g = 80, b = 90},
	groups = {water = 1, cools_lava = 1},
	use_texture_alpha = "blend",
	liquid_range = 2,
}, {
	special_tiles = {
		{
			name = "default_river_water_flowing_animated.png",
			backface_culling = false,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 1,
			},
		},
		{
			name = "default_river_water_flowing_animated.png",
			backface_culling = true,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 1,
			},
		},
	},
})

bucket.register_liquid(
	"aurum_base:river_water_source",
	"aurum_base:river_water_flowing",
	"aurum_base:bucket_river_water",
	"bucket_river_water.png",
	S"River Water Bucket",
	{},
	true
)
minetest.register_alias("bucket:bucket_river_water", "aurum_base:bucket_river_water")
