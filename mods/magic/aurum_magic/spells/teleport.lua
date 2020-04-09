local S = minetest.get_translator()

aurum.magic.register_spell("teleport", {
	description = S"Teleport",
	longdesc = S"Teleports the user to a specific location.",
	max_level = 3,

	rod = function(level) return "aurum_magic:teleport_rod_" .. level end,

	apply_requirements = function(pointed_thing)
		return pointed_thing.type == "node"
	end,

	apply = function(pointed_thing, level, player)
		local pos = minetest.get_pointed_thing_position(pointed_thing, true)
		player:set_pos(pos)
	end,
})

for i=1,3 do
	aurum.rods.register("aurum_magic:teleport_rod_" .. i, {
		range = 20 * i,
	})
end
