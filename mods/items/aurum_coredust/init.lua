local S = minetest.get_translator()

local bronze_list = {}
local recipe = {}
for x=-1,1 do
	for y=0,1 do
		local bronze = {vector.new(x, y, -1), "aurum_ore:bronze_block"}
		table.insert(bronze_list, bronze)
		table.insert(recipe, bronze)
	end
	for z=-1,1 do
		table.insert(recipe, {vector.new(x, -1, z), "aurum_base:foundation"})
	end
end

aurum.magic.register_ritual("create_coredust", {
	description = S"Create Coredust",
	longdesc = S"A brief invocation that binds infinitely small pieces of the world's foundation to bronze.",

	size = aurum.box.new(vector.new(-1, -1, -1), vector.new(1, 1, 1)),
	protected = true,

	recipe = recipe,

	apply = function(at)
		for _,d in ipairs(bronze_list) do
			minetest.set_node(at(d[1]), {name = "aurum_coredust:dusty_bronze"})
		end

		return true
	end,
})

minetest.register_node("aurum_coredust:dusty_bronze", {
	description = S"Coredusty Bronze",
	_doc_items_longdesc = S"Bronze is a natural candidate to be infused with coredust. Once merged, the dusty block of metal gives off an aura of solidity.",
	tiles = {minetest.registered_items["aurum_ore:bronze_block"].tiles[1] .. "^aurum_coredust_overlay.png"},

	groups = {dig_pick = 1, level = 3},
	sounds = aurum.sounds.metal(),
})
