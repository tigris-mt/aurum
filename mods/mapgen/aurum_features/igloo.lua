local s = "aurum_base:snow"
local ladder = "aurum_features:ph_1"
local loot_basic = "aurum_features:ph_2"
local loot_occult = "aurum_features:ph_3"
local useful_thing = "aurum_features:ph_4"
local useful_occult_thing = "aurum_features:ph_5"
local oven = "aurum_features:ph_6"
local air = "air"
local ignore = "ignore"

local top = {
	{
		{ignore, ignore, ignore, ignore, ignore, ignore, ignore},
		{ignore, s, s, s, s, s, ignore},
		{ignore, s, s, s, s, s, ignore},
		{ignore, s, s, ignore, s, s, ignore},
		{ignore, s, s, s, s, s, ignore},
		{ignore, s, s, s, s, s, ignore},
		{ignore, ignore, ignore, ignore, ignore, ignore, ignore},
		{ignore, ignore, ignore, ignore, ignore, ignore, ignore},
		{ignore, ignore, ignore, ignore, ignore, ignore, ignore},
		{ignore, ignore, ignore, ignore, ignore, ignore, ignore},
		{ignore, ignore, ignore, ignore, ignore, ignore, ignore},
	},
	{
		{ignore, s, s, s, s, s, ignore},
		{s, s, s, s, s, s, s},
		{s, s, air, air, air, s, s},
		{s, s, air, air, air, s, s},
		{s, s, air, air, air, s, s},
		{s, s, s, s, s, s, s},
		{ignore, s, s, s, s, s, ignore},
		{ignore, ignore, s, s, s, ignore, ignore},
		{ignore, ignore, s, s, s, ignore, ignore},
		{ignore, ignore, s, s, s, ignore, ignore},
		{ignore, ignore, s, s, s, ignore, ignore},
	},
	{
		{ignore, s, s, s, s, s, ignore},
		{s, air, air, air, air, air, s},
		{s, air, air, air, air, air, s},
		{s, air, air, air, air, air, s},
		{s, air, air, air, air, air, s},
		{s, air, air, air, air, air, s},
		{ignore, s, s, air, s, s, ignore},
		{ignore, ignore, s, air, s, ignore, ignore},
		{ignore, ignore, s, air, s, ignore, ignore},
		{ignore, ignore, s, air, s, ignore, ignore},
		{ignore, ignore, s, air, s, ignore, ignore},
	},
	{
		{ignore, s, s, s, s, s, ignore},
		{s, loot_basic, air, air, air, loot_basic, s},
		{s, air, air, air, air, air, s},
		{s, air, air, oven, air, air, s},
		{s, air, air, air, air, air, s},
		{s, useful_thing, air, air, air, loot_basic, s},
		{ignore, s, s, air, s, s, ignore},
		{ignore, ignore, s, air, s, ignore, ignore},
		{ignore, ignore, s, air, s, ignore, ignore},
		{ignore, ignore, s, air, s, ignore, ignore},
		{ignore, ignore, s, air, s, ignore, ignore},
	},
}

local no_basement = {
	{
		{ignore, s, s, s, s, s, ignore},
		{s, s, s, s, s, s, s},
		{s, s, s, s, s, s, s},
		{s, s, s, s, s, s, s},
		{s, s, s, s, s, s, s},
		{s, s, s, s, s, s, s},
		{ignore, s, s, s, s, s, ignore},
		{ignore, ignore, s, s, s, ignore, ignore},
		{ignore, ignore, s, s, s, ignore, ignore},
		{ignore, ignore, s, s, s, ignore, ignore},
		{ignore, ignore, s, s, s, ignore, ignore},
	},
	{
		{ignore, s, s, s, s, s, ignore},
		{s, s, s, s, s, s, s},
		{s, s, s, s, s, s, s},
		{s, s, s, s, s, s, s},
		{s, s, s, s, s, s, s},
		{s, s, s, s, s, s, s},
		{ignore, s, s, s, s, s, ignore},
		{ignore, ignore, s, s, s, ignore, ignore},
		{ignore, ignore, s, s, s, ignore, ignore},
		{ignore, ignore, s, s, s, ignore, ignore},
		{ignore, ignore, s, s, s, ignore, ignore},
	},
	{
		{ignore, s, s, s, s, s, ignore},
		{s, s, s, s, s, s, s},
		{s, s, s, s, s, s, s},
		{s, s, s, s, s, s, s},
		{s, s, s, s, s, s, s},
		{s, s, s, s, s, s, s},
		{ignore, s, s, s, s, s, ignore},
		{ignore, ignore, s, s, s, ignore, ignore},
		{ignore, ignore, s, s, s, ignore, ignore},
		{ignore, ignore, s, s, s, ignore, ignore},
		{ignore, ignore, s, s, s, ignore, ignore},
	},
	{
		{ignore, s, s, s, s, s, ignore},
		{s, s, s, s, s, s, s},
		{s, s, s, s, s, s, s},
		{s, s, s, s, s, s, s},
		{s, s, s, s, s, s, s},
		{s, s, s, s, s, s, s},
		{ignore, s, s, s, s, s, ignore},
		{ignore, ignore, s, s, s, ignore, ignore},
		{ignore, ignore, s, s, s, ignore, ignore},
		{ignore, ignore, s, s, s, ignore, ignore},
		{ignore, ignore, s, s, s, ignore, ignore},
	},
}

