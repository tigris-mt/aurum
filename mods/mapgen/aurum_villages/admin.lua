local S = aurum.get_translator()

minetest.register_privilege("villages", {
	description = S"Can manually spawn villages.",
	give_to_singleplayer = false,
})

minetest.register_chatcommand("spawn_village", {
	params = S"<name>",
	description = S"Spawn a village at your current position.",
	privs = {villages = true},
	func = function(caller, param)
		local caller = minetest.get_player_by_name(caller)
		if caller then
			if aurum.villages.villages[param] then
				local ok = aurum.villages.generate_village(param, vector.round(caller:get_pos()), {
					emerge = false,
				})
				return ok, (ok and S"Village spawned." or S"Could not spawn village.")
			else
				return false, S"Village not registered."
			end
		else
			return false, S"No caller."
		end
	end,
})
