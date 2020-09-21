local MAX_SEARCH_HEIGHT = 100

aurum.features.register_decoration{
	place_on = {
		"aurum_base:stone",
		"aurum_base:regret",
	},
	biomes = aurum.biomes.get_all_group("all", {"under"}),

	noise_params = {
		offset = -0.05,
		scale = 0.1,
		spread = vector.new(200, 200, 200),
		seed = 0xCA4E14EE,
		octaves = 3,
		persist = 0.5,
	},

	on_offset = function(c)
		c.s.biome = b.t.combine({heat = 50, humidity = 50}, minetest.get_biome_data(c.pos) or {})
		for i=1,MAX_SEARCH_HEIGHT do
			local pos = vector.add(c.pos, vector.new(0, i, 0))
			local nn = aurum.force_get_node(pos).name
			if nn ~= "air" then
				if nn == "ignore" then
					return nil
				else
					c.s.height = c.random(i - 1)
					pos.y = pos.y - c.s.height
					return pos
				end
			end
		end
	end,

	make_schematic = function(c)
		local node
		if c.s.biome.heat < 25 then
			node = "aurum_trees:white_crystal_trunk"
		elseif c.s.biome.heat < 50 then
			node = "aurum_trees:blue_crystal_trunk"
		elseif c.s.biome.heat < 75 then
			node = "aurum_trees:yellow_crystal_trunk"
		else
			node = "aurum_trees:red_crystal_trunk"
		end
		local size = vector.new(1, c.s.height, 1)
		local data = {}
		for i=1,size.y do
			table.insert(data, {{node}})
		end
		return aurum.features.schematic(size, data)
	end,
}
