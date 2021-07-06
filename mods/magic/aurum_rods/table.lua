local S = aurum.get_translator()

local form
form = aurum.gui.node_smartfs("aurum_rods:table", function(state)
	local s = aurum.player.inventory_size(state.location.player)
	state:size(math.max(8, s.x), s.y + 2)

	local pos = state.param.pos
	local meta = minetest.get_meta(pos)
	local invloc = ("nodemeta:%d,%d,%d"):format(pos.x, pos.y, pos.z)

	-- Invisible delegate.
	state:inventory(-2, -2, 1, 1, "delegate"):setLocation(invloc)

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
		if not player or aurum.is_protected(pos, player) then
			return
		end

		local info = get_info(player)
		if info.valid then
			-- Set rod spell.
			meta:get_inventory():set_list("rod", {aurum.rods.set_item(ItemStack(info.rod), {
				spell = info.scroll_info.name,
				level = info.scroll_info.level,
			})})

			-- Consume scroll.
			meta:get_inventory():set_list("scroll", {})
		end

		form:reshow(pos)
	end)

	state:inventory(0, 2, s.x, s.y, "main")

	state:element("code", {name = "listring", code = [[
		listring[current_player;main]
		listring[]] .. invloc .. [[;delegate]
		listring[current_player;main]
		listring[]] .. invloc .. [[;scroll]
		listring[current_player;main]
		listring[]] .. invloc .. [[;rod]
		listring[current_player;main]
	]]})
end)

minetest.register_node("aurum_rods:table", {
	description = S"Rod Bespelling Table",
	tiles = {"aurum_base_stone.png^aurum_rods_table_top.png", "aurum_base_stone.png"},
	paramtype2 = "facedir",
	on_place = minetest.rotate_node,
	is_ground_content = false,
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
		inv:set_size("delegate", 1)
	end,

	on_rightclick = function(pos, _, clicker)
		form:show(pos, clicker)
	end,

	on_receive_fields = smartfs.nodemeta_on_receive_fields,

	allow_metadata_inventory_put = aurum.allow_metadata_inventory_put_delegate({"scroll", "rod"}, function(pos, listname, _, stack, player)
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
	end),

	allow_metadata_inventory_move = aurum.metadata_inventory_move_delegate,

	allow_metadata_inventory_take = function(pos, _, _, stack, player)
		return aurum.is_protected(pos, player) and 0 or stack:get_count()
	end,

	on_metadata_inventory_put = aurum.on_metadata_inventory_put_delegate({"scroll", "rod"}, function(pos)
		form:reshow(pos)
	end),

	on_metadata_inventory_take = function(pos)
		form:reshow(pos)
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
