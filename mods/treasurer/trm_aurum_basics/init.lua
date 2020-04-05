-- Register list of item names to treasurer with the same parameters, except that rarity is divided by the number of items in the list.
local function list(l, ...)
	local p = {...}
	-- First parameter is rarity; divide by number of items.
	p[1] = p[1] / #l
	for _,n in ipairs(l) do
		treasurer.register_treasure(n, unpack(p))
	end
end

minetest.register_on_mods_loaded(function()
	-- Basic materials.
	list({
		"aurum_base:stone",
		"aurum_base:dirt",
		"aurum_base:sand",
		"aurum_clay:clay_white",
	}, 0.35, 0, {1, 30}, 0, {"raw"})

	-- Ore products.
	local num_ores = #b.t.keys(aurum.ore.ores)
	for k,v in pairs(aurum.ore.ores) do
		if v.ingot then
			treasurer.register_treasure(v.ingot, 0.3 / num_ores, v.level, {1, 10}, 0, {"processed"})
		end
		if v.block then
			treasurer.register_treasure(v.block, 0.1 / num_ores, v.level + 1, {1, 10}, 0, {"processed"})
		end
	end

	-- Tree stuff.
	local num_trees = #b.t.keys(aurum.trees.types)
	for k,v in pairs(aurum.trees.types) do
		treasurer.register_treasure(v.planks, 0.3 / num_trees, 1, {1, 10}, 0, {"building_block", "fuel"})
		treasurer.register_treasure(v.sapling, 0.3 / num_trees, 2, {1, 10}, 0, {"seed"})
	end

	-- Lighting.
	treasurer.register_treasure("aurum_flare:flare", 0.5, 1, {1, 10}, 0, {"light"})

	-- All ladders.
	list(b.t.keys(aurum.ladders.ladders), 0.5, 0, {1, 20}, 0, {"ladder"})

	-- Building blocks.
	list({
		"aurum_base:stone_brick",
		"aurum_base:glass_white",
		"aurum_clay:brick_white",
	}, 0.5, 1, {1, 30}, 0, {"building_block"})

	-- Utility blocks.
	list({
		"aurum_cook:oven",
		"aurum_cook:smelter",
		"aurum_storage:box",
		"aurum_magic:altar",
		"aurum_enchants:table",
		"aurum_rods:table",
		"aurum_storage:scroll_hole",
	}, 0.5, 3, {1, 10}, 0, {"worker"})

	-- Farming.
	list({
		"aurum_farming:carrot_seed",
	}, 0.5, 2, {1, 5}, 0, {"seed"})

	-- Dyes.
	list(b.t.map(dye.dyes, function(v) return "dye:" .. v[1] end), 0.25, 1, {1, 20}, 0, {"crafting_component", "dye"})
end)
