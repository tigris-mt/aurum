-- An old watchtower.
-- In the top a wizard would stand guard.
-- In the basement was the armory.

local sb = "aurum_base:stone_brick"
local ladder1 = "aurum_features:ph_1"
local ladder2 = "aurum_features:ph_2"
local air = "air"

local top = {
	{
		{air, air, air, air, air, air, air},
		{air, air, air, air, air, air, air},
		{air, air, sb, sb, sb, air, air},
		{air, air, sb, sb, sb, air, air},
		{air, air, sb, sb, sb, air, air},
		{air, air, air, air, air, air, air},
		{air, air, air, air, air, air, air},
	},
	{
		{air, air, air, air, air, air, air},
		{air, sb, sb, sb, sb, sb, air},
		{air, sb, sb, sb, sb, sb, air},
		{air, sb, sb, sb, sb, sb, air},
		{air, sb, sb, sb, sb, sb, air},
		{air, sb, sb, sb, sb, sb, air},
		{air, air, air, air, air, air, air},
	},
	{
		{air, air, air, air, air, air, air},
		{air, sb, sb, sb, sb, sb, air},
		{air, sb, air, air, air, sb, air},
		{air, sb, air, air, air, sb, air},
		{air, sb, air, air, air, sb, air},
		{air, sb, sb, sb, sb, sb, air},
		{air, air, air, air, air, air, air},
	},
	{
		{air, air, air, air, air, air, air},
		{air, sb, sb, air, sb, sb, air},
		{air, sb, air, air, air, sb, air},
		{air, air, air, air, air, air, air},
		{air, sb, air, air, air, sb, air},
		{air, sb, sb, air, sb, sb, air},
		{air, air, air, air, air, air, air},
	},
	{
		{air, air, air, air, air, air, air},
		{air, sb, sb, sb, sb, sb, air},
		{air, sb, "aurum_features:ph_3", air, "aurum_features:ph_3", sb, air},
		{air, sb, air, air, air, sb, air},
		{air, sb, "aurum_features:ph_3", air, "aurum_features:ph_3", sb, air},
		{air, sb, sb, sb, sb, sb, air},
		{air, air, air, air, air, air, air},
	},
	{
		{sb, sb, sb, sb, sb, sb, sb},
		{sb, sb, sb, sb, sb, sb, sb},
		{sb, sb, sb, sb, sb, sb, sb},
		{sb, sb, sb, air, sb, sb, sb},
		{sb, sb, sb, sb, sb, sb, sb},
		{sb, sb, sb, sb, sb, sb, sb},
		{sb, sb, sb, sb, sb, sb, sb},
	},
}

local center = {
	{
		{sb, sb, sb, air, sb, sb, sb},
		{sb, air, air, air, air, air, sb},
		{sb, air, air, air, air, air, sb},
		{air, air, air, air, air, air, air},
		{sb, air, air, air, air, air, sb},
		{sb, air, air, air, air, air, sb},
		{sb, sb, sb, air, sb, sb, sb},
	},
	{
		{sb, sb, sb, sb, sb, sb, sb},
		{sb, air, air, air, air, air, sb},
		{sb, air, air, air, air, air, sb},
		{sb, air, air, air, air, air, sb},
		{sb, air, air, air, air, air, sb},
		{sb, air, air, air, air, air, sb},
		{sb, sb, sb, sb, sb, sb, sb},
	},
	{
		{sb, sb, sb, air, sb, sb, sb},
		{sb, air, air, air, air, air, sb},
		{sb, air, air, air, air, air, sb},
		{air, air, air, air, air, air, air},
		{sb, air, air, air, air, air, sb},
		{sb, air, air, air, air, air, sb},
		{sb, sb, sb, air, sb, sb, sb},
	},
	{
		{sb, sb, sb, air, sb, sb, sb},
		{sb, air, air, air, air, air, sb},
		{sb, air, air, air, air, air, sb},
		{sb, air, air, air, air, air, sb},
		{sb, air, air, air, air, air, sb},
		{sb, air, air, air, air, air, sb},
		{sb, sb, sb, air, sb, sb, sb},
	},
	{
		{sb, sb, sb, sb, sb, sb, sb},
		{sb, sb, sb, sb, sb, sb, sb},
		{sb, sb, sb, sb, sb, sb, sb},
		{sb, ladder1, sb, sb, sb, ladder2, sb},
		{sb, sb, sb, sb, sb, sb, sb},
		{sb, sb, sb, sb, sb, sb, sb},
		{sb, sb, sb, sb, sb, sb, sb},
	},
}

