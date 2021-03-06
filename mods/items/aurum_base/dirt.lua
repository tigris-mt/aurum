local S = aurum.get_translator()
local LIGHT = 10
local RADIUS = 4

doc.sub.items.register_factoid("nodes", "use", function(itemstring, def)
	if minetest.get_item_group(itemstring, "dirt_spread") > 0 then
		return S("This node spreads to nearby (@1 cube radius) dirt with a light level of @2 or greater above.", RADIUS, LIGHT)
	end
	return ""
end)

-- Spread dirt <node> from <pos>.
function aurum.base.dirt_spread(pos, node)
	local rvec = vector.new(RADIUS, RADIUS, RADIUS)
	local nodes = minetest.find_nodes_in_area(vector.subtract(pos, rvec), vector.add(pos, rvec), "group:dirt_base")
	local target = nil
	for _,tpos in ipairs(b.t.shuffled(nodes)) do
		local above = vector.add(tpos, vector.new(0, 1, 0))
		if (minetest.get_node_light(above) or 0) >= LIGHT then
			target = tpos
			break
		end
	end
	if target then
		minetest.set_node(target, node)
	end
end

minetest.register_abm{
	label = "Dirt Spreading",
	nodenames = {"group:dirt_spread"},
	neighbors = {"group:dirt_base"},

	interval = 30,
	chance = 30,

	catch_up = false,

	action = aurum.base.dirt_spread,
}

doc.sub.items.register_factoid("nodes", "use", function(itemstring, def)
	if minetest.get_item_group(itemstring, "dirt_smother") > 0 then
		return S"This node becomes dirt if an opaque and dark node is on top of it for some time."
	end
	return ""
end)

minetest.register_abm{
	label = "Dirt Smothering",
	nodenames = {"group:dirt_smother"},

	interval = 30,
	chance = 30,

	catch_up = false,

	action = function(pos, node)
		local above = vector.add(pos, vector.new(0, 1, 0))
		local anode = minetest.get_node_or_nil(above)
		if anode then
			local adef = minetest.registered_nodes[anode.name]
			if not (adef.sunlight_propagates or adef.paramtype == "light") then
				node.name = "aurum_base:dirt"
				minetest.swap_node(pos, node)
			end
		end
	end,
}
