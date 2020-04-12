local M = {}
aurum.structures.temples = M

local PH_SCROLL = 1
local PH_ZECKWEAVER = 2

local function f(path)
	return minetest.get_modpath(minetest.get_current_modname()) .. "/schematics/" .. path
end

local defs = {
	{
		schematic = f"temple_1.mts",
		offset = -3,
	},
}

for _,def in ipairs(defs) do
	def = b.t.combine({
		schematic = nil,
		offset = 0,
	}, def)

	aurum.features.register_decoration{
		place_on = {"group:soil"},
		rarity = 1 / (18 ^ 3) / #defs,
		biomes = aurum.biomes.get_all_group("aurum:primus", {"base"}),
		schematic = def.schematic,

		on_offset = function(c)
			return vector.add(c.pos, vector.new(0, def.offset, 0))
		end,

		on_generated = function(c)
			for _,pos in ipairs(c:ph(PH_SCROLL)) do
				minetest.set_node(pos, {name = "aurum_storage:scroll_hole"})
				c:treasures(pos, "main", c:random(-3, 2), {
					{
						count = 1,
						preciousness = {1, 10},
						groups = {"scroll"},
					},
				})
			end

			for _,pos in ipairs(c:ph(PH_ZECKWEAVER)) do
				minetest.set_node(pos, {name = "aurum_zeckweaver:zeckweaver"})
			end
		end,
	}
end
