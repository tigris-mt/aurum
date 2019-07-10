local S = minetest.get_translator()

aurum.realms.register("aurum_realms:aurum", {
	description = S("Aurum"),
	size = vector.new(480, 480, 480),
})

function aurum_spawn(player)
	local pos = aurum.gpos("aurum_realms:aurum", vector.new(0, 0, 0))
	pos = table.combine(pos, {y = minetest.get_spawn_level(pos.x, pos.z)})
	player:set_pos(pos)
end

minetest.register_on_newplayer(aurum_spawn)
minetest.register_on_respawnplayer(aurum_spawn)

aurum.realms.register("aurum_realms:aether", {
	description = S("The Aether"),
	size = vector.new(480, 480, 480),
})
