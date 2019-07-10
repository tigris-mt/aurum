aurum.biomes.register("aurum:aurum", {
	name = "aurum_forest",
	node_top = "aurum_base:grass",
	depth_top = 1,
	node_filler = "aurum_base:dirt",
	depth_filler = 3,
	heat_point = 50,
	humidity_point = 50,
})

local function nc(size, nodes, yp)
    local ret = {
        size = size,
        data = {},
        yslice_prob = yp or {},
    }
    for i=1,size.x * size.y * size.z do
        table.insert(ret.data, {name = "air", prob = 0})
    end
    for _,n in ipairs(nodes) do
        local pos = vector.add(n[1], vector.floor(vector.divide(size, 2)))
        local name = n[2]
        local prob = n[3] or 255
        local area = VoxelArea:new({MinEdge=vector.new(0, 0, 0), MaxEdge=vector.subtract(size, 1)})
        ret.data[area:indexp(pos)] = {name = name, prob = prob}
    end
    return ret
end

minetest.register_decoration({
	deco_type = "schematic",
	place_on = {"group:soil"},
	sidelen = 80,
	fill_ratio = 0.05,
	biomes = {"aurum_forest"},
	y_min = 0,
	schematic = nc(vector.new(3, 5, 3), {
		{vector.new(0, 1, 0), "aurum_trees:oak_leaves"},
		{vector.new(1, 1, 0), "aurum_trees:oak_leaves"},
		{vector.new(1, 1, 1), "aurum_trees:oak_leaves"},
		{vector.new(-1, 1, 0), "aurum_trees:oak_leaves"},
		{vector.new(-1, 1, 1), "aurum_trees:oak_leaves"},
		{vector.new(0, 1, 1), "aurum_trees:oak_leaves"},
		{vector.new(-1, 1, -1), "aurum_trees:oak_leaves"},
		{vector.new(0, 1, -1), "aurum_trees:oak_leaves"},
		{vector.new(1, 1, -1), "aurum_trees:oak_leaves"},

		{vector.new(0, 2, 0), "aurum_trees:oak_leaves"},
		{vector.new(1, 2, 0), "aurum_trees:oak_leaves"},
		{vector.new(1, 2, 1), "aurum_trees:oak_leaves"},
		{vector.new(-1, 2, 0), "aurum_trees:oak_leaves"},
		{vector.new(-1, 2, 1), "aurum_trees:oak_leaves"},
		{vector.new(0, 2, 1), "aurum_trees:oak_leaves"},
		{vector.new(-1, 2, -1), "aurum_trees:oak_leaves"},
		{vector.new(0, 2, -1), "aurum_trees:oak_leaves"},
		{vector.new(1, 2, -1), "aurum_trees:oak_leaves"},

		{vector.new(0, -1, 0), "aurum_trees:oak_trunk"},
		{vector.new(0, 0, 0), "aurum_trees:oak_trunk"},
		{vector.new(0, 1, 0), "aurum_trees:oak_trunk"},
	}),
	rotation = "random",
	flags = {place_center_x = true, place_center_y = false, place_center_z = true},
})
