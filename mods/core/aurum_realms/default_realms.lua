local S = minetest.get_translator()

aurum.realms.register("aurum:aurum", {
	description = S("Aurum"),
	size = vector.new(8000, 800, 8000),
})

function aurum_spawn(player)
	player:set_pos(aurum.realms.get_spawn("aurum:aurum"))
end

minetest.register_on_newplayer(aurum_spawn)
minetest.register_on_respawnplayer(aurum_spawn)
