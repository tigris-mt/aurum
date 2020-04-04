local S = minetest.get_translator()

aurum.hunger = {
	STARVE_HP = 1,
	REGEN_LIMIT = 75,
	REGEN_HP = 2,
	MAX = 100,
	LOSS = 1 / 30, -- 50 minutes to empty.
	REGEN_TIMES = 10,
	TICK = 2,
}

function aurum.hunger.hunger(player, set, relative)
	if set then
		local old = aurum.hunger.hunger(player)
		-- Actual amount set when relative is true is current + set.
		local set = relative and (set + old) or set
		-- Clamp to reasonable values.
		set = math.max(0, math.min(set, aurum.hunger.MAX))

		player:get_meta():set_float("aurum_hunger:hunger", set)
		hb.change_hudbar(player, "aurum_hunger", math.floor(set + 0.5), aurum.hunger.MAX)
	else
		return player:get_meta():get_float("aurum_hunger:hunger", set)
	end
end

minetest.register_on_respawnplayer(function(player)
	aurum.hunger.hunger(player, aurum.hunger.MAX)
end)

minetest.register_on_joinplayer(function(player)
	if player:get_meta():get_int("aurum_hunger:has") ~= 1 then
		player:get_meta():set_float("aurum_hunger:hunger", aurum.hunger.MAX)
		player:get_meta():set_int("aurum_hunger:has", 1)
	end
	hb.init_hudbar(player, "aurum_hunger", math.floor(aurum.hunger.hunger(player) + 0.5), aurum.hunger.MAX)
end)

hb.register_hudbar("aurum_hunger", 0xFFFFFF, S"Satiation", {
	bar = "aurum_hunger_bg.png",
	icon = "aurum_hunger_icon.png",
	bgicon = "aurum_hunger_bgicon.png"
}, 0, aurum.hunger.MAX, false)

minetest.register_chatcommand("hunger", {
	params = S"<amount> [<username or self>] [<absolute boolean>]",
	description = S"Set player hunger.",
	privs = {mana = true},
	func = function(caller, param)
		local split = param:split(" ")

		local amount = tonumber(split[1])
		local target = split[2] and minetest.get_player_by_name(split[1]) or minetest.get_player_by_name(caller)
		local relative = not minetest.is_yes(split[3])

		if not amount then
			return false, S"Invalid amount."
		end

		if not target then
			return false, S"Invalid target."
		end

		aurum.hunger.hunger(target, amount, relative)
		return true, S("@1 now has @2 satiation.", target:get_player_name(), aurum.hunger.hunger(target))
	end,
})

local timer = 0
minetest.register_globalstep(function(dtime)
	timer = timer + dtime
	if timer > aurum.hunger.TICK then
		for _,player in ipairs(minetest.get_connected_players()) do
			aurum.hunger.hunger(player, -aurum.hunger.LOSS * timer, true)
			local h = aurum.hunger.hunger(player)
			if h <= 0 then
				player:punch(player, 1, {
					full_punch_interval = 1.0,
					damage_groups = {starve = aurum.hunger.STARVE_HP * timer},
				})
			elseif h >= aurum.hunger.REGEN_LIMIT then
				if player:get_hp() < player:get_properties().hp_max then
					aurum.hunger.hunger(player, -aurum.hunger.LOSS * aurum.hunger.REGEN_TIMES * timer, true)
					player:set_hp(player:get_hp() + aurum.hunger.REGEN_HP * timer)
				end
			end
		end
		timer = 0
	end
end)

minetest.register_on_item_eat(function(change, replace, itemstack, player)
	aurum.hunger.hunger(player, change, true)
	itemstack:take_item()
	if replace then
		aurum.drop_item(player:get_pos(), player:get_inventory():add_item("main", itemstack:add_item(replace)))
	end
	return itemstack
end)
