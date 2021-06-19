for _,def in ipairs({
	{
		name = "aurum_villages:ruined_well",
		pl = "aurum_trees:drywood_planks",
		wa = "air",
		foundation = {"aurum_base:gravel"},
	},
	{
		name = "aurum_villages:ruined_well_jungle",
		pl = "aurum_trees:pander_planks",
		wa = "aurum_base:water_source",
		foundation = {"aurum_base:dirt"},
	},
}) do
	local pl = def.pl
	local wa = def.wa
	local air = "air"

	aurum.villages.register_structure(def.name, {
		size = vector.new(3, 3, 3),
		foundation = def.foundation,

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
				{pl, wa, pl},
				{pl, pl, pl},
			},
		}),
	})
end
