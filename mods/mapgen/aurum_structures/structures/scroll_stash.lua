-- A little underground stash of scrolls.

local sb = "aurum_base:stone_brick"
local sh = "aurum_features:ph_1"
local cd = "aurum_features:ph_2"
local fl = "aurum_features:ph_3"
local air = "air"

aurum.features.register_decoration{
	place_on = {"aurum_base:stone"},
	rarity = 1 / (18 * 18 * 18),
	biomes = aurum.biomes.get_all_group("aurum:aurum", {"under"}),

	on_offset = function(pos)
		return vector.add(pos, vector.new(0, -3, 0))
	end,

	schematic = aurum.trees.schematic(vector.new(3, 6, 3), {
		{
			{sb, sb, sb},
			{sb, sb, sb},
			{sb, sb, sb},
		},
		{
			{sb, sb, sb},
			{air, fl, air},
			{air, air, air},
		},
		{
			{sb, sb, sb},
			{sh, cd, sh},
			{air, air, air},
		},
		{
			{sb, sb, sb},
			{sb, sb, sb},
			{sb, sb, sb},
		},
		{
			{sb, sb, sb},
			{sb, sb, sb},
			{sb, sb, sb},
		},
		{
			{sb, sb, sb},
			{sb, sb, sb},
			{sb, sb, sb},
		},
	}),

	on_generated = function(c)
		for i=1,math.random(0, #c:ph(1)) do
			minetest.set_node(c:ph(1)[i], {name = "aurum_storage:scroll_hole"})
			c:treasures(c:ph(1)[i], "main", c:random(0, 2), {
				{
					count = 1,
					preciousness = {1, 6},
					groups = {"enchant_scroll", "lorebook_general"},
				},
			})
		end

		for _,pos in ipairs(c:ph(2)) do
			if c:random() <= 0.5 then
				minetest.set_node(pos, {
					name = "aurum_enchants:copying_desk",
					param2 = minetest.dir_to_facedir(c:dir(vector.new(0, 0, 1))),
				})

				for _,list in ipairs{"src", "dst", "library"} do
					c:treasures(pos, list, c:random(-4, 2), {
						{
							count = 1,
							preciousness = {1, 6},
							groups = {"enchant_scroll"},
						},
					})
				end
			end
		end

		for _,pos in ipairs(c:ph(3)) do
			minetest.set_node(pos, {
				name = "aurum_flare:flare",
				param2 = minetest.dir_to_wallmounted(c:dir(vector.new(0, 0, 1))),
			})
		end
	end,
}
