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

-- Tool wear max.
aurum.TOOL_WEAR = 65535

-- Drop item with slightly random position and velocity.
function aurum.drop_item(pos, item)
	local function r(c)
		return c - 0.5 + math.random()
	end
	local obj = minetest.add_item(vector.apply(pos, r), item)
	if obj then
		obj:set_velocity(vector.multiply(vector.apply(vector.new(0, 1, 0), r), 3))
	end
end

-- Get a node, loading it from disk if necessary.
function aurum.force_get_node(pos)
	local node = minetest.get_node_or_nil(pos)
	if not node then
		VoxelManip():read_from_map(pos, pos)
		node = minetest.get_node(pos)
	end
	return node
end

local has_creative = minetest.get_modpath("creative")
function aurum.in_creative(player)
	return has_creative and creative.is_enabled_for(player:get_player_name()) or false
end

aurum.dofile("lua_utils.lua")

aurum.dofile("damage.lua")

-- Helpful geometric functions.
aurum.dofile("geometry/box.lua")

-- Node sounds.
aurum.dofile("sounds.lua")
