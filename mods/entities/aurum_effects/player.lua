function aurum.effects.get_player(player)
	return minetest.deserialize(player:get_meta():get_string("aurum_effects")) or {}
end

function aurum.effects.set_player(player, effects)
	player:get_meta():set_string("aurum_effects", minetest.serialize(effects))
end

local huds = {}

minetest.register_globalstep(function(dtime)
	for _,player in ipairs(minetest.get_connected_players()) do
		local effects = aurum.effects.get_player(player)
		aurum.effects.operate(player, effects, dtime)
		aurum.effects.set_player(player, effects)

		local text = {}
		for name,state in b.t.spairs(effects) do
			local def = aurum.effects.effects[name]
			if not def.hidden then
				table.insert(text, state.forever and def.description or ("%s (%ds)"):format(def.description, math.ceil(state.duration)))
			end
		end
		player:hud_change(huds[player:get_player_name()], "text", table.concat(text, "\n"))
	end
end)

minetest.register_on_joinplayer(function(player)
	huds[player:get_player_name()] = player:hud_add{
		hud_elem_type = "text",
		text = "",
		number = 0xFFFFFF,
		position = {x = 1, y = 0.5},
		offset = {x = -0, y = -128},
		direction = 3,
		alignment = {x = -1, y = 1},
		scale = {x = 800, y = 20 * 20},
	}
end)

minetest.register_on_leaveplayer(function(player)
	huds[player:get_player_name()] = nil
end)
