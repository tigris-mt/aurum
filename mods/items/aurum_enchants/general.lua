local S = minetest.get_translator()

aurum.tools.register_enchant("durability", {
	categories = {
		tool = true,
		armor = true,
	},
	description = S"Durability",
	longdesc = S"Improves the durability (maximum uses) of tools and armor.",
	apply = function(state, level, stack)
		-- Tool durability.
		if minetest.get_item_group(stack:get_name(), "tool") > 0 then
			for k,v in pairs(state.tool_capabilities.groupcaps) do
				v.uses = v.uses * (1 + level / 2)
			end
		-- Equipment durability.
		else
			state.eqdef.durability = state.eqdef.durability * (1 + level / 2)
		end
	end,
})
