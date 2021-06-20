local defs = {}

minetest.register_node("aurum_features:placeholder", {
	description = "Dynamic Decoration Placeholder",
	tiles = {"aurum_base_stone.png"},
	drawtype = "airlike",
	groups = {dig_immediate = 3, not_in_creative_inventory = 1},
	_doc_items_create_entry = false,
	buildable_to = true,
	walkable = false,
	pointable = false,
	drop = "",
	on_timer = function(pos)
		local id = minetest.get_meta(pos):get_int("aurum_features:id")
		if defs[id] then
			defs[id].callback(pos, b.seed_random(minetest.hash_node_position(pos) + 0x7ACE401D))
		end
		if minetest.get_node(pos).name == "aurum_features:placeholder" then
			minetest.remove_node(pos)
		end
	end,
})

function aurum.features.register_dynamic_decoration(def)
	local id = b.new_uid()
	local decoration = b.t.combine(def.decoration, {
		name = "aurum_features:dynamic_decoration_" .. id,
		deco_type = "simple",
		decoration = "aurum_features:placeholder",
	})

	minetest.register_decoration(decoration)

	local deco_id = minetest.get_decoration_id(decoration.name)
	minetest.set_gen_notify({decoration = true}, {deco_id})

	defs[id] = {
		deco_id = deco_id,
		key = "decoration#" .. deco_id,
		callback = def.callback,
	}
end

minetest.register_on_generated(function(minp, maxp, seed)
	local gn = minetest.get_mapgen_object("gennotify")
	for id,def in pairs(defs) do
		if gn[def.key] then
			for _,pos in ipairs(gn[def.key]) do
				local above = vector.add(pos, vector.new(0, 1, 0))
				minetest.get_meta(above):set_int("aurum_features:id", id)
			end
		end
	end
end)

minetest.register_lbm{
	label = "Activate Placeholders",
	name = "aurum_features:dynamic_decoration",
	nodenames = {"aurum_features:placeholder"},
	run_at_every_load = true,
	action = function(pos, node)
		if not minetest.get_node_timer(pos):is_started() then
			minetest.get_node_timer(pos):start(0)
		end
	end,
}
