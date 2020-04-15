-- Create aurum global.
b.dofile("aurum_table.lua")

-- Gravity acceleration.
aurum.GRAVITY = vector.new(0, -9.81, 0)

-- Tool wear max.
aurum.TOOL_WEAR = 65535

function aurum.is_air(name)
	return name == "air" or minetest.registered_nodes[name].drawtype == "airlike"
end

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
	if not player or not player:is_player() then
		return false
	end
	return has_creative and creative.is_enabled_for(player:get_player_name()) or false
end

-- Is pos protected against a player?
-- Player may be name or objectref.
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
		ret = b.t.icombine(ret, items)
	end
	return ret
end

-- Default on_blast callback, will drop all inventory and remove+drop self.
function aurum.drop_all_blast(pos)
	local drops = b.t.icombine(get_drops(pos), {name})
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
	local mod, name = (test or ""):match("([^:]*):(.*)")
	mod = mod or ""
	name = name or ""

	if mod == "group" then
		return minetest.get_item_group(item, name) > 0
	else
		return item == test
	end
end

-- Test if <item> matches any itemstring/groupstring in <test_list>.
function aurum.match_item_list(item, test_list)
	for _,test in ipairs(test_list) do
		if aurum.match_item(item, test) then
			return true
		end
	end
	return false
end

-- Send a message to a player object.
-- The message will be temporarily displayed prominently in some way.
function aurum.info_message(player, message)
	cmsg.push_message_player(player, message)
	minetest.chat_send_player(player:get_player_name(), message)
end

-- Set as allow_metadata_inventory_move to delegate all work to put/take.
function aurum.metadata_inventory_move_delegate(pos, from_list, from_index, to_list, to_index, count, player)
	local def = minetest.registered_nodes[minetest.get_node(pos).name]
	local inv = minetest.get_meta(pos):get_inventory()
	local actual_stack = inv:get_stack(from_list, from_index)
	actual_stack:set_count(count)
	return math.min(
		count,
		def.allow_metadata_inventory_put and def.allow_metadata_inventory_put(pos, to_list, to_index, actual_stack, player) or count,
		def.allow_metadata_inventory_take and def.allow_metadata_inventory_take(pos, from_list, from_index, actual_stack, player) or count
	)
end

function aurum.rotate_node_and_after(itemstack, placer, pointed_thing)
	local invert_wall = placer and placer:get_player_control().sneak or false
	return minetest.rotate_and_place(itemstack, placer, pointed_thing, aurum.in_creative(placer), {invert_wall = invert_wall}, false)
end

-- Get a b ref table for who to blame for object.
-- Returns nil if no ref table could be determined.
-- Override in mods.
function aurum.get_blame(object)
	if object:is_player() then
		return b.ref_to_table(object)
	else
		local e = object:get_luaentity()
		if e then
			if e._aurum_mobs_id then
				return b.ref_to_table(object)
			elseif e._gprojectile then
				return e._blame
			elseif e.name == "aurum_effects:dummy" then
				return e._blame
			end
		end
	end
end

b.dofile("damage.lua")

-- Node sounds.
b.dofile("sounds.lua")

-- Assign shape table in namespace.
aurum.shape = aurum_shape
