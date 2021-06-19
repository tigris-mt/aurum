local op = "aurum_trees:oak_planks"
local air = "air"

aurum.villages.register_structure("aurum_villages:ruined_hut", {
	size = vector.new(5, 4, 5),
	foundation = {"aurum_base:stone_brick"},

	schematic = aurum.features.schematic(vector.new(5, 4, 5), {
		{
			{op, op, op, op, op},
			{op, op, op, op, op},
			{op, op, op, op, op},
			{op, op, op, op, op},
			{op, op, op, op, op},
		},
		{
			{op, op, op, op, op},
			{op, air, air, air, op},
			{op, air, air, air, op},
			{op, air, air, air, op},
			{op, op, air, op, op},
		},
		{
			{op, op, op, op, op},
			{op, "aurum_features:ph_1", air, "aurum_features:ph_1", op},
			{op, air, air, air, op},
			{op, "aurum_features:ph_1", air, "aurum_features:ph_1", op},
			{op, op, air, op, op},
		},
		{
			{op, op, op, op, op},
			{op, op, op, op, op},
			{op, op, op, op, op},
			{op, op, op, op, op},
			{op, op, op, op, op},
		},
	}),

	on_offset = function(context)
		return vector.add(context.pos, vector.new(0, -1, 0))
	end,

	on_generated = function(c)
		local ph = c:ph(1)

		if #ph > 0 then
			minetest.set_node(ph[1], {name = "aurum_storage:box"})
			c:treasures(ph[1], "main", c:random(2, 4), {
				{
					count = c:random(1, 3),
					preciousness = {0, 2},
					groups = {"building_block", "crafting_component"},
				},
			})
		end
	end,
})
