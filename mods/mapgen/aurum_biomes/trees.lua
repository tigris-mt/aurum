aurum.biomes.trees = {}

local function sum_rarity(table, keys)
	local total = 0
	local keys = keys or b.t.keys(table)
	for _,k in ipairs(keys) do
		total = total + (table[k] or 1)
	end
	return total
end

function aurum.biomes.trees.register(def)
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
		--- Will be grown after map generation.
		--- Same format as <custom_schematics>.
		post_schematics = {},
		-- Decoration biomes.
		biomes = nil,
		-- Custom tree types.
	}, def)

	local total = sum_rarity(def.custom_schematics) + sum_rarity(treedef.decorations, def.schematics) + sum_rarity(def.post_schematics)

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

	for schematic_name, rarity in pairs(def.post_schematics) do
		local deco = aurum.trees.generate_decoration(def.name, schematic_name)
		aurum.features.register_decoration{
			place_on = treedef.terrain,
			rarity = 0.005 * (def.rarity or 1) * rarity / total,
			biomes = def.biomes,
			schematic = deco.schematic,
			on_offset = function(context)
				return vector.add(context.pos, vector.new(0, deco.place_offset_y, 0))
			end,
		}
	end
end
