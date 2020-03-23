local S = minetest.get_translator()

-- Get the central spawn point for a realm.
function aurum.realms.get_spawn(id)
	-- Start out at 0,0,0.
	local pos = screalms.gpos(id, vector.new(0, 0, 0))
	-- Try to get the natural spawn level there.
	pos = b.t.combine(pos, {y = minetest.get_spawn_level(pos.x, pos.z)})

	-- Go up until a free space is found.
	for y=0,150 do
		local t = vector.add(pos, vector.new(0, y, 0))

		-- If enough free space, then return here.
		local function above(n)
			return aurum.force_get_node(vector.add(t, vector.new(0, n, 0))).name
		end
		if aurum.is_air(above(0)) and aurum.is_air(above(1)) and aurum.is_air(above(2)) then
			return t
		end
	end

	-- Just fall back to 0,0,0 (or the spawn_level, if it was found).
	return pos
end

minetest.register_chatcommand("rteleport", {
	params = S"<realm>",
	description = S"Teleport to a realm's spawn",
	privs = {teleport = true},
	func = function(name, param)
		local player = minetest.get_player_by_name(name)
		if not player then
			return false
		end

		if not screalms.get(param) then
			return false, S"No such realm."
		end

		aurum.player.teleport_guarantee(player, b.box.new_add(aurum.realms.get_spawn(param), vector.new(0, 150, 0)), function(player)
			aurum.player.teleport(player, aurum.realms.get_spawn(param))
		end)
		return true, S("Teleporting to @1", param)
	end,
})
