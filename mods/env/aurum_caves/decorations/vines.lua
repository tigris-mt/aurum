local S = minetest.get_translator()
local MAX_SEARCH_HEIGHT = 160

for _,c in ipairs{
	{
		name = "red",
		desc = "Red",
		texture = "[colorize:#FF0000:127",
	},
	{
		name = "yellow",
		desc = "Yellow",
		texture = "[colorize:#FFFF00:127",
	},
	{
		name = "white",
		desc = "White",
		texture = "[colorize:#FFFFFF:127",
	},
	{
		name = "blue",
		desc = "Blue",
		texture = "[colorize:#0000FF:127",
	},
} do
	aurum.flora.register("aurum_caves:vine_" .. c.name, {
		description = S(c.desc .. " Cave Vine"),
		_doc_items_longdesc = S"A glowing plant that descends from cave ceilings.",
		tiles = {{
			image = "aurum_caves_vine.png^" .. c.texture,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 1,
			},
		}},
		groups = {flora = 0, attached_node = 0},
		waving = 0,
		buildable_to = false,
		selection_box = {
			type = "fixed",
			fixed = {
				-0.35, -0.5, -0.35,
				0.35, 0.5, 0.35,
			},
		},

		climbable = true,

		light_source = 9,

		-- Recursively dig down.
		after_dig_node = function(pos, node, _, digger)
			local below = vector.subtract(pos, vector.new(0, 1, 0))
			local bnode = minetest.get_node(below)
			if bnode.name == node.name or bnode.name == "aurum_caves:vine_fruit" then
				minetest.dig_node(below)
			end
		end,
	})
end

minetest.register_node("aurum_caves:vine_fruit", {
	description = S"Cave Vine Fruit",
	_doc_items_longdesc = S"The juicy fruit of the cave vine.",
	sounds = aurum.sounds.wood(),
	tiles = {"aurum_caves_vine_fruit.png"},
	paramtype = "light",
	light_source = 12,
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			-0.35, -0.5, -0.35,
			0.35, 0.5, 0.35,
		},
	},
	groups = {dig_chop = 3, edible = 12},
	on_use = minetest.item_eat(12),
})

aurum.features.register_decoration{
	place_on = {
		"aurum_base:stone",
		"aurum_base:regret",
	},
	biomes = aurum.biomes.get_all_group("all", {"under"}),

	noise_params = {
		offset = 0,
		scale = 0.1,
		spread = vector.new(200, 200, 200),
		seed = 8402,
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
			node = "aurum_caves:vine_white"
		elseif c.s.biome.heat < 50 then
			node = "aurum_caves:vine_blue"
		elseif c.s.biome.heat < 75 then
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
