local colors = {
	{"white", 5},
	{"pink", 5},
	{"orange", 5},
	{"cyan", 5},
	{"violet", 2},
	{"blue", 2},
	{"dark_green", 2},
	{"green", 2},
	{"yellow", 2},
	{"brown", 2},
	{"red", 2},
	{"magenta", 2},
	{"grey", 1},
	{"black", 0.1},
}

local airn = {name = "air"}

minetest.register_on_generated(function(minp, maxp, blockseed)
	local box = b.box.new(minp, maxp)
	local realm = screalms.box_to_realm(box)
	if realm ~= "aurum:ultimus" then
		return
	end

	local vm, emin, emax = minetest.get_mapgen_object("voxelmanip")
	local area = VoxelArea:new{MinEdge = emin, MaxEdge = emax}

	-- Reset lighting (Ultimus Hortum has no sun).
	vm:set_lighting{day = 0, night = 0}

	local random = b.seed_random(blockseed + 0xA715)

	-- Sometimes blocks will be empty (give a sense of space & scale to the player).
	local empty = random() < (1 / 7)

	-- Select the wall material.
	local wall = b.t.weighted_choice({
		-- Usually brick.
		{"aurum_clay:brick_" .. b.t.weighted_choice(colors, random), 1},
		-- Sometimes wood.
		{b.t.choice({
			"aurum_trees:oak_planks",
			"aurum_trees:pander_planks",
		}, random), 0.25},
	}, random)

	-- In Ultimus, the lighting comes from magic(?) glass.
	local glass = "aurum_base:glowing_glass_" .. b.t.weighted_choice(colors, random)

	local windows = random() < 0.9

	local base_room_schematic = (function()
		local ret = {
			size = vector.new(16, 8, 16),
			data = {},
		}

		local box = b.box.new(vector.new(), vector.subtract(ret.size, 1))
		local area = b.box.voxelarea(box)
		for i in area:iterp(box.a, box.b) do
			local pos = area:position(i)
			-- Set wall nodes.
			if not empty and (pos.x == box.a.x or pos.y == box.a.y or pos.z == box.a.z) then
				-- Is this a doorway?
				local door_spot = ((pos.x == math.ceil((box.b.x + box.a.x) / 2) or pos.z == math.ceil((box.b.z + box.a.z) / 2)) and (pos.y == 1 or pos.y == 2))
				ret.data[i] = door_spot and airn or b.t.weighted_choice({
					-- Walls are usually solid.
					{{name = wall}, 1},
					-- Sometimes there are glass windows.
					{{name = glass}, windows and 0.05 or 0},
				}, random)
			else
				ret.data[i] = airn
			end
		end

		return ret
	end)()

	-- Generate all rooms in the block.
	for x=0,4 do
		for y=0,9 do
			for z=0,4 do
				-- Where does this room start?
				local start = vector.add(minp, vector.new(16 * x, 8 * y, 16 * z))

				-- Place the room base.
				minetest.place_schematic_on_vmanip(vm, start, base_room_schematic)

				-- Rare fire (could burn down wooden block).
				if random() < (1 / 200) then
					minetest.set_node(vector.add(start, vector.new(1, 1, 1)), {name = "fire:basic_flame"})
				end
			end
		end
	end

	vm:calc_lighting()
	vm:write_to_map()

	-- Generate structures (don't try in empty rooms).
	if not empty and #aurum.ultimus.structures > 0 then
		for x=0,4 do
			for y=0,9 do
				for z=0,4 do
					local structure = b.t.weighted_choice(aurum.ultimus.structures, random)
					if structure then
						local center = vector.add(minp, vector.new(16 * x + 8, 8 * y, 16 * z + 8))
						aurum.features.place_decoration(center, structure, random)
					end
				end
			end
		end
	end
end)