local basement = {
	{
		{sb, sb, sb, sb, sb, sb, sb},
		{sb, air, air, air, air, air, sb},
		{sb, air, air, air, air, air, sb},
		{sb, ladder1, air, air, air, ladder2, sb},
		{sb, air, air, air, air, air, sb},
		{sb, air, air, air, air, air, sb},
		{sb, sb, sb, sb, sb, sb, sb},
	},
	{
		{sb, sb, sb, sb, sb, sb, sb},
		{sb, air, air, air, air, air, sb},
		{sb, air, air, air, air, air, sb},
		{sb, ladder1, air, air, air, ladder2, sb},
		{sb, air, air, air, air, air, sb},
		{sb, air, air, air, air, air, sb},
		{sb, sb, sb, sb, sb, sb, sb},
	},
	{
		{sb, sb, sb, sb, sb, sb, sb},
		{sb, air, air, air, air, air, sb},
		{sb, air, air, air, air, air, sb},
		{sb, ladder1, air, air, air, ladder2, sb},
		{sb, air, air, air, air, air, sb},
		{sb, air, air, air, air, air, sb},
		{sb, sb, sb, sb, sb, sb, sb},
	},
	{
		{sb, sb, sb, sb, sb, sb, sb},
		{sb, air, air, "aurum_features:ph_4", air, air, sb},
		{sb, air, air, air, air, air, sb},
		{sb, ladder1, air, air, air, ladder2, sb},
		{sb, air, air, air, air, air, sb},
		{sb, air, air, "aurum_features:ph_4", air, air, sb},
		{sb, sb, sb, sb, sb, sb, sb},
	},
	{
		{sb, sb, sb, sb, sb, sb, sb},
		{sb, sb, sb, sb, sb, sb, sb},
		{sb, sb, sb, sb, sb, sb, sb},
		{sb, sb, sb, sb, sb, sb, sb},
		{sb, sb, sb, sb, sb, sb, sb},
		{sb, sb, sb, sb, sb, sb, sb},
		{sb, sb, sb, sb, sb, sb, sb},
	},
}

aurum.features.register_decoration{
	place_on = {"group:sand", "aurum_base:gravel"},
	rarity = 0.000035,
	biomes = aurum.biomes.get_all_group("aurum:aurum", {"base"}),
	schematic = aurum.features.schematic(vector.new(7, 16, 7), b.t.icombine(
		top,
		center,
		basement
	)),

	on_offset = function(context)
		return vector.add(context.pos, vector.new(0, -5, 0))
	end,

	on_generated = function(c)
		for _,pos in ipairs(c:ph(1)) do
			minetest.set_node(pos, {
				name = "aurum_ladders:wood",
				param2 = minetest.dir_to_wallmounted(c:dir(vector.new(-1, 0, 0))),
			})
		end

		for _,pos in ipairs(c:ph(2)) do
			minetest.set_node(pos, {
				name = "aurum_ladders:wood",
				param2 = minetest.dir_to_wallmounted(c:dir(vector.new(1, 0, 0))),
			})
		end

		-- Treasures
		local top = c:ph(3)
		local bottom = c:ph(4)

		-- 1/4 chance this was a wizard's watchtower.
		if top[1] and c:random() < 1/4 then
			minetest.set_node(top[1], {name = "aurum_storage:box"})
			c:treasures(top[1], "main", c:random(1, 2), {
				{
					count = 1,
					preciousness = {1, 4},
					groups = {"magic"},
				},
			})
		end

		-- Always generate some weapons/equipment.
		if bottom[1] then
			minetest.set_node(bottom[1], {name = "aurum_storage:box"})
			c:treasures(bottom[1], "main", c:random(1, 2), {
				{
					count = 1,
					preciousness = {1, 4},
					groups = {"melee_weapon", "ranged_weapon", "equipment"},
				},
			})
		end
	end,
}
