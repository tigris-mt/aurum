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

minetest.register_decoration{
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
	-- All green biomes except dark.
	biomes = b.set.to_array(b.set.subtract(
		b.set(aurum.biomes.get_all_group("green", {"base"})),
		b.set(aurum.biomes.get_all_group("dark", {"base"}))
	)),
}

-- Register <max> grass nodes from <base_name> to <base_name>_<max>.
-- <def> is passed to aurum.flora.register() with suitable defaults.
-- ... is passed to minetest.register_decoration() with suitable defaults.
function aurum.flora.register_grass(base_name, max, def, ...)
	for i=1,max do
		local name = (i == 1) and base_name or (base_name .. "_" .. i)
		local next_name = (i ~= max) and (base_name .. "_" .. (i + 1))
		aurum.flora.register(":" .. name, b.t.combine({
			drop = base_name,
			groups = {not_in_creative_inventory = (i == 1) and 0 or 1},
			_doc_items_create_entry = (i == 1),
			_on_flora_spread = function(pos, node)
				if next_name then
					node.name = next_name
					minetest.set_node(pos, node)
					return false
				else
					return true, base_name
				end
			end,
		}, def, {
			tiles = {def._texture .. "_" .. i .. ".png" .. (def._texture_append and ("^" .. def._texture_append) or "")},
		}))

		if i ~= 1 then
			doc.add_entry_alias("nodes", base_name, "nodes", name)
		end

		for _,decodef in ipairs{...} do
			minetest.register_decoration(b.t.combine({
				name = name,
				decoration = name,
				deco_type = "simple",
				sidelen = 16,
			}, decodef))
		end
	end
end

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
}, {
	place_on = {"group:soil"},
	noise_params = {
		offset = 0,
		scale = 0.25,
		spread = vector.new(50, 50, 50),
		seed = 421,
		octaves = 3,
		persist = 0.5,
	},
	-- All dark green biomes.
	biomes = b.set.to_array(b.set._and(
		b.set(aurum.biomes.get_all_group("green", {"base"})),
		b.set(aurum.biomes.get_all_group("dark", {"base"}))
	)),
})

aurum.flora.register_grass("aurum_flora:desert_weed", 3, {
	description = S"Desert Weed",
	_texture = "aurum_flora_grass",
	_texture_append = "[colorize:#5c4030:200",
	_flora_spread_node = "group:sand",
	selection_box = {
		type = "fixed",
		fixed = {
			-4 / 16, -8 / 16, -4 / 16,
			4 / 16, 4 / 16, 4 / 16,
		},
	},
	groups = {dye_source = 1, color_brown = 1},
}, {
	place_on = {"group:sand"},
	noise_params = {
		offset = 0.005,
		scale = 0.01,
		spread = vector.new(200, 200, 200),
		seed = 421,
		octaves = 3,
		persist = 0.5,
	},
	biomes = aurum.biomes.get_all_group("desert", {"base"}),
})


minetest.register_craft{
	output = "aurum_base:paste 2",
	recipe = {
		{"group:flora", "group:flora", "group:flora"},
		{"group:flora", "group:flora", "group:flora"},
	},
}
