aurum.features.decorations = {}
local idx = 0

function aurum.features.register_decoration(def)
	local def = table.combine({
		place_on = {},
		rarity = 0.01,
		biomes = {},
		on_generated = function(box) end,
		schematic = nil,
	}, def)

	def.biome_map = aurum.set.new(def.biomes)

	idx = idx + 1
	def.name = def.name or ("aurum_features:deco_" .. idx)
	aurum.features.decorations[def.name] = def
end

for i=1,99 do
	minetest.register_node("aurum_features:ph_" .. i, {
		groups = {not_in_creative_inventory = 1},
		buildable_to = true,
		drop = "",
	})
end

minetest.register_on_generated(function(minp, maxp, seed)
	local center = vector.divide(vector.add(minp, maxp), 2)
	local biome = minetest.get_biome_data(center)
	local biome_name = biome and minetest.get_biome_name(biome.biome)

	if not biome_name then
		return
	end

	local rng = PseudoRandom(seed)

	local function prob(chance)
		return rng:next() / 32767 <= chance
	end

	for _,def in pairs(aurum.features.decorations) do
		if def.biome_map[biome_name] then
			for _,pos in ipairs(minetest.find_nodes_in_area_under_air(minp, maxp, def.place_on)) do
				local rotation = rng:next() % (3 + 1)
				rotation = 1
				local limit = vector.subtract(def.schematic.size, 1)
				if rotation == 1 or rotation == 3 then
					limit = vector.new(limit.z, limit.y, limit.x)
				end
				local rotname = {"0", "90", "180", "270"}
				local function at(offset)
					local actual = vector.new(0, offset.y, 0)
					if rotation % 4 == 0 then
						actual.x = offset.x
						actual.z = -offset.z
					elseif rotation % 4 == 1 then
						actual.x = -offset.x
						actual.z = -offset.z
					elseif rotation % 4 == 2 then
						actual.x = -offset.x
						actual.z = offset.z
					elseif rotation % 4 == 3 then
						actual.x = offset.z
						actual.z = offset.x
					end
					return vector.add(pos, actual)
				end
				if prob(def.rarity) then
					minetest.place_schematic(pos, def.schematic, rotname[rotation], {}, true, {place_center_x = true, place_center_z = true})
					def.on_generated(aurum.box.extremes(aurum.box.new(
							at(table.combine(vector.apply(vector.divide(limit, -2), math.floor), {y = 0})),
							at(table.combine(vector.apply(vector.divide(limit, 2), math.floor), {y = limit.y}))
						)), at)
				end
			end
		end
	end
end)
