trm_aurum_tools = {}

function trm_aurum_tools.register(stack, rarity, preciousness, ...)
	for i=0,stack:get_definition()._enchant_levels do
		local function callback(stack)
			local target = i
			local possible = b.t.shuffled(aurum.tools.get_possible_enchants(stack:get_name()))
			local enchants = {}
			for _,e in ipairs(possible) do
				local edef = aurum.tools.enchants[e]
				local level = math.min(target, math.random(1, edef.max_level))
				target = target - level
				enchants[e] = level
				if target <= 0 then
					break
				end
			end
			return aurum.tools.set_item_enchants(stack, enchants)
		end
		aurum.treasurer.register_itemstack_callback(stack, callback, rarity / (stack:get_definition()._enchant_levels + 1), math.min(10, math.floor(preciousness + i / 2)), ...)
	end
end

minetest.register_on_mods_loaded(function()
	local total = 0
	local queue = {}
	for k,v in pairs(aurum.tools.tools) do
		local groups = b.set{"enchantable"}
		if minetest.get_item_group(k, "tool_hammer") > 0 then
			groups.melee_weapon = true
		elseif minetest.get_item_group(k, "tool") > 0 then
			groups.minetool = true
		elseif minetest.get_item_group(k, "equipment") > 0 then
			groups.equipment = true
		else
			groups = nil
		end
		if groups then
			total = total + 1
			table.insert(queue, function()
				local stack = ItemStack(k)
				trm_aurum_tools.register(stack, 0.5 / total, math.min(10, math.floor(stack:get_definition()._enchant_levels / 2)), 1, {1, aurum.TOOL_WEAR}, b.set.to_array(groups))
			end)
		end
	end
	for _,f in ipairs(queue) do
		f()
	end
end)
