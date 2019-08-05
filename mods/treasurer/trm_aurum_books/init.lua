trm_aurum_books = {}

trm_aurum_books.groups = {}

-- Generate lore_<x> and lorebook_<x> treasure groups set for each argument.
function trm_aurum_books.categories(...)
	local ret = {}
	for _,v in ipairs{...} do
		ret["lore_" .. v] = true
		ret["lorebook_" .. v] = true
	end
	return ret
end

function trm_aurum_books.register(def)
	local def = table.combine({
		-- Weight of this book in being chosen randomly.
		weight = 1,
		-- What items should this book come as?
		items = {"aurum_books:book_written"},
		-- Called before choosing, can return new/modified gtextitems data.
		callback = function(data)
			return data
		end,
	}, def, {
		-- Treasure groups set.
		groups = table.combine({
			lore = true,
			lorebook = true,
		}, def.groups or {}),

		-- Default gtextitems data.
		data = table.combine({
			author = nil,
			title = nil,
			text = nil,
		}, def.data or {}),
	})

	-- Weighted list entry.
	local entry = {def, def.weight}
	-- For each treasure group, insert the weighted entry into its list.
	for g in aurum.set.iter(def.groups) do
		trm_aurum_books.groups[g] = trm_aurum_books.groups[g] or {}
		table.insert(trm_aurum_books.groups[g], entry)
	end
end

-- Choose a random book (gtextitems data) by treasurer group.
-- Second return is the itemstring to use for the book.
function trm_aurum_books.random_book(group)
	local entries = trm_aurum_books.groups[group]
	if not entries then
		return
	end

	local choice = aurum.weighted_choice(entries)

	local item = nil
	if #choice.items > 0 then
		item = choice.items[math.random(#choice.items)]
	end

	return choice.callback(table.copy(choice.data)), item
end

-- Register all books with treasurer.
-- They have zero preciousness, their distribution should be determined by groups only.
minetest.register_on_mods_loaded(function()
	local len = #table.keys(trm_aurum_books.groups)
	for g in pairs(trm_aurum_books.groups) do
		aurum.treasurer.register_itemstack_callback(ItemStack("aurum_books:book_written"), function(stack)
			local data, item = trm_aurum_books.random_book(g)
			if item then
				stack:set_name(item)
			end
			return gtextitems.set_item(stack, data)
		end, 0.5 / len, 0, 1, 0, g)
	end
end)

aurum.dofile("books/init.lua")
