local S = aurum.get_translator()

local defaults = {
	-- The mob to spawn.
	mob = "",
	-- Number of mobs that should be spawned in the area at any time.
	-- Negative number to be unlimited.
	limit = aurum.mobs.SPAWN_LIMIT,
	-- How long until the next spawn attempt? Passed to math.random.
	time = {10, 40},
	-- If set, will replace the spawner with this node table after spawning the first mob. No more mobs will be spawned.
	replace = nil,
}

minetest.register_node("aurum_mobs:spawner", {
	description = S"Mob Spawner",
	_doc_items_longdesc = S"A mystic portal filled with strange sights, sounds, and smells.",

	tiles = {"aurum_mobs_spawner.png"},
	light_source = 5,
	paramtype = "light",
	drawtype = "glasslike",
	sunlight_propagates = true,

	sounds = aurum.sounds.metal(),
	groups = {dig_pick = 1, level = 2},
	drop = "",

	on_timer = function(pos)
		local meta = minetest.get_meta(pos)
		local def = b.t.combine(defaults, minetest.deserialize(meta:get_string("def")) or {})

		meta:set_string("infotext", "")
		if minetest.registered_entities[def.mob] then
			meta:set_string("infotext", minetest.registered_entities[def.mob].description)
			local nearby = #b.t.imap(minetest.get_objects_inside_radius(pos, aurum.mobs.SPAWN_RADIUS), function(v) return (v:get_luaentity() and v:get_luaentity().name == def.mob) and v or nil end)
			if def.limit < 0 or nearby < def.limit then
				local function try(radius)
					for _,bp in ipairs(b.box.poses(b.box.new(vector.new(-radius, 0, -radius), vector.new(radius, 1, radius)), vector.new(0, 0, 0))) do
						local spawn_at = vector.add(pos, bp)
						local spawn_above = vector.add(spawn_at, vector.new(0, 1, 0))
						local spawn_below = vector.add(spawn_at, vector.new(0, -1, 0))
						if minetest.registered_nodes[minetest.get_node(spawn_below).name].walkable and aurum.is_air(minetest.get_node(spawn_at).name) and aurum.is_air(minetest.get_node(spawn_above).name) then
							if aurum.mobs.spawn(spawn_at, def.mob) then
								minetest.log("action", ("Spawner %s spawned mob %s at %s"):format(minetest.pos_to_string(pos), def.mob, minetest.pos_to_string(spawn_at)))
							end
							if def.replace then
								minetest.set_node(pos, def.replace)
							end
							return true
						end
					end
				end

				if not (try(1) or try(2) or try(3)) then
					minetest.log("action", ("Spawner failed to spawn mob %s at %s"):format(def.mob, minetest.pos_to_string(pos)))
				elseif def.replace then
					-- Success and replaced, skip processing.
					return false
				end
			end
		else
			minetest.log("warning", ("Spawner tried to spawn unknown mob %s at %s"):format(def.mob, minetest.pos_to_string(pos)))
		end

		minetest.get_node_timer(pos):start(math.random(unpack(def.time)))
		return false
	end,
})

function aurum.mobs.set_spawner(pos, def)
	local meta = minetest.get_meta(pos)
	meta:set_string("def", minetest.serialize(def))
	minetest.get_node_timer(pos):start(1)
end
