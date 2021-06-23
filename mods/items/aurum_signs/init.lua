local S = aurum.get_translator()

b.t.merge(signs_lib.standard_wood_groups, {dig_chop = 3, dig_handle = 2, flammable = 1})

signs_lib.standard_wood_pole_texture = minetest.registered_items["aurum_trees:oak_planks"].tiles[1]

signs_lib.glow_item = "aurum_glee:glee_shard"

local function register_tree_sign(tree)
	local tree_def = aurum.trees.types[tree]
	local planks_def = minetest.registered_nodes[tree_def.planks]
	if planks_def then
		local sign_name = ("aurum_signs:wood_sign_%s"):format(tree:gsub(":", "_"))
		signs_lib.register_sign(sign_name, {
			description = S(("%s Sign"):format(tree_def.description)),
			inventory_image = planks_def.tiles[1] .. "^aurum_signs_sign_wall_inv.png^[makealpha:255,0,255",
			tiles = {
				planks_def.tiles[1] .. "^aurum_signs_sign_wall.png^[makealpha:255,0,255",
				planks_def.tiles[1] .. "^aurum_signs_sign_wall_edges.png^[makealpha:255,0,255",
				nil, nil,
				planks_def.tiles[1],
			},
			entity_info = "standard",
			allow_hanging = true,
			allow_widefont = true,
			allow_onpole = true,
			allow_onpole_horizontal = true,
			allow_yard = true,
			use_texture_alpha = "clip",
		})

		minetest.register_craft{
			output = sign_name .. " 4",
			recipe = {
				{tree_def.planks, tree_def.planks, tree_def.planks},
				{tree_def.planks, tree_def.planks, tree_def.planks},
				{"", "aurum_base:sticky_stick", ""},
			},
		}

		minetest.register_craft{
			type = "fuel",
			recipe = sign_name,
			burntime = 5,
		}
	end
end

-- Register all once and future trees.
for tree in pairs(aurum.trees.types) do
	register_tree_sign(tree)
end

local old = aurum.trees.register
function aurum.trees.register(name, ...)
	local ret = old(name, ...)
	register_tree_sign(name)
	return ret
end
