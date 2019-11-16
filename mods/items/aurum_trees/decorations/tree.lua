return function(def, height, radius, trunk_radius_ratio, leaf_height_ratio, leaf_extent, depth)
	height = tonumber(height) or 6
	radius = tonumber(radius) or 2
	local width = 1 + (radius - 1) * 2
	trunk_radius_ratio = tonumber(trunk_radius_ratio) or 0.25
	leaf_height_ratio = tonumber(leaf_height_ratio) or 0.4
	local trunk_radius = radius * trunk_radius_ratio
	leaf_extent = tonumber(leaf_extent) or def.leafdistance
	depth = tonumber(depth) or 3

	local t = {name = def.trunk, force_place = true}
	local l = {name = def.leaves}
	local lp = {name = def.leaves, prob = 127}

	local size = vector.round(vector.new(width, height + depth, width))
	local limit = vector.subtract(size, 1)
	local area = aurum.box.voxelarea(aurum.box.new(vector.new(0, 0, 0), limit))
	local data = {}

	for i in area:iterp(vector.new(0, 0, 0), limit) do
		data[i] = {name = "ignore"}
	end

	for x=0,limit.x do
		for z=0,limit.z do
			local dist = math.sqrt(math.pow(x - limit.x / 2, 2) + math.pow(z - limit.z / 2, 2))
			for y=0,limit.y do
				local i = area:index(x, y, z)
				if dist < trunk_radius and y < limit.y then
					data[i] = t
				elseif y - depth > (height * leaf_height_ratio) and dist < trunk_radius + def.leafdistance and dist < trunk_radius + leaf_extent then
					data[i] = (dist > trunk_radius + 1) and lp or l
				end
			end
		end
	end

	return {
		size = size,
		data = data,
	}, -depth
end
