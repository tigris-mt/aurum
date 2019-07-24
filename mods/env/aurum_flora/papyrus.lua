local S = minetest.get_translator()
local HEIGHT = 4

local function grow(pos, node)
	local base = pos
	local below
	local bnode
	while true do
		below = vector.add(pos, vector.new(0, -1, 0))
		bnode = minetest.get_node(below)

		if bnode.name == "aurum_flora:papyrus" then
			base = below
		else
			break
		end
	end

	if minetest.get_item_group(bnode.name, "soil") < 1 and minetest.get_item_group(bnode.name, "sand") < 1 then
		return false
	end

	if #minetest.find_nodes_in_area(vector.subtract(base, 1), vector.add(base, 1), "group:water") == 0 then
		return false
	end

	local n = 1
	for n=0,HEIGHT-1 do
		local at = vector.add(base, vector.new(0, n, 0))
		local atnode = minetest.get_node(at)
		if atnode.name == "air" then
			minetest.set_node(at, {name = "aurum_flora:papyrus"})
			return true
		elseif atnode.name ~= "aurum_flora:papyrus" then
			break
		end
	end

	return false
end

aurum.flora.register("aurum_flora:papyrus", {
	description = S"Papyrus",
	_doc_items_longdesc = S"A useful reed that grows on soil and sand by water.",
	tiles = {"aurum_flora_papyrus.png"},
	groups = {flora = 0, attached_node = 0},
	_on_grow_plant = grow,
	waving = 0,
	buildable_to = false,
	selection_box = {
		type = "fixed",
		fixed = {
			-0.35, -0.5, -0.35,
			0.35, 0.5, 0.35,
		},
	},

	-- Recursively dig up.
	after_dig_node = function(pos, node, _, digger)
		local above = vector.add(pos, vector.new(0, 1, 0))
		local anode = minetest.get_node(above)
		if anode.name == node.name then
			minetest.dig_node(above, anode, digger)
		end
	end,
})

minetest.register_decoration{
	name = "aurum_flora:papyrus",
	decoration = "aurum_flora:papyrus",
	deco_type = "simple",
	place_on = {"group:soil", "group:sand"},
	sidelen = 16,
	height_max = HEIGHT,
	noise_params = {
		offset = 0,
		scale = 0.5,
		spread = vector.new(200, 200, 200),
		seed = 11,
		octaves = 3,
		persist = 0.5,
	},
	y_max = 2,
	y_min = 0,
	biomes = aurum.set.to_array(aurum.set.intersection(
		aurum.set(aurum.biomes.get_all_group("desert", {"base"})),
		aurum.set(aurum.biomes.get_all_group("aurum:aurum", {"base"}))
	)),
}

minetest.register_abm{
	label = "Papyrus Growth",
	nodenames = {"aurum_flora:papyrus"},
	neighbors = {"group:water"},
	interval = 10,
	chance = 10,
	action = grow,
}
