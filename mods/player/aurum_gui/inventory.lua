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

local form = smartfs.create("aurum_player:equipment", function(state)
    state:size(8, 6)

	local inventories = ""
	local listrings = ""
	local function i(x, y, n)
		inventories = inventories .. "list[current_player;" .. n .. ";" .. x .. "," .. y .. ";1,1]"
		listrings = listrings .. "listring[current_player;main]listring[current_player;" .. n .. "]"
	end

	-- Invisible delegate inventory.
	-- Must be first inventory in the listring.
	i(-2, -2, gequip.DELEGATE)
	i(3.5, 0, gequip.types["head"].list_name)
	i(3.5, 1, gequip.types["chest"].list_name)
	i(3.5, 2, gequip.types["legs"].list_name)
	i(3.5, 3, gequip.types["feet"].list_name)

	state:element("code", {name = "listrings", code = inventories .. "\n" .. listrings})

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
