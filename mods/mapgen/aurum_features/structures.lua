aurum.features.decorations = {}
local idx = 0

function aurum.features.register_decoration(decodef, def)
	local def = table.combine({
		on_generated = function(pos) end,
		decodef = decodef,
	}, def)

	-- If no name is provided, add one so we can use get_decoration_id.
	idx = idx + 1
	decodef.name = decodef.name or ("aurum_features:deco_" .. idx)

	minetest.register_decoration(decodef)

	local id = minetest.get_decoration_id(decodef.name)
	minetest.set_gen_notify("decoration", {id})

	aurum.features.decorations[id] = def
	return id
end

minetest.register_on_mods_loaded(function()
	minetest.register_on_generated(function(minp, maxp, seed)
		local g = minetest.get_mapgen_object("gennotify")
		if not g then
			return
		end

		for id,def in pairs(aurum.features.decorations) do
			for _,pos in ipairs(g["decoration#" .. id] or {}) do
				def.on_generated(pos)
			end
		end
	end)
end)
