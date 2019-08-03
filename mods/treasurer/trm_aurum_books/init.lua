trm_aurum_books = {}

trm_aurum_books.groups = {}

function trm_aurum_books.register(def)
	local def = table.combine({
		weight = 1,
		items = {"aurum_books:book_written"},
		callback = function(data)
			return data
		end,
	}, def, {
		groups = table.combine({
			lore = true,
			lorebook = true,
		}, def.groups or {}),

		data = table.combine({
			author = nil,
			title = nil,
			text = nil,
		}, def.data or {}),
	})

	local entry = {def, def.weight}
	for g in aurum.set.iter(def.groups) do
		trm_aurum_books.groups[g] = trm_aurum_books.groups[g] or {}
		table.insert(trm_aurum_books.groups[g], entry)
	end
end

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

minetest.register_on_mods_loaded(function()
	local len = #table.keys(trm_aurum_books.groups)
	for g in pairs(trm_aurum_books.groups) do
		aurum.treasurer.register_itemstack_callback(ItemStack("aurum_books:book_written"), function(stack)
			local data, item = trm_aurum_books.random_book(g)
			if item then
				stack:set_name(item)
			end
			return gtextitems.set_item(stack, data)
		end, 0.5 / len, 3, 1, 0, g)
	end
end)

aurum.dofile("books/init.lua")
