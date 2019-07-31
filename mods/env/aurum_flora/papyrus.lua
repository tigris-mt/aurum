local S = minetest.get_translator()
-- How much is the fully mature papyrus?
local HEIGHT = 4

local function grow(pos, node)
	-- We start at pos, but must find the real base by searching down.
	local base = pos
	local below = pos
	local bnode
	while true do
		below = vector.add(below, vector.new(0, -1, 0))
		bnode = minetest.get_node(below)

		if bnode.name == "aurum_flora:papyrus" then
			base = below
		else
			break
		end
	end

	-- Only grow on soil or sand.
	if minetest.get_item_group(bnode.name, "soil") < 1 and minetest.get_item_group(bnode.name, "sand") < 1 then
		return false
	end

	-- And directly by water.
	if #minetest.find_nodes_in_area(vector.subtract(base, 1), vector.add(base, 1), "group:water") == 0 then
		return false
	end

	-- Try to find a place and grow.
	for n=0,HEIGHT-1 do
		local at = vector.add(base, vector.new(0, n, 0))
		local atnode = minetest.get_node(at)
		-- Air found, place new growth.
		if atnode.name == "air" then
			minetest.set_node(at, {name = "aurum_flora:papyrus"})
			return true
		-- Something else is in the way, don't go further.
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
	-- Add to all aurum:aurum deserts.
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
	chance = 10 * HEIGHT / 2,
	action = grow,
}
