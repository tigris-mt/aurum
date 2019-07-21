minetest.register_on_player_hpchange(function(player, hp_change, reason)
	if hp_change >= 0 then
		return
	end
	local inv = player:get_inventory()
	for _,def in pairs(gequip.types) do
		local list = inv:get_list(def.list_name)
		for _,item in ipairs(list) do
			if item:get_count() > 0 then
				local eqdef = gequip.get_eqdef(item)
				if eqdef.durability then
					item:add_wear(aurum.TOOL_WEAR / eqdef.durability)
				end
			end
		end
		inv:set_list(def.list_name, list)
	end
end)
