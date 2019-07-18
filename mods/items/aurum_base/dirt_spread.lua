local S = minetest.get_translator()
local LIGHT = 10
local RADIUS = 4

doc.sub.items.register_factoid("nodes", "use", function(itemstring, def)
	if minetest.get_item_group(itemstring, "dirt_spread") then
		return S("This node spreads to nearby (@1 cube radius) dirt with a light level of @2 or greater above.", RADIUS, LIGHT)
	end
	return ""
end)

minetest.register_abm{
	label = "Dirt Spreading",
	nodenames = {"group:dirt_spread"},
	neighbors = {"group:dirt_base"},

	interval = 20,
	chance = 10,

	action = function(pos, node)
		local rvec = vector.new(RADIUS, RADIUS, RADIUS)
		local nodes = minetest.find_nodes_in_area_under_air(vector.subtract(pos, rvec), vector.add(pos, rvec), "group:dirt_base")
		local target = nil
		for _,tpos in ipairs(nodes) do
			local above = vector.add(tpos, vector.new(0, 1, 0))
			if minetest.get_node_light(above) >= LIGHT then
				target = tpos
				break
			end
		end
		if target then
			minetest.set_node(target, node)
		end
	end,
}
