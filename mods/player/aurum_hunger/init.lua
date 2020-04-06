local S = minetest.get_translator()

local function monoid(identity)
	return player_monoids.make_monoid{
		combine = function(a, b)
			return a * b
		end,
		fold = function(tab)
			local r = identity
			for _,v in pairs(tab) do
				r = r * v
			end
			return r
		end,
		identity = identity,
		apply = function(n, player) end,
		on_change = function() return end,
	}
end

aurum.hunger = {
	STARVE_HP = monoid(1),
	REGEN_LIMIT = monoid(75),
	REGEN_HP = monoid(1),
	MAX = monoid(100),
	LOSS = monoid(1 / 30), -- 50 minutes to empty.
	REGEN_LOSS = monoid(1 / 3),
	TICK = 2,
}

function aurum.hunger.hunger(player, set, relative)
	if set then
		local old = aurum.hunger.hunger(player)
		-- Actual amount set when relative is true is current + set.
		local set = relative and (set + old) or set
		-- Clamp to reasonable values.
		set = math.max(0, math.min(set, aurum.hunger.MAX:value(player)))

		player:get_meta():set_float("aurum_hunger:hunger", set)
		hb.change_hudbar(player, "aurum_hunger", math.floor(set + 0.5), aurum.hunger.MAX:value(player))
	else
		return player:get_meta():get_float("aurum_hunger:hunger", set)
	end
end

minetest.register_on_respawnplayer(function(player)
	aurum.hunger.hunger(player, aurum.hunger.MAX:value(player))
end)

minetest.register_on_joinplayer(function(player)
	if player:get_meta():get_int("aurum_hunger:has") ~= 1 then
		player:get_meta():set_float("aurum_hunger:hunger", aurum.hunger.MAX:value(player))
		player:get_meta():set_int("aurum_hunger:has", 1)
	end
	hb.init_hudbar(player, "aurum_hunger", math.floor(aurum.hunger.hunger(player) + 0.5), aurum.hunger.MAX:value(player))
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
			if player:get_hp() > 0 then
				aurum.hunger.hunger(player, -aurum.hunger.LOSS:value(player) * timer, true)
				local h = aurum.hunger.hunger(player)
				if h <= 0 then
					player:punch(player, 1, {
						full_punch_interval = 1.0,
						damage_groups = {starve = b.random_whole(aurum.hunger.STARVE_HP:value(player) * timer)},
					})
				elseif h >= aurum.hunger.REGEN_LIMIT:value(player) then
					if player:get_hp() < player:get_properties().hp_max then
						aurum.hunger.hunger(player, -aurum.hunger.REGEN_LOSS:value(player) * timer, true)
						player:set_hp(player:get_hp() + b.random_whole(aurum.hunger.REGEN_HP:value(player) * timer))
					end
				end
			end
		end
		timer = 0
	end
end)

doc.sub.items.register_factoid(nil, "use", function(itemstring, def)
	if minetest.get_item_group(itemstring, "edible") > 0 then
		return S("This item provides @1 satiation when eaten.", minetest.get_item_group(itemstring, "edible"))
	end
	return ""
end)

doc.sub.items.register_factoid(nil, "use", function(itemstring, def)
	if minetest.get_item_group(itemstring, "edible_morale") > 0 then
		return S("This item provides @1 morale when eaten.", minetest.get_item_group(itemstring, "edible_morale"))
	end
	return ""
end)

minetest.register_on_item_eat(function(change, replace, itemstack, player)
	local def = itemstack:get_definition()

	-- Apply/remove morale buff.
	local morale = minetest.get_item_group(itemstack:get_name(), "edible_morale")
	if morale > 0 then
		aurum.effects.add(player, "aurum_effects:morale", morale, 10 * 60)
	else
		aurum.effects.remove(player, "aurum_effects:morale")
	end

	-- Play appropriate sound.
	minetest.sound_play((def and def.sound and def.sound.eat) or {name = "aurum_hunger_eat", gain = 1}, {
		object = player,
		max_hear_distance = 16,
	})

	-- Modify hunger.
	aurum.hunger.hunger(player, change, true)

	-- Take item and possibly replace.
	itemstack:take_item()
	if replace then
		aurum.drop_item(player:get_pos(), player:get_inventory():add_item("main", itemstack:add_item(replace)))
	end
	return itemstack
end)
