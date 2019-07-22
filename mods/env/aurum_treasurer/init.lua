local S = minetest.get_translator()
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

minetest.register_chatcommand("givemetreasure", {
	params = S"[<amount>] [<min preciousness>] [<max preciousness>] [<group>]",
	description = S"Generates treasure.",
	privs = {give = true},
	func = function(name, params)
		local player = minetest.get_player_by_name(name)
		if not player then
			return false, S"No player."
		end

		local split = params:split(" ")
		local num = tonumber(split[1]) or 1
		local pmin = tonumber(split[2]) or 0
		local pmax = tonumber(split[3]) or 10
		local group = split[4]

		for i=1,num do
			player:get_inventory():add_item("main", treasurer.select_random_treasures(1, pmin, pmax, group)[1] or ItemStack(""))
		end
		return true, "Produced treasure."
	end,
})
