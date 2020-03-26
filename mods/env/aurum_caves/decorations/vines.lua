local MAX_SEARCH_HEIGHT = 160

aurum.features.register_decoration{
	place_on = {
		"aurum_base:stone",
		"aurum_base:regret",
	},
	rarity = 0.01,
	biomes = aurum.biomes.get_all_group("all", {"under"}),

	on_offset = function(c)
		for i=1,MAX_SEARCH_HEIGHT do
			local pos = vector.add(c.pos, vector.new(0, i, 0))
			local nn = aurum.force_get_node(pos).name
			if nn ~= "air" then
				if nn == "ignore" then
					return nil
				else
					c.s.height = c.random(i)
					pos.y = pos.y - c.s.height
					return pos
				end
			end
		end
	end,

	make_schematic = function(c)
		local biome = b.t.combine({heat = 50, humidity = 50}, minetest.get_biome_data(c.pos) or {})
		local node
		if biome.heat < 25 then
			node = "aurum_caves:vine_white"
		elseif biome.heat < 50 then
			node = "aurum_caves:vine_blue"
		elseif biome.heat < 75 then
			node = "aurum_caves:vine_yellow"
		else
			node = "aurum_caves:vine_red"
		end
		local size = vector.new(1, c.s.height, 1)
		local data = {}
		for i=1,size.y do
			table.insert(data, {{node}})
		end
		if size.y > 1 and c.random() < 0.25 then
			data[size.y] = {{"aurum_caves:vine_fruit"}}
		end
		return aurum.features.schematic(size, data)
	end,
}
