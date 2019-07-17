local S = minetest.get_translator()
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

		description = "?",

		apply = function(state, level, stack) end,
	}, def)
	aurum.tools.enchants[name] = def
end

-- Get possible enchant types for a tool, returns array or nil if unenchantable.
function aurum.tools.get_possible_enchants(name)
	local def = minetest.registered_items[name]

	if (def._enchant_levels or 0) == 0 then
		return nil
	end

	local ret = {}
	for _,index in ipairs(def._enchants) do
		ret = table.icombine(ret, aurum.tools.get_category_enchants(index) or {})
	end

	return ret
end

doc.sub.items.register_factoid("tools", "use", function(itemstring, def)
	local possible = aurum.tools.get_possible_enchants(itemstring)
	if possible then
		table.sort(possible)
		return S("This tool has a potential enchantment level of @1.", def._enchant_levels) .. ((#possible > 0) and ("\n" .. S("Enchantment types: @1", table.concat(possible, ", "))) or "")
	end
	return ""
end)

-- Get a table of item enchants.
function aurum.tools.get_item_enchants(stack)
	local meta = stack:get_meta()
	return meta:contains("enchants") and minetest.deserialize(meta:get_string("enchants")) or {}
end

-- Write back enchants and refresh properties.
-- Returns stack.
function aurum.tools.set_item_enchants(stack, enchants)
	stack:get_meta():set_string("enchants", minetest.serialize(enchants))
	return aurum.tools.refresh_item(stack)
end

aurum.tools.enchant_callbacks = {}

function aurum.tools.register_enchant_callback(def)
	table.insert(aurum.tools.enchant_callbacks, table.combine({
		init = function(state, stack) end,
		apply = function(state, stack) end,
	}, def))
end

-- Refresh item properties from def and enchants.
-- Returns stack.
function aurum.tools.refresh_item(stack)
	local enchants = aurum.tools.get_item_enchants(stack)

	-- Create initial state from base properties.
	local state = {
		description = {stack:get_definition().description},
	}

	for _,v in ipairs(aurum.tools.enchant_callbacks) do
		v.init(state, stack)
	end

	local applied = false

	-- Apply all enchantments.
	for name,level in table.spairs(enchants) do
		if level > 0 then
			applied = true
			table.insert(state.description, S("@1: @2", aurum.tools.enchants[name].description, level))
			stack = aurum.tools.enchants[name].apply(state, level, stack) or stack
		end
	end

	-- Update enchanted variant.
	stack:set_name(applied and stack:get_definition()._enchanted or stack:get_definition()._unenchanted)

	-- Write refreshed data.
	for _,v in ipairs(aurum.tools.enchant_callbacks) do
		v.apply(state, stack)
	end
	stack:get_meta():set_string("description", table.concat(state.description, "\n"))

	return stack
end

aurum.tools.register_enchant_callback{
	init = function(state, stack)
		state.caps = stack:get_definition().tool_capabilities
	end,

	apply = function(state, stack)
		stack:get_meta():set_tool_capabilities(state.caps)
		return stack
	end,
}
