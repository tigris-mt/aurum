local S = aurum.get_translator()

local search_positions = b.dofile("search_positions.lua")

function aurum.realms.get_spawn_prelim(id)
	-- Start out at 0,0,0.
	local pos = screalms.gpos(id, screalms.get(id).aurum_default_spawn or vector.new(0, 0, 0))
	local s = screalms.get(id).aurum_spawn_biomes

	if s then
		-- Look for an appropriate biome nearby.
		for _,try_s in ipairs(search_positions) do
			local try = screalms.gpos(id, vector.add(vector.multiply(try_s, 8), vector.new(0, 2, 0)))
			local biome = minetest.get_biome_data(try)
			if biome then
				local biome_name = minetest.get_biome_name(biome.biome)
				if s[biome_name] then
					pos = try
					break
				end
			end
		end
	end

	-- Try to get the natural spawn level there.
	return (function()
		for x=-64,64 do
			for z=-64,64 do
				local test = vector.add(pos, vector.new(x * 8, 2, z * 8))
				local level = minetest.get_spawn_level(test.x, test.y)
				if level then
					if s then
						local biome = minetest.get_biome_data(test)
						if biome then
							local biome_name = minetest.get_biome_name(biome.biome)
							if s[biome_name] then
								test.level = level
								return test
							end
						end
					else
						test.level = level
						return test
					end
				end
			end
		end
	end)() or pos
end

-- Get the central spawn point for a realm.
aurum.realms.get_spawn = b.cache.simple(function(id)
	local pos = aurum.realms.get_spawn_prelim(id)

	-- Go up until a free space is found.
	for y=0,250 do
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
end, function(id) return id end)

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

		aurum.player.teleport_guarantee(player, b.box.new_add(aurum.realms.get_spawn_prelim(param), vector.new(0, 150, 0)), function(player)
			aurum.player.teleport(player, aurum.realms.get_spawn(param))
		end)
		return true, S("Teleporting to @1", param)
	end,
})
