local m = {}
aurum.realms = m

local storage = minetest.get_mod_storage()
local realm_store = storage:get("realms") and minetest.deserialize(storage:get("realms")) or {}

-- Save modified realm_store back to storage.
local function save()
	storage:set_string("realms", minetest.serialize(realm_store))
end

local realms = {}

-- A realm is an NxNxN cube.
-- They are allocated first-come, first-served; but once a biome ID is registered its global position will be remembered in storage.

-- Realm sizes must be aligned
m.ALIGN = 32
local function coord_ok(value)
	return (value % m.ALIGN) == 0
end

local function allocate_position(realm)
	minetest.log("action", "Allocating position for new realm: " .. realm.id)

	-- Loop through all possible positions until a space is found that does not collide.
	for x=aurum.WORLD.min.x, aurum.WORLD.max.x, realm.size.x do
		for y=aurum.WORLD.min.y, aurum.WORLD.max.y, realm.size.y do
			for z=aurum.WORLD.min.z, aurum.WORLD.max.z, realm.size.z do
				local corner = vector.new(x, y, z)
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
		size = vector.new(1024, 1024, 1024),
	}, def, {
		id = id,
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

	-- Global bounding box.
	r.box = aurum.box.new(r.global_corner, vector.add(r.global_corner, r.size))

	minetest.log("action", ("Registered realm (%s) centered at %s, size %s: %s"):format(id, minetest.pos_to_string(r.global_center), minetest.pos_to_string(r.size), r.description))

	realms[id] = r
	return r
end

-- General functions to convert between realm and global positions.

-- Get position within realm.
function aurum.rpos(realm_id, global_pos)
	return vector.sub(realms[realm_id].global_center, global_pos)
end

-- Get global position from realm.
function aurum.gpos(realm_id, realm_pos)
	return vector.add(realms[realm_id].global_center, global_pos)
end

-- Returns realm id or nil
function aurum.pos_to_realm(global_pos)
	for id,realm in pairs(realms) do
		if aurum.box.collide_point(realm.box, global_pos) then
			return id
		end
	end
end

aurum.dofile("default_realms.lua")
