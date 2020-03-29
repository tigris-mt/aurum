local I = minetest.request_insecure_environment()
if I then
	local dir = minetest.get_worldpath() .. "/aurum_amidst"
	assert(minetest.mkdir(dir), "could not create directory: " .. dir)
	local json = b.dofile("json.lua/json.lua")
	minetest.register_on_mods_loaded(function()
		minetest.log("action", "[aurum_amidst] dumping biome data for each realm")
		for realm,rdef in pairs(screalms.realms) do
			local fn = dir .. "/" .. realm .. ".mt"
			local out = {
				name = "SCRealms: " .. realm,
				biomeList = {},
			}
			for name,def in pairs(aurum.biomes.biomes) do
				if def._realm == realm then
					table.insert(out.biomeList, {
						name = name,
						color = {r = math.random(0, 255), g = math.random(0, 255), b = math.random(0, 255)},
						y_min = -1024,
						y_max = 1024,
						heat_point = def.heat_point,
						humidity_point = def.humidity_point,
					})
				end
			end
			local f = assert(I.io.open(fn, "w"), "could not open: " .. fn)
			f:write(json.encode(out))
			f:close()
		end
	end)
end
