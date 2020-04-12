local S = minetest.get_translator()

aurum.magic.register_spell("air_blast", {
	description = S"Air Blast",
	longdesc = S"Blasts air against whatever node the user is pointing at, sending the user flying backward.",
	max_level = 2,

	rod = function(level) return "aurum_magic:air_blast_rod_" .. level end,

	apply_requirements = function(thing)
		return thing.type == "node"
	end,

	apply = function(_, level, player)
		local vel = vector.multiply(player:get_look_dir(), -(5 + level * 2))

		local wings = aurum.wings.flying(player)
		if wings then
			wings:add_velocity(vel)
		else
			player:add_player_velocity(vel)
		end
	end,
})

for i=1,3 do
	aurum.rods.register("aurum_magic:air_blast_rod_" .. i, {
		range = 5 + i * 2,
		liquids_pointable = true,
	})
end

