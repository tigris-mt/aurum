local S = minetest.get_translator()

local RADIUS = 4
local LIGHT = 13
local LIMIT = 3

doc.sub.items.register_factoid("nodes", "use", function(itemstring, def)
	if minetest.get_item_group(itemstring, "flora") > 0 then
		return S("When this node is on @1 and has a light level of @2 or greater, it may spread to soil in a @3 radius cube with the same light level requirement as long as there is not already more than @4 flora there.", def._flora_spread_node or "group:soil", LIGHT, RADIUS, LIMIT)
	end
	return ""
end)

-- Run flora spreading logic at pos for node.
function aurum.flora.spread(pos, node)
	local under = vector.add(pos, vector.new(0, -1, 0))
	local above = vector.add(pos, vector.new(0, 1, 0))

	local spread = minetest.registered_nodes[node.name]._flora_spread_node or "group:soil"

	if #minetest.find_nodes_in_area(under, under, spread) == 0 then
		return
	end

	if minetest.get_node_light(pos) < LIGHT then
		return
	end

	-- Default to spreading the current node.
	local spread_node = node.name

	-- If the node has an _on_flora_spread callback, run that.
	if minetest.registered_nodes[node.name]._on_flora_spread then
		local cancel, cs = minetest.registered_nodes[node.name]._on_flora_spread(pos, node)
		-- The callback may have provided a new node to spread.
		spread_node = cs or spread_node
		if cancel == false then
			return
		end
	end

	if #minetest.find_nodes_in_area(vector.subtract(pos, RADIUS), vector.add(pos, RADIUS), "group:flora") > LIMIT then
		return
	end

	local targets = minetest.find_nodes_in_area(vector.subtract(pos, RADIUS), vector.add(pos, RADIUS), spread)
	for _,target in ipairs(table.shuffled(targets)) do
		local tabove = vector.add(target, vector.new(0, 1, 0))
		if minetest.get_node_light(tabove) >= LIGHT then
			minetest.set_node(tabove, {name = spread_node})
			return
		end
	end
end

minetest.register_abm{
	label = "Flora Spread",
	nodenames = {"group:flora"},
	interval = 20,
	chance = 150,
	action = aurum.flora.spread,
}
