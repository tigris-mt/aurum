local m = aurum.trees

-- Schematic parameter delimiter.
local SCHEMATIC_DELIM = ","

m.generators = {}

-- Map names to more generic schematics.
m.translation = {
	simple = "tree,5,2",
	wide = "tree,6,4,0.3,0.25",
	tall = "tree,8,2",
	very_tall = "tree,14,5",
	huge = "tree,14,7",
	giant = "tree,26,12",
	double = "tree,7,5",
}

local function remove_force_place(schematic)
	local ret = table.copy(schematic)
	for _,v in ipairs(ret.data) do
		v.force_place = nil
	end
	return ret
end

function m.translate_specifier(n)
	return m.translation[n] or n
end

function m.split_specifier(n)
	-- Split up decoration name by delimiter.
	local split = m.translate_specifier(n):split(SCHEMATIC_DELIM, true)
	local name = split[1]
	local params = {}
	for i=2,#split do
		table.insert(params, split[i])
	end
	return name, params
end

local modpath = minetest.get_modpath(minetest.get_current_modname())

-- Returns a decoration for tree according to specifier n.
m.generate_schematic_decoration = b.cache.simple(function(tree, n)
	local t_begin = minetest.get_us_time()

	local name, params = m.split_specifier(n)

	-- Execute decoration schematic generator according to def and params.
	local schematic, offset = m.generators[name].func(m.types[tree], unpack(params))
	offset = offset or 0

	-- Warn if elapsed time was lengthy.
	local t_sec = (minetest.get_us_time() - t_begin) / 1000000
	if t_sec > 0.1 then
		minetest.log("warning", ("Generating tree decoration %s (%s) took %.4f seconds."):format(tree, n, t_sec))
	end

	return {
		schematic = schematic,
		rotation = "random",
		flags = {place_center_x = true, place_center_y = false, place_center_z = true},
		place_offset_y = offset,
	}
end, function(tree, n) return tree .. " " .. m.translate_specifier(n) end)

function m.register_generator(name, def)
	m.generators[name] = def
end

function m.spawn_tree(pos, tree, schematic, options)
	options = b.t.combine({
		replace = false,
		random = math.random,
	}, options or {})

	local name, params = m.split_specifier(schematic)

	local gdef = m.generators[name]
	assert(gdef, "generator " .. tostring(name) .. " was not found")

	if gdef.type == "schematic_generator" then
		local deco = m.generate_schematic_decoration(tree, schematic)
		minetest.place_schematic(pos, options.replace and deco.schematic or remove_force_place(deco.schematic), deco.rotation, {}, false, deco.flags)
	else
		error("unsupported generator type: " .. gdef.type)
	end
end

function m.register_decoration(tree, schematic, decodef, advanced_generation)
	local name, params = m.split_specifier(schematic)

	local gdef = m.generators[name]
	assert(gdef, "generator " .. tostring(name) .. " was not found")

	if gdef.type == "schematic_generator" then
		local deco = m.generate_schematic_decoration(tree, schematic)
		if advanced_generation then
			aurum.features.register_decoration(b.t.combine({
				schematic = deco.schematic,
				offset = vector.new(0, deco.place_offset_y, 0),
			}, decodef))
		else
			minetest.register_decoration(b.t.combine({deco_type = "schematic"}, deco, decodef))
		end
	else
		aurum.features.register_dynamic_decoration{
			decoration = decodef,
			callback = function(pos, random)
				m.spawn_tree(pos, tree, schematic, {
					random = random,
					replace = true,
				})
			end,
		}
	end
end
