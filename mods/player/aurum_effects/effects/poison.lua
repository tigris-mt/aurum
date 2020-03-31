local S = minetest.get_translator()

aurum.effects.register("aurum_effects:poison", {
	max_level = 3,
	description = S"Poison",
	repeat_interval = 1,
	apply = function(player, level)
		player:punch(player, 1, {
			full_punch_interval = 1.0,
			damage_groups = {poison = level * 2},
		})
	end,
	cancel = function() end,
})
