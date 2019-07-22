minetest.register_on_mods_loaded(function()
	local total = 0
	local queue = {}
	for k,v in pairs(aurum.tools.enchants) do
		for i=1,v.max_level do
			total = total + 1
			-- Rarity is (0.3 / level).
			-- Preciousness is (2 + level); level 1 at 3, level 3 at 5, and level 5 at 7.
			table.insert(queue, function()
				aurum.treasurer.register_itemstack(aurum.enchants.new_scroll(k, i), 1 / i / total, 2 + i, 1, 0, {"enchant", "scroll", "magic"})
			end)
		end
	end
	for _,f in ipairs(queue) do
		f()
	end
end)
