-- Water
for _,d in ipairs{
	{30, b.WORLD.max.y, 200},
	{25, 200, 50},
	{21, 50, 15},
	{18, 15, -50},
	{25, -50, -200},
	{30, -200, b.WORLD.min.y},
} do
	minetest.register_ore({
		ore_type = "scatter",
		ore = "aurum_base:water_source",
		-- All biomes except frozen.
		biomes = b.set.to_array(b.set.subtract(
			b.set(aurum.biomes.find(function() return true end)),
			b.set(aurum.biomes.get_all_group("frozen", {"base"}))
		)),
		wherein = {"aurum_base:stone", "aurum_base:gravel", "group:clay"},
		clust_scarcity = d[1] ^ 3,
		clust_num_ores = 1,
		clust_size = 1,
		y_max = d[2],
		y_min = d[3],
	})
end

-- Lava
for _,d in ipairs{
	{50, b.WORLD.max.y, 200},
	{45, 200, 50},
	{40, 50, 25},
	{35, 25, 10},
	{30, 10, -25},
	{27, -25, -200},
	{25, -200, b.WORLD.min.y},
} do
	minetest.register_ore({
		ore_type = "scatter",
		ore = "aurum_base:lava_source",
		-- All biomes except forest and frozen.
		biomes = b.set.to_array(b.set.subtract(
			b.set(aurum.biomes.find(function() return true end)),
			b.set(aurum.biomes.get_all_group("forest", {"base"})),
			b.set(aurum.biomes.get_all_group("frozen", {"base"}))
		)),
		wherein = {"aurum_base:stone", "aurum_base:gravel", "group:sand", "group:clay"},
		clust_scarcity = d[1] ^ 3,
		clust_num_ores = 1,
		clust_size = 1,
		y_max = d[2],
		y_min = d[3],
	})
end

-- Loom lava
for _,d in ipairs{
	{20, b.WORLD.max.y, 200},
	{19, 200, 50},
	{18, 50, 25},
	{17, 25, 10},
	{16, 10, -25},
	{15, -25, -200},
	{14, -200, b.WORLD.min.y},
} do
	minetest.register_ore({
		ore_type = "scatter",
		ore = "aurum_base:lava_source",
		biomes = aurum.biomes.get_all_group("aurum:loom"),
		wherein = {"aurum_base:regret"},
		clust_scarcity = d[1] ^ 3,
		clust_num_ores = 1,
		clust_size = 1,
		y_max = d[2],
		y_min = d[3],
	})
end
