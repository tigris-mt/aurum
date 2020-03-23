local realms = {}
local default_color = {}

minetest.register_on_joinplayer(function(player)
	default_color = player:get_sky_color()
	aurum.player.realm_refresh(player)
end)

minetest.register_on_leaveplayer(function(player)
	realms[player:get_player_name()] = nil
end)

function aurum.player.get_realm(player)
	return realms[player:get_player_name()]
end

function aurum.player.realm_refresh(player)
	local realm = screalms.pos_to_realm(vector.round(player:get_pos()))
	realms[player:get_player_name()] = realm

	-- Restore default appearances.
	player:set_sky{
		type = "regular",
		sky_color = default_color,
		clouds = true,
	}
	player:set_clouds{
		density = 0.4,
		color = "#fff0f0e5",
		ambient = "#000000",
		thickness = 16,
		speed = {x = 0, z = -2},
		height = tonumber(minetest.settings:get("cloud_height")) or 120,
	}
	player:override_day_night_ratio(nil)

	if realm then
		local r = screalms.get(realm)
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

function aurum.player.teleport_guarantee(player, box, after, cancel)
	cancel = cancel or function(player) return false end
	local name = player:get_player_name()
	local cancelled = false
	minetest.emerge_area(box.a, box.b, function(_, _, remaining)
		local player = minetest.get_player_by_name(name)
		if not player then
			cancelled = true
		end
		if cancelled then
			return
		end
		if cancel(player) then
			cancelled = true
		elseif remaining <= 0 then
			after(player)
		end
	end)
end
