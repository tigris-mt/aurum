local S = aurum.get_translator()

aurum.effects.register("aurum_effects:poison", {
	max_level = 3,
	description = S"Poison",
	longdesc = S"Contact with toxic substances. Poison will cause damage over time.",
	repeat_interval = 1,
	apply = function(object, level)
		object:punch(aurum.effects.make_blame_puncher(object, aurum.effects.has(object, "aurum_effects:poison").blame), 1, {
			full_punch_interval = 1.0,
			damage_groups = {poison = level * 2},
		})
	end,
	cancel = function() end,
})
