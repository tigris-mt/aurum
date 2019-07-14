local S = minetest.get_translator()
aurum.cook = {}

-- Register a cooker.
function aurum.cook.register(name, def)
	local def = table.combine({
		-- Range of cooking.
		range = {0, 10},

		-- General node def.
		node = {},

		-- Active node def.
		active = {},
	}, def)

	local function allow_metadata_inventory_put(pos, listname, _, stack, player)
		if minetest.is_protected(pos, player:get_player_name()) then
			minetest.record_protection_violation(pos, player:get_player_name())
			return 0
		end

		local inv = minetest.get_meta(pos):get_inventory()

		if
	end

	local function allow_metadata_inventory_move(pos, from_list, from_index, to_list, to_index, count, player)
		local inv = minetest.get_meta(pos):get_inventory()
		return allow_metadata_inventory_put(pos, to_list, to_index, inv:get_stack(from_list, from_index), player)
	end

	local function allow_metadata_inventory_take(pos, _, _, stack, player)
		if minetest.is_protected(pos, player:get_player_name()) then
			minetest.record_protection_violation(pos, player:get_player_name())
			return 0
		end
	end

	def.node = table.combine({
		allow_metadata_inventory_put = allow_metadata_inventory_put,
		allow_metadata_inventory_move = allow_metadata_inventory_move,
		allow_metadata_inventory_take = allow_metadata_inventory_take,

		on_construct = function(pos)
			local meta = minetest.get_meta(pos)
			local inv = meta:get_inventory()
			inv:set_size("src", 1)
			inv:set_size("dst", 4)
			inv:set_size("fuel", 1)
		end,

		on_metadata_inventory_move = function(pos)
			minetest.get_node_timer(pos):start(1)
		end,

		on_metadata_inventory_put = function(pos)
			minetest.get_node_timer(pos):start(1)
		end,

		on_blast = destruct,
		on_destruct = destruct,
	}, def.node)

	def.active = table.combine(def.node, {
		drop = name,
		light_source = 8,
		groups = table.combine(def.node.groups, {
			not_in_creative_inventory = true,
		}),
	}, def.active)

	local function valid(itemstring)
		local temp = minetest.get_item_group("itemstring", "cook_temp")
		return temp >= def.range[1] and temp <= def.range[2]
	end
end

aurum.cook.register("aurum_cook:smelter", {
	range = {10, 20},
	node = {
		description = S"Smelter",
		_doc_items_longdesc = S"Stone piled into a smelting furnace.",
		_doc_items_usagehelp = S"Insert fuel in the bottom slot and something to smelt in the top slot.",
		_doc_items_hidden = false,

		tiles = {
			"aurum_cook_smelter.png", "aurum_cook_smelter.png",
			"aurum_cook_smelter.png", "aurum_cook_smelter.png",
			"aurum_cook_smelter.png", "aurum_cook_smelter_front.png",
		},

		paramtype2 = facedir,
		on_place = minetest.rotate_node,
		sounds = aurum.sounds.stone(),

		groups = {dig_pick = 2},
	},
	active = {
		tiles = {
			"aurum_cook_smelter.png", "aurum_cook_smelter.png",
			"aurum_cook_smelter.png", "aurum_cook_smelter.png",
			"aurum_cook_smelter.png", "aurum_cook_smelter_front_active.png",
		},
	},
})
