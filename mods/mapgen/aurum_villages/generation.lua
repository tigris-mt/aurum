local function can_replace(node, foundation)
	-- Air is replacable, of course.
	if aurum.is_air(node.name) then
		return true
	else
		local def = minetest.registered_nodes[node.name]
		if not foundation and (def.liquidtype or "none") ~= "none" then
			-- Consider liquid solid, so don't build in it, unless placing the foundation.
			return false
		else
			-- Otherwise, replace anything that isn't part of the ground.
			return def.buildable_to or not def.is_ground_content
		end
	end
end

local function can_replace_check(want, pos, ...)
	local node = minetest.get_node(pos)
	if node.name == "ignore" then
		return false
	else
		return can_replace(node, ...) == want
	end
end

local get_build_pos = b.cache.simple(function(pos)
	local check = vector.new(pos)

	-- Go down to the ground.
	check.y = check.y - 1
	while can_replace_check(true, check) do
		check.y = check.y - 1
	end

	-- Go back to center.
	check.y = check.y + 1

	-- Go to lowest possible.
	while can_replace_check(false, check) do
		check.y = check.y + 1
	end

	return check
end, function(pos) return minetest.hash_node_position(vector.new(pos.x, 0, pos.z)) end)

local function get_actual_corner(start, size)
	-- Go down to the ground.
	local down_check = vector.new(start)
	down_check.y = down_check.y - 1
	while can_replace_check(true, down_check, true) do
		down_check.y = down_check.y - 1
	end

	-- Go back to center.
	local new_y = down_check.y + 1

	-- Go to lowest possible for the entire bottom.
	for x=start.x,start.x+size.x-1 do
		for z=start.z,start.z+size.z-1 do
			local up_check = vector.new(x, new_y, z)
			while can_replace_check(false, up_check) do
				up_check.y = up_check.y + 1
			end
			new_y = up_check.y
		end
	end
	return vector.new(start.x, new_y, start.z)
end

local function corner_to_center(corner, size)
	local offset = vector.floor(vector.divide(size, 2))
	offset.y = 0
	return vector.add(corner, offset)
end

local function get_max_size(size)
	local max_coord = math.max(size.x, size.z)
	return vector.new(max_coord, size.y, max_coord)
end

