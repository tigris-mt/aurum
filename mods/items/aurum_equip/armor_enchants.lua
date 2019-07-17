local S = minetest.get_translator()

aurum.tools.register_enchant("speed", {
	categories = {
		boots = true,
	},
	description = S"Speed",
	apply = function(state, level)
		state.eqdef.effects = state.eqdef.effects or {}
		state.eqdef.effects.speed = (state.eqdef.effects.speed or 1) * (1 + level / 10)
	end,
})
