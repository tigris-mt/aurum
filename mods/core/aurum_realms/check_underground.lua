function aurum.realms.check_underground(player, yunder, f)
	if player:get_pos().y > yunder then
		return
	end

	local nh = minetest.registered_nodes[minetest.get_node(vector.add(player:get_pos(), vector.new(0, 1.5, 0))).name]
	if nh.walkable == false or nh.drawtype == "mesh" then
		f()
	end
end