local basement = {
	{
		{ignore, s, s, s, s, s, ignore},
		{s, s, s, ladder, s, s, s},
		{s, s, s, s, s, s, s},
		{s, s, s, s, s, s, s},
		{s, s, s, s, s, s, s},
		{s, s, s, s, s, s, s},
		{ignore, s, s, s, s, s, ignore},
		{ignore, ignore, s, s, s, ignore, ignore},
		{ignore, ignore, s, s, s, ignore, ignore},
		{ignore, ignore, s, s, s, ignore, ignore},
		{ignore, ignore, s, s, s, ignore, ignore},
	},
	{
		{ignore, s, s, s, s, s, ignore},
		{s, air, air, ladder, air, air, s},
		{s, air, air, air, air, air, s},
		{s, air, air, air, air, air, s},
		{s, air, air, air, air, air, s},
		{s, air, air, air, air, air, s},
		{ignore, s, s, s, s, s, ignore},
		{ignore, ignore, s, s, s, ignore, ignore},
		{ignore, ignore, s, s, s, ignore, ignore},
		{ignore, ignore, s, s, s, ignore, ignore},
		{ignore, ignore, s, s, s, ignore, ignore},
	},
	{
		{ignore, s, s, s, s, s, ignore},
		{s, air, air, ladder, air, air, s},
		{s, air, air, air, air, air, s},
		{s, air, air, air, air, air, s},
		{s, air, air, air, air, air, s},
		{s, air, air, air, air, air, s},
		{ignore, s, s, s, s, s, ignore},
		{ignore, ignore, s, s, s, ignore, ignore},
		{ignore, ignore, s, s, s, ignore, ignore},
		{ignore, ignore, s, s, s, ignore, ignore},
		{ignore, ignore, s, s, s, ignore, ignore},
	},
	{
		{ignore, s, s, s, s, s, ignore},
		{s, air, air, ladder, air, air, s},
		{s, air, air, air, air, air, s},
		{s, air, air, air, air, air, s},
		{s, air, air, air, air, air, s},
		{s, loot_occult, air, useful_occult_thing, air, loot_occult, s},
		{ignore, s, s, s, s, s, ignore},
		{ignore, ignore, s, s, s, ignore, ignore},
		{ignore, ignore, s, s, s, ignore, ignore},
		{ignore, ignore, s, s, s, ignore, ignore},
		{ignore, ignore, s, s, s, ignore, ignore},
	},
	{
		{ignore, s, s, s, s, s, ignore},
		{s, s, s, s, s, s, s},
		{s, s, s, s, s, s, s},
		{s, s, s, s, s, s, s},
		{s, s, s, s, s, s, s},
		{s, s, s, s, s, s, s},
		{ignore, s, s, s, s, s, ignore},
		{ignore, ignore, s, s, s, ignore, ignore},
		{ignore, ignore, s, s, s, ignore, ignore},
		{ignore, ignore, s, s, s, ignore, ignore},
		{ignore, ignore, s, s, s, ignore, ignore},
	},
	{
		{ignore, s, s, s, s, s, ignore},
		{s, s, s, s, s, s, s},
		{s, s, s, s, s, s, s},
		{s, s, s, s, s, s, s},
		{s, s, s, s, s, s, s},
		{s, s, s, s, s, s, s},
		{ignore, s, s, s, s, s, ignore},
		{ignore, ignore, s, s, s, ignore, ignore},
		{ignore, ignore, s, s, s, ignore, ignore},
		{ignore, ignore, s, s, s, ignore, ignore},
		{ignore, ignore, s, s, s, ignore, ignore},
	},
	{
		{ignore, s, s, s, s, s, ignore},
		{s, s, s, s, s, s, s},
		{s, s, s, s, s, s, s},
		{s, s, s, s, s, s, s},
		{s, s, s, s, s, s, s},
		{s, s, s, s, s, s, s},
		{ignore, s, s, s, s, s, ignore},
		{ignore, ignore, s, s, s, ignore, ignore},
		{ignore, ignore, s, s, s, ignore, ignore},
		{ignore, ignore, s, s, s, ignore, ignore},
		{ignore, ignore, s, s, s, ignore, ignore},
	},
	{
		{ignore, s, s, s, s, s, ignore},
		{s, s, s, s, s, s, s},
		{s, s, s, s, s, s, s},
		{s, s, s, s, s, s, s},
		{s, s, s, s, s, s, s},
		{s, s, s, s, s, s, s},
		{ignore, s, s, s, s, s, ignore},
		{ignore, ignore, s, s, s, ignore, ignore},
		{ignore, ignore, s, s, s, ignore, ignore},
		{ignore, ignore, s, s, s, ignore, ignore},
		{ignore, ignore, s, s, s, ignore, ignore},
	},
}

