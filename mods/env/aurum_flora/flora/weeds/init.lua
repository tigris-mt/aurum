-- Register <max> grass nodes from <base_name> to <base_name>_<max>.
-- <def> is passed to aurum.flora.register() with suitable defaults.
-- ... is passed to minetest.register_decoration() with suitable defaults.
function aurum.flora.register_grass(base_name, max, def, ...)
	for i=1,max do
		local name = (i == 1) and base_name or (base_name .. "_" .. i)
		local next_name = (i ~= max) and (base_name .. "_" .. (i + 1))
		aurum.flora.register(":" .. name, b.t.combine({
			drop = base_name,
			groups = {not_in_creative_inventory = (i == 1) and 0 or 1},
			_doc_items_create_entry = (i == 1),
			_on_flora_spread = function(pos, node)
				if next_name then
					node.name = next_name
					minetest.set_node(pos, node)
					return false
				else
					return true, base_name
				end
			end,
		}, def, {
			tiles = {def._texture .. "_" .. i .. ".png" .. (def._texture_append and ("^" .. def._texture_append) or "")},
		}))

		if i ~= 1 then
			doc.add_entry_alias("nodes", base_name, "nodes", name)
		end

		for _,decodef in ipairs{...} do
			minetest.register_decoration(b.t.combine({
				name = name,
				decoration = name,
				deco_type = "simple",
				sidelen = 16,
			}, decodef))
		end
	end
end
