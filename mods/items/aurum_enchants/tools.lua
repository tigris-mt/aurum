local S = minetest.get_translator()

-- If the stack is a tool, copy tool_capabilities into the state and out into the meta.
aurum.tools.register_enchant_callback{
	init = function(state, stack)
		state.tool_capabilities = stack:get_definition().tool_capabilities and table.copy(stack:get_definition().tool_capabilities)
	end,

	apply = function(state, stack)
		if state.tool_capabilities then
			stack:get_meta():set_tool_capabilities(state.tool_capabilities)
		end
		return stack
	end,
}

aurum.tools.register_enchant("smash", {
	categories = {
		hammer = true,
	},
	description = S"Smash",
	longdesc = S"Improves the damage of hammers.",
	apply = function(state, level, stack)
		state.tool_capabilities.damage_groups.impact = state.tool_capabilities.damage_groups.impact + level
	end,
})
