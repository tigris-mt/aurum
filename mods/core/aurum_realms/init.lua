local m = {}
aurum.realms = m

local storage = minetest.get_mod_storage()
local realm_store = storage:get("realms") and minetest.deserialize(storage:get("realms")) or {}

-- Save modified realm_store back to storage.
local function save()
	storage:set_string("realms", minetest.serialize(realm_store))
end

local realms = {}

-- Realm sizes must be aligned
m.ALIGN = 16
local function coord_ok(value)
	return (value % m.ALIGN) == 0
end

-- There must be sizable "buffer" space between realms.
m.SPACING = 400

local function allocate_position(realm)
	minetest.log("action", "Allocating position for new realm: " .. realm.id)

	-- Loop through all possible positions until a space is found that does not collide.
	for x=aurum.WORLDA.min.x, aurum.WORLDA.max.x, realm.size.x + m.SPACING do
		for z=aurum.WORLDA.min.z, aurum.WORLDA.max.z, realm.size.z + m.SPACING do
			local corner = vector.new(x, realm.y - realm.size.y / 2, z)
			local box = aurum.box.new(corner, vector.add(corner, realm.size))

			local ok = true

			-- For all stored realms...
			for _,store in pairs(realm_store) do
				-- If this potential position collides with the stored realm.
				local otherbox = aurum.box.new(store.corner, vector.add(store.corner, store.size))
				if aurum.box.collide_box(box, otherbox) then
					-- Skip this position.
					ok = false
					break
				end
			end

			-- No collisions, use this position.
			if ok then
				return corner
			end
		end
	end

	-- No position found.
	return nil
end

-- Get the corner of an allocated or previous realm region.
local function get_position(realm)
	-- Table describing the stored realm.
	local store = realm_store[realm.id] or {
		corner = allocate_position(realm),
		size = realm.size,
	}

	-- No corner means not allocated.
	if not store.corner then
		return nil
	end

	-- Changing realm sizes could lead to spatial collisions.
	assert(vector.equals(store.size, realm.size), "realm sizes cannot change once registered")

	-- Save the realm data.
	realm_store[realm.id] = store
	save()

	-- Return the (possibly previously) allocated position.
	return store.corner
end

-- Register a new realm.
function m.register(id, def)
	assert(not realms[id], "realm already exists")

	-- Create realm from defaults and supplied values.
	local r = table.combine({
		-- Human-readable identifier of the realm.
		description = "?",

		-- Realm size.
		size = vector.new(480, 480, 480),

		-- Realm Y location.
		y = 0,
	}, def, {
		id = id,
		-- Default biome setup.
		biome_default = table.combine({
			node_stone = "aurum_base:stone",
			node_water = "aurum_base:water_source",
			node_river_water = "aurum_base:river_water_source",
			node_riverbed = "aurum_base:sand",
			depth_riverbed = 2,
			node_cave_liquid = {"aurum_base:water_source", "aurum_base:lava_source"},
			node_dungeon = "aurum_base:stone",
			node_dungeon_stair = "aurum_base:stone",
		}, def.biome_default or {})
	})

	-- Ensure valid positioning.
	assert(coord_ok(r.size.x))
	assert(coord_ok(r.size.y))
	assert(coord_ok(r.size.z))

	-- Relative 0,0,0 point.
	r.center = vector.divide(r.size, 2)

	-- Find a global position.
	r.global_corner = assert(get_position(r), "out of room, cannot add a realm of this size")
	-- Global center.
	r.global_center = vector.add(r.global_corner, r.center)

	-- Local bounding box.
	r.local_box = aurum.box.new(vector.multiply(r.center, -1), r.center)

	-- Global bounding box.
	r.global_box = aurum.box.new(r.global_corner, vector.add(r.global_corner, r.size))

	minetest.log("action", ("Registered realm (%s) centered at %s, size %s"):format(id, minetest.pos_to_string(r.global_center), minetest.pos_to_string(r.size)))

	realms[id] = r
	return r
end

-- Remove a realm by ID, freeing the id and stored position.
-- Note that if any of this realm has already been generated, *weird things* can happen.
function m.unregister(id)
	realms[id] = nil
	realm_store[id] = nil
end

-- Get a realm definition.
function m.get(id)
	return realms[id]
end

-- Get position within realm.
function aurum.rpos(realm_id, global_pos)
	return vector.sub(global_pos, realms[realm_id].global_center)
end

-- Get global position from realm.
function aurum.gpos(realm_id, realm_pos)
	return vector.add(realms[realm_id].global_center, realm_pos)
end

-- Returns realm id or nil
function aurum.pos_to_realm(global_pos)
	for id,realm in pairs(realms) do
		if aurum.box.collide_point(realm.global_box, global_pos) then
			return id
		end
	end
end

function aurum.box_to_realm(global_box)
	for id,realm in pairs(realms) do
		if aurum.box.collide_box(realm.global_box, global_box) then
			return id
		end
	end
end

-- Generate the realm border.
minetest.register_on_generated(function(minp, maxp, seed)
	-- Check if any part of the block is in a realm.
	local realm = aurum.box_to_realm(aurum.box.new(minp, maxp))

	-- If not within a realm, then we don't need to generate the border.
	if not realm then
		return
	end

	realm = m.get(realm)

	-- Read all data.
	local vm, emin, emax = minetest.get_mapgen_object("voxelmanip")
	local area = VoxelArea:new{MinEdge = emin, MaxEdge = emax}
	local data = vm:get_data()

	local center = vector.divide(vector.add(emin, emax), 2)

	local c_border = minetest.get_content_id((maxp.y > 0) and "aurum_base:limit" or "aurum_base:foundation")

	for _,axis in ipairs{"x", "y", "z"} do
		local sign = math.sign(center[axis] - realm.global_center[axis])
		local corner = (sign < 0) and "a" or "b"
		local border = realm.global_box[corner][axis]

		if emin[axis] <= border and emax[axis] >= border then
			local emin = table.copy(emin)
			local emax = table.copy(emax)

			emin[axis] = border
			emax[axis] = border

			for i in area:iterp(emin, emax) do
				data[i] = c_border
			end
		end
	end

	-- And write back.
	vm:set_data(data)
	vm:write_to_map()
end)

aurum.dofile("default_realms.lua")
aurum.dofile("spawn.lua")
