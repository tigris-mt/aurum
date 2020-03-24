aurum.flavor.books = {}
aurum.flavor.books.groups = {}

-- Generate lore_<x> and lorebook_<x> groups set for each argument.
-- These groups are used in, e.g, treasurer.
function aurum.flavor.books.categories(...)
	local ret = {}
	for _,v in ipairs{...} do
		ret["lore_" .. v] = true
		ret["lorebook_" .. v] = true
	end
	return ret
end

function aurum.flavor.books.register(def)
	local def = b.t.combine({
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
		groups = b.t.combine({
			lore = true,
			lorebook = true,
		}, def.groups or {}),

		-- Default gtextitems data.
		data = b.t.combine({
			author = nil,
			author_type = "npc",
			title = nil,
			text = nil,
			id = nil,
		}, def.data or {}),
	})

	-- Weighted list entry.
	local entry = {def, def.weight}
	-- For each treasure group, insert the weighted entry into its list.
	for g in b.set.iter(def.groups) do
		aurum.flavor.books.groups[g] = aurum.flavor.books.groups[g] or {}
		table.insert(aurum.flavor.books.groups[g], entry)
	end
end

-- Choose a random book (gtextitems data) by group.
-- Second return is the itemstring to use for the book.
function aurum.flavor.books.random_book(group)
	local entries = aurum.flavor.books.groups[group]
	if not entries then
		return
	end

	local choice = b.t.weighted_choice(entries)

	local item = nil
	if #choice.items > 0 then
		item = choice.items[math.random(#choice.items)]
	end

	return choice.callback(table.copy(choice.data)), item
end
