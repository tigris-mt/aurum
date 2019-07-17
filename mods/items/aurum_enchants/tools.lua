local S = minetest.get_translator()

aurum.tools.register_enchant_callback{
	init = function(state, stack)
		state.tool_capabilities = table.copy(stack:get_definition().tool_capabilities)
	end,

	apply = function(state, stack)
		stack:get_meta():set_tool_capabilities(state.tool_capabilities)
		return stack
	end,
}

aurum.tools.register_enchant("smash", {
	categories = {
		hammer = true,
	},
	description = S"Smash",
	apply = function(state, level, stack)
		state.tool_capabilities.damage_groups.impact = state.tool_capabilities.damage_groups.impact + level
	end,
})
