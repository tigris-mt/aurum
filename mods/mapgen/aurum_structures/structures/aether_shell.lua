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
	place_on = {
		"aurum_base:regret",
		"aurum_base:stone",
		"aurum_base:gravel",
		"aurum_base:aether_shell",
		"aurum_base:aether_skin",
		"aurum_base:aether_flesh",
	},
	rarity = 0.0001,
	biomes = b.set.to_array(b.set._or(
		b.set(aurum.biomes.get_all_group("barren")),
		b.set(aurum.biomes.get_all_group("aurum:aether"))
	)),

	on_offset = function(c)
		c.shell_radius = c.random(2, 5) + math.max(0, c.random(-100, 10))
		return vector.subtract(c.pos, vector.new(0, c.shell_radius, 0))
	end,

	make_schematic = function(c)
		return make(c.shell_radius, c.random(0, 10) <= 3)
	end,
}
