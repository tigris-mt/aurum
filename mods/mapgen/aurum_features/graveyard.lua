local function make_headstone(pos)
	gtextitems.set_node(pos, {
		title = "Unknown's Grave",
		text = "They died.",
		author = "the Headstoner",
	})
end

minetest.register_decoration{
	name = "aurum_features:graveyard",
	deco_type = "schematic",
	schematic = aurum.trees.schematic(vector.new(1, 4, 1), {
		{{"aurum_books:stone_tablet_written"}},
		{{"aurum_base:dirt"}},
		{{"aurum_farming:fertilizer"}},
		{{"aurum_farming:fertilizer"}},
	}),
	rotation = "random",
	flags = {force_placement = true},
	place_offset_y = -2,
	place_on = {"group:soil", "aurum_base:gravel", "aurum_base:sand", "aurum_base:snow"},
	sidelen = 16,
	noise_params = {
		offset = -0.099,
		scale = 0.1,
		spread = vector.new(150, 150, 150),
		seed = 537,
		octaves = 3,
		persist = 0.5,
	},
	biomes = aurum.biomes.get_all_group("aurum:aurum", {"base"}),
}

local did = minetest.get_decoration_id("aurum_features:graveyard")

minetest.set_gen_notify("decoration", {did})
minetest.register_on_generated(function()
	local g = minetest.get_mapgen_object("gennotify")
	local d = g["decoration#" .. did]
	if d then
		for _,pos in ipairs(d) do
			pos.y = pos.y + 1
			if minetest.get_node(pos).name == "aurum_books:stone_tablet_written" then
				make_headstone(pos)
			end
		end
	end
end)
