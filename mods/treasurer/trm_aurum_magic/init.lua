minetest.register_on_mods_loaded(function()
	local total = 0
	local queue = {}
	for k,v in pairs(aurum.tools.enchants) do
		for i=1,v.max_level do
			total = total + 1
			table.insert(queue, function()
				aurum.treasurer.register_itemstack(aurum.enchants.new_scroll(k, i), 1 / i / total, 2 + i, 1, 0, {"enchant", "scroll", "magic"})
			end)
		end
	end
	for k,v in pairs(aurum.magic.spells) do
		for i=1,v.max_level do
			total = total + 1
			table.insert(queue, function()
				aurum.treasurer.register_itemstack(aurum.magic.new_spell_scroll(k, i), 0.75 / i / total, 1 + i, 1, 0, {"spell", "scroll", "magic"})
			end)
		end
	end
	for _,f in ipairs(queue) do
		f()
	end
end)
