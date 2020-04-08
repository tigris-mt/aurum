local S = minetest.get_translator()

aurum.magic.register_spell("extinguish", {
	description = S"Extinguish",
	longdesc = S"Snuffs out fire in a cube with a radius of the spell's level.",

	apply = function(pointed_thing, level, player)
		local pos = vector.round(minetest.get_pointed_thing_position(pointed_thing) or player:get_pos())

		for _,pos in ipairs(minetest.find_nodes_in_area(vector.subtract(pos, level), vector.add(pos, level), {"fire:basic_flame", "fire:permanent_flame"})) do
			minetest.remove_node(pos)
		end

		return true
	end,
})

aurum.magic.register_spell_ritual("extinguish", {
	longdesc = S"Molds water and lava into the essence of anti-fire.",

	size = b.box.new(vector.new(-1, 0, 0), vector.new(1, 1, 0)),
	protected = true,

	recipe = {
		{vector.new(-1, 0, 0), "group:water"},
		{vector.new(1, 0, 0), "aurum_base:lava_source"},
		{vector.new(0, 1, 0), "aurum_storage:scroll_hole"},
	},

	apply = function(at)
		if not aurum.magic.spell_ritual_inv(at(vector.new(0, 1, 0)), "main", "extinguish", 3) then
			return false
		end

		for _,pos in ipairs{
			vector.new(-1, 0, 0),
			vector.new(1, 0, 0),
		} do
			minetest.remove_node(at(pos))
		end

		return true
	end,
})
