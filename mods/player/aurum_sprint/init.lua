minetest.register_globalstep(function()
	for _,player in ipairs(minetest.get_connected_players()) do
		player_monoids.speed:add_change(player, player:get_player_control().aux1 and 2 or 1, "aurum_sprint:sprint")
		aurum.hunger.LOSS:add_change(player, player:get_player_control().aux1 and 30 or 1, "aurum_sprint:sprint")
	end
end)
