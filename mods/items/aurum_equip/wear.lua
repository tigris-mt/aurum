-- When the player is damaged, add wear to their equipment.
minetest.register_on_player_hpchange(function(player, hp_change, reason)
	-- Only negative HP changes wear equipment.
	if hp_change >= 0 then
		return
	end

	local refresh = false

	-- Loop through all equipment.
	local inv = player:get_inventory()
	for _,def in pairs(gequip.types) do
		local list = inv:get_list(def.list_name)
		for _,item in ipairs(list) do
			if item:get_count() > 0 then
				-- If the equipment has durability, then wear it accordingly.
				local eqdef = gequip.get_eqdef(item)
				if eqdef.durability then
					item:add_wear(aurum.TOOL_WEAR / eqdef.durability)
					-- If destroyed, refresh to have the player fall.
					if item:get_count() == 0 then
						refresh = true
					end
				end
			end
		end
		inv:set_list(def.list_name, list)
	end

	if refresh then
		gequip.refresh(player)
	end
end)
