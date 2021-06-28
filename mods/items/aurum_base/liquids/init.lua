minetest.register_craft{
	output = "bucket:bucket_empty",
	recipe = {
		{"aurum_ore:tin_ingot", "", "aurum_ore:tin_ingot"},
		{"", "aurum_ore:tin_ingot", ""},
	}
}

function aurum.base.register_liquid(name, def, flowing_def)
	local defaults = {
		drawtype = "liquid",
		paramtype = "light",
		liquidtype = "source",
		liquid_viscosity = 1,
		groups = {liquid = 1},
		buildable_to = true,
		walkable = false,
		pointable = false,
		diggable = false,
		sounds = aurum.sounds.water(),
		drowning = 2,
		drop = "",
		liquid_alternative_source = name .. "_source",
		liquid_alternative_flowing = name .. "_flowing",
		liquid_renewable = false,
		liquid_range = 8,
		waving = 3,
	}
	local flowing_defaults = {
		drawtype = "flowingliquid",
		paramtype2 = "flowingliquid",
		liquidtype = "flowing",
		tiles = def.tiles,
		groups = {not_in_creative_inventory = 1},
		_doc_items_create_entry = false,
	}
	minetest.register_node(":" .. name .. "_source", b.t.combine(defaults, def, {groups = b.t.combine(defaults.groups or {}, def.groups or {})}))
	minetest.register_node(":" .. name .. "_flowing", b.t.combine(defaults, def, flowing_defaults, flowing_def, {groups = b.t.combine(defaults.groups or {}, def.groups or {}, flowing_defaults.groups or {}, flowing_def.groups or {})}))
	doc.add_entry_alias("nodes", name .. "_source", "nodes", name .. "_flowing")
end
