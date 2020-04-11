-- Test if player is flying. Returns reference to active wings or nil.
function aurum.wings.flying(player)
	local attached = player:get_attach()
	return (attached and attached:get_luaentity() and attached:get_luaentity().name == "aurum_wings:active_wings") and attached or nil
end

-- Override callback.
function aurum.wings.on_start_fly(player)
	minetest.chat_send_all(player:get_player_name())
end

-- Override callback.
function aurum.wings.on_stop_fly(player, damage)
	minetest.chat_send_all(player:get_player_name() .. " " .. damage)
end
