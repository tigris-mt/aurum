local RADIUS = 40
local TIME = {0, 1000}
local TIMER = 1

aurum.mobs.spawns = {}
aurum.mobs.spawn_biomes = {}

local function reset_timer(def, mod)
	def.timer = math.random(unpack(TIME)) / def.rarity * (mod or 1)
end

function aurum.mobs.register_spawn(def)
	def = b.t.combine({
		rarity = 1,
		-- Name of the mob.
		mob = nil,
		-- Table of nodes to spawn on.
		-- Defaults to mob's habitat nodes.
		nodes = nil,
		-- Table of biomes to spawn in.
		biomes = nil,
	}, def)

	reset_timer(def, 0.01)

	def.nodes = def.nodes or aurum.mobs.mobs[def.mob].habitat_nodes

	assert(def.mob, "must specify mob")
	assert(def.biomes and #def.biomes > 0, "must specify biomes")

	for _,biome in ipairs(def.biomes) do
		aurum.mobs.spawn_biomes[biome] = aurum.mobs.spawn_biomes[biome] or {}
		table.insert(aurum.mobs.spawn_biomes[biome], def)
	end

	table.insert(aurum.mobs.spawns, def)
end

local timer = 0
minetest.register_globalstep(function(dtime)
	timer = timer + dtime
	if timer > TIMER then
		for _,player in ipairs(minetest.get_connected_players()) do
			local pos = player:get_pos()
			local biome = minetest.get_biome_data(pos)
			local biome_name = biome and minetest.get_biome_name(biome.biome)

			if biome_name then
				for _,def in ipairs(aurum.mobs.spawn_biomes[biome_name] or {}) do
					def.timer = def.timer - timer
					if def.timer <= 0 then
						reset_timer(def)
						local box = aurum.box.new_radius(pos, RADIUS)
						local poses = b.t.shuffled(minetest.find_nodes_in_area_under_air(box.a, box.b, def.nodes))
						for _,pos in ipairs(poses) do
							if aurum.mobs.spawn(pos, def.mob) then
								break
							end
						end
					end
				end
			end
		end
		timer = 0
	end
end)
