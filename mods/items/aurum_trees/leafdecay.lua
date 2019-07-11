minetest.register_abm{
	label = "Leaf decay",
	nodenames = {"group:leafdecay"},
	-- High chance for more spread.
	interval = 2,
	chance = 5,
	catch_up = false,
	action = function(pos, node)
		-- If trunk nearby, do nothing.
		if minetest.find_node_near(pos, minetest.get_item_group(node.name, "leafdecay"), {"group:tree"}) then
			return
		end

		local drops = minetest.get_node_drops(node.name)
		for _,item in ipairs(drops) do
			if item ~= node.name then
				aurum.drop_item(pos, item)
			end
		end

		minetest.remove_node(pos)
		minetest.check_for_falling(pos)
	end,
}
