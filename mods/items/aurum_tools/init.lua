aurum.tools = {}

-- Returns the variant properties.
function aurum.tools.register_variant(name)
	local def = minetest.registered_items[name]
	local properties = {
		_unenchanted = name,
		_enchanted = name .. "_enchanted",
	}

	minetest.override_item(name, properties)
	minetest.register_tool(":" .. properties._enchanted, table.combine(def, properties))
	return properties
end

-- Returns the (possibly modified) def.
function aurum.tools.register(name, def)
	minetest.register_tool(":" .. name, def)

	-- If this tool has enchant levels, register an enchanted variant.
	if (def._enchant_levels or 0) > 0 then
		return table.combine(def, aurum.tools.register_variant(name))
	end
	return def
end

aurum.tools.enchants = {}

aurum.dofile("default_enchants.lua")
aurum.dofile("default_tools.lua")