local l = {
	{
		schematic = aurum.trees.schematic(vector.new(7, #top + #no_basement, 11), table.icombine(top, no_basement)),

		on_offset = function(pos)
			return vector.add(pos, vector.new(0, -#no_basement + 1, 0))
		end,
	},
	{
		schematic = aurum.trees.schematic(vector.new(7, #top + #basement, 11), table.icombine(top, basement)),

		on_offset = function(pos)
			return vector.add(pos, vector.new(0, -#basement + 1, 0))
		end,
	},
}

for _,def in ipairs(l) do
	aurum.features.register_decoration(table.combine({
		place_on = {"aurum_base:snow"},
		rarity = 0.000035,
		biomes = aurum.biomes.get_all_group("frozen", {"base"}),

		on_generated = function(c)
			for _,pos in ipairs(c:ph(1)) do
				minetest.set_node(pos, {
					name = "aurum_ladders:wood",
					param2 = minetest.dir_to_wallmounted(c:dir(vector.new(0, 0, 1))),
				})
			end

			for i=1,math.random(0, #c:ph(2)) do
				minetest.set_node(c:ph(2)[i], {name = "aurum_storage:box"})
				c:treasures(c:ph(2)[i], "main", c:random(1, 3), {
					{
						count = 1,
						preciousness = {1, 3},
						groups = {"building_block", "melee_weapon", "seed", "minetool", "raw"},
					},
				})
			end

			for i=1,math.random(-2, #c:ph(3)) do
				minetest.set_node(c:ph(3)[i], {name = "aurum_storage:box"})
				c:treasures(c:ph(3)[i], "main", c:random(1, 3), {
					{
						count = 1,
						preciousness = {1, 3},
						groups = {"scroll"},
					},
				})
			end

			for i=1,math.random(0, #c:ph(4)) do
				local possible = {
					"aurum_cook:smelter",
					"aurum_storage:box",
					"aurum_stamp:stamper",
				}
				minetest.set_node(c:ph(4)[i], {name = possible[math.random(#possible)]})
			end

			for i=1,math.random(-2, #c:ph(5)) do
				local possible = {
					"aurum_enchants:table",
					"aurum_enchants:copying_desk",
					"aurum_rods:table",
				}
				minetest.set_node(c:ph(5)[i], {name = possible[math.random(#possible)]})
			end

			if #c:ph(6) > 0 then
				minetest.set_node(c:ph(6)[1], {
					name = "aurum_cook:oven",
					param2 = minetest.dir_to_facedir(c:dir(vector.new(0, 0, 1))),
				})
				c:treasures(c:ph(6)[1], "fuel", 1, {
					{
						count = 1,
						preciousness = {1, 3},
						groups = {"fuel"},
					},
				})
			end
		end,
	}, def))
end
