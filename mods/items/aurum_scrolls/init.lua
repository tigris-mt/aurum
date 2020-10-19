local S = aurum.get_translator()
aurum.scrolls = {}

minetest.register_craftitem("aurum_scrolls:paper", {
	description = S"Paper",
	inventory_image = "aurum_scrolls_paper.png",
	groups = {paper = 1},
})

minetest.register_craft{
	output = "aurum_scrolls:paper",
	recipe = {{"aurum_flora:reed", "aurum_flora:reed", "aurum_flora:reed"}},
}

minetest.register_craft{
	type = "fuel",
	recipe = "group:paper",
	burntime = 1,
}

minetest.register_craftitem("aurum_scrolls:scroll", {
	description = S"Empty Magic Scroll",
	_doc_items_longdesc = S"Made from paper and unrefined mana dust, this scroll is ever so slightly tingly to the touch.",
	inventory_image = "aurum_scrolls_scroll.png",
	groups = {paper = 1, scroll = 1},
})

minetest.register_craft{
	output = "aurum_scrolls:scroll",
	recipe = {
		{"", "aurum_scrolls:paper", ""},
		{"aurum_ore:mana_bean", "aurum_scrolls:paper", "aurum_ore:mana_bean"},
		{"", "aurum_scrolls:paper", ""},
	},
}

-- Erasure craft.
minetest.register_craft{
	output = "aurum_scrolls:scroll",
	recipe = {
		{"aurum_scrolls:scroll_full", "aurum_ore:iron_ingot"},
	},
}

minetest.register_craftitem("aurum_scrolls:scroll_full", {
	description = S"Active Magic Scroll",
	_doc_items_longdesc = S"This faintly humming roll of paper contains magic. It can be erased with iron.",
	inventory_image = "aurum_scrolls_scroll_full.png",
	groups = {paper = 1, scroll = 1},
	stack_max = 1,
})

-- Get the def of a scroll (see aurum.scrolls.new()) or nil if it is invalid.
function aurum.scrolls.get(stack)
	if stack:get_name() ~= "aurum_scrolls:scroll_full" then
		return nil
	end

	local contents = stack:get_meta():get_string("contents")
	if #contents > 0 then
		return minetest.deserialize(contents)
	else
		return nil
	end
end

function aurum.scrolls.new(def)
	local stack = ItemStack("aurum_scrolls:scroll_full")
	local def = b.t.combine({
		-- Type of magic (enchant, spell).
		type = "",
		-- Name of magic (durability, growth).
		name = "",
		-- Level of magic.
		level = 1,
	}, def)
	def.description = def.description or ("Magic Scroll: %s %s %d"):format(def.type, def.name, def.level)
	stack:get_meta():set_string("contents", minetest.serialize(def))
	aurum.set_stack_description(stack, def.description)
	return stack
end

minetest.register_chatcommand("givemescroll", {
	params = S"<type> <name> [<level>]",
	description = S"Creates an arbitrary magic scroll.",
	privs = {give = true},
	func = function(name, params)
		local player = minetest.get_player_by_name(name)
		if not player then
			return false, S"No player."
		end

		local split = params:split(" ")
		local type = split[1]
		local name = split[2]
		local level = tonumber(split[3])

		if not (type and name) then
			return false, S"Invalid parameters."
		end

		local leftover = player:get_inventory():add_item("main", aurum.scrolls.new{
			type = type,
			name = name,
			level = level,
		})
		if leftover:get_count() > 0 then
			return false, S"Unable to give scroll."
		else
			return true, S"Produced scroll."
		end
	end,
})
