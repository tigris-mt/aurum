local S = aurum.get_translator()

local function make(pos, random)
	local name = aurum.flavor.generate_name(random)
	gtextitems.set_node(pos, {
		title = S("The Words of @1", name),
		text = S("@1 has said, \"@2 @3 @4. @5\"", name,
			b.t.weighted_choice({
				{S"Read:", 5},
				{S"Hear:", 5},
				{S"It is said,", 1},
				{S"Though commonly misunderstood,", 1},
				{S"Commonly understood, yet deceptively complex,", 1},
				{S"Simply,", 1},
				{S"Whereas,", 1},
				{S"And,", 1},
				{S"But,", 1},
				{S"So,", 1},
				{S"Listen,", 1},
				{S"Shall we then say,", 1},
				{S"The truth is this,", 1},
				{S"I must tell you,", 1},
				{S"Have you not heard,", 1},
			}, random),
			b.t.choice({
				S"the mass",
				S"this place",
				S"the holy ground",
				S"decay",
				S"morality",
				S"a universal norm",
				S"philosophy",
				S"the human race",
				S"physicality",
				S"He",
				S"She",
				S"It",
				S"the end",
				S"an apocalypse",
				S"a terrible fate",
				S"the titan",
				S"the great titan",
				S"a fallen titan",
				S"the elder archon",
				S"a man of the five tall men",
				S"the word",
				S"the truth",
				S"the lie",
			}, random),
			b.t.choice({
				S"is false",
				S"is true",
				S"is even now standing here",
				S"may yet be understood",
				S"is able to be grasped",
				S"waits for us",
				S"anticipates you",
				S"is my one goal",
				S"can never be truly understood",
				S"is the root of much evil",
				S"is the root of much good",
				S"can be studied",
				S"generates falsehoods",
				S"speaks to all of us",
				S"must be contemplated",
			}, random),
			b.t.choice({
				S"Know this.",
				S"Keep it within your heart.",
				S"Do you see now why I told you all about it?",
				S"This makes me happy.",
				S"Very sad.",
				S"I heard about it from five tall men.",
				S"Perhaps you should write it on your headstone.",
				S"That is my motto.",
			}, random)
		),
		author = aurum.flavor.generate_name(random),
		author_type = "npc",
		id = "aurum_structures:hidden_record",
	})
end

minetest.register_decoration{
	name = "aurum_structures:hidden_record",
	deco_type = "simple",
	decoration = "aurum_books:stone_obelisk_written",
	rotation = "random",
	place_on = {"group:soil"},
	biomes = aurum.biomes.get_all_group("aurum:primus", {"base"}),
	sidelen = 16,
	fill_ratio = 0.001,
}

local did = minetest.get_decoration_id("aurum_structures:hidden_record")

minetest.set_gen_notify("decoration", {did})
minetest.register_on_generated(function(_, _, seed)
	local g = minetest.get_mapgen_object("gennotify")
	local d = g["decoration#" .. did]
	if d then
		local random = b.seed_random(seed + 0x0B3115C)
		for _,pos in ipairs(d) do
			pos.y = pos.y + 1
			if minetest.get_node(pos).name == "aurum_books:stone_obelisk_written" then
				make(pos, random)
			end
		end
	end
end)

