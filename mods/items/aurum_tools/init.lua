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
		inventory_image = (def.inventory_image and #def.inventory_image > 0) and (def.inventory_image .. "^aurum_tools_enchanted.png") or nil,
		wield_image = (def.wield_image and #def.wield_image > 0) and (def.wield_image .. "^aurum_tools_enchanted.png") or nil,
	}))
	doc.add_entry_alias("tools", name, "tools", name .. "_enchanted")
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

doc.add_category("enchants", {
	name = S"Enchants",
	description = S"Attribute boosts for usable items",
	build_formspec = doc.entry_builders.text,
})

doc.add_entry("basics", "enchants", {
	name = S"Enchanting",
	data = {
		text = table.concat({
			S"Enchantments are contained within scrolls of enchantment. They provide attribute boosts and benefits for items.",
			S"By using an Enchanting Table, you can add appropriate enchantments to items such as tools or armor.",
			S"Items can only support a certain level of enchantment, so the number and level of their enchanting is limited.",
		}, "\n"),
	},
})

aurum.dofile("enchants.lua")
aurum.dofile("default_tools.lua")
aurum.dofile("hammer_break.lua")

aurum.dofile("enchant_command.lua")
