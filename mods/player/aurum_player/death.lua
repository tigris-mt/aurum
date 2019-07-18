minetest.register_on_dieplayer(function(player)
	local lists = {"main", "craft"}
	for k,v in pairs(gequip.types) do
		table.insert(lists, v.list_name)
	end

	for _,list in ipairs(lists) do
		for _,item in ipairs(player:get_inventory():get_list(list)) do
			aurum.drop_item(player:get_pos(), item)
		end
		player:get_inventory():set_list(list, {})
	end

	gequip.refresh(player)
end)
