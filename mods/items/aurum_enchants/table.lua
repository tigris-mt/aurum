local S = minetest.get_translator()

local form
form = smartfs.create("aurum_enchants:table", function(state)
	state:size(8, 6)

	local pos = state.location.pos
	local meta = minetest.get_meta(pos)
	local invloc = ("nodemeta:%d,%d,%d"):format(pos.x, pos.y, pos.z)

	state:label(2, 0, "scroll_label", S"Enchantment Scroll")
	state:inventory(2, 0.5, 1, 1, "scroll"):setLocation(invloc)
	state:label(6, 0, "tool_label", S"Tool")
	state:inventory(6, 0.5, 1, 1, "tool"):setLocation(invloc)

	local function get_info(player)
		local info = {}

		info.scroll = meta:get_inventory():get_list("scroll")[1]
		info.scroll_info = info.scroll:get_count() > 0 and aurum.scrolls.get(info.scroll)

		info.tool = meta:get_inventory():get_list("tool")[1]
		info.tool_info = info.tool:get_count() > 0 and aurum.tools.get_item_info(info.tool)

		if info.scroll_info then
			if info.tool_info then
				-- The current level (or 0) of this particular enchantment on the tool
				local current_enchantment = (info.tool_info.enchants[info.scroll_info.name] or 0)
				-- Will this enchantment fit in the tool? Subtract current_enchantment since it will be replaced with the new level.
				info.valid = (info.scroll_info.level - current_enchantment) <= (info.tool_info.total - info.tool_info.used)
			end

			-- How many mana leves are required to perform this enchantment?
			info.required_mana = aurum.tools.enchants[info.scroll_info.name].mana_level(info.scroll_info.level)
			-- Does the player have enough mana levels?
			info.enough_mana = player and xmana.mana_to_level(xmana.mana(player)) >= info.required_mana
		end

		return info
	end

	local info = get_info()

	-- Create info display.
	local infot = {}
	if info.scroll_info then
		table.insert(infot, S("Required mana level: @1", info.required_mana))
	end
	if info.tool_info then
		table.insert(infot, S("Tool levels used: @1 out of @2", info.tool_info.used, info.tool_info.total))
	end
	if info.valid == false then
		table.insert(infot, minetest.colorize("#ff0000", S"Not enough free tool levels"))
	end
	state:label(0, 1.5, "info_label", table.concat(infot, " | "))

	state:button(3.5, 0, 1, 2, "enchant", S"Enchant"):onClick(function(self, state, name)
		local player = minetest.get_player_by_name(name)
		if not player or aurum.is_protected(state.location.pos, player) then
			return
		end

		local info = get_info(player)
		if not info.enough_mana then
			aurum.info_message(player, S"Not enough mana levels.")
			return
		end
		if info.valid then
			-- Overwrite tool with new enchantment level.
			meta:get_inventory():set_list("tool", {
				aurum.tools.set_item_enchants(ItemStack(info.tool), table.combine(info.tool_info.enchants, {
					[info.scroll_info.name] = info.scroll_info.level,
				})),
			})
			-- Consume scroll.
			meta:get_inventory():set_list("scroll", {})
			-- Consume half the required mana.
			xmana.mana(player, -xmana.level_to_mana(info.required_mana) / 2, true, "enchanting")
		end

		form:attach_to_node(state.location.pos)
	end)

	state:inventory(0, 2, 8, 4, "main")

	state:element("code", {name = "listring", code = [[
		listring[]] .. invloc .. [[;scroll]
		listring[current_player;main]
		listring[]] .. invloc .. [[;tool]
		listring[current_player;main]
	]]})
end)

local gold = minetest.registered_nodes["aurum_ore:gold_block"].tiles[1]

minetest.register_node("aurum_enchants:table", {
	description = S"Enchanting Table",
	tiles = {gold .. "^aurum_enchants_table_top.png", gold, gold .. "^aurum_enchants_table_side.png"},
	paramtype = "light",
	light_source = 10,
	paramtype2 = "facedir",
	on_place = minetest.rotate_node,
	groups = {dig_pick = 2},

	sounds = aurum.sounds.metal(),

	on_construct = function(pos)
		local inv = minetest.get_meta(pos):get_inventory()
		inv:set_size("scroll", 1)
		inv:set_size("tool", 1)

		form:attach_to_node(pos)
	end,

	on_receive_fields = smartfs.nodemeta_on_receive_fields,

	allow_metadata_inventory_put = function(pos, listname, _, stack, player)
		if aurum.is_protected(pos, player) then
			return 0
		end

		if listname == "scroll" then
			local scroll = aurum.scrolls.get(stack)
			if not (scroll and scroll.type == "enchant") then
				return 0
			end
		elseif listname == "tool" then
			if not aurum.tools.get_item_info(stack) then
				return 0
			end
		end

		return stack:get_count()
	end,

	allow_metadata_inventory_move = aurum.metadata_inventory_move_delegate,

	allow_metadata_inventory_take = function(pos, _, _, stack, player)
		return aurum.is_protected(pos, player) and 0 or stack:get_count()
	end,

	on_metadata_inventory_put = function(pos)
		form:attach_to_node(pos)
	end,

	on_metadata_inventory_take = function(pos)
		form:attach_to_node(pos)
	end,

	on_blast = aurum.drop_all_blast,
	on_destruct = aurum.drop_all,
})

minetest.register_craft{
	output = "aurum_enchants:table",
	recipe = {
		{"aurum_ore:mana_bean", "aurum_ore:gold_ingot", "aurum_ore:mana_bean"},
		{"aurum_base:sticky_stick", "aurum_ore:gold_block", "aurum_base:sticky_stick"},
		{"aurum_ore:bronze_ingot", "aurum_ore:gold_ingot", "aurum_ore:bronze_ingot"},
	},
}
