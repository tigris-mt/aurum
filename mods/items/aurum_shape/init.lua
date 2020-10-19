local S = minetest.get_translator("aurum_shape")

aurum_shape = {
	shaped = {},
}

-- Enable shaping for a node.
function aurum_shape.enable(name)
	aurum_shape.shaped[name] = {}

	local shape = {
		cost = 1,
		node_name = name,
	}

	minetest.override_item(name, {
		_aurum_shape_shape = shape,
	})
	aurum_shape.shaped[name][""] = shape
end

-- Register a specific shape for a node.
function aurum_shape.register_shape(name, shape)
	shape = b.t.combine({
		-- Suffix name.
		name = nil,
		-- Description of shape.
		description = "?",
		-- Fixed node box.
		fixed = nil,
		-- Number of shapes per full node.
		cost = 1,

		-- Crafting recipe.
		recipe = nil,

		-- Additional def.
		def = {},
	}, shape)

	shape.parent_name = name
	shape.node_name = shape.node_name or (name .. "_sh_" .. shape.name)

	local def = b.t.combine(assert(minetest.registered_nodes[name], "trying to register shape for unknown node: " .. name), {
		paramtype2 = "facedir",
		on_place = minetest.rotate_node,
		drawtype = "nodebox",
		node_box = {
			type = "fixed",
			fixed = shape.fixed,
		},
		paramtype = "light",
		_doc_items_create_entry = false,
		_aurum_shape_shape = shape,
	}, shape.def)

	def.description = S("@1 @2", def.description or "?", shape.description)

	def.groups = b.t.combine(def.groups, {
		shapable = 0,
	})

	minetest.register_node(":" .. shape.node_name, def)
	doc.add_entry_alias("nodes", name, "nodes", shape.node_name)
	aurum_shape.shaped[name][shape.name] = shape

	if shape.recipe then
		minetest.register_craft{
			output = shape.node_name .. " " .. shape.recipe.count,
			recipe = shape.recipe.recipe,
		}
	end
end

-- Enable shaping and register all shapes for a node.
function aurum_shape.register(name)
	aurum_shape.enable(name)

	aurum_shape.register_shape(name, {
		name = "stairs",
		description = S"Stairs",
		cost = 3 / 4,
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, 0, 0.5},
			{-0.5, 0, 0, 0.5, 0.5, 0.5},
		},
		recipe = {
			count = 8,
			recipe = {
				{name, "", "aurum_shape:chisel"},
				{name, name, ""},
				{name, name, name},
			},
		},
	})

	aurum_shape.register_shape(name, {
		name = "slab",
		description = S"Slab",
		cost = 1 / 2,
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, 0, 0.5},
		},
		recipe = {
			count = 6,
			recipe = {
				{name, name, name},
				{"", "aurum_shape:chisel", ""},
			},
		},
	})
end

-- Automatically register all shapable.
local old = minetest.register_node
function minetest.register_node(name, def)
	local ret = old(name, def)
	if minetest.get_item_group(def.name, "shapable") > 0 then
		aurum_shape.register(def.name)
	end
end

minetest.register_craftitem("aurum_shape:chisel", {
	description = S"Shaping Chisel",
	inventory_image = "aurum_shape_chisel.png",
})

minetest.register_craft{
	output = "aurum_shape:chisel 4",
	recipe = {
		{"aurum_base:sticky_stick"},
		{"aurum_ore:tin_ingot"},
	},
}
