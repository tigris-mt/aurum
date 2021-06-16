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

	aurum.effects.remove_group(player, "aurum_realms")

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

	player:set_sun{
		visible = true,
		sunrise_visible = true,
	}

	player:set_moon{
		visible = true,
	}

	bright_night.apply(player)

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

awards.register_trigger("realm_change", {
	type = "counted_key",
	progress = "@1/@2 realms entered",
	auto_description = { "Enter: @2", "Enter: @1×@2" },
	auto_description_total = { "Enter @1 realm.", "Enter @1 realm." },
	get_key = function(self, def)
		return def.trigger.realm
	end,
})

function aurum.player.teleport(player, pos)
	local old_realm = aurum.player.get_realm(player)
	player:set_pos(pos)
	aurum.player.realm_refresh(player)
	local new_realm = aurum.player.get_realm(player)
	if old_realm ~= new_realm and new_realm then
		awards.notify_realm_change(player, new_realm)
	end
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
