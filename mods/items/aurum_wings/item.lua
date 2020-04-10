local S = minetest.get_translator()

aurum.tools.register("aurum_wings:wings", {
	description = S"Wings",
	_doc_items_longdesc = S"Two shimmering wings, much like those of a butterfly. They flutter slightly.",
	_doc_items_usagehelp = S"Equip the wings in your chest slot. They will automatically engage whenever you fall for a while and retract when you touch the ground.",
	inventory_image = "aurum_wings_wings.png",
	groups = {trm_aurum_tools_preciousness = 10, equipment = 1},
	sound = aurum.sounds.tool(),
	_enchants = {"armor", "wings"},
	_enchant_levels = 9,
	_eqtype = "chest",
	on_use = gequip.on_use,
	_eqdef = {
		armor = {
			burn = 0.75,
			chill = 0.75,
			psyche = 0.75,
		},
		wings = true,
		durability = 100,
	},
})

gequip.register_action("aurum_wings:wings", {
	init = function(state)
		state.wings = false
	end,

	add = function(state, r)
		state.wings = state.wings or r.wings
	end,

	apply = function(state, player)
		player:get_meta():set_int("aurum_wings:wings", state.wings and 1 or 0)
	end,
})
