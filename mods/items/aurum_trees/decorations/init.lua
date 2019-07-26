function aurum.trees.schematic(size, nodes)
	local ret = {
		size = size,
		data = {},
	}

	local area = VoxelArea:new({MinEdge=vector.new(0, 0, 0), MaxEdge=vector.subtract(size, 1)})

	for y,yn in ipairs(nodes) do
		local y = size.y - y
		for z,zn in ipairs(yn) do
			local z = #yn - z
			for x,xn in ipairs(zn) do
				local x = x - 1
				local pos = vector.new(x, y, z)
				assert(area:containsp(pos))
				local nd = type(xn) == "string" and {name = xn, prob = 255} or xn
				ret.data[area:indexp(pos)] = nd
			end
		end
	end

	return ret
end
