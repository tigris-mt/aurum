function aurum.wings.apply_wear(player, dtime)
	local inv = player:get_inventory()
	local list = inv:get_list(gequip.types[aurum.wings.EQTYPE].list_name)
	local refresh = false
	for _,item in ipairs(list) do
		if item:get_count() > 0 and minetest.get_item_group(item:get_name(), "aurum_wings") > 0 then
			local eqdef = gequip.get_eqdef(item)
			if eqdef.durability then
				item:add_wear(b.random_whole((aurum.TOOL_WEAR / eqdef.durability) * dtime / 60))
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
