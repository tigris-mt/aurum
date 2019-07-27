aurum.features.decorations = {}
local idx = 0

local biome_map = {}

function aurum.features.register_decoration(def)
	local def = table.combine({
		-- What nodes to place on?
		place_on = {},

		-- Rarity per node.
		rarity = 0.01,

		-- Biomes to generate in.
		biomes = {},

		-- Called on generation.
		on_generated = function(context) end,

		-- Called on offsetting, must return new pos.
		on_offset = function(pos) return pos end,

		-- Schematic table.
		schematic = nil,
	}, def)

	def.biome_map = aurum.set.new(def.biomes)

	idx = idx + 1
	def.name = def.name or ("aurum_features:deco_" .. idx)

	for k in aurum.set.iter(def.biome_map) do
		biome_map[k] = biome_map[k] or {}
		table.insert(biome_map[k], def.name)
	end
	aurum.features.decorations[def.name] = def
end

for i=1,99 do
	minetest.register_node("aurum_features:ph_" .. i, {
		groups = {not_in_creative_inventory = 1},
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
		local poses = table.shuffled(minetest.find_nodes_in_area(self.box.a, self.box.b, "aurum_features:ph_" .. n))
		self._ph[n] = poses
		for _,pos in ipairs(poses) do
			minetest.remove_node(pos)
		end
		return poses
	end,

	-- Random function. Could potentially use seed.
	random = function(self, ...)
		return math.random(...)
	end,

	-- Shuffled function. Could potentially use seed.
	shuffled = function(self, ...)
		return table.shuffled(...)
	end,

	-- Add treasures to list at pos.
	treasures = function(self, pos, listname, count, loot)
		local inv = minetest.get_meta(pos):get_inventory()

		local shuffled = self:shuffled(loot)
		local ti = 0
		for i=1,count do
			ti = ti + 1
			if ti > #shuffled then
				ti = 1
			end

			local search = shuffled[ti]
			if search then
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

function aurum.features.structure_context(box, at, rotation)
	return setmetatable({
		box = box,
		rotation = rotation,
		_at = at,
		_ph = {},
	}, {__index = metatable})
end

minetest.register_on_generated(function(minp, maxp, seed)
	local center = vector.divide(vector.add(minp, maxp), 2)
	local biome = minetest.get_biome_data(center)
	local biome_name = biome and minetest.get_biome_name(biome.biome)

	if not biome_name then
		return
	end

	-- TODO: Use the seed for random structure choices.
	local function prob(chance)
		return math.random() <= chance
	end

	-- For all decorations registered with this biome...
	for _,name in ipairs(biome_map[biome_name] or {}) do
		local def = aurum.features.decorations[name]

		-- Look for suitable places.
		for _,pos in ipairs(minetest.find_nodes_in_area_under_air(minp, maxp, def.place_on)) do
			local pos = def.on_offset(pos)
			local schematic = def.schematic or def.make_schematic(pos, math.random)

			-- Random rotation 0 to 270 degrees.
			local rotation = math.random(0, 3)

			-- Calculate limit.
			local limit = vector.subtract(schematic.size, 1)
			if rotation == 1 or rotation == 3 then
				limit = vector.new(limit.z, limit.y, limit.x)
			end

			-- Center offset.
			local halflimit = vector.apply(vector.divide(limit, 2), function(v)
				return math.sign(v) * math.floor(math.abs(v))
			end)

			-- Shift pos by center offset.
			local real_pos = table.combine(vector.subtract(pos, halflimit), {y = pos.y})

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

			if prob(def.rarity) then
				-- Place schematic.
				local rotname = {"0", "90", "180", "270"}
				minetest.place_schematic(pos, schematic, rotname[rotation + 1], {}, true, {place_center_x = true, place_center_z = true})

				-- Run callback.
				def.on_generated(aurum.features.structure_context(aurum.box.new(
					at(vector.new(0, 0, 0)),
					at(limit)
				), at, rotation))
			end
		end
	end
end)
