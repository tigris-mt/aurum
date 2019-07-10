aurum = {}

-- Do a file relative to the current mod.
aurum.dofile = function(path)
	return dofile(minetest.get_modpath(minetest.get_current_modname()) .. "/" .. path)
end

-- The world size.
aurum.WORLD = {
	min = vector.new(-31000, -31000, -31000),
	max = vector.new(31000, 31000, 31000),
}

-- The world size, aligned to chunks.
aurum.WORLDA = {
	min = vector.new(-30000, -30000, -30000),
	max = vector.new(30000, 30000, 30000),
}

aurum.dofile("lua_utils.lua")

-- Helpful geometric functions.
aurum.dofile("geometry/box.lua")

-- Node sounds.
aurum.dofile("sounds.lua")
