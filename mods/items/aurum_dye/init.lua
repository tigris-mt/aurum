local S = aurum.get_translator()
aurum.dye = {}

-- Register <name> as a colorable node with <base> being the item's group for redying or nil if no redying is allowed.
-- If a function, then f(name, color, colored_name) will be called for each color.
function aurum.dye.register_node(name, def, base, f)
	for _,row in ipairs(dye.dyes) do
		local dye = {name = row[1], desc = row[2], colorspec = b.color.convert(row[1])}
		local colored_name = name .. "_" .. dye.name

		local cdef = b.t.combine(def, {
			description = S("@1 @2", dye.desc, def.description or "?"),
			color = b.color.tostring(dye.colorspec),
			_aurum_dye_base = name,
		})

		if b.set({"glasslike", "glasslike_framed", "glasslike_framed_optional"})[def.drawtype] then
			local i = def.tiles[1] .. "^[colorize:" .. cdef.color
			cdef.inventory_image = minetest.inventorycube(i, i, i)
		end

		cdef.groups = b.t.combine(cdef.groups, {
			not_in_craft_guide = (dye.name == "white") and 0 or 1,
			dye_colorable = base and 1 or 0,
		})

		if dye.name ~= "white" then
			cdef._doc_items_create_entry = false
			doc.add_entry_alias("nodes", name .. "_white", "nodes", colored_name)
		end

		minetest.register_node(colored_name, cdef)

		-- Redye recipe.
		if base then
			minetest.register_craft{
				output = colored_name,
				type = "shapeless",
				recipe = {base, "group:dye,color_" .. dye.name},
			}
		end

		if f then
			f(name, dye.name, colored_name)
		end
	end
end

doc.sub.items.register_factoid("nodes", "use", function(itemstring, def)
	if minetest.get_item_group(itemstring, "dye_colorable") > 0 then
		return S"This node can be dyed in the crafting inventory."
	end
	return ""
end)
