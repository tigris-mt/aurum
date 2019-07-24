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
-- Is a player in creative?
function aurum.in_creative(player)
	return has_creative and creative.is_enabled_for(player:get_player_name()) or false
end

-- Is pos protected against a player?
-- Quiet option may be respected, for times when the player does not need to be aware of protection.
function aurum.is_protected(pos, player_or_name, quiet)
	local name = (type(player_or_name) == "string") and player_or_name or player_or_name:get_player_name()
	if minetest.is_protected(pos, name) then
		if not quiet then
			minetest.record_protection_violation(pos, name)
		end
		return true
	end
	return false
end

-- Get all inventory drops from meta at pos.
local function get_drops(pos)
	local ret = {}
	local inv = minetest.get_meta(pos):get_inventory()
	for _,items in pairs(inv:get_lists()) do
		ret = table.icombine(ret, items)
	end
	return ret
end

-- Default on_blast callback, will drop all inventory and remove+drop self.
function aurum.drop_all_blast(pos)
	local drops = table.icombine(get_drops(pos), {name})
	minetest.remove_node(pos)
	return drops
end

-- Default on_destruct callback, will drop all inventory.
function aurum.drop_all(pos)
	for _,drop in ipairs(get_drops(pos)) do
		aurum.drop_item(pos, drop)
	end
end

-- Will replace first line of description with metadata description_override if available.
function aurum.set_stack_description(stack, description)
	local split = description:split("\n", true)
	local override = stack:get_meta():get_string("description_override")
	if #override > 0 then
		split[1] = override
	end
	stack:get_meta():set_string("description", table.concat(split, "\n"))
	return stack
end

-- Does the <item> itemstring match <test> itemstring?
-- Test can be a group:groupname itemstring.
function aurum.match_item(item, test)
	local mod, name = test:match("([^:]*):(.*)")
	mod = mod or ""
	name = name or ""

	if mod == "group" then
		return minetest.get_item_group(item, name) > 0
	else
		return item == test
	end
end

aurum.dofile("lua_utils.lua")
aurum.dofile("set.lua")

aurum.dofile("damage.lua")

-- Helpful geometric functions.
aurum.dofile("geometry/box.lua")

-- Node sounds.
aurum.dofile("sounds.lua")
