-- An enclosed sphere of aether flesh.

local make = b.cache.simple(function(a, dead)
	local size = vector.round(vector.multiply(vector.new(a, a, a), 2.5))
	local limit = vector.subtract(size, 1)
	local data = {}
	local area = VoxelArea:new({MinEdge=vector.new(0, 0, 0), MaxEdge=limit})
	for i in area:iterp(vector.new(0, 0, 0), limit) do
		data[i] = {name = "ignore"}
	end

	local center = vector.divide(size, 2)

	local function sphere(radius, node)
		for x=0,limit.x,1 do
			for y=0,limit.y,1 do
				for z=0,limit.z,1 do
					local v = vector.new(x, y, z)
					if math.floor(vector.distance(v, center)) <= radius then
						data[area:indexp(v)] = {name = node}
					end
				end
			end
		end
	end

	sphere(a, "aurum_base:aether_shell")
	if dead then
		sphere(a - 2, "air")
	else
		sphere(a - 2, "aurum_base:aether_skin")
		sphere(a - 3, "aurum_base:aether_flesh")
	end

	return {
		size = size,
		data = data,
	}
end, function(a, dead) return a + 1000 * (dead and 1 or 0) end)

aurum.features.register_decoration{
	place_on = {"aurum_base:regret", "aurum_base:stone", "aurum_base:gravel", "aurum_base:aether_shell"},
	rarity = 0.0001,
	biomes = b.set.to_array(b.set._or(
		b.set(aurum.biomes.get_all_group("barren", {"base"})),
		b.set(aurum.biomes.get_all_group("aurum:aether", {"base"}))
	)),

	make_schematic = function(pos, random)
		local a = random(2, 5) + math.max(0, random(-100, 10))
		-- Offset position.
		pos.y = pos.y - a

		return make(a, random(0, 10) <= 3)
	end,
}
