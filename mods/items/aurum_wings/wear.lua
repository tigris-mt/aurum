local S = aurum.get_translator()

function aurum.wings.get_wings(player)
	local inv = player:get_inventory()
	local list = inv:get_list(gequip.types[aurum.wings.EQTYPE].list_name)
	local refresh = false
	for _,item in ipairs(list) do
		if item:get_count() > 0 and minetest.get_item_group(item:get_name(), "aurum_wings") > 0 then
			local eqdef = gequip.get_eqdef(item)
			if eqdef.durability then
				return math.floor((aurum.TOOL_WEAR - item:get_wear()) / aurum.TOOL_WEAR * eqdef.durability + 0.5), math.floor(eqdef.durability + 0.5)
			end
		end
	end
	return 0, 0
end

function aurum.wings.apply_wear(player, dtime)
	local inv = player:get_inventory()
	local list = inv:get_list(gequip.types[aurum.wings.EQTYPE].list_name)
	local refresh = false
	for _,item in ipairs(list) do
		if item:get_count() > 0 and minetest.get_item_group(item:get_name(), "aurum_wings") > 0 then
			local eqdef = gequip.get_eqdef(item)
			if eqdef.durability then
				item:add_wear(b.random_whole((aurum.TOOL_WEAR / eqdef.durability) * dtime / 60))
				hb.change_hudbar(player, "aurum_wings", math.floor((aurum.TOOL_WEAR - item:get_wear()) / aurum.TOOL_WEAR * eqdef.durability + 0.5), math.floor(eqdef.durability + 0.5))
				-- If destroyed, refresh to have the player fall.
				if item:get_count() == 0 then
					refresh = true
				end
			end
		end
	end
	inv:set_list(gequip.types[aurum.wings.EQTYPE].list_name, list)
	if refresh then
		gequip.refresh(player)
	end
end

local old_start = aurum.wings.on_start_fly
function aurum.wings.on_start_fly(player, ...)
	old_start(player, ...)
	local c, m = aurum.wings.get_wings(player)
	hb.change_hudbar(player, "aurum_wings", c, m)
	hb.unhide_hudbar(player, "aurum_wings")
end

local old_stop = aurum.wings.on_stop_fly
function aurum.wings.on_stop_fly(player, ...)
	old_stop(player, ...)
	hb.hide_hudbar(player, "aurum_wings")
end

minetest.register_on_joinplayer(function(player)
	local c, m = aurum.wings.get_wings(player)
	hb.init_hudbar(player, "aurum_wings", c, m)
end)

hb.register_hudbar("aurum_wings", 0xFFFFFF, S"Flight Minutes", {
	bar = "aurum_wings_bg.png",
	icon = "aurum_wings_wings.png",
	bgicon = "aurum_wings_bgicon.png"
}, 0, 0, true)
