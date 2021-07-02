local S = aurum.get_translator()

-- Override sfinv formspec builder with dynamic inventory rendering.
function sfinv.make_formspec(player, context, content, show_inv, size)
	local s = aurum.player.inventory_size(player)

	local default_inv_fs = {}
	if show_inv then
		for i=1,s.x do
			table.insert(default_inv_fs, ("image[%d,5.2;1,1;gui_hb_bg.png]"):format(i - 1))
		end
		table.insert(default_inv_fs, ("list[current_player;main;0,5.2;%d,1;]"):format(s.x))
		if s.y > 1 then
			table.insert(default_inv_fs, ("list[current_player;main;0,6.35;%d,%d;%d]"):format(s.x, s.y - 1, s.x))
		end
	end

	local tmp = {
		size or (show_inv and ("size[%f,%f]"):format(math.max(8, s.x), s.y + 5.1) or "size[8,9.1]"),
		sfinv.get_nav_fs(player, context, context.nav_titles, context.nav_idx),
		table.concat(default_inv_fs, ""),
		content
	}
	return table.concat(tmp, "")
end

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

	-- Build inventory display as raw formspec so that the listrings can be ordered.
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
	i(4.5, 1, gequip.types["hands"].list_name)

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
		"-",
		g("drown"),
		g("fall"),
	}, "\n"))
end)

-- Refresh SFInv page on equipment update.
local old = gequip.refresh
function gequip.refresh(player)
	local ret = old(player)
	if sfinv.get_page(player) then
		sfinv.set_page(player, sfinv.get_page(player))
	end
	return ret
end

-- Add to inventories.
smartfs.add_to_inventory(form, "aurum_base_grass.png", S"Equipment", true)
