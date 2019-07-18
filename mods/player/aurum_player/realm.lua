local realms = {}

minetest.register_on_joinplayer(function(player)
	aurum.player.realm_refresh(player)
end)

minetest.register_on_leaveplayer(function(player)
	realms[player:get_player_name()] = nil
end)

function aurum.player.get_realm(player)
	return realms[player:get_player_name()]
end

function aurum.player.realm_refresh(player)
	local realm = aurum.pos_to_realm(vector.round(player:get_pos()))

	-- No change.
	if realms[player:get_player_name()] == realm then
		return
	end

	realms[player:get_player_name()] = realm

	if realm then
		local r = aurum.realms.get(realm)

		r.apply_player(player)
	end
end

local timer = 0
minetest.register_globalstep(function(dtime)
	timer = timer + dtime
	if timer > 4 then
		timer = 0
		for _,player in ipairs(minetest.get_connected_players()) do
			aurum.player.realm_refresh(player)
		end
	end
end)

function aurum.player.teleport(player, pos)
	player:set_pos(pos)
	aurum.player.realm_refresh(player)
end
