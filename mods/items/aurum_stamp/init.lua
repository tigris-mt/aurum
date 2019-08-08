local S = minetest.get_translator()

local form
form = smartfs.create("aurum_stamp:stamper", function(state)
	state:size(8, 6)

	local pos = state.location.pos
	local meta = minetest.get_meta(pos)
	local invloc = ("nodemeta:%d,%d,%d"):format(pos.x, pos.y, pos.z)

	state:inventory(0, 0, 1, 1, "item"):setLocation(invloc)
	state:inventory(0, 2, 8, 4, "main")

	state:field(1.75, 0.4, 5, 1, "text", S"Text")

	local required = xmana.level_to_mana(2)

	state:button(7, 0, 1, 1, "stamp", S"Stamp"):onClick(function(self, state, name)
		local player = minetest.get_player_by_name(name)
		if not player or aurum.is_protected(state.location.pos, player) then
			return
		end

		if xmana.mana(player) < required then
			aurum.info_message(player, S"Not enough mana.")
			return
		end

		local stack = meta:get_inventory():get_list("item")[1]
		if stack:get_count() > 0 then
			local text = state:get("text"):getText()
			stack:get_meta():set_string("description_override", (#text > 0) and text or stack:get_definition().description)
			stack = b.set_stack_description(stack, stack:get_meta():get_string("description"))
			xmana.mana(player, -required, true)
			meta:get_inventory():set_list("item", {stack})
		end

		form:attach_to_node(state.location.pos)
	end)

	if meta:get_inventory():get_list("item")[1]:get_count() > 0 then
		state:label(2, 1, "info", S("Required mana: @1", math.ceil(required)))
	end

	state:element("code", {name = "listring", code = [[
		listring[]] .. invloc .. [[;item]
		listring[current_player;main]
	]]})
end)

local texture = aurum.ore.ores["aurum_ore:bronze"].texture
minetest.register_node("aurum_stamp:stamper", {
	description = S"Name Stamper",
	_doc_items_longdesc = S"A sturdy device that uses mana to engrave a name on items.",
	tiles = {texture},
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			-- Bottom.
			{-0.4, -0.5, -0.25, 0.4, 0, 0.25},
			-- Top.
			{-0.2, 0.2, -0.15, 0.4, 0.3, 0.15},
			-- Connector.
			{0.3, 0, -0.15, 0.4, 0.2, 0.15},
		},
	},

	paramtype2 = "facedir",
	on_place = minetest.rotate_node,

	paramtype = "light",
	sunlight_propagates = true,

	is_ground_content = false,
	groups = {dig_pick = 2},
	sounds = aurum.sounds.metal(),

	on_construct = function(pos)
		minetest.get_meta(pos):get_inventory():set_size("item", 1)
		form:attach_to_node(pos)
	end,

	on_receive_fields = smartfs.nodemeta_on_receive_fields,

	allow_metadata_inventory_put = function(pos, listname, _, stack, player)
		return aurum.is_protected(pos, player) and 0 or stack:get_count()
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
	output = "aurum_stamp:stamper",
	recipe = {
		{"", "aurum_ore:bronze_ingot", ""},
		{"", "", "aurum_ore:bronze_ingot"},
		{"aurum_ore:bronze_ingot", "aurum_ore:bronze_ingot", "aurum_ore:bronze_ingot"},
	},
}
