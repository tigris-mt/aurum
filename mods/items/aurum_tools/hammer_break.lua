local S = aurum.get_translator()

local old = minetest.get_node_drops
function minetest.get_node_drops(node, toolname)
	local ret = old(node, toolname)
	if minetest.get_item_group(node.name, "dig_hammer") > 0 and minetest.get_item_group(toolname, "tool_hammer") > 0 then
		for i,v in ipairs(ret) do
			local stack = ItemStack(v)
			if stack:get_name() == node.name then
				stack:set_name(minetest.registered_nodes[node.name]._hammer_drop)
			end
			ret[i] = stack:to_string()
		end
	end
	return ret
end

doc.sub.items.register_factoid("nodes", "drop_destroy", function(itemstring, def)
	if minetest.get_item_group(itemstring, "dig_hammer") > 0 then
		return S("When dug with a hammer, this node will drop @1.", minetest.registered_nodes[def._hammer_drop].description)
	end
	return ""
end)
