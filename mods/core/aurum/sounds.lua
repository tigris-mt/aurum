aurum.sounds = {}

-- Register a sound template, suitable for nodedef `sounds = x` or similiar.
-- Will create a function aurum.sounds.<name>([def]) where def can override any sound in the template.
function aurum.sounds.register(name, defaults)
	aurum.sounds[name] = function(def)
		return b.t.combine({
			footstep = {name = "", gain = 1},
			dug = {name = "default_dug_node", gain = 1 / 4},
			place = {name = "default_place_node_hard", gain = 1},
		}, defaults or {}, def or {})
	end
end

aurum.sounds.register("default")

aurum.sounds.register("dirt", {
	footstep = {name = "default_dirt_footstep", gain = 1 / 3},
	dug = {name = "default_dirt_footstep", gain = 1},
	place = {name = "default_place_node", gain = 1},
})

aurum.sounds.register("glass", {
	footstep = {name = "default_glass_footstep", gain = 1 / 3},
	dig = {name = "default_glass_footstep", gain = 1 / 2},
	dug = {name = "default_break_glass", gain = 1},
})

aurum.sounds.register("grass", {
	footstep = {name = "default_grass_footstep", gain = 1 / 2},
	dug = {name = "default_grass_footstep", gain = 2 / 3},
	place = {name = "default_place_node", gain = 1},
})

aurum.sounds.register("gravel", {
	footstep = {name = "default_gravel_footstep", gain = 1 / 3},
	dug = {name = "default_gravel_footstep", gain = 1},
	place = {name = "default_place_node", gain = 1},
})

aurum.sounds.register("metal", {
	footstep = {name = "default_metal_footstep", gain = 3 / 8},
	dig = {name = "default_dig_metal", gain = 1 / 2},
	dug = {name = "default_dug_metal", gain = 1 / 2},
	place = {name = "default_place_node_metal", gain = 1 / 2},
})

aurum.sounds.register("sand", {
	footstep = {name = "default_sand_footstep", gain = 1 / 8},
	dug = {name = "default_sand_footstep", gain = 2 / 8},
	place = {name = "default_place_node", gain = 1},
})

aurum.sounds.register("snow", {
	footstep = {name = "default_snow_footstep", gain = 1 / 4},
	dig = {name = "default_snow_footstep", gain = 1 / 3},
	dug = {name = "default_snow_footstep", gain = 1 / 3},
	place = {name = "default_place_node", gain = 1},
})

aurum.sounds.register("stone", {
	footstep = {name = "default_hard_footstep", gain = 1 / 3},
	dug = {name = "default_hard_footstep", gain = 1},
})

aurum.sounds.register("water", {
	footstep = {name = "default_water_footstep", gain = 1 / 4},
})

aurum.sounds.register("wood", {
	footstep = {name = "default_wood_footstep", gain = 1 / 3},
	dug = {name = "default_wood_footstep", gain = 1},
})

aurum.sounds.crystal = aurum.sounds.glass
aurum.sounds.flesh = aurum.sounds.grass
aurum.sounds.leaves = aurum.sounds.grass

-- Suitable for tooldefs.
function aurum.sounds.tool()
	return {
		breaks = "default_tool_breaks",
	}
end
