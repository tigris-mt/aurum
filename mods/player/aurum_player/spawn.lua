local S = minetest.get_translator()

minetest.register_on_respawnplayer(function(player)
	local pos = minetest.string_to_pos(player:get_meta():get_string("aurum_player:spawnpoint"))
	if pos then
		minetest.after(0, function()
			if aurum.force_get_node(pos).name == "aurum_player:hyperion_totem" then
				aurum.player.teleport(player, pos)
			end
		end)
	end
end)

-- If no static spawn is set, respawn in the spawn realm.
local realm_spawn = minetest.settings:get("aurum.spawn_realm") or "aurum:aurum"
if not minetest.settings:get("static_spawnpoint") then
	local function aurum_spawn(player)
		-- If the player has a spawn point, do nothing.
		if minetest.string_to_pos(player:get_meta():get_string("aurum_player:spawnpoint")) then
			return
		end

		aurum.player.teleport_guarantee(player, aurum.box.new_add(aurum.realms.get_spawn(realm_spawn), vector.new(0, 150, 0)), function(player)
			aurum.player.teleport(player, aurum.realms.get_spawn(realm_spawn))
		end)
	end

	minetest.register_on_newplayer(aurum_spawn)
	minetest.register_on_respawnplayer(aurum_spawn)
end

local box = {
	type = "fixed",
	fixed = {{-0.4, -0.5, -0.4, 0.4, 1.4, 0.4}},
}
minetest.register_node("aurum_player:hyperion_totem", {
	description = S"Hyperion Totem",
	_doc_items_longdesc = S"The likeness of Hyperion, carved out of copper, placed upon wood, and infused with mana.\nRight-click on the totem to set your respawn point.",
	_doc_items_hidden = false,

	drawtype = "mesh",
	mesh = "aurum_player_totem.b3d",
	visual_scale = 0.25,
	tiles = {"aurum_player_totem.png"},

	paramtype2 = "facedir",
	on_place = minetest.rotate_node,

	selection_box = box,
	collision_box = box,

	paramtype = "light",
	light_source = 13,

	is_ground_content = false,
	groups = {dig_chop = 3},

	on_rightclick = function(pos, _, player)
		if aurum.is_protected(pos, player) then
			return
		end

		player:get_meta():set_string("aurum_player:spawnpoint", minetest.pos_to_string(pos))
		aurum.info_message(player, S("Your respawn point is now @1", minetest.pos_to_string(pos)))
	end,
})

minetest.register_craft{
	output = "aurum_player:hyperion_totem",
	recipe = {
		{"", "aurum_ore:copper_ingot", ""},
		{"aurum_ore:mana_bean", "group:wood", "aurum_ore:mana_bean"},
		{"", "group:wood", ""},
	},
}
