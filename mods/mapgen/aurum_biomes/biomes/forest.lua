aurum.biomes.register("aurum:aurum", {
	name = "aurum_forest",
	node_top = "aurum_base:grass",
	depth_top = 1,
	node_filler = "aurum_base:dirt",
	depth_filler = 3,
	heat_point = 50,
	humidity_point = 50,
})

local oak = aurum.trees.types["aurum_trees:oak"].decorations
for k,v in pairs(oak) do
	minetest.register_decoration(table.combine({
		deco_type = "schematic",
		place_on = {"group:soil"},
		sidelen = 80,
		fill_ratio = 0.005 / #table.keys(oak),
		biomes = {"aurum_forest"},
	}, v))
end
