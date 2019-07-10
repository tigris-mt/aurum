-- Get the central spawn point for a realm.
function aurum.realms.get_spawn(id)
	local pos = aurum.gpos(id, vector.new(0, 0, 0))
	return table.combine(pos, {y = minetest.get_spawn_level(pos.x, pos.z)})
end

minetest.register_chatcommand("rteleport", {
	params = "<realm>",
	description = "Teleport to a realm's spawn",
	privs = {teleport = true},
	func = function(name, param)
		local player = minetest.get_player_by_name(name)
		if not player then
			return false
		end

		if not aurum.realms.get(param) then
			return false, "No such realm."
		end

		player:set_pos(aurum.realms.get_spawn(param))
		return true, "Teleported to " .. minetest.pos_to_string(player:get_pos())
	end,
})
