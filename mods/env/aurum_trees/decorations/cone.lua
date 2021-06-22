aurum.trees.register_generator("cone", {
	type = "schematic_generator",
	func = function(def, overall, trunk_ratio, width_ratio, fruit)
		overall = tonumber(overall) or 1
		trunk_ratio = tonumber(trunk_ratio) or 1
		width_ratio = tonumber(width_ratio) or 1.5

		local t = {name = def.trunk, force_place = true}
		local l = {name = def.leaves}
		local lp = {name = def.leaves, prob = 127}

		local size = vector.round(vector.new(overall * width_ratio, overall * 5 + 3, overall * width_ratio))
		local limit = vector.subtract(size, 1)
		local area = b.box.voxelarea(b.box.new(vector.new(0, 0, 0), limit))
		local data = {}

		local ignore = {name = "ignore"}
		for i in area:iterp(vector.new(0, 0, 0), limit) do
			data[i] = ignore
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
					local dist_x = (x - limit.x / 2) ^  2
					for z=z_start,z_end,1 do
						local i = area:index(x, y, z)
						local dist = math.sqrt(dist_x + ((z - limit.z / 2) ^  2))
						local trs = ss / 4 * trunk_ratio
						if y >= leaf_stop and dist < trs + def.leafdistance then
							data[i] = (dist > trs + def.leafdistance / 2) and (fruit and b.t.weighted_choice{{{name = fruit}, 0.2}, {lp, 1}} or lp) or l
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
	end,
})
