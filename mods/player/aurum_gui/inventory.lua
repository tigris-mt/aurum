local S = minetest.get_translator()

sfinv.override_page("sfinv:crafting", {
	get = function(self, player, context)
		return sfinv.make_formspec(player, context, [[
			image_button[0.75,0.5;1,1;craftguide_book.png;craftguide;]
			tooltip[craftguide;]] .. S"Crafting Guide" .. [[]
			image_button[0.75,2.5;1,1;doc_button_icon_lores.png;help;]
			tooltip[help;]] .. S"General Help" .. [[]
			list[current_player;craft;1.75,0.5;3,3]
			list[current_player;craftpreview;5.75,1.5;1,1]
			image[4.75,1.5;1,1;gui_furnace_arrow_bg.png^[transformR270]
			listring[current_player;main]
			listring[current_player;craft]
		]], true)
	end,

	on_player_receive_fields = function(self, player, context, fields)
		if fields.craftguide then
			sfinv.set_page(player, "craftguide:craftguide")
			return true
		elseif fields.help then
			doc.show_doc(player:get_player_name())
			return true
		end
	end,
})

local DELEGATE = "aurum_player_delegate"

minetest.register_on_joinplayer(function(player)
	player:get_inventory():set_size(DELEGATE, 1)
	-- Ensure delegate inventory is clear.
	player:get_inventory():set_list(DELEGATE, {})
end)

minetest.register_allow_player_inventory_action(function(player, action, inv, info)
	local stack
	if action == "move" and info.to_list == DELEGATE and info.from_list ~= DELEGATE then
		stack = ItemStack(player:get_inventory():get_list(info.from_list)[info.from_index])
		stack:set_count(info.count)
	elseif action == "put" and info.listname == DELEGATE then
		stack = info.stack
	else
		return nil
	end

	for type,def in pairs(gequip.types) do
		if player:get_inventory():room_for_item(def.list_name, stack) and (def.allow_player_inventory_action(player, "put", player:get_inventory(), {stack = stack, listname = def.list_name}) or 1) > 0 then
			return 1
		end
	end

	return 0
end)

minetest.register_on_player_inventory_action(function(player, action, inv, info)
	local stack
	if action == "move" and info.to_list == DELEGATE then
		stack = ItemStack(player:get_inventory():get_list(info.to_list)[info.to_index])
		stack:set_count(info.count)
	elseif action == "put" and info.listname == DELEGATE then
		stack = info.stack
	else
		return
	end

	local def = gequip.types[stack:get_definition()._eqtype]
	player:get_inventory():set_list(DELEGATE, {})
	player:get_inventory():add_item(def.list_name, stack)
	def.on_player_inventory_action(player, "put", player:get_inventory(), {stack = stack, listname = def.list_name})
end)

local form = smartfs.create("aurum_player:equipment", function(state)
    state:size(8, 6)

	local function i(x, y, n)
		state:inventory(x, y, 1, 1, n)
		state:element("code", {name = "listring_" .. n, code = "listring[current_player;main]listring[current_player;" .. n .. "]"})
	end
	i(3.5, 0, "gequip_head")
	i(3.5, 1, "gequip_chest")
	i(3.5, 2, "gequip_legs")
	i(3.5, 3, "gequip_feet")
	-- Invisible inventory list for shift-insertion.
	-- Must be last inventory in the listring.
	i(-2, -2, DELEGATE)

	local function g(n)
		return S(n .. ": @1%", 100 - minetest.get_player_by_name(state.location.player):get_armor_groups()[n])
	end
	state:label(0, 0, "armor", table.concat({
		"Protected:",
		g("blade"),
		g("pierce"),
		g("impact"),
		"-",
		g("burn"),
		g("chill"),
		g("psyche"),
	}, "\n"))
end)

-- Refresh SFInv page on equipment update.
local old = gequip.refresh
function gequip.refresh(player)
	local ret = old(player)
	if sfinv.get_page(player) == "aurum_player:equipment" then
		sfinv.set_page(player, "aurum_player:equipment")
	end
	return ret
end

-- Add to inventories.
smartfs.add_to_inventory(form, "aurum_base_grass.png", S"Equipment", true)
