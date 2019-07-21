minetest.register_on_mods_loaded(function()
	for k,v in pairs(aurum.tools.enchants) do
		for i=1,v.max_level do
			aurum.treasurer.register_itemstack(aurum.enchants.new_scroll(k, i), 0.3 / v.max_level, 5 + 3 * (i / v.max_level), 1, 0, {"enchant", "scroll", "magic"})
		end
	end
end)
