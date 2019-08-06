local S = minetest.get_translator()

local function make_headstone(pos)
	local name = aurum.flavor.generate_name()
	local age = math.random(16, 110)
	gtextitems.set_node(pos, {
		title = S("Grave of @1", name),
		text = S("They lived @1 years before @2 took them. I buried them @3. In life, they were @4. That is all I know.\n\nRequiescat in pace, @5.",
			age,
			aurum.weighted_choice{
				{(age > 70) and S"old age" or S"sudden disease", 5},
				{S"corruption from the Loom", 1},
				{S"wild animals", 1},
				{S"a murderer", 1},
				{S"monsters", 1},
				{S"an accident", 1},
				{S"disease", 1},
				{S"an injury", 1},
				{S"a demigod", 0.1},
				{S"Hyperion", 0.1},
				{S"inexplicable circumstances", 1},
				{S"a trap", 1},
				{S"paranoia", 0.25},
				{S"a magical mishap", 0.25},
			},
			aurum.weighted_choice{
				{S"quickly", 1},
				{S"after some time", 1},
				{S"respectfully", 1},
				{S"with scorn", 1},
				{S"carelessly", 1},
				{S"lovingly", 1},
				{S"hatefully", 1},
				{S"where they wanted to be", 1},
				{S"far from home", 1},
				{S"at the site of their death", 0.1},
				{S"sadly", 1},
				{S"joyfully", 1},
			},
			aurum.weighted_choice{
				{S"humble", 1},
				{S"filled with pride", 1},
				{S"kind", 1},
				{S"ruthless", 1},
				{S"a ruler", 1},
				{S"a servant", 1},
				{S"a slave", 0.1},
				{S"beautiful", 1},
				{S"ugly", 1},
				{S"knowledgable", 1},
				{S"ignorant", 1},
				{S"fun", 1},
				{S"bitter", 1},
				{S"caring", 1},
				{S"incompetent", 1},
				{S"reverent", 1},
				{S"profane", 1},
				{S"a wizard", 0.25},
				{S"a great wizard", 0.1},
				{S"a holy person, dedicated to me", 0.01},
				{S"someone I wish was still alive", 0.01},
			},
			name
		),
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
