local S = minetest.get_translator()

function aurum.base.register_liquid(name, def, flowing_def)
	local defaults = {
		drawtype = "liquid",
		paramtype = "light",
		liquidtype = "source",
		liquid_viscosity = 1,
		groups = {liquid = 1},
		buildable_to = true,
		walkable = false,
		pointable = false,
		diggable = false,
		sounds = aurum.sounds.water(),
		drowning = 1,
		drop = "",
		liquid_alternative_source = name .. "_source",
		liquid_alternative_flowing = name .. "_flowing",
		liquid_renewable = false,
		liquid_range = 8,
	}
	local flowing_defaults = {
		drawtype = "flowingliquid",
		paramtype2 = "flowingliquid",
		liquidtype = "flowing",
		tiles = def.tiles,
		groups = {not_in_creative_inventory = 1},
		_doc_items_create_entry = false,
	}
	minetest.register_node(":" .. name .. "_source", table.combine(defaults, def, {groups = table.combine(defaults.groups or {}, def.groups or {})}))
	minetest.register_node(":" .. name .. "_flowing", table.combine(defaults, def, flowing_defaults, flowing_def, {groups = table.combine(defaults.groups or {}, def.groups or {}, flowing_defaults.groups or {}, flowing_def.groups or {})}))
	doc.add_entry_alias("nodes", name .. "_source", "nodes", name .. "_flowing")
end

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
	alpha = 150,
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
	alpha = 150,
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
	groups = {lava = 1},
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
