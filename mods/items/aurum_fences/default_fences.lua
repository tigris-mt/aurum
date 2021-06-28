local S = aurum.get_translator()

aurum.trees.once_and_future(function(tree)
	local tree_def = aurum.trees.types[tree]
	local planks_def = minetest.registered_nodes[tree_def.planks]
	if planks_def then
		local fence_name = ("aurum_fences:fence_%s"):format(tree:gsub(":", "_"))

		aurum.fences.register(fence_name, {
			description = S(("%s Fence"):format(tree_def.description)),
			texture = planks_def.tiles[1],

			node_def = {
				groups = {dig_chop = 3, flammable = 1, dig_handle = 1},
				sounds = planks_def.sounds,
			},
		})

		minetest.register_craft{
			output = fence_name .. " 4",
			recipe = {
				{tree_def.planks, "group:stick", tree_def.planks},
				{tree_def.planks, "group:stick", tree_def.planks},
			},
		}

		minetest.register_craft{
			type = "fuel",
			recipe = fence_name,
			burntime = 7,
		}
	end
end)
