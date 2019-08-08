-- Register all books with treasurer.
-- They have zero preciousness, their distribution should be determined by groups only.
minetest.register_on_mods_loaded(function()
	local len = #b.t.keys(aurum.flavor.books.groups)
	for g in pairs(aurum.flavor.books.groups) do
		aurum.treasurer.register_itemstack_callback(ItemStack("aurum_books:book_written"), function(stack)
			local data, item = aurum.flavor.books.random_book(g)
			if item then
				stack:set_name(item)
			end
			return gtextitems.set_item(stack, data)
		end, 0.5 / len, 0, 1, 0, g)
	end
end)
