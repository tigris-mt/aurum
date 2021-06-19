local storage = minetest.get_mod_storage()
local areastore = AreaStore()

aurum.villages.villages = {}

if storage:contains("villages_areastore") then
	areastore:from_string(minetest.decode_base64(storage:get_string("villages_areastore")))
end

function aurum.villages.save_areastore()
	storage:set_string("villages_areastore", minetest.encode_base64(areastore:to_string()))
end

function aurum.villages.get_village_id_at(pos)
	return b.t.keys(areastore:get_areas_for_pos(pos))[1]
end

function aurum.villages.get_villages_ids_in(box)
	return areastore:get_areas_in_area(box.a, box.b, true)
end

function aurum.villages.get_village(id)
	if storage:contains("village_" .. tostring(id)) then
		return minetest.deserialize(storage:get_string("village_" .. tostring(id)))
	end
end

function aurum.villages.set_village(id, data)
	storage:set_string("village_" .. tostring(id), minetest.serialize(data))
end

function aurum.villages.delete_village(id)
	areastore:remove_area(id)
	aurum.villages.save_areastore()
	storage:set_string("village_" .. tostring(id), "")
end

function aurum.villages.register_village(name, def)
	def = b.t.combine({
		radius = 40,
		structures = {},
	}, def)

	aurum.villages.villages[name] = def
end

local function can_replace(pos, foundation)
	local node = minetest.get_node(pos)
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

local function get_actual_corner(start, size)
	-- Go down to the ground.
	local down_check = vector.new(start)
	down_check.y = down_check.y - 1
	while can_replace(down_check, true) do
		down_check.y = down_check.y - 1
	end

	-- Go back to center.
	local new_y = down_check.y + 1

	-- Go to lowest possible for the entire bottom.
	for x=start.x,start.x+size.x-1 do
		for z=start.z,start.z+size.z-1 do
			local up_check = vector.new(x, new_y, z)
			while not can_replace(up_check) do
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
		local STEP = 8
		for x=params.box.a.x,params.box.b.x,STEP do
			for z=params.box.a.z,params.box.b.z,STEP do
				table.insert(ret, vector.new(x, 0, z))
			end
		end
		return ret
	end)()

	local plots = {}

	local function hits_plot(plot)
		for _,check in pairs(plots) do
			if b.box.collide_box(plot, check) then
				return true
			end
		end
		return false
	end

	-- Finds a new plot and returns the corner position, or nil if none found.
	local function get_plot(size)
		for _,pos in b.t.ro_ipairs(poses) do
			local plot = b.box.new_add(vector.new(pos.x, 0, pos.z), size)
			if not hits_plot(plot) then
				table.insert(plots, plot)
				return vector.new(pos.x, v_pos.y, pos.z)
			end
		end
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
		for _,s in ipairs(generate_queue) do
			local corner = get_actual_corner(s.pos, s.def.size)
			s.center = corner_to_center(corner, s.def.size)

			params.box.a.y = math.min(params.box.a.y, corner.y)
			params.box.b.y = math.max(params.box.b.y, vector.add(corner, s.def.size).y)
		end

		if #aurum.villages.get_villages_ids_in(params.box) > 0 then
			log("Collision with an existing village, will not generate.")
			return false
		end

		local village_id = assert(areastore:insert_area(params.box.a, params.box.b, ""), "could not add village to areastore")
		aurum.villages.save_areastore()
		aurum.villages.set_village(village_id, {
			id = village_id,
			box = params.box,
			name = aurum.flavor.generate_village_name(params.random),
			founder = aurum.flavor.generate_name(params.random),
		})

		for _,s in ipairs(generate_queue) do
			aurum.features.place_decoration(s.center, s.def, params.random, function(c)
				-- Build foundation.
				local e = b.box.extremes(c.box)
				for x=e.a.x,e.b.x do
					for z=e.a.z,e.b.z do
						local foundation_pos = vector.new(x, c.box.a.y - 1, z)
						while can_replace(foundation_pos, true) do
							minetest.set_node(foundation_pos, {name = b.t.choice(s.def.foundation, params.random)})
							foundation_pos.y = foundation_pos.y - 1
						end
					end
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
