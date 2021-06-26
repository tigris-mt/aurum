local S = aurum.get_translator()

aurum.effects.register("aurum_effects:breath_regen", {
	max_level = 3,
	description = S"Breath Regen",
	longdesc = S"Regenerates breath even when submerged.",
	repeat_interval = 1,
	enchant = false,
	apply = function(object, level)
		object:set_breath(object:get_breath() + b.random_whole(0.2 * level))
	end,
	cancel = function() end,
})
