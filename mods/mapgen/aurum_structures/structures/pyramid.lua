function aurum.structures.register_pyramid(def)
	local def = b.t.combine({
		wall_node = "aurum_base:stone_brick",
		base_node = "aurum_base:stone",
		liquid_node = "aurum_base:lava_source",

		decoration = {},
	}, def)

	local wn = {name = def.wall_node}
	local bn = {name = def.base_node}
	local ln = {name = def.liquid_node}
	local air = {name = "air"}

	local make = b.cache.simple(function(size)
		local limit = vector.subtract(size, 1)
		local data = {}
		local area = VoxelArea:new({MinEdge=vector.new(0, 0, 0), MaxEdge=limit})
		for i in area:iterp(vector.new(0, 0, 0), limit) do
			data[i] = {name = "ignore"}
		end

		local ground = math.ceil(size.y / 4)

		for y=0,limit.y do
			local off = y - ground
			local xoff = (y < ground) and 0 or math.min(limit.x - 1, off)
			local zoff = (y < ground) and 0 or math.min(limit.z - 1, off)
			for x=xoff,limit.x-xoff do
				for z=zoff,limit.z-zoff do
					if x == xoff or x == limit.x - xoff or z == zoff or z == limit.z - zoff or y == 0 then
						data[area:index(x, y, z)] = wn
					elseif y < ground / 2 then
						data[area:index(x, y, z)] = ln
					else
						data[area:index(x, y, z)] = air
					end
				end
			end
		end

		return {
			size = size,
			data = data,
		}
	end, minetest.hash_node_position)

	aurum.features.register_decoration(b.t.combine({
		on_offset = function(c)
			c.s.size = vector.multiply(vector.new(c.random(15, 20), c.random(10, 15) * 2, c.random(15, 20)), 2)
			return vector.subtract(c.pos, vector.new(0, math.ceil(c.s.size.y / 4), 0))
		end,

		make_schematic = function(c)
			return make(c.s.size)
		end,
	}, def.decoration))
end

aurum.structures.register_pyramid{
	decoration = {
		rarity = 0.0001,
		place_on = {"group:sand"},
		biomes = aurum.biomes.get_all_group("desert", {"base"}),
	},
}
