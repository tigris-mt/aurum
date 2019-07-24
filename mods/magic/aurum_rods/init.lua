local S = minetest.get_translator()
aurum.rods = {}

aurum.tools.register("aurum_rods:rod", {
	description = S"Rod",
	_doc_items_longdesc = "A bronze rod with a gold tip, intended for holding spells. It can be bespelled in a Rod Bespelling Table.",
	_doc_items_usage = "Punch something (or nothing) to use the spell held within the rod. The rod will wear out faster with higher-level spells.",
	inventory_image = "aurum_rods_rod.png",
	_enchant_levels = 6,
	_enchants = {"rod"},
	_rod_durability = 10,
	_rod_power = 0,
	groups = {rod = 1},

	on_use = function(stack, player, pointed_thing)
		local data = aurum.rods.get_item(stack)
		local spell = aurum.magic.spells[data.spell]
		if spell then
			local level = data.level

			-- Durability boost.
			local durability = stack:get_meta():get_int("rod_durability")
			if durability == 0 then
				durability = stack:get_definition()._rod_durability
			end

			-- Power boost.
			local power = stack:get_meta():get_int("rod_power")
			if power == 0 then
				power = stack:get_definition()._rod_power
			end

			-- Apply level boost.
			level = level + power

			if not spell.apply_requirements(pointed_thing, level, player) then
				return
			end

			spell.apply(pointed_thing, level, player)

			-- Apply one use per spell level, but not for levels from the power boost.
			stack:add_wear(aurum.TOOL_WEAR / durability * (level - power))
			return stack
		end
	end,
})

minetest.register_craft{
	output = "aurum_rods:rod",
	recipe = {
		{"aurum_ore:gold_ingot"},
		{"aurum_ore:bronze_ingot"},
		{"aurum_ore:bronze_ingot"},
	},
}

function aurum.rods.get_item(stack)
	return {
		spell = stack:get_meta():get_string("spell"),
		level = math.max(1, stack:get_meta():get_int("spell_level")),
	}
end

function aurum.rods.set_item(stack, data)
	stack:get_meta():set_string("spell", data.spell)
	stack:get_meta():set_int("spell_level", data.level)
	return aurum.tools.refresh_item(stack)
end

aurum.tools.register_enchant_callback{
	init = function(state, stack)
		state.is_rod = minetest.get_item_group(stack:get_name(), "rod") > 0
		if state.is_rod then
			-- Uses per level 1 spell.
			state.rod_durability = stack:get_definition()._rod_durability
			-- Innate spell level boost.
			state.rod_power = stack:get_definition()._rod_power

			-- Replace default description if bespelled.
			local spell = aurum.magic.spells[stack:get_meta():get_string("spell")]
			if spell then
				state.description[1] = S("Rod of @1 @2", spell.description, stack:get_meta():get_int("spell_level"))
			end
		end
	end,

	apply = function(state, stack)
		if state.is_rod then
			stack:get_meta():set_int("rod_durability", state.rod_durability)
			stack:get_meta():set_int("rod_power", state.rod_power)
		end
		return stack
	end,
}

aurum.tools.register_enchant("rod_strength", {
	categories = {
		rod = true,
	},
	description = S"Rod Strength",
	longdesc = S"Improves the strength of a rod, allowing it to cast more spells before breaking.",
	apply = function(state, level, stack)
		state.rod_durability = state.rod_durability * (level + 1)
	end,
})

aurum.tools.register_enchant("rod_power", {
	categories = {
		rod = true,
	},
	description = S"Rod Power",
	longdesc = S"Adds to the power of a rod, giving a boost in power to the spells it casts. This boost of power does not reduce the rod's durability.",
	apply = function(state, level, stack)
		state.rod_power = state.rod_power + level
	end,
})

aurum.dofile("command.lua")
aurum.dofile("table.lua")
