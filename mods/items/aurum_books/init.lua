local S = minetest.get_translator()

gtextitems.register("aurum_books:book", {
	item = {
		description = S"Book",
		inventory_image = "default_book.png",
		groups = {
			aurum_book = 1,
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
	recipe = "group:aurum_book",
	burntime = 3,
}
