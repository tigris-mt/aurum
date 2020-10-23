local S = aurum.get_translator()

local time = function()
	return math.random(600, 1200)
end

local function vine_grow(pos, node, random)
	local placed = {}
	if node.param2 > 0 then
		local box = b.box.new_radius(pos, 1)
		local poses = b.t.imap(b.t.shuffled(minetest.find_nodes_in_area_under_air(box.a, box.b, {"group:soil"})), function(v)
			return vector.distance(pos, v) <= 1.5 and v or nil
		end)
		if #poses > 0 then
			for i=1,math.min(2, random(#poses)) do
				local vine_pos = vector.add(poses[i], vector.new(0, 1, 0))
				minetest.set_node(vine_pos, {name = "aurum_farming:creeper_vine", param2 = random(0, node.param2 - 1)})
				minetest.get_node_timer(vine_pos):start(time())
				table.insert(placed, vine_pos)
			end
		end
	end
	return #placed > 0, placed
end

aurum.farming.register_crop("aurum_farming:creeper", {
	texture = "aurum_farming_creeper",
	description = S"Creeper",
	max = 2,

	groups = {
		connect_to_raillike = minetest.raillike_group("aurum_farming:creeper"),
	},

	time = time,

	seed = {},

	on_growth = function(pos, def, stage)
		-- Mature plant, send out vines.
		if stage == 2 then
			vine_grow(pos, {param2 = 15}, math.random)
		end
	end,
})

minetest.register_node("aurum_farming:creeper_vine", {
	description = S"Creeper Vine",
	drawtype = "raillike",
	paramtype = "light",
	is_ground_content = false,
	sunlight_propagates = true,
	walkable = false,

	tiles = {
		"aurum_farming_creeper_vine_line.png",
		"aurum_farming_creeper_vine_curve.png",
		"aurum_farming_creeper_vine_t.png",
		"aurum_farming_creeper_vine_cross.png",
	},

	selection_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.5, 0.5, -7 / 16, 0.5},
	},

	groups = {
		dig_snap = 3,
		flammable = 1,
		attached_node = 1,
		grow_plant = 1,
		dye_source = 1,
		color_green = 1,
		connect_to_raillike = minetest.raillike_group("aurum_farming:creeper"),
	},

	sounds = aurum.sounds.leaves(),

	on_timer = function(pos) return not vine_grow(pos, minetest.get_node(pos), math.random) end,
	_on_grow_plant = function(pos, node) return vine_grow(pos, node, math.random) end,

	drop = {
		max_items = 2,
		items = {
			{rarity = 20, items = {"aurum_farming:creeper_seed"}},
			{rarity = 1, items = {"aurum_farming:creeper_vine"}},
		},
	},
})

minetest.register_craft{
	type = "fuel",
	recipe = "aurum_farming:creeper_vine",
	burntime = 3,
}

minetest.register_craft{
	output = "aurum_base:paste 2",
	recipe = {
		{"aurum_farming:creeper_vine", "aurum_farming:creeper_vine"},
	},
}

aurum.features.register_dynamic_decoration({
	decoration = {
		place_on = {"group:soil"},
		sidelen = 16,
		fill_ratio = 0.015,
		biomes = aurum.biomes.get_all_group("green", {"base"}),
		num_spawn_by = 1,
		spawn_by = {"group:water", "group:fertilizer"},
	},

	callback = function(pos, random)
		minetest.set_node(pos, {name = "aurum_farming:creeper_2"})

		local grow_at_pos
		grow_at_pos = function(pos, param2)
			local _, grown = vine_grow(pos, b.t.combine(minetest.get_node(pos), {param2 = param2}), random)
			for _,new_pos in ipairs(grown) do
				grow_at_pos(new_pos)
			end
		end

		grow_at_pos(pos, 15)
	end,
})
