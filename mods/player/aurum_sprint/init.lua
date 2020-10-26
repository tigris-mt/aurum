minetest.register_globalstep(function()
	for _,player in ipairs(minetest.get_connected_players()) do
		local sprint = player:get_player_control().aux1 and not player:get_attach()
		player_monoids.speed:add_change(player, sprint and 2 or 1, "aurum_sprint:sprint")
		aurum.hunger.LOSS:add_change(player, sprint and 10 or 1, "aurum_sprint:sprint")
	end
end)
