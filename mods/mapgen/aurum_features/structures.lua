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
				if prob(def.rarity) then
					minetest.place_schematic(pos, def.schematic, "0", {}, true)
					def.on_generated(aurum.box.new(pos, vector.add(pos, def.schematic.size)))
				end
			end
		end
	end
end)