function aurum.villages.generate_village(v_name, v_pos, params)
	local function log(message)
		minetest.log("action", ("[aurum_villages] %s at %s: %s"):format(v_name, minetest.pos_to_string(v_pos), message))
	end

	log("Generating...")

	local def = assert(aurum.villages.villages[v_name], "Tried to generate invalid village type: " .. v_name)

	params = b.t.combine({
		random = math.random,
		emerge = true,
	}, params)

	params.box = b.box.new_radius(v_pos, def.radius)

	local poses = (function()
		local ret = {}
		local STEP = 3
		for x=params.box.a.x,params.box.b.x,STEP do
			for z=params.box.a.z,params.box.b.z,STEP do
				table.insert(ret, vector.new(x, 0, z))
			end
		end
		return ret
	end)()

	local plots = AreaStore()

	local function hits_plot(plot)
		return #b.t.keys(plots:get_areas_in_area(plot.a, plot.b, true)) > 0
	end

	-- Finds a new plot and returns the corner position, or nil if none found.
	local function get_plot(size)
		local maxed_size = get_max_size(size)
		for _,pos in b.t.ro_ipairs(poses, params.random) do
			local plot = b.box.new_add(vector.new(pos.x, 0, pos.z), maxed_size)
			if not hits_plot(plot) then
				plots:insert_area(plot.a, plot.b, "")
				return vector.new(pos.x, v_pos.y, pos.z)
			end
		end
	end

	local num_x_paths = math.floor((params.box.b.x - params.box.a.x) / (def.path_width + def.path_spacing))
	local num_z_paths = math.floor((params.box.b.x - params.box.a.x) / (def.path_width + def.path_spacing))

	local x_paths_all = {}
	local z_paths_all = {}

	for i=0,num_x_paths-1 do
		b.t.random_insert(x_paths_all, {
			start = vector.new(params.box.a.x, 0, params.box.a.z + i * (def.path_width + def.path_spacing) - math.floor(def.path_width / 2)),
			finish = vector.new(params.box.b.x, 1, params.box.a.z + i * (def.path_width + def.path_spacing) + math.ceil(def.path_width / 2)),
		}, params.random)
	end

	for i=0,num_z_paths-1 do
		b.t.random_insert(z_paths_all, {
			start = vector.new(params.box.a.x + i * (def.path_width + def.path_spacing) - math.floor(def.path_width / 2), 0, params.box.a.z),
			finish = vector.new(params.box.a.x + i * (def.path_width + def.path_spacing) + math.ceil(def.path_width / 2), 1, params.box.b.z),
		}, params.random)
	end

	local x_paths = {}
	if #x_paths_all > 0 then
		for i=1,params.random(#x_paths_all) do
			table.insert(x_paths, x_paths_all[i])
		end
	end

	local z_paths = {}
	if #z_paths_all > 0 then
		for i=1,params.random(#z_paths_all) do
			table.insert(z_paths, z_paths_all[i])
		end
	end

	for _,path in ipairs(b.t.icombine(x_paths, z_paths)) do
		plots:insert_area(path.start, path.finish, "")
	end

	local structures_needed = {}
	local structures_wanted = {}

	for _,s_def in pairs(def.structures) do
		local need = s_def.min
		local want = params.random(0, s_def.max - need)

		local function try(q)
			local name = b.t.choice(s_def.names, params.random)
			local structure = assert(aurum.villages.structures[name], "structure not registered: " .. name)
			local pos = get_plot(structure.size)
			if pos then
				table.insert(q, {
					name = name,
					def = structure,
					pos = pos,
				})
				return true
			else
				return false, name
			end
		end

		for i=1,need do
			local ok, name = try(structures_needed)
			if not ok then
				log("Failed trying to add: " .. name)
				return false
			end
		end

		for i=1,want do
			try(structures_wanted)
		end
	end

	local generate_queue = b.t.icombine(structures_needed, structures_wanted)

	local function generate()

		-- Calculate actual corners for structures and the real village box size.
		for _,s in ipairs(generate_queue) do
			local corner = get_actual_corner(s.pos, s.def.size)
			s.center = corner_to_center(corner, s.def.size)

			local real_corner = vector.add(corner, s.def.offset)
			local real_limit = vector.add(real_corner, vector.subtract(get_max_size(s.def.size), vector.new(1, 1, 1)))

			for _,coord in ipairs{"x", "y", "z"} do
				params.box.a[coord] = math.min(params.box.a[coord], real_corner[coord])
				params.box.b[coord] = math.max(params.box.b[coord], real_limit[coord])
			end
		end

		if #aurum.villages.get_village_ids_in(params.box) > 0 then
			log("Collision with an existing village, will not generate.")
			return false
		end

		local village_id = aurum.villages.new_village(params.box)
		aurum.villages.set_village(village_id, {
			id = village_id,
			box = params.box,
			name = aurum.flavor.generate_village_name(params.random),
			founder = aurum.flavor.generate_name(params.random),
		})

		local face_xp = minetest.dir_to_facedir(vector.new(-1, 0, 0))
		local face_xm = minetest.dir_to_facedir(vector.new(1, 0, 0))
		for _,path in ipairs(x_paths) do
			for x=path.start.x,path.finish.x do
				for z=path.start.z,path.finish.z do
					local pos = vector.new(get_build_pos(vector.new(x, params.box.b.y, z)))
					pos.y = pos.y - 1
					minetest.set_node(pos, {name = def.path.base})

					local next_pos = get_build_pos(vector.new(x + 1, params.box.b.y, z))
					local y_diff = next_pos.y - pos.y - 1

					if y_diff == 1 then
						pos.y = pos.y + 1
						minetest.set_node(pos, {name = def.path.stairs, param2 = face_xm})
					elseif y_diff == -1 then
						minetest.set_node(pos, {name = def.path.stairs, param2 = face_xp})
					end
				end
			end
		end

		local face_zp = minetest.dir_to_facedir(vector.new(0, 0, -1))
		local face_zm = minetest.dir_to_facedir(vector.new(0, 0, 1))
		for _,path in ipairs(z_paths) do
			for x=path.start.x,path.finish.x do
				for z=path.start.z,path.finish.z do
					local pos = vector.new(get_build_pos(vector.new(x, params.box.b.y, z)))
					pos.y = pos.y - 1
					minetest.set_node(pos, {name = def.path.base})

					local next_pos = get_build_pos(vector.new(x, params.box.b.y, z + 1))
					local y_diff = next_pos.y - pos.y - 1

					if y_diff == 1 then
						pos.y = pos.y + 1
						minetest.set_node(pos, {name = def.path.stairs, param2 = face_zm})
					elseif y_diff == -1 then
						minetest.set_node(pos, {name = def.path.stairs, param2 = face_zp})
					end
				end
			end
		end

		for _,s in ipairs(generate_queue) do
			aurum.features.place_decoration(s.center, s.def, params.random, function(c)
				-- Build foundation.
				local e = b.box.extremes(c.box)
				assert(not vector.equals(e.a, e.b))

				local radius = vector.distance(e.a, e.b) / 2
				local center_pos = vector.add(vector.new(e.a.x, 0, e.a.z), vector.divide(vector.subtract(vector.new(e.b.x, 0, e.b.z), vector.new(e.a.x, 0, e.a.z)), 2))

				local y = c.box.a.y
				while true do
					y = y - 1
					center_pos.y = y

					if radius > 0 then
						for x=e.a.x,e.b.x do
							for z=e.a.z,e.b.z do
								local foundation_pos = vector.new(x, y, z)
								local distance = vector.distance(center_pos, foundation_pos)
								if distance <= radius and can_replace_check(true, foundation_pos, true) then
									minetest.set_node(foundation_pos, {name = b.t.choice(s.def.foundation, params.random)})
								end
							end
						end
					else
						return
					end

					radius = radius - 1
				end
			end)
		end

		log(("Success, %d structures."):format(#generate_queue))
		return true
	end

	if params.emerge then
		local emerge_offset = vector.new(32, 32, 32)
		minetest.emerge_area(vector.subtract(params.box.a, emerge_offset), vector.add(params.box.b, emerge_offset), function(_, _, calls_remaining)
			if calls_remaining == 0 then
				generate()
			end
		end)
		return true
	else
		return generate()
	end
end
