local PH = {
	MESS = 1,
	TREASURE = 2,
	FLOOR = 3,
	SPAWNER = 4,
}

function aurum.structures.register_pyramid(def)
	local def = b.t.combine({
		wall_node = "aurum_clay:brick_orange",
		base_node = "aurum_clay:clay_orange",
		liquid_node = "aurum_base:lava_source",
		trap_node = "aurum_base:sand",

		mess_nodes = {
			{"aurum_clay:brick_grey", 1},
			{"aurum_clay:brick_green", 1},
			{"aurum_flora:reed", 4},
			{"aurum_flora:cactus", 4},
			{"air", 4},
		},

		floor_nodes = {
			{"aurum_base:sand", 0.5},
			{"air", 0.5},
			{"aurum_clay:brick_orange", 1},
			{"aurum_clay:brick_red", 1},
		},

		decoration = {},
	}, def)

	local wn = {name = def.wall_node}
	local ln = {name = def.liquid_node}
	local air = {name = "air"}

	local make = b.cache.simple(function(size)
		local limit = vector.subtract(size, 1)
		local data = {}
		local area = VoxelArea:new({MinEdge=vector.new(0, 0, 0), MaxEdge=limit})
		for i in area:iterp(vector.new(0, 0, 0), limit) do
			data[i] = {name = "ignore"}
		end

		local ground = math.floor(size.y / 2)

		for y=0,limit.y do
			local off = y - ground
			local xoff = (y < ground) and 0 or math.min(limit.x - 1, off)
			local zoff = (y < ground) and 0 or math.min(limit.z - 1, off)
			for x=xoff,limit.x-xoff do
				for z=zoff,limit.z-zoff do
					local delta = math.sqrt(((x - limit.x / 2) ^ 2) + ((z - limit.z / 2) ^ 2))
					if x == xoff or x == limit.x - xoff or z == zoff or z == limit.z - zoff or y == 0 or y == limit.y then
						data[area:index(x, y, z)] = wn
					elseif delta <= 0.5 then
						data[area:index(x, y, z)] = {name = aurum.features.ph((y == ground) and PH.SPAWNER or PH.TREASURE)}
					elseif delta <= 1.5 then
						data[area:index(x, y, z)] = wn
					elseif y < ground * 0.75 then
						data[area:index(x, y, z)] = ln
					elseif y == ground then
						data[area:index(x, y, z)] = {name = aurum.features.ph(PH.FLOOR)}
					elseif y > ground and delta >= math.min(size.x, size.z) / 3 then
						data[area:index(x, y, z)] = {name = aurum.features.ph(PH.MESS)}
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
			local s = c.random(7, 12) * 2 - 1
			local h = c.random(7, 12) * 2 - 1
			c.s.size = vector.new(s, h, s)
			return vector.subtract(c.pos, vector.new(0, math.floor(c.s.size.y / 2), 0))
		end,

		make_schematic = function(c)
			return make(c.s.size)
		end,

		on_generated = function(c)
			for _,pos in ipairs(c:ph(PH.TREASURE)) do
				if c:random() < 1 / (c.base.s.size.y / 2) * 2 then
					minetest.set_node(pos, {name = "aurum_storage:box"})
					c:treasures(pos, "main", c:random(1, 3), {
						{
							count = 1,
							preciousness = {0, 6},
							groups = {"scroll", "deco", "equipment"},
						},
					})
				else
					minetest.set_node(pos, {name = def.wall_node})
				end
			end

			for _,pos in ipairs(c:ph(PH.MESS)) do
				minetest.set_node(pos, {name = b.t.weighted_choice(def.mess_nodes)})
			end

			for _,pos in ipairs(c:ph(PH.FLOOR)) do
				minetest.set_node(pos, {name = b.t.weighted_choice(def.floor_nodes)})
			end

			for _,pos in ipairs(c:ph(PH.SPAWNER)) do
				minetest.set_node(pos, {name = "aurum_mobs:spawner"})
				aurum.mobs.set_spawner(pos, {
					mob = "aurum_mobs_animals:spider",
				})
			end
		end,
	}, def.decoration))
end

aurum.structures.register_pyramid{
	decoration = {
		rarity = 0.00001,
		place_on = {"group:sand", "group:clay"},
		biomes = aurum.biomes.get_all_group("desert", {"base"}),
	},
}
