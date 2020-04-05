local S = minetest.get_translator()

aurum.effects.register("aurum_effects:morale", {
	max_level = 3,
	description = S"Morale",
	enchants = false,
	apply = function(object, level) end,
	cancel = function() end,
})
