local S = minetest.get_translator()

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
		tiles = {"aurum_caves_vine.png^" .. c.texture},
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
				minetest.dig_node(below, bnode, digger)
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
	groups = {dig_chop = 3, edible = 4},
	on_use = minetest.item_eat(4),
})
