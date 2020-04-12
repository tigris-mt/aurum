aurum.structures = {}

function aurum.structures.f(path)
	return minetest.get_modpath(minetest.get_current_modname()) .. "/schematics/" .. path
end

b.dodir("structures", true)
