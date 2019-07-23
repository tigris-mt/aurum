local S = minetest.get_translator()

local form
form = smartfs.create("aurum_rods:table", function(state)
	state:size(8, 5.5)

	local pos = state.location.pos
	local meta = minetest.get_meta(pos)
	local invloc = ("nodemeta:%d,%d,%d"):format(pos.x, pos.y, pos.z)

	state:label(0, 0, "scroll_label", S"Spell Scroll")
	state:inventory(0, 0.5, 1, 1, "scroll"):setLocation(invloc)
	state:label(7, 0, "rod_label", S"Rod")
	state:inventory(7, 0.5, 1, 1, "rod"):setLocation(invloc)

	local function get_info(player)
		local info = {}

		info.scroll = meta:get_inventory():get_list("scroll")[1]
		info.scroll_info = info.scroll:get_count() > 0 and aurum.scrolls.get(info.scroll)

		info.rod = meta:get_inventory():get_list("rod")[1]

		info.valid = info.scroll_info and info.rod:get_count() > 0

		return info
	end

	state:button(3.5, 0, 1, 2, "bespell", S"Bespell"):onClick(function(self, state, name)
		local player = minetest.get_player_by_name(name)
		if not player or aurum.is_protected(state.location.pos, player) then
			return
		end

		local info = get_info(player)
		if info.valid then
			-- Set rod spell and level.
			local new_rod = ItemStack(info.rod)
			new_rod:get_meta():set_string("spell", info.scroll_info.name)
			new_rod:get_meta():set_int("spell_level", info.scroll_info.level)
			new_rod = aurum.tools.refresh_item(new_rod)
			meta:get_inventory():set_list("rod", {new_rod})

			-- Consume scroll.
			meta:get_inventory():set_list("scroll", {})
		end

		form:attach_to_node(state.location.pos)
	end)

	state:inventory(0, 2, 8, 4, "main")

	state:element("code", {name = "listring", code = [[
		listring[]] .. invloc .. [[;scroll]
		listring[current_player;main]
		listring[]] .. invloc .. [[;rod]
		listring[current_player;main]
	]]})
end)

minetest.register_node("aurum_rods:table", {
	description = S"Rod Table",
	tiles = {"aurum_base_stone.png^aurum_rods_table_top.png", "aurum_base_stone.png"},
	paramtype2 = "facedir",
	on_place = minetest.rotate_node,
	groups = {dig_pick = 3},

	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, 0.2, -0.5, 0.5, 0.5, 0.5},
			{-0.25, -0.5, -0.25, 0.25, 0.2, 0.25},
		},
	},

	sounds = aurum.sounds.stone(),

	on_construct = function(pos)
		local inv = minetest.get_meta(pos):get_inventory()
		inv:set_size("scroll", 1)
		inv:set_size("rod", 1)

		form:attach_to_node(pos)
	end,

	on_receive_fields = smartfs.nodemeta_on_receive_fields,

	allow_metadata_inventory_put = function(pos, listname, _, stack, player)
		if aurum.is_protected(pos, player) then
			return 0
		end

		if listname == "scroll" then
			local scroll = aurum.scrolls.get(stack)
			if not (scroll and scroll.type == "spell") then
				return 0
			end
		elseif listname == "rod" then
			if minetest.get_item_group(stack:get_name(), "rod") == 0 then
				return 0
			end
		end

		return stack:get_count()
	end,

	allow_metadata_inventory_move = function()
		return 0
	end,

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
	output = "aurum_rods:table",
	recipe = {
		{"group:stone", "aurum_rods:rod", "group:stone"},
		{"", "group:stone", ""},
		{"", "group:stone", ""},
	},
}
