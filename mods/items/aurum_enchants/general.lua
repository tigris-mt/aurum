local S = minetest.get_translator()

aurum.tools.register_enchant("durability", {
	categories = {
		tool = true,
		armor = true,
	},
	description = S"Durability",
	apply = function(state, level)
		-- Nothing
	end,
})
