local function set(player)
	player:set_properties{
		hp_max = tonumber(minetest.settings:get("aurum_player.max_hp")) or 100,
	}
	player:set_hp(player:get_properties().hp_max)
end

minetest.register_on_newplayer(set)
minetest.register_on_respawnplayer(set)
