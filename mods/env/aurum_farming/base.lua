local S = minetest.get_translator()

-- How close does water need to be for soil to maintain fertility?
local RADIUS = 2

doc.sub.items.register_factoid("nodes", "use", function(itemstring, def)
	if minetest.get_item_group(itemstring, "fertilizer") > 0 then
		return S("This node can be placed on soil and right-clicked with a shovel to produce wet soil of level @1.", minetest.get_item_group(itemstring, "fertilizer"))
	end
	return ""
end)

doc.sub.items.register_factoid("nodes", "use", function(itemstring, def)
	if minetest.get_item_group(itemstring, "soil_wet") > 0 then
		return S("This node can support plants of level @1.", minetest.get_item_group(itemstring, "soil_wet"))
	end
	return ""
end)

doc.sub.items.register_factoid("nodes", "use", function(itemstring, def)
	if minetest.get_item_group(itemstring, "soil_wet") > 0 then
		return S("This node will quickly dry out unless water is within @1 nodes radius.", RADIUS)
	end
	return ""
end)

-- Handle right-clicking on fertilizier.
function aurum.farming.fertilizer_rightclick(pos, node, player, item)
	-- Only shovels can mix fertilizer into soil.
	if minetest.get_item_group(item:get_name(), "tool_shovel") <= 0 then
		return
	end

	local under = vector.add(pos, vector.new(0, -1, 0))
	local undernode = minetest.get_node(under)

	-- Ensure soil.
	if minetest.get_item_group(undernode.name, "soil") <= 0 then
		return
	end

	-- Check protection for both the fertilizer and the soil.
	if aurum.is_protected(pos, player) or aurum.is_protected(under, player) then
		return
	end

	-- Fertilize the soil.
	minetest.set_node(under, {
		-- Set the node to soil of the appropriate level.
		name = "aurum_farming:soil_" .. minetest.get_item_group(node.name, "fertilizer"),
	})

	-- Remove the fertilizer.
	minetest.remove_node(pos)
	minetest.check_for_falling(pos)

	minetest.sound_play("default_dig_crumbly", {
		pos = under, gain = 0.5,
	})

	-- Wear down the tool.
	local wear = aurum.TOOL_WEAR / item:get_tool_capabilities().groupcaps.dig_dig.uses
	item:add_wear(aurum.in_creative(player) and 0 or wear)
	return item
end

-- Fertilizer is a liquid you can get stuck and drown in.
-- Better bring a shovel or have the energy to claw your way out!
minetest.register_node("aurum_farming:fertilizer", {
	description = S"Fertilizer",
	_doc_items_longdesc = S"It may not look good or have a nice smell, but fertilizer is vital for your survival. Just don't fall in!",
	_doc_items_hidden = false,
	groups = {fertilizer = 1, liquid = 1, disable_jump = 1, dig_dig = 2, flammable = 1, dig_long_handle = 1},
	sounds = aurum.sounds.dirt(),

	tiles = {"aurum_farming_fertilizer.png"},

	liquid_viscosity = 15,

	liquidtype = "source",
	liquid_alternative_flowing = "aurum_farming:fertilizer",
	liquid_alternative_source = "aurum_farming:fertilizer",

	liquid_renewable = false,
	liquid_range = 0,
	drowning = 1,
	post_effect_color = {r = 15, g = 21, b = 7, a = 245},

	walkable = false,
	climbable = false,

	on_rightclick = aurum.farming.fertilizer_rightclick,
})

minetest.register_craft{
	type = "fuel",
	recipe = "group:fertilizer",
	burntime = 10,
}

-- Level 1 wet soil.
minetest.register_node("aurum_farming:soil_1", {
	description = S"Wet Soil",
	groups = {soil = 1, soil_wet = 1, dig_dig = 2},
	drop = "aurum_base:dirt",
	sounds = aurum.sounds.dirt(),

	tiles = {"aurum_farming_soil.png", "aurum_base_dirt.png"},
})

minetest.register_abm{
	label = "Soil Drying",
	nodenames = {"group:soil_wet"},
	interval = 5,
	chance = 10,
	action = function(pos)
		if #minetest.find_nodes_in_area(vector.subtract(pos, RADIUS), vector.add(pos, RADIUS), "group:water") == 0 then
			minetest.set_node(pos, {name = "aurum_base:dirt"})
		end
	end,
}

-- Fertilizer blob ore around forest biomes.
local blob = {
	ore_type = "blob",
	ore = "aurum_farming:fertilizer",
	wherein = "group:soil",
	clust_scarcity = 13 * 13 * 13,
	clust_size = 3,

	noise_threshold = 0,
	noise_params = {
		offset = 0.5,
		seed = 13,
		scale = 0.25,
		spread = vector.new(200, 200, 200),
		octaves = 1,
	},

	biomes = aurum.biomes.get_all_group("forest", {"base"})
}

minetest.register_ore(blob)

-- More common in dark grass.
minetest.register_ore(b.t.combine(blob, {
	wherein = "aurum_base:dark_grass",
	clust_scarcity = 10 * 10 * 10,
}))
