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

		-- Decoration definitions.
		decorations = {},

		-- Growth terrain.
		terrain = {"group:soil"},
		-- Description of what this tree grows on.
		terrain_desc = S"any dirt or soil",
	}, def, {
		name = name
	})

	-- Register and set a part of the tree.
	-- Will set def[sub] to the new node's name.
	local function subnode(sub, default)
		-- If a string is specified, just use that for the part.
		-- An empty string indicates that the tree does not use this part.
		if type(def[sub]) == "string" then
			return (#def[sub] > 0) and def[sub] or nil
		end

		-- Combine the defs.
		local spec = table.combine(default, {
			-- Builds a translatable description according to the tree's S parameter.
			description = def.S(def.description .. " @1", default.description or ""),
		}, def[sub] or {})

		-- Create the final part def.
		local ndef = table.combine({
			name = name .. "_" .. sub,
			tiles = {def.texture_base .. "_" .. sub .. ".png"},
		}, spec)

		-- Register and set name in tree's table.
		minetest.register_node(ndef.name, ndef)
		def[sub] = ndef.name
		return ndef
	end

	subnode("trunk", {
		description = S"Trunk",
		_doc_items_longdesc = S"The trunk of a tree. It can be cut into planks.",
		sounds = aurum.sounds.wood(),
		groups = {dig_chop = 3, tree = 1, flammable = 1},
	})

	subnode("planks", {
		description = S"Planks",
		_doc_items_longdesc = S"Wood cut into planks. Firm and useful.",
		sounds = aurum.sounds.wood(),
		groups = {dig_chop = 3, wood = 1, flammable = 1},
	})

	local sapling = subnode("sapling", {
		description = S"Sapling",
		_doc_items_longdesc = S"A young tree. Given time, it will grow." .. "\n" .. def.S("It grows on @1.", def.terrain_desc),
		sounds = aurum.sounds.grass(),
		paramtype = "light",
		drawtype = "plantlike",
		selection_box = {
			type = "fixed",
			fixed = {-4 / 16, -8 / 16, -4 / 16, 4 / 16, 7 / 16, 4 / 16}
		},
		walkable = true,
		groups = {dig_hand = 3, flammable = 1, sapling = 1, attached_node = 1, grow_plant = 1},

		_on_grow_plant = function(pos, node)
			-- Ensure there's at least some room above the sapling.
			for y=1,3 do
				if minetest.get_node(vector.add(pos, vector.new(0, y, 0))).name ~= "air" then
					return false
				end
			end
			-- Ensure we're on valid terrain.
			local below = vector.add(pos, vector.new(0, -1, 0))
			if #minetest.find_nodes_in_area(below, below, def.terrain) == 0 then
				return false
			end
			-- Select and place a random schematic.
			local dk = table.keys(def.decorations)
			local d = def.decorations[dk[math.random(#dk)]]
			minetest.remove_node(pos)
			minetest.place_schematic(pos, d.schematic, d.rotation, {}, false, d.flags)
			return true
		end,

		on_construct = function(pos)
			minetest.get_node_timer(pos):start(math.random(60 * 4, 60 * 20))
		end,

		on_timer = function(pos)
			local node = minetest.get_node(pos)
			local def = minetest.registered_nodes[node.name]
			if def._on_grow_plant then
				-- Restart the timer if growth was not successful.
				return not def._on_grow_plant(pos, node)
			end
		end,
	})

	subnode("leaves", {
		description = S"Leaves",
		_doc_items_longdesc = S"A bundle of soft leaves. They will decay when not near a trunk.",
		sounds = aurum.sounds.grass(),

		drawtype = "allfaces_optional",
		waving = 2,
		paramtype = "light",
		place_param2 = 1,
		groups = {dig_chop = 3, dig_hand = 3, leaves = 1, flammable = 1, leafdecay = def.leafdecay},

		drop = {
			max_items = 1,
			items = {
				{rarity = 10, items = {sapling.name}},
				{rarity = 1, items = {name .. "_leaves"}},
			},
		},
	})

	for _,n in ipairs{
		"simple",
		"wide",
		"tall",
	} do
		def.decorations[n] = {
			schematic = aurum.dofile("decorations/" .. n .. ".lua")(def),
			rotation = "random",
			flags = {place_center_x = true, place_center_y = false, place_center_z = true}
		}
	end

	m.types[name] = def
end

aurum.dofile("decorations/init.lua")
aurum.dofile("default_trees.lua")
aurum.dofile("leafdecay.lua")
