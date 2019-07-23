local S = minetest.get_translator()

aurum.magic.register_spell("extinguish", {
	description = S"Extinguish",
	longdesc = S"Snuffs out fire in a cube with a radius of the spell's level.",

	apply = function(pointed_thing, level, owner)
		local pos = vector.round(minetest.get_pointed_thing_position(pointed_thing) or owner:get_pos())

		for _,pos in ipairs(minetest.find_nodes_in_area(vector.subtract(pos, level), vector.add(pos, level), "fire:basic_flame")) do
			minetest.remove_node(pos)
		end

		return true
	end,
})
