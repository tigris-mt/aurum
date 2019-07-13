sfinv.override_page("sfinv:crafting", {
	get = function(self, player, context)
		return sfinv.make_formspec(player, context, [[
			list[current_player;craft;2.625,0.75;2,2;]
			list[current_player;craftpreview;5.75,1.5;1,1;]
			image[4.75,1.5;1,1;gui_furnace_arrow_bg.png^[transformR270]
			listring[current_player;main]
			listring[current_player;craft]
		]], true)
	end
})

local form = smartfs.create("aurum_player:equipment", function(state)
    state:size(8, 6)

    state:inventory(3.5, 0, 1, 1, "gequip_head")
	state:inventory(3.5, 1, 1, 1, "gequip_chest")
	state:inventory(3.5, 2, 1, 1, "gequip_legs")
	state:inventory(3.5, 3, 1, 1, "gequip_feet")

    state:element("code", {name = "listring", code = "listring[current_player;jewelry]listring[current_player;main]"})
end)

-- Add to inventories.
smartfs.add_to_inventory(form, "aurum_base_grass.png", "Equipment", true)
