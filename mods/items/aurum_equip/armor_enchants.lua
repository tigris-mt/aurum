local S = minetest.get_translator()

aurum.tools.register_enchant("speed", {
	categories = {
		boots = true,
	},
	description = S"Speed",
	apply = function(state, level)
		state.eqdef.effects = state.eqdef.effects or {}
		state.eqdef.effects.speed = (state.eqdef.effects.speed or 1) * (1 + (level + 1) / 5)
	end,
})

aurum.tools.register_enchant("psyche_shield", {
	categories = {
		helmet = true,
	},
	description = S"Psyche Shield",
	apply = function(state, level)
		state.eqdef.armor = table.copy(state.eqdef.armor) or {}
		state.eqdef.armor.psyche = (state.eqdef.armor.psyche or 1) / (1 + level / 3)
	end,
})
