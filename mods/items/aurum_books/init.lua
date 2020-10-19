local S = aurum.get_translator()

gtextitems.register("aurum_books:book", {
	item = {
		description = S"Book",
		inventory_image = "default_book.png",
		groups = {
			book = 1,
		},
	},
	written = {
		description = S"Written Book",
		inventory_image = "default_book_written.png",
	},
})

minetest.register_craft{
	output = "aurum_books:book",
	recipe = {
		{"aurum_base:sticky_stick", "aurum_scrolls:paper"},
		{"aurum_base:sticky_stick", "aurum_scrolls:paper"},
		{"aurum_base:sticky_stick", "aurum_scrolls:paper"},
	},
}

minetest.register_craft{
	type = "fuel",
	recipe = "group:book",
	burntime = 3,
}

local t = "aurum_base_stone.png"
local u = t .. "^aurum_books_stone_tablet.png"
local w = t .. "^aurum_books_stone_tablet_written.png"

gtextitems.register("aurum_books:stone_tablet", {
	node = true,
	item = {
		description = S"Stone Tablet",
		tiles = {t, t, t, t, t, u},
		drawtype = "nodebox",
		node_box = {
			type = "fixed",
			fixed = {
				{-0.3, -0.5, -0.1, 0.3, 0.5, 0.1},
			},
		},
		paramtype2 = "facedir",
		on_place = aurum.rotate_node_and_after,
		paramtype = "light",
		sunlight_propagates = true,
		sounds = aurum.sounds.stone(),
		groups = {
			dig_pick = 2,
		},
	},
	written = {
		description = S"Written Stone Tablet",
		tiles = {t, t, t, t, t, w},
	},
})

minetest.register_craft{
	output = "aurum_books:stone_tablet",
	recipe = {
		{"aurum_ore:iron_ingot", "group:stone"},
		{"aurum_ore:iron_ingot", "group:stone"},
		{"aurum_ore:iron_ingot", "group:stone"},
	},
}

gtextitems.register("aurum_books:stone_obelisk", {
	node = true,
	item = {
		description = S"Stone Obelisk",
		tiles = {t, t, u, u, u, u},
		paramtype2 = "facedir",
		on_place = aurum.rotate_node_and_after,
		sounds = aurum.sounds.stone(),
		groups = {
			dig_pick = 2,
		},
	},
	written = {
		description = S"Written Stone Obelisk",
		tiles = {t, t, w, w, w, w},
	},
})

minetest.register_craft{
	output = "aurum_books:stone_obelisk",
	recipe = {
		{"aurum_books:stone_tablet", "group:stone", "aurum_books:stone_tablet"},
	},
}
