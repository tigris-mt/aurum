local PH_STORAGE = 1
local PH_WORKER = 2
local PH_CONTRABAND = 3

aurum.villages.register_structure("aurum_villages:ruined_hall", {
	size = vector.new(7, 9, 9),
	foundation = {"aurum_base:gravel"},

	schematic = aurum.structures.f"ruined_hall.mts",

	on_offset = function(context)
		return vector.add(context.pos, vector.new(0, -1, 0))
	end,

	on_generated = function(c)
		for _,pos in ipairs(c:ph(PH_STORAGE)) do
			minetest.set_node(pos, {name = "aurum_storage:box"})
			c:treasures(pos, "main", c:random(1, 4), {
				{
					count = c:random(-2, 3),
					preciousness = {0, 4},
					groups = {"building_block", "crafting_component", "transport_structure", "transport_vehicle", "processed", "raw", "deco", "minetool"},
				},
			})
		end

		for _,pos in ipairs(c:ph(PH_WORKER)) do
			minetest.set_node(pos, {name = b.t.choice({
				"aurum_cook:oven",
				"aurum_cook:smelter",
			}, c.base.random), param2 = minetest.dir_to_facedir(c:dir(vector.new(1, 0, 0)))})
			c:treasures(pos, "fuel", 1, {
				{
					count = 1,
					preciousness = {1, 3},
					groups = {"fuel"},
				},
			})
		end

		for _,pos in ipairs(c:ph(PH_CONTRABAND)) do
			minetest.set_node(pos, {name = "aurum_storage:box"})
			c:treasures(pos, "main", c:random(1, 4), {
				{
					count = 1,
					preciousness = {0, 4},
					groups = {"dye", "magic", "lore", "scroll"},
				},
			})
		end
	end,
})

