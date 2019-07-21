aurum.treasurer = {}

local map = {}
local index = 0

-- Register an itemstack with metadata along will all other fields.
-- Only the itemstack's name and metadata will be used.
function aurum.treasurer.register_itemstack(stack, ...)
	index = index + 1
	local key = ("aurum_treasurer:%d"):format(index)
	map[key] = stack
	return treasurer.register_treasure(key, ...)
end

-- Override that catches special itemstack keys and replaces the name and metadata.
local old = treasurer.treasure_to_itemstack
function treasurer.treasure_to_itemstack(treasure)
	local ret = old(treasure)
	local over = map[treasure.name]
	if over then
		ret:set_name(over:get_name())
		ret:get_meta():from_table(over:get_meta():to_table())
	end
	return ret
end
