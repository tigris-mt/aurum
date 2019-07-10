local S = minetest.get_translator()
local m = {}
aurum.trees = m

m.types = {}
function m.register(name, def)
	assert(not m.types[name], "tree type already exists")

	def = table.combine({
		-- Basic description of tree type.
		description = "Generic",

		-- Base texture, will add subnames to it.
		texture_base = "aurum_trees_generic",

		-- Translator.
		S = S,

		-- Leafdecay distance.
		leafdecay = 4,
	}, def, {
		name = name
	})

	local function subnode(sub, default)
		if type(def[sub]) == "string" then
			return def[sub]
		end

		local subname = name .. "_" .. sub
		local spec = table.combine(default, def[sub] or {})
		local ndef = table.combine({
			description = def.S(def.description .. " @1", spec.description),
			tiles = {def.texture_base .. "_" .. sub .. ".png"},
		}, spec)
		minetest.register_node(subname, ndef)
		def[sub] = subname
	end

	subnode("trunk", {
		description = S"Trunk",
		_doc_items_longdesc = S"The trunk of a tree. It can be cut into planks.",
		sounds = aurum.sounds.wood(),
	})

	subnode("leaves", {
		description = S"Leaves",
		_doc_items_longdesc = S"A bundle of soft leaves.",
		sounds = aurum.sounds.grass(),

		drawtype = "allfaces_optional",
		waving = 2,
		paramtype = "light",
		place_param2 = 1,
		groups = {leafdecay = def.leafdecay},
	})

	subnode("planks", {
		description = S"Planks",
		_doc_items_longdesc = S"Wood cut into planks. Firm and useful.",
		sounds = aurum.sounds.wood(),
	})

	subnode("sapling", {
		description = S"Sapling",
		_doc_items_longdesc = S"A young tree. Given time, light, and soil, it will grow.",
		sounds = aurum.sounds.grass(),
		paramtype = "light",
		drawtype = "plantlike",
		selection_box = {
			type = "fixed",
			fixed = {-4 / 16, -8 / 16, -4 / 16, 4 / 16, 7 / 16, 4 / 16}
		},
		walkable = true,
	})

	m.types[name] = def
end

m.register("aurum_trees:oak", {
	description = "Oak",
	texture_base = "aurum_trees_oak",
})
