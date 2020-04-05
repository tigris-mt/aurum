local S = minetest.get_translator()

aurum.effects.register("aurum_effects:morale", {
	max_level = 3,
	description = S"Morale",
	longdesc = S"The result of eating well. Morale comes with increased resistance to poison and mental attacks.",
	enchant = false,
	apply = function(object, level)
		if object:is_player() then
			armor_monoid.monoid:add_change(object, {poison = 1 - level / 5, psyche = 1 - level / 5}, "aurum_effects:morale")
		end
	end,
	cancel = function(object)
		if object:is_player() then
			armor_monoid.monoid:del_change(object, "aurum_effects:morale")
		end
	end,
})
