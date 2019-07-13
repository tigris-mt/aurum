aurum.biomes = {}

-- List of biomes per realm.
aurum.biomes.realms = {}

-- Register a biome with the position limits defined relative to and limited by a realm's box.
function aurum.biomes.register(realm, def)
	local def = table.combine({
		node_stone = aurum.realms.get(realm).stone,
	}, def)

	-- Construct original biome box.
	local min = table.combine(aurum.realms.get(realm).local_box.a, {y = def.y_min}, def.min_pos or {})
	local max = table.combine(aurum.realms.get(realm).local_box.b, {y = def.y_max}, def.max_pos or {})
	local box = aurum.box.translate(aurum.box.new(min, max), aurum.realms.get(realm).global_center)

	-- Set new biome box.
	def.min_pos = box.a
	def.max_pos = box.b

	aurum.biomes.realms[realm] = aurum.biomes.realms[realm] or {}
	table.insert(aurum.biomes.realms[realm], def.name)

	return minetest.register_biome(def)
end

function aurum.biomes.register_tree_decoration(def)
	local treedef = aurum.trees.types[def.name]
	local d = treedef.decorations
	local def = table.combine({
		-- Relative rarity.
		rarity = 1,
		-- Tree types to use.
		schematics = table.keys(d),
		-- Decoration biomes.
		biomes = nil,
	}, def)
	for _,k in ipairs(def.schematics) do
		minetest.register_decoration(table.combine({
			deco_type = "schematic",
			place_on = treedef.terrain,
			sidelen = 80,
			fill_ratio = 0.005 * (def.rarity or 1) / #def.schematics,
			biomes = def.biomes,
		}, d[k]))
	end
end

aurum.dofile("biomes/grassland.lua")
aurum.dofile("biomes/forest.lua")
