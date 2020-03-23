local S = minetest.get_translator()

local mod = "^[colorize:#FFFFFF:250"

aurum.base.register_liquid("aurum_base:aether", {
	description = S"Aether",
	tiles = {
		{
			name = "default_lava_source_animated.png" .. mod,
			backface_culling = false,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 3,
			},
		},
		{
			name = "default_lava_source_animated.png" .. mod,
			backface_culling = true,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 3,
			},
		},
	},
	light_source = 10,
	post_effect_color = {a = 255, r = 255, g = 255, b = 255},
	liquid_viscosity = 1,
	damage_per_second = 10,
	_damage_type = "psyche",
}, {
	special_tiles = {
		{
			name = "default_lava_flowing_animated.png" .. mod,
			backface_culling = false,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 3,
			},
		},
		{
			name = "default_lava_flowing_animated.png" .. mod,
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
