function aurum.flora.stack_grow(grow_on, height, grow_by)
	return function(pos, node)
		-- We start at pos, but must find the real base by searching down.
		local base = pos
		local below = pos
		local bnode
		while true do
			below = vector.add(below, vector.new(0, -1, 0))
			bnode = minetest.get_node(below)

			if bnode.name == node.name then
				base = below
			else
				break
			end
		end

		if grow_on and #minetest.find_nodes_in_area(below, below, grow_on) == 0 then
			return false
		end

		if grow_by and #minetest.find_nodes_in_area(vector.subtract(base, 1), vector.add(base, 1), grow_by) == 0 then
			return false
		end

		-- Try to find a place and grow.
		for n=0,height-1 do
			local at = vector.add(base, vector.new(0, n, 0))
			local atnode = minetest.get_node(at)
			-- Air found, place new growth.
			if aurum.is_air(atnode.name) then
				minetest.set_node(at, {name = node.name})
				return true
			-- Something else is in the way, don't go further.
			elseif atnode.name ~= node.name then
				break
			end
		end

		return false
	end
end
