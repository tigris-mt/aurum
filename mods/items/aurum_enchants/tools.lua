local S = minetest.get_translator()

aurum.tools.register_enchant_callback{
	init = function(state, stack)
		state.caps = stack:get_definition().tool_capabilities
	end,

	apply = function(state, stack)
		stack:get_meta():set_tool_capabilities(state.caps)
		return stack
	end,
}
