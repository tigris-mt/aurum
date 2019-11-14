aurum.biomes = {}

-- List of biomes per realm.
aurum.biomes.realms = {}

-- List of biomes per variant.
aurum.biomes.variants = {}

aurum.biomes.biomes = {}

-- Register a biome with the position limits defined relative to and limited by a realm's box.
function aurum.biomes.register(realm, def)
	local def = b.t.combine(aurum.realms.get(realm).biome_default, def)

	-- Construct original biome box.
	local min = b.t.combine(aurum.realms.get(realm).local_box.a, {y = def.y_min}, def.min_pos or {})
	local max = b.t.combine(aurum.realms.get(realm).local_box.b, {y = def.y_max}, def.max_pos or {})
	local box = aurum.box.translate(aurum.box.new(min, max), aurum.realms.get(realm).global_center)

	-- Set new biome box.
	def.min_pos = box.a
	def.max_pos = box.b

	aurum.biomes.realms[realm] = aurum.biomes.realms[realm] or {}
	table.insert(aurum.biomes.realms[realm], def.name)
	return minetest.register_biome(def)
end

local function add_suffix(name, suffix)
	 return (suffix == "base") and name or (name .. "_" .. suffix)
end

function aurum.biomes.register_all(realm, def)
	def = b.t.combine({
		_groups = {},
		_variants = {},
	}, def)

	table.insert(def._groups, realm)

	aurum.biomes.biomes[def.name] = def

	for suffix,variant in pairs(def._variants) do
		local vdef = b.t.combine(def, variant, {
			name = add_suffix(def.name, suffix)
		})

		aurum.biomes.variants[suffix] = aurum.biomes.variants[suffix] or {}
		table.insert(aurum.biomes.variants[suffix], def.name)

		aurum.biomes.register(realm, vdef)
	end
end

function aurum.biomes.get_all_group(group, variants)
	local ret = {}
	for name,def in pairs(aurum.biomes.biomes) do
		local ok = false
		for _,bgroup in ipairs(def._groups) do
			if bgroup == group then
				ok = true
				break
			end
		end
		if ok then
			for _,v in ipairs(variants or b.t.keys(def._variants)) do
				if def._variants[v] then
					table.insert(ret, add_suffix(def.name, v))
				end
			end
		end
	end
	return ret
end

local function sum_rarity(table, keys)
	local total = 0
	local keys = keys or b.t.keys(table)
	for _,k in ipairs(keys) do
		total = total + (table[k] or 1)
	end
	return total
end

function aurum.biomes.register_tree_decoration(def)
	local treedef = aurum.trees.types[def.name]
	local d = treedef.decodefs
	local def = b.t.combine({
		-- Relative rarity.
		rarity = 1,
		-- Tree types to use.
		--- Only keys, uses rarity from tree definition.
		schematics = b.t.keys(b.t.map(treedef.decorations, function(v) return (v > 0) and v or nil end)),
		--- Keys and values: <tree>: <rarity>
		custom_schematics = {},
		-- Decoration biomes.
		biomes = nil,
		-- Custom tree types.
	}, def)

	local total = sum_rarity(def.custom_schematics) + sum_rarity(treedef.decorations, def.schematics)

	for _,k in ipairs(def.schematics) do
		minetest.register_decoration(b.t.combine({
			deco_type = "schematic",
			place_on = treedef.terrain,
			sidelen = 80,
			fill_ratio = 0.005 * (def.rarity or 1) * (treedef.decorations[k] or 1) / total,
			biomes = def.biomes,
		}, d[k]))
	end

	for schematic_name,rarity in pairs(def.custom_schematics) do
		minetest.register_decoration(b.t.combine({
			deco_type = "schematic",
			place_on = treedef.terrain,
			sidelen = 80,
			fill_ratio = 0.005 * (def.rarity or 1) * rarity / total,
			biomes = def.biomes,
		}, aurum.trees.generate_decoration(def.name, schematic_name)))
	end
end

b.dofile("variants.lua")

b.dofile("biomes/aurum.lua")
b.dofile("biomes/loom.lua")
b.dofile("biomes/primus.lua")
