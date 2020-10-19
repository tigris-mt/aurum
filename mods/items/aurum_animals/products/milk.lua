local S = aurum.get_translator()

local tex = "^[colorize:#ffffff:225"

aurum.base.register_liquid("aurum_animals:milk", {
	description = S"Milk",
	tiles = {
		{
			name = "default_water_source_animated.png" .. tex,
			backface_culling = false,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 2,
			},
		},
		{
			name = "default_water_source_animated.png" .. tex,
			backface_culling = true,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 2,
			},
		},
	},
	post_effect_color = {a = 200, r = 255, g = 255, b = 255},
	groups = {cools_lava = 1},
	alpha = 250,
}, {
	special_tiles = {
		{
			name = "default_water_flowing_animated.png" .. tex,
			backface_culling = false,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 1,
			},
		},
		{
			name = "default_water_flowing_animated.png" .. tex,
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
	"aurum_animals:milk_source",
	"aurum_animals:milk_flowing",
	"aurum_animals:bucket_milk",
	"bucket.png^aurum_animals_bucket_milk.png",
	S"Milk Bucket"
)

minetest.override_item("aurum_animals:bucket_milk", {
	groups = b.t.combine(minetest.registered_items["aurum_animals:bucket_milk"].groups, {edible = 15}),
	on_use = minetest.item_eat(15, "bucket:bucket_empty"),
})
