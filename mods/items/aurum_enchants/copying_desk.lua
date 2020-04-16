local S = minetest.get_translator()

local form
form = smartfs.create("aurum_enchants:copying_desk", function(state)
	state:size(8, 6)

	local pos = state.location.pos
	local meta = minetest.get_meta(pos)
	local invloc = ("nodemeta:%d,%d,%d"):format(pos.x, pos.y, pos.z)

	state:label(0, 0, "src_label", S"Source")
	state:inventory(0, 0.7, 1, 1, "src"):setLocation(invloc)

	state:label(1, 0, "dst_label", S"Target")
	state:inventory(1, 0.7, 1, 1, "dst"):setLocation(invloc)

	state:label(2.5, 0, "cat_label", S"Mana Beans")
	state:inventory(2.5, 0.7, 1, 1, "catalyst"):setLocation(invloc)

	state:label(6, 0, "lib_label", S"Library")
	state:inventory(6, 0.7, 2, 1, "library"):setLocation(invloc)

	local function get(listname)
		return meta:get_inventory():get_list(listname)[1]
	end

	local function set(listname, stack)
		return meta:get_inventory():set_list(listname, {stack})
	end

	local function get_count()
		return math.min((get("src"):get_count() == 0 or get("dst"):get_name() ~= "aurum_scrolls:scroll") and 0 or get("dst"):get_count(), get("catalyst"):get_count())
	end

	local function mana_cost(add)
		local scroll = aurum.scrolls.get(get("src"))
		return math.ceil((((add + 2) * 3) ^ 2) * get_count() * (1 + ((scroll and scroll.level or 1) ^ 1.5)))
	end

	local function can_add(add)
		local scroll = aurum.scrolls.get(get("src"))
		return scroll and (aurum.tools.enchants[scroll.name].max_level >= scroll.level + add) and (scroll.level + add) > 0
	end

	local function work(add, pos, player)
		if not player then
			return
		end

		if get_count() == 0 then
			return
		end

		if xmana.mana(player) < mana_cost(add) then
			aurum.info_message(player, S"Not enough mana.")
			return
		end

		if not can_add(add) then
			return
		end

		xmana.mana(player, -mana_cost(add), true)
		local cat = get("catalyst")
		cat:set_count(cat:get_count() - get_count())
		set("catalyst", cat)

		local scroll = aurum.scrolls.get(get("src"))
		local stack = aurum.enchants.new_scroll(scroll.name, scroll.level + add)
		stack:set_count(get("dst"):get_count())
		set("dst", stack)
	end

	if can_add(-1) then
		state:button(3.75, 0, 2.25, 1, "reduce", S("Reduce (@1 mana)", mana_cost(-1))):onClick(function(self, state, player)
			work(-1, state.location.pos, minetest.get_player_by_name(player))
		end)
	end

	if can_add(0) then
		state:button(3.75, 1, 2.25, 1, "copy", S("Copy (@1 mana)", mana_cost(0))):onClick(function(self, state, player)
			work(0, state.location.pos, minetest.get_player_by_name(player))
		end)
	end

	-- TODO: Improve mechanic?
	--[[
	if can_add(1) then
		state:button(3.75, 1, 2.25, 1, "improve", S("Improve (@1 mana)", mana_cost(1))):onClick(function(self, state, player)
			work(1, state.location.pos, minetest.get_player_by_name(player))
		end)
	end
	]]

	state:inventory(0, 2, 8, 4, "main")

	state:element("code", {name = "listring", code = [[
		listring[]] .. invloc .. [[;src]
		listring[current_player;main]
		listring[]] .. invloc .. [[;dst]
		listring[current_player;main]
		listring[]] .. invloc .. [[;catalyst]
		listring[current_player;main]
		listring[]] .. invloc .. [[;library]
		listring[current_player;main]
	]]})
end)

minetest.register_node("aurum_enchants:copying_desk", {
	description = S"Enchanter's Copying Desk",
	_doc_items_longdesc = S"The all-in-one solution to duplicating scrolls of enchantment.",
	_doc_items_usagehelp = S"Insert a scroll of enchantment in the source slot. Insert empty scrolls in the target slot, and mana beans in the mana bean slot. By spending mana, you can then copy the enchant to the empty scrolls. This will consume as many mana beans as there are empty scrolls.",
	tiles = {"aurum_trees_birch_planks.png^aurum_enchants_copying_desk.png", "aurum_trees_birch_planks.png"},
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			-- Legs
			{-0.5, -0.5, -0.5, -0.4, 0.25, -0.4},
			{0.5, -0.5, -0.5, 0.4, 0.25, -0.4},
			{-0.5, -0.5, 0.5, -0.4, 0.25, 0.4},
			{0.5, -0.5, 0.5, 0.4, 0.25, 0.4},

			-- Table back.
			{-0.5, 0.25, 0, 0.5, 0.5, 0.5},
			-- Table front.
			{-0.5, 0.25, 0, 0.5, 0.4, -0.5},
		},
	},

	paramtype2 = "facedir",
	on_place = minetest.rotate_node,

	paramtype = "light",
	sunlight_propagates = true,

	is_ground_content = false,
	groups = {dig_chop = 2, flammable = 1},
	sounds = aurum.sounds.wood(),

	on_construct = function(pos)
		minetest.get_meta(pos):get_inventory():set_size("src", 1)
		minetest.get_meta(pos):get_inventory():set_size("dst", 1)
		minetest.get_meta(pos):get_inventory():set_size("catalyst", 1)
		minetest.get_meta(pos):get_inventory():set_size("library", 2)
		form:attach_to_node(pos)
	end,

	on_receive_fields = smartfs.nodemeta_on_receive_fields,

	allow_metadata_inventory_put = function(pos, listname, _, stack, player)
		if listname == "src" then
			local scroll = aurum.scrolls.get(stack)
			if not (scroll and scroll.type == "enchant") then
				return 0
			end
		elseif listname == "dst" then
			if stack:get_name() ~= "aurum_scrolls:scroll" then
				return 0
			end
		elseif listname == "catalyst" then
			if stack:get_name() ~= "aurum_ore:mana_bean" then
				return 0
			end
		elseif listname == "library" then
			if minetest.get_item_group(stack:get_name(), "scroll") < 1 then
				return 0
			end
		end
		return aurum.is_protected(pos, player) and 0 or stack:get_count()
	end,

	allow_metadata_inventory_move = aurum.metadata_inventory_move_delegate,

	allow_metadata_inventory_take = function(pos, _, _, stack, player)
		return aurum.is_protected(pos, player) and 0 or stack:get_count()
	end,

	on_metadata_inventory_put = function(pos)
		form:attach_to_node(pos)
	end,

	on_metadata_inventory_move = function(pos)
		form:attach_to_node(pos)
	end,

	on_metadata_inventory_take = function(pos)
		form:attach_to_node(pos)
	end,

	on_blast = aurum.drop_all_blast,
	on_destruct = aurum.drop_all,
})

minetest.register_craft{
	output = "aurum_enchants:copying_desk",
	recipe = {
		{"group:wood", "group:wood", "group:wood"},
		{"aurum_base:sticky_stick", "aurum_scrolls:paper", "aurum_base:sticky_stick"},
	},
}
