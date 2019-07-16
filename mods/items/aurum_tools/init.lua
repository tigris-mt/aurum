local S = minetest.get_translator()
aurum.tools = {}

-- Returns the variant properties.
function aurum.tools.register_variant(name)
	local def = minetest.registered_items[name]
	local properties = {
		_unenchanted = name,
		_enchanted = name .. "_enchanted",
	}

	minetest.override_item(name, properties)
	minetest.register_tool(":" .. properties._enchanted, table.combine({_doc_items_create_entry = false}, def, properties, {
		groups = table.combine({not_in_creative_inventory = 1}, def.groups),
	}))
	return properties
end

-- Returns the (possibly modified) def.
function aurum.tools.register(name, def)
	local def = table.combine({
		_enchant_levels = 0,
		_enchants = {},
	}, def)
	minetest.register_tool(":" .. name, def)

	-- If this tool has enchant levels, register an enchanted variant.
	if (def._enchant_levels or 0) > 0 then
		return table.combine(def, aurum.tools.register_variant(name))
	end
	return def
end

-- Get possible enchant types for a tool, returns array or nil if unenchantable.
function aurum.tools.get_enchants(name)
	local def = minetest.registered_items[name]

	if (def._enchant_levels or 0) == 0 then
		return nil
	end

	local ret = {}
	for _,index in ipairs(def._enchants) do
		ret = table.combine(ret, aurum.tools.get_category_enchants(index) or {})
	end

	return ret
end

doc.sub.items.register_factoid("tools", "use", function(itemstring, def)
	if aurum.tools.get_enchants(itemstring) then
		local keys = {}
		for k,v in pairs(aurum.tools.get_enchants(itemstring)) do
			if v then
				table.insert(keys, k)
			end
		end
		return S("This tool has a potential enchantment level of @1.", def._enchant_levels) .. ((#keys > 0) and ("\n" .. S("Enchantment types: @1", table.concat(keys, ", "))) or "")
	end
	return ""
end)

aurum.dofile("enchants.lua")
aurum.dofile("default_tools.lua")
aurum.dofile("hammer_break.lua")
