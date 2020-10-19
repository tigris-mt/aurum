local S = aurum.get_translator()

-- If the stack is equipment, then copy eqdef into the state and write it back to the metadata.
aurum.tools.register_enchant_callback{
	init = function(state, stack)
		if stack:get_definition()._eqtype then
			state.eqdef = gequip.get_eqdef(stack, true)
		end
	end,

	apply = function(state, stack)
		if stack:get_definition()._eqtype then
			stack:get_meta():set_string("eqdef", minetest.serialize(state.eqdef))
		end
	end,
}

aurum.tools.register_enchant("health_augmentation", {
	categories = {
		armor = true,
	},
	description = S"Health Augmentation",
	longdesc = S"Increases the wearer's maximum health.",
	apply = function(state, level)
		state.eqdef.hp_max = state.eqdef.hp_max * (1 + (level + 1) / 10)
	end,
})

aurum.tools.register_enchant("speed", {
	categories = {
		boots = true,
		wings = true,
	},
	description = S"Speed",
	longdesc = S"Increases the wearer's movement speed.",
	apply = function(state, level)
		state.eqdef.effects.speed = state.eqdef.effects.speed * (1 + (level + 1) / 5)
	end,
})

aurum.tools.register_enchant("psyche_shield", {
	categories = {
		helmet = true,
	},
	description = S"Psyche Shield",
	longdesc = S"Shields the wearer against psyche damage.",
	apply = function(state, level)
		state.eqdef.armor.psyche = state.eqdef.armor.psyche / (1 + level / 3)
	end,
})
