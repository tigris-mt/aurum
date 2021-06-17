local S = aurum.get_translator()

local function register_tree_cart(tree)
	local tree_def = aurum.trees.types[tree]
	local planks_def = minetest.registered_nodes[tree_def.planks]
	if planks_def then
		local cart_name = ("aurum_carts:cart_%s"):format(tree:gsub(":", "_"))

		aurum.carts.register(cart_name, {
			description = S(("%s Rail Cart"):format(tree_def.description)),
			texture = planks_def.tiles[1],
		})

		minetest.register_craft{
			output = cart_name,
			recipe = {
				{tree_def.planks, "", tree_def.planks},
				{tree_def.planks, tree_def.planks, tree_def.planks},
				{"aurum_ore:iron_ingot", "", "aurum_ore:iron_ingot"},
			},
		}

		minetest.register_craft{
			type = "fuel",
			recipe = cart_name,
			burntime = 25,
		}
	end
end

-- Register all once and future trees.
for tree in pairs(aurum.trees.types) do
	register_tree_cart(tree)
end

local old = aurum.trees.register
function aurum.trees.register(name, ...)
	local ret = old(name, ...)
	register_tree_cart(name)
	return ret
end
