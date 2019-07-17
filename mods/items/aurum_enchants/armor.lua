local S = minetest.get_translator()

aurum.tools.register_enchant_callback{
	init = function(state, stack)
		state.eqdef = gequip.get_eqdef(stack, true)
	end,

	apply = function(state, stack)
		stack:get_meta():set_string("eqdef", minetest.serialize(state.eqdef))
	end,
}

aurum.tools.register_enchant("speed", {
	categories = {
		boots = true,
	},
	description = S"Speed",
	apply = function(state, level)
		state.eqdef.effects.speed = state.eqdef.effects.speed * (1 + (level + 1) / 5)
	end,
})

aurum.tools.register_enchant("psyche_shield", {
	categories = {
		helmet = true,
	},
	description = S"Psyche Shield",
	apply = function(state, level)
		state.eqdef.armor.psyche = state.eqdef.armor.psyche / (1 + level / 3)
	end,
})
