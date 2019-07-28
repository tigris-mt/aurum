local S = minetest.get_translator()
aurum.portals = {}

function aurum.portals.relative_pos(from, to, pos)
	local from = aurum.realms.get(from)
	local to = aurum.realms.get(to)

	return vector.round(vector.multiply(pos, vector.divide(to.size, from.size)))
end

local base_def = {
	description = S"Portal Base",
	_doc_items_longdesc = S"A slab of golden power. It is perfectly clean, for dust vanishes upon touching it.",
	tiles = {"aurum_portals_base.png"},

	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, -0.1, 0.5},
		},
	},

	paramtype = "light",
	light_source = 3,
	sunlight_propagates = true,

	groups = {dig_pick = 2, level = 2},
	sounds = aurum.sounds.metal(),

	drop = "aurum_portals:base",
}
minetest.register_node("aurum_portals:base", base_def)

minetest.register_craft{
	output = "aurum_portals:base",
	recipe = {
		{"aurum_ore:gold_ingot", "aurum_ore:gold_ingot", "aurum_ore:gold_ingot"},
		{"aurum_ore:iron_ingot", "aurum_ore:mana_bean", "aurum_ore:iron_ingot"},
		{"aurum_ore:gold_ingot", "aurum_ore:gold_ingot", "aurum_ore:gold_ingot"},
	},
}

local teleporting = {}

function aurum.portals.teleport(player, from_pos, to_realm)
	local rdef = aurum.realms.get(to_realm)

	local name = player:get_player_name()
	local key = ("%d %d %s"):format(
		minetest.hash_node_position(from_pos),
		minetest.hash_node_position(gnode_augment.players[name].nodes.stand_pos),
		to_realm
	)

	if teleporting[name] == key then
		return
	end

	if teleporting[name] then
		aurum.info_message(player, S"Teleportation cancelled.")
	end

	aurum.info_message(player, S("Teleporting to @1...", rdef.description))
	teleporting[name] = key

	aurum.player.teleport_guarantee(player, aurum.box.new_add(aurum.realms.get_spawn(to_realm), vector.new(0, 150, 0)), function(player)
		aurum.player.teleport(player, aurum.realms.get_spawn(to_realm))
		aurum.info_message(player, S("Teleported to @1.", rdef.description))
		teleporting[name] = nil
	end, function(player)
		-- Recalculate key.
		local key = ("%d %d %s"):format(
			minetest.hash_node_position(from_pos),
			minetest.hash_node_position(gnode_augment.players[name].nodes.stand_pos),
			to_realm
		)

		if teleporting[name] ~= key then
			aurum.info_message(player, S"Teleportation cancelled.")
			return true
		end

		return false
	end)
end

minetest.register_on_leaveplayer(function(player)
	teleporting[player:get_player_name()] = nil
end)

function aurum.portals.register(realm, def)
	local rdef = aurum.realms.get(realm)

	local def = table.combine({
		color = "#FFFFFF",
		name = "aurum_portals:portal_" .. realm,
	}, def)

	def.node = table.combine(base_def, {
		description = S("Portal to @1", rdef.description),
		_doc_items_longdesc = S"The gateway to another realm.",
		_doc_items_usagehelp = S"Stand on the portal to be transported.",
		light_source = 13,
		tiles = {"aurum_portals_base.png^(aurum_portals_active.png^[colorize:" .. def.color .. ":127)"},

		_on_standing = function(pos, node, obj)
			if obj:is_player() then
				aurum.portals.teleport(obj, pos, realm)
			end
		end,
	}, def.node or {})

	minetest.register_node(":" .. def.name, def.node)
end

aurum.dofile("default_portals.lua")
