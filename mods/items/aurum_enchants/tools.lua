local S = aurum.get_translator()

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

aurum.tools.register_enchant("dig", {
	categories = {
		tool = true,
	},
	description = S"Dig",
	max_level = 5,
	longdesc = S"Improves the digging/mining power of any tool. Also slightly increases damage at high levels.",
	apply = function(state, level, stack)
		for k,v in pairs(state.tool_capabilities.damage_groups or {}) do
			state.tool_capabilities.damage_groups[k] = v + math.floor(level / 3)
		end
		for _,g in pairs(state.tool_capabilities.groupcaps or {}) do
			g.times = b.t.map(g.times, function(v)
				return v * (1 - level / 5)
			end)
		end
	end,
})
