local S = minetest.get_translator()

aurum.realms.register("aurum:aurum", {
	description = S("Aurum"),
	size = vector.new(8000, 800, 8000),
})

if not minetest.settings:get("static_spawnpoint") then
	local function aurum_spawn(player)
		minetest.after(0, function()
			player:set_pos(aurum.realms.get_spawn("aurum:aurum"))
		end)
	end

	minetest.register_on_newplayer(aurum_spawn)
	minetest.register_on_respawnplayer(aurum_spawn)
end
