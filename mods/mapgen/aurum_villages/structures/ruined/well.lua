local pl = "aurum_trees:drywood_planks"
local air = "air"

aurum.villages.register_structure("aurum_villages:ruined_well", {
	size = vector.new(3, 3, 3),
	foundation = {"aurum_base:gravel"},

	schematic = aurum.features.schematic(vector.new(3, 3, 3), {
		{
			{air, air, air},
			{pl, pl, pl},
			{air, air, air},
		},
		{
			{air, air, air},
			{pl, air, pl},
			{air, air, air},
		},
		{
			{pl, pl, pl},
			{pl, air, pl},
			{pl, pl, pl},
		},
	}),
})
