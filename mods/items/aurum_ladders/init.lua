local S = minetest.get_translator()
aurum.ladders = {}

aurum.ladders.ladders = {}

function aurum.ladders.register(name, def)
	local tex = def._texture .. "^aurum_ladders_ladder.png^[makealpha:255,0,255"
	local def = table.combine({
		_doc_items_longdesc = S"The classic device for performing vertical movement.",
		drawtype = "signlike",
		tiles = {tex},
		inventory_image = tex,
		wield_image = tex,

		paramtype = "light",
		sunlight_propagates = true,

		paramtype2 = "wallmounted",
		walkable = false,
		climbable = true,
		selection_box = {type = "wallmounted"},
	}, def)

	minetest.register_node(name, def)
	aurum.ladders.ladders[name] = def
end

for k,v in pairs(aurum.trees.types) do
	local subname = k:match("[^:]*:(.*)")
	aurum.ladders.register("aurum_ladders:" .. subname, {
		description = S("@1 Ladder", v.description),
		_texture = minetest.registered_nodes[v.planks].tiles[1],
		groups = {dig_chop = 3},
		sounds = aurum.sounds.wood(),
	})

	minetest.register_craft{
		type = "fuel",
		recipe = "aurum_ladders:" .. subname,
		burntime = 2,
	}

	minetest.register_craft{
		output = "aurum_ladders:" .. subname .. " 16",
		recipe = {
			{v.planks, "", v.planks},
			{v.planks, v.planks, v.planks},
			{v.planks, "", v.planks},
		},
	}
end

aurum.ladders.register("aurum_ladders:iron", {
	description = S"Iron Ladder",
	_texture = aurum.ore.ores["aurum_ore:iron"].texture,
	groups = {dig_pick = 3},
	sounds = aurum.sounds.metal(),
})

minetest.register_craft{
		output = "aurum_ladders:iron 8",
		recipe = {
			{"aurum_ore:iron_ingot", "", "aurum_ore:iron_ingot"},
			{"aurum_ore:iron_ingot", "aurum_ore:iron_ingot", "aurum_ore:iron_ingot"},
			{"aurum_ore:iron_ingot", "", "aurum_ore:iron_ingot"},
		},
	}
