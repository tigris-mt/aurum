return function(def, length, width, hollow)
	length = tonumber(length) or 1
	width = tonumber(width) or 1
	hollow = (tonumber(hollow) or 1) > 0

	local t = {name = def.trunk, param2 = 12}

	local size = vector.new(length, width, width)
	local limit = vector.subtract(size, 1)
	local area = aurum.box.voxelarea(aurum.box.new(vector.new(0, 0, 0), limit))
	local data = {}

	local half = vector.divide(limit, 2)

	for i in area:iterp(vector.new(0, 0, 0), limit) do
		local p = area:position(i)
		if vector.distance(p, b.t.combine(half, {x = p.x})) < width / 2 then
			if hollow and vector.distance(p, b.t.combine(half, {x = p.x})) < width / 2 - 1 then
				data[i] = {name = "air"}
			else
				data[i] = t
			end
		else
			data[i] = {name = "ignore"}
		end
	end

	return {
		size = size,
		data = data,
	}, 1
end
