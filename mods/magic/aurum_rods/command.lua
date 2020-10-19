local S = aurum.get_translator()

minetest.register_chatcommand("bespellrod", {
	params = S"<spell> <level>",
	description = S"Modify the current rod's spell.",
	privs = {give = true},
	func = function(player, param)
		local player = minetest.get_player_by_name(player)
		if not player then
			return false, S"No player."
		end

		local split = param:split(" ")
		local spell = split[1]
		local level = tonumber(split[2])

		if not spell or not level then
			return false, S"Invalid parameters."
		end

		if not aurum.magic.spells[spell] then
			return false, S"No such spell."
		end

		if level < 0 then
			return false, S"Level must be 0 or greater."
		end

		local stack = player:get_wielded_item()
		if minetest.get_item_group(stack:get_name(), "rod") == 0 then
			return false, S"Not a rod."
		end
		stack:set_wear(0)
		stack = aurum.rods.set_item(stack, {
			spell = spell,
			level = level,
		})
		player:set_wielded_item(stack)

		return true, S("Bespelled: @1 @2.", spell, level)
	end,
})
