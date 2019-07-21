local S = minetest.get_translator()

minetest.register_chatcommand("enchant", {
	params = S"<enchant> <level>",
	description = S"Modify the enchantments on the wielded item",
	privs = {give = true},
	func = function(player, param)
		local player = minetest.get_player_by_name(player)
		if not player then
			return false, S"No player."
		end

		local split = param:split(" ")
		local enchant = split[1]
		local level = tonumber(split[2])

		if not enchant or not level then
			return false, S"Invalid parameters."
		end

		if level < 0 then
			return false, S"Level must be 0 or greater."
		end

		local stack = player:get_wielded_item()
		local possible = aurum.tools.get_possible_enchants(stack:get_name())

		if table.indexof(possible, enchant) == -1 then
			return false, S"Invalid enchantment for this item type."
		end

		local e = aurum.tools.get_item_enchants(stack)
		e[enchant] = level > 0 and level or nil
		player:set_wielded_item(aurum.tools.set_item_enchants(stack, e))

		return true, S("Enchant @1 set to level @2.", enchant, level)
	end,
})


