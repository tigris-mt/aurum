local TIMER = 5

aurum.mobs.spawns = {}
aurum.mobs.spawn_biomes = {}

local function reset_timer(def, factor)
	def.timer = math.random(unpack(def.time)) * (factor or 1)
end

function aurum.mobs.register_spawn(def)
	def = b.t.combine({
		-- (1/chance) chance to spawn per node.
		chance = 1000,
		-- Spawning time range.
		time = {0, 120},
		-- Name of the mob.
		mob = nil,
		-- Table of nodes to spawn on.
		-- Defaults to mob's habitat nodes.
		nodes = nil,
		-- Table of biomes to spawn in.
		biomes = nil,
		-- Light range.
		light_min = 0,
		light_max = minetest.LIGHT_MAX,
	}, def)

	-- Establish initial timeout.
	reset_timer(def, 0.1)

	def.nodes = def.nodes or aurum.mobs.mobs[def.mob].initial_data.habitat_nodes

	assert(def.mob, "must specify mob")
	assert(def.biomes and #def.biomes > 0, "must specify biomes")

	for _,biome in ipairs(def.biomes) do
		aurum.mobs.spawn_biomes[biome] = aurum.mobs.spawn_biomes[biome] or {}
		table.insert(aurum.mobs.spawn_biomes[biome], def)
	end

	table.insert(aurum.mobs.spawns, def)
end

-- Mob limit of zero means no spawning.
if aurum.mobs.SPAWN_LIMIT ~= 0 then
	local timer = 0
	minetest.register_globalstep(function(dtime)
		timer = timer + dtime
		if timer > TIMER then
			for _,player in ipairs(minetest.get_connected_players()) do
				local pos = player:get_pos()
				local biome = minetest.get_biome_data(pos)
				local biome_name = biome and minetest.get_biome_name(biome.biome)
				local nearby_mobs = b.t.imap(minetest.get_objects_inside_radius(pos, aurum.mobs.SPAWN_RADIUS), function(v) return (v:get_luaentity() and v:get_luaentity()._aurum_mobs_id) and v or nil end)

				if biome_name then
					for _,def in ipairs(aurum.mobs.spawn_biomes[biome_name] or {}) do
						if (aurum.mobs.SPAWN_LIMIT < 0 or #b.t.imap(nearby_mobs, function(v) return (v:get_luaentity().name == def.mob) and v or nil end) <= aurum.mobs.SPAWN_LIMIT) then
							def.timer = def.timer - timer
							if def.timer <= 0 then
								local spawned = false
								local box = b.box.new_radius(pos, aurum.mobs.SPAWN_RADIUS)
								for _,pos in b.t.ro_ipairs(minetest.find_nodes_in_area_under_air(box.a, box.b, def.nodes)) do
									local spawn_pos = vector.add(pos, vector.new(0, 1, 0))
									local light = minetest.get_node_light(spawn_pos)
									if light >= def.light_min and light <= def.light_max and math.random() < (1 / def.chance) then
										if aurum.mobs.spawn(spawn_pos, def.mob) then
											spawned = true
											minetest.log("action", ("Spawned mob %s at %s near %s"):format(def.mob, minetest.pos_to_string(spawn_pos), player:get_player_name()))
										end
									end
								end
								reset_timer(def, (not spawned) and 0.1)
							end
						end
					end
				end
			end
			timer = 0
		end
	end)
end
