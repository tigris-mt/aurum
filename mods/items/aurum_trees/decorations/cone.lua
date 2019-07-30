return function(def, overall, trunk_ratio, width_ratio)
	trunk_ratio = trunk_ratio or 1
	width_ratio = width_ratio or 1.5

	local t = {name = def.trunk, force_place = true}
	local l = {name = def.leaves}
	local lp = {name = def.leaves, prob = 127}

	local size = vector.round(vector.new(overall * width_ratio, overall * 5 + 3, overall * width_ratio))
	local limit = vector.subtract(size, 1)
	local area = aurum.box.voxelarea(aurum.box.new(vector.new(0, 0, 0), limit))
	local data = {}

	for i in area:iterp(vector.new(0, 0, 0), limit) do
		data[i] = {name = "air"}
	end

	local leaf_stop = math.floor(3 + overall / 4 + 3)

	for y=limit.y,0,-1 do
		local leaf_frac = 1 - (y - leaf_stop) / (limit.y - leaf_stop)

		if leaf_frac > 0.5 then
			local x_start = math.max(0, math.floor(limit.x * (1 - leaf_frac) + 0.5))
			local x_end = math.min(limit.x, math.ceil(limit.x * leaf_frac - 0.5))

			local z_start = math.max(0, math.floor(limit.z * (1 - leaf_frac) + 0.5))
			local z_end = math.min(limit.x, math.ceil(limit.z * leaf_frac - 0.5))

			local ss = math.max(x_end - x_start, z_end - z_start)
			for x=x_start,x_end,1 do
				for z=z_start,z_end,1 do
					local i = area:index(x, y, z)
					local dist = math.sqrt(math.pow(x - limit.x / 2, 2) + math.pow(z - limit.z / 2, 2))
					if y >= leaf_stop and dist < ss / 4 * trunk_ratio + def.leafdecay then
						data[i] = l
					end
					if dist < ss / 4 * trunk_ratio then
						data[i] = t
					end
				end
			end
		end
	end

	return {
		size = size,
		data = data,
	}, -3
end
