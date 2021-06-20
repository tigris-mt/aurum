local PH_SCROLL_HOLE = 1
local PH_STORAGE = 2
local PH_CONTRABAND = 3
local PH_MOCKING = 4

aurum.villages.register_structure("aurum_villages:corrupted_temple", {
	size = vector.new(11, 18, 10),
	offset = vector.new(0, -5, 0),
	foundation = {"aurum_base:stone_brick"},

	schematic = aurum.structures.f"corrupted_temple.mts",

	on_generated = function(c)
		for _,pos in ipairs(c:ph(PH_SCROLL_HOLE)) do
			minetest.set_node(pos, {name = "aurum_storage:scroll_hole"})
			c:treasures(pos, "main", c:random(1, 2), {
				{
					count = c:random(1, 2),
					preciousness = {0, 2},
					groups = {"scroll", "lore_aurum"},
				},
			})
		end

		for _,pos in ipairs(c:ph(PH_STORAGE)) do
			minetest.set_node(pos, {name = "aurum_storage:box"})
			c:treasures(pos, "main", c:random(1, 2), {
				{
					count = c:random(1, 2),
					preciousness = {0, 2},
					groups = {"deco", "minetool", "building_block", "crafting_component", "scroll"},
				},
			})
		end

		for _,pos in ipairs(c:ph(PH_CONTRABAND)) do
			minetest.set_node(pos, {name = "aurum_storage:shell_box"})
			c:treasures(pos, "main", c:random(1, 2), {
				{
					count = c:random(0, 2),
					preciousness = {0, 5},
					groups = {"magic", "spell", "worker"},
				},
			})
		end

		local village_id = aurum.villages.get_village_id_at(c.base.pos)
		local village = village_id and aurum.villages.get_village(village_id)

		for _,pos in ipairs(c:ph(PH_MOCKING)) do
			if village then
				minetest.set_node(pos, {name = "aurum_books:stone_tablet_written", param2 = minetest.dir_to_facedir(c:dir(vector.new(-1, 0, 0)))})
				gtextitems.set_node(pos, {
					title = village.name,
					text = ("Our %s servant %s has brought about the end of %s."):format(aurum.flavor.generate_mocking(c:random(4), c.base.random), aurum.flavor.generate_name(c.base.random), village.name),
					author = "a dreadful one",
					author_type = "npc",
					id = "aurum_villages:corrupted_temple_mocking",
				})
			end
		end
	end,
})
