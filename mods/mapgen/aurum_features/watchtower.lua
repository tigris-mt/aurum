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
		{air, sb, air, air, air, sb, air},
		{air, sb, air, air, air, sb, air},
		{air, sb, air, air, air, sb, air},
		{air, sb, sb, sb, sb, sb, air},
		{air, air, air, air, air, air, air},
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
		{sb, air, air, air, air, air, sb},
		{sb, air, air, air, air, air, sb},
		{sb, ladder1, air, air, air, ladder2, sb},
		{sb, air, air, air, air, air, sb},
		{sb, air, air, air, air, air, sb},
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
	--place_on = {"group:sand"},
	place_on = {"group:sand", "group:soil", "aurum_base:gravel"},
	rarity = 0.001,
	biomes = aurum.biomes.get_all_group("aurum:aurum", {"base"}),
	schematic = aurum.trees.schematic(vector.new(7, 16, 7), table.icombine(
		top,
		center,
		basement
	)),

	on_offset = function(pos)
		return vector.add(pos, vector.new(0, -5, 0))
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
	end,
}
