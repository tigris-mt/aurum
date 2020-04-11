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
		local attached = player:get_attach()
		if attached and attached:get_luaentity() and attached:get_luaentity().name == "aurum_wings:active_wings" then
			attached:set_pos(pos)
		else
			player:set_pos(pos)
		end
	end,
})

for i=1,3 do
	aurum.rods.register("aurum_magic:teleport_rod_" .. i, {
		range = 20 * i,
	})
end
