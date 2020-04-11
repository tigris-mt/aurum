local S = minetest.get_translator()

aurum.magic.register_spell("rend_psyche", {
	description = S"Rend Psyche",
	longdesc = S"Deals a tremendous amount of pure psychic damage to a target.",
	max_level = 3,

	apply_requirements = function(pointed_thing)
		return pointed_thing.type == "object"
	end,

	apply = function(pointed_thing, level, player)
		pointed_thing.ref:punch(player, 1, {
			full_punch_interval = 1.0,
			damage_groups = {psyche = 20 + 10 * level},
		})
	end,
})
