aurum.features.decorations = {}
local idx = 0

local biome_map = {}

aurum.features.default_decoration_def = {
	-- What nodes to place on?
	place_on = {},

	-- Rarity per node, conflicts with noise.
	rarity = nil,

	-- Noise parameters, conflicts with rarity.
	noise_params = nil,

	-- Biomes to generate in.
	biomes = {},

	-- Called on generation.
	on_generated = function(context) end,

	-- Default offset.
	offset = vector.new(0, 0, 0),

	-- Called on offsetting, return new pos or nil to cancel placement.
	on_offset = function(base_context) return vector.add(base_context.pos, base_context.def.offset) end,

	-- Schematic specifier.
	schematic = nil,

	-- Schematic function, if table is nil.
	-- Returns specifier or nil to cancel placement.
	make_schematic = function(base_context) end,

	force_placement = true,
}

function aurum.features.register_decoration(def)
	local def = b.t.combine(aurum.features.default_decoration_def, def)

	assert(def.rarity or def.noise_params, "decoration must specify noise parameters or rarity per node")

	def.biome_map = b.set(def.biomes)

	idx = idx + 1
	def.name = def.name or ("aurum_features:deco_" .. idx)

	for k in b.set.iter(def.biome_map) do
		biome_map[k] = biome_map[k] or {}
		table.insert(biome_map[k], def.name)
	end
	aurum.features.decorations[def.name] = def
end

function aurum.features.ph(n)
	return "aurum_features:ph_" .. n
end

-- Special node, will be replaced with ignore before placed when reading schematics from a file.
minetest.register_node("aurum_features:null", {
	is_ground_content = false,
	tiles = {"aurum_base_stone.png"},
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {-0.1, -0.1, -0.1, 0.1, 0.1, 0.1},
	},
	paramtype = "light",
	sunlight_propagates = true,
	groups = {not_in_creative_inventory = 1, dig_handle = 3},
	walkable = false,
	drop = "",
})

for i=1,99 do
	minetest.register_node(aurum.features.ph(i), {
		is_ground_content = false,
		groups = {not_in_creative_inventory = 1, dig_immediate = 3},
		buildable_to = true,
		drop = "",
	})
end

local metatable = {
	-- Convert relative position to absolute position.
	at = function(self, pos)
		return self._at(pos)
	end,

	-- Convert relative facing direction to absolute direction.
	dir = function(self, o)
		if self.rotation == 0 then
			return o
		elseif self.rotation == 1 then
			return vector.new(o.z, o.y, -o.x)
		elseif self.rotation == 2 then
			return vector.new(-o.x, o.y, -o.z)
		elseif self.rotation == 3 then
			return vector.new(-o.z, o.y, o.x)
		end
	end,

	-- Get all placeholder <n> nodes.
	-- First call will cache positions and remove actual placeholder nodes.
	ph = function(self, n)
		if self._ph[n] then
			return self._ph[n]
		end
		local poses = self:shuffled(minetest.find_nodes_in_area(self.box.a, self.box.b, "aurum_features:ph_" .. n))
		self._ph[n] = poses
		for _,pos in ipairs(poses) do
			minetest.remove_node(pos)
		end
		return poses
	end,

	-- Random function. Could potentially use seed.
	random = function(self, ...)
		return self.base.random(...)
	end,

	-- Shuffled function. Could potentially use seed.
	shuffled = function(self, t)
		return b.t.shuffled(t, function(...) return self:random(...) end)
	end,

	-- Add treasures to list at pos.
	treasures = function(self, pos, listname, count, loot)
		local inv = minetest.get_meta(pos):get_inventory()

		local shuffled = self:shuffled(b.t.map(loot, function(v) return ((v.count or 1) > 0) and v or nil end))
		local ti = 0
		for i=1,count do
			ti = ti + 1
			if ti > #shuffled then
				ti = 1
			end

			local search = shuffled[ti]
			if search then
				search = b.t.combine({
					count = 1,
					preciousness = {0, 10},
					groups = nil,
				}, search)
				for _,stack in ipairs(treasurer.select_random_treasures(
					search.count,
					search.preciousness[1],
					search.preciousness[2],
					search.groups
				) or {}) do
					-- Ignore overflow.
					inv:add_item(listname, stack)
				end
			end
		end

		-- Shuffle inventory slots.
		inv:set_list(listname, self:shuffled(inv:get_list(listname)))
	end,
}

function aurum.features.structure_context(base, box, at, rotation)
	return setmetatable({
		base = base,
		box = box,
		rotation = rotation,
		_at = at,
		_ph = {},
	}, {__index = metatable})
end

function aurum.features.place_decoration(pos, def, random, on_generated)
	local base_context = {
		pos = pos,
		random = random,
		def = def,
		-- For individual structure use.
		s = {},
	}
	base_context.pos = def.on_offset(base_context)
	if base_context.pos then
		local schematic = def.schematic or def.make_schematic(base_context)
		if schematic then
			if type(schematic) == "string" then
				schematic = minetest.read_schematic(schematic, {})
				for _,v in ipairs(schematic.data) do
					if v.name == "aurum_features:null" then
						v.name = "ignore"
					end
				end
			end

			-- Random rotation 0 to 270 degrees.
			local rotation = base_context.random(0, 3)

			-- Calculate limit.
			local limit = vector.subtract(schematic.size, 1)

			-- Center offset.
			local halflimit = vector.apply(vector.divide(limit, 2), function(v)
				return math.sign(v) * math.floor(math.abs(v))
			end)

			-- Shift pos by center offset.
			local real_pos = b.t.combine(vector.subtract(base_context.pos, halflimit), {y = base_context.pos.y})

			local function at(offset)
				local actual = vector.new(0, offset.y, 0)
				if rotation == 0 then
					actual.x = offset.x
					actual.z = offset.z
				elseif rotation == 1 then
					actual.z = limit.x - offset.x
					actual.x = offset.z
				elseif rotation == 2 then
					actual.x = limit.x - offset.x
					actual.z = limit.z - offset.z
				elseif rotation == 3 then
					actual.z = offset.x
					actual.x = limit.z - offset.z
				else
					error("invalid rotation: " .. rotation)
				end
				return vector.add(real_pos, actual)
			end

			-- Place schematic.
			local rotname = {"0", "90", "180", "270"}
			minetest.place_schematic(real_pos, schematic, rotname[rotation + 1], {}, def.force_placement)

			local context = aurum.features.structure_context(base_context, b.box.extremes(b.box.new(
				at(vector.new(0, 0, 0)),
				at(limit)
			)), at, rotation)

			-- Run callbacks.
			def.on_generated(context)
			if on_generated then
				on_generated(context)
			end
		end
	end
end

minetest.register_on_mods_loaded(function()
	minetest.register_on_generated(function(minp, maxp, seed)
		local center = vector.round(vector.divide(vector.add(minp, maxp), 2))
		local biome = minetest.get_biome_data(center)
		local biome_name = biome and minetest.get_biome_name(biome.biome)

		if not biome_name then
			return
		end

		local random = b.seed_random(seed + 0x574C745)

		-- For all decorations registered with this biome...
		for _,name in ipairs(biome_map[biome_name] or {}) do
			local def = aurum.features.decorations[name]
			local perlin = def.noise_params and minetest.get_perlin(def.noise_params)
			local rarity = def.noise_params and perlin:get_3d(center) or def.rarity

			-- Look for suitable places.
			for _,pos in ipairs(minetest.find_nodes_in_area_under_air(minp, maxp, def.place_on)) do
				if random() < rarity then
					aurum.features.place_decoration(pos, def, random)
				end
			end
		end
	end)
end)
