local S = minetest.get_translator()

local function make(pos, random)
	gtextitems.set_node(pos, {
		title = S("You @1!", aurum.flavor.generate_mocking(random(2), random)),
		text = S("You are a @1, and a @2. Understand, @3?", aurum.flavor.generate_mocking(random(8), random), aurum.flavor.generate_mocking(random(8), random), aurum.flavor.generate_mocking(random(8), random)),
		author = "a fiend",
		author_type = "npc",
		id = "aurum_structures:fiendish_mocking",
	})
end

minetest.register_decoration{
	name = "aurum_structures:fiendish_mocking",
	deco_type = "simple",
	decoration = "aurum_books:stone_tablet_written",
	rotation = "random",
	place_on = {"aurum_base:regret"},
	biomes = aurum.biomes.get_all_group("aurum:loom", {"base"}),
	sidelen = 16,
	fill_ratio = 0.0001,
}

local did = minetest.get_decoration_id("aurum_structures:fiendish_mocking")

minetest.set_gen_notify("decoration", {did})
minetest.register_on_generated(function(_, _, seed)
	local g = minetest.get_mapgen_object("gennotify")
	local d = g["decoration#" .. did]
	if d then
		local random = b.seed_random(seed + 0xF1E4D154)
		for _,pos in ipairs(d) do
			pos.y = pos.y + 1
			if minetest.get_node(pos).name == "aurum_books:stone_tablet_written" then
				make(pos, random)
			end
		end
	end
end)
