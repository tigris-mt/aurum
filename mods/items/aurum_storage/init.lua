local S = aurum.get_translator()
aurum.storage = {}

doc.sub.items.register_factoid("nodes", "use", function(itemstring, def)
	if minetest.get_item_group(itemstring, "storage") > 0 then
		return S("This node stores up to @1 item stacks.", minetest.get_item_group(itemstring, "storage"))
	end
	return ""
end)

function aurum.storage.register(name, def)
	local def = b.t.combine({
		-- Inventory size.
		width = 1,
		height = 1,

		-- Can this stack be inserted into the inventory?
		valid_item = function(stack)
			return true
		end,

		-- Node definition.
		node = {},

		protected = false,
	}, def)

	local form = aurum.gui.node_smartfs(name, function(state)
		local s = aurum.player.inventory_size(state.location.player)
		state:size(math.max(8, def.width, s.x), def.height + 0.5 + s.y)

		local pos = state.param.pos
		local meta = minetest.get_meta(pos)
		local invloc = ("nodemeta:%d,%d,%d"):format(pos.x, pos.y, pos.z)

		state:inventory(state:getSize().w / 2 - def.width / 2, 0, def.width, def.height, "main"):setLocation(invloc)

		local pix = state:getSize().w / 2 - s.x / 2
		local piy = def.height + 0.5

		state:element("code", {name = "player_main", code = [[
			list[current_player;main;]] .. pix .. [[,]] .. piy .. [[;]] .. s.x .. [[,]] .. s.y .. [[]
		]]})

		state:element("code", {name = "listring", code = [[
			listring[]] .. invloc .. [[;main]
			listring[current_player;main]
		]]})
	end)

	local ndef = b.t.combine({
		on_construct = function(pos)
			minetest.get_meta(pos):get_inventory():set_size("main", def.width * def.height)
		end,

		on_rightclick = function(pos, _, clicker)
			form:show(pos, clicker)
		end,

		allow_metadata_inventory_put = function(pos, listname, _, stack, player)
			if def.protected and aurum.is_protected(pos, player) then
				return 0
			end

			return def.valid_item(stack) and stack:get_count() or 0
		end,

		allow_metadata_inventory_move = aurum.metadata_inventory_move_delegate,

		allow_metadata_inventory_take = function(pos, _, _, stack, player)
			return (def.protected and aurum.is_protected(pos, player)) and 0 or stack:get_count()
		end,

		on_blast = aurum.drop_all_blast,
		on_destruct = aurum.drop_all,

		is_ground_content = false,
	}, def.node, {
		groups = b.t.combine({
			storage = def.width * def.height,
		}, def.node.groups or {}),
	})

	minetest.register_node(name, ndef)
end

aurum.storage.register("aurum_storage:box", {
	width = 6,
	height = 4,
	node = {
		description = S"Box",
		_doc_items_hidden = false,
		tiles = {"aurum_storage_box.png"},
		sounds = aurum.sounds.wood(),
		groups = {dig_chop = 3, flammable = 1},
	},
})

minetest.register_craft{
	output = "aurum_storage:box",
	recipe = {
		{"group:wood", "group:wood", "group:wood"},
		{"group:wood", "", "group:wood"},
		{"group:wood", "group:wood", "group:wood"},
	},
}

aurum.storage.register("aurum_storage:shell_box", {
	width = 10,
	height = 6,
	node = {
		description = S"Shell Box",
		tiles = {"aurum_storage_shell_box.png"},
		sounds = aurum.sounds.stone(),
		groups = {dig_pick = 2, level = 2},
	},
})

minetest.register_craft{
	output = "aurum_storage:shell_box",
	recipe = {
		{"aurum_base:aether_shell", "aurum_base:aether_skin", "aurum_base:aether_shell"},
		{"aurum_base:aether_shell", "", "aurum_base:aether_shell"},
		{"aurum_base:aether_shell", "aurum_base:aether_skin", "aurum_base:aether_shell"},
	},
}

aurum.storage.register("aurum_storage:scroll_hole", {
	width = 2,
	height = 2,
	node = {
		description = S"Scroll Hole",
		drawtype = "nodebox",
		node_box = {
			type = "fixed",
			fixed = {
				{-0.25, -0.2, -0.25, -0.1, 0.2, 0.25},
				{-0.25, -0.5, -0.25, 0.25, 0.2, -0.1},
				{0.25, -0.2, 0.25, 0.1, 0.2, -0.25},
				{0.25, -0.5, 0.25, -0.25, 0.2, 0.1},
			},
		},
		tiles = {"aurum_base_stone_brick.png"},
		sounds = aurum.sounds.stone(),
		groups = {dig_pick = 2},
		paramtype = "light",
	},
	valid_item = function(stack)
		return minetest.get_item_group(stack:get_name(), "scroll") > 0 or minetest.get_item_group(stack:get_name(), "book") > 0
	end,
})

minetest.register_craft{
	output = "aurum_storage:scroll_hole 2",
	recipe = {
		{"aurum_base:stone_brick", "", "aurum_base:stone_brick"},
		{"aurum_base:stone_brick", "", "aurum_base:stone_brick"},
		{"aurum_base:stone_brick", "", "aurum_base:stone_brick"},
	},
}
