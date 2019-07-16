aurum.tools.enchants = {}

function aurum.tools.get_category_enchants(category)
	local ret = {}
	for k,v in pairs(aurum.tools.enchants) do
		if v.categories[category] then
			table.insert(ret, k)
		end
	end
	return ret
end

function aurum.tools.register_enchant(name, def)
	local def = table.combine({
		categories = {},
	}, def)
	aurum.tools.enchants[name] = def
end
