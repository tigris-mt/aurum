local S = aurum.get_translator()

function aurum.player.spawn_totem(player)
	local pos = minetest.string_to_pos(player:get_meta():get_string("aurum_player:spawnpoint"))
	if pos then
		minetest.after(0, function()
			if aurum.force_get_node(pos).name == "aurum_player:hyperion_totem" then
				aurum.player.teleport(player, pos)
			end
		end)
		return true
	end
	return false
end

minetest.register_on_respawnplayer(aurum.player.spawn_totem)

local spawning = {}

local function show_spawn_fs(player)
	minetest.show_formspec(player:get_player_name(), "aurum_player:spawn", ("size[3,1] label[0,0.25;%s]"):format(minetest.formspec_escape(b.t.choice{
		"Arrival imminent!",
		"Life awaits.",
		"The void holds no claim on you.",
		"A world unfolds.",
	})))
	spawning[player:get_player_name()] = true
end

local function close_spawn_fs(player)
	minetest.close_formspec(player:get_player_name(), "aurum_player:spawn")
	spawning[player:get_player_name()] = nil
end

local realm_spawn = minetest.settings:get("aurum.spawn_realm") or "aurum:aurum"
function aurum.player.spawn_realm(player)
	-- If the player has a spawn point, do nothing.
	if minetest.string_to_pos(player:get_meta():get_string("aurum_player:spawnpoint")) then
		return false
	elseif minetest.string_to_pos(minetest.settings:get("static_spawnpoint")) then
		player:set_pos(minetest.string_to_pos(minetest.settings:get("static_spawnpoint")))
		return true
	else
		-- Teleport to the realm spawn point.
		if aurum.realms.get_spawn_cache.stored[realm_spawn] then
			-- If the point is cached, just teleport.
			aurum.player.teleport(player, aurum.realms.get_spawn(realm_spawn))
		else
			-- If the point is not cached, teleport to the next best thing with a waiting message, then generate, cache, and teleport.
			show_spawn_fs(player)
			aurum.player.teleport(player, aurum.realms.get_spawn_cache.f(realm_spawn))
			aurum.player.teleport_guarantee(player, b.box.new_add(aurum.realms.get_spawn_prelim(realm_spawn), vector.new(0, 150, 0)), function(player)
				aurum.player.teleport(player, aurum.realms.get_spawn(realm_spawn))
				close_spawn_fs(player)
			end)
		end
		return true
	end
end

minetest.register_on_player_receive_fields(function(player, formname)
	if formname == "aurum_player:spawn" then
		if spawning[player:get_player_name()] then
			show_spawn_fs(player)
		end
		return true
	end
end)

-- If no static spawn is set, respawn in the spawn realm.
if not minetest.settings:get("static_spawnpoint") then
	minetest.register_on_newplayer(aurum.player.spawn_realm)
	minetest.register_on_respawnplayer(aurum.player.spawn_realm)
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
