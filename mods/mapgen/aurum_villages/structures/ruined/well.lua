local op = "aurum_trees:oak_planks"
local wa = "aurum_base:water_source"
local air = "air"

aurum.villages.register_structure("aurum_villages:ruined_well", {
	size = vector.new(3, 3, 3),
	foundation = {"aurum_base:gravel"},

	schematic = aurum.features.schematic(vector.new(3, 3, 3), {
		{
			{air, air, air},
			{op, op, op},
			{air, air, air},
		},
		{
			{air, air, air},
			{op, air, op},
			{air, air, air},
		},
		{
			{op, op, op},
			{op, wa, op},
			{op, op, op},
		},
	}),
})
