local S = aurum.get_translator()

aurum.magic.register_spell("create_fire", {
	description = S"Create Fire",
	longdesc = S"Creates a permanent flame. Higher levels create a surrounding cube of temporary fire.",

	apply_requirements = function(pointed_thing)
		return minetest.get_pointed_thing_position(pointed_thing, true) ~= nil
	end,

	apply = function(pointed_thing, level, player)
		local pos = minetest.get_pointed_thing_position(pointed_thing, true)

		for _,pos in ipairs(minetest.find_nodes_in_area(vector.subtract(pos, level - 1), vector.add(pos, level - 1), {"air"})) do
			if math.random() < 0.5 then
				minetest.set_node(pos, {name = "fire:basic_flame"})
			end
		end

		minetest.set_node(pos, {name = "fire:permanent_flame"})
		return true
	end,
})
