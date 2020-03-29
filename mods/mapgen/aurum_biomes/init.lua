aurum.biomes = {}

-- List of biomes per realm.
aurum.biomes.realms = {}

-- List of biomes per variant.
aurum.biomes.variants = {}

aurum.biomes.biomes = {}

-- Register a biome with the position limits defined relative to and limited by a realm's box.
function aurum.biomes.register(realm, def)
	local def = b.t.combine(screalms.get(realm).biome_default, def)

	-- Construct original biome box.
	local min = b.t.combine(screalms.get(realm).local_box.a, {y = def.y_min}, def.min_pos or {})
	local max = b.t.combine(screalms.get(realm).local_box.b, {y = def.y_max}, def.max_pos or {})
	local box = b.box.translate(b.box.new(min, max), screalms.get(realm).global_center)

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
		_complex_variants = false,
		_realm = realm,
	}, def)

	table.insert(def._groups, "all")
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
		if b.set(def._groups)[group] then
			for _,v in ipairs(variants or b.t.keys(def._variants)) do
				if def._variants[v] then
					table.insert(ret, add_suffix(def.name, v))
				end
				if def._complex_variants then
					for vk,vv in pairs(def._variants) do
						if vv._master_variant == v then
							table.insert(ret, add_suffix(def.name, vk))
						end
					end
				end
			end
		end
	end
	return ret
end

b.dofile("trees.lua")
b.dofile("variants.lua")

b.dodir("biomes")
