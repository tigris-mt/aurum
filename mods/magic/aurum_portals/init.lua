local S = minetest.get_translator()
aurum.portals = {}

aurum.portals.min_delay = tonumber(minetest.settings:get("aurum.portals.min_delay")) or 5

local RADIUS = vector.new(16, 16, 16)

-- Convert <pos> in realm <from> to the proportional position in realm <to>.
function aurum.portals.relative_pos(from, to, pos)
	local from = aurum.realms.get(from)
	local to = aurum.realms.get(to)

	return aurum.gpos(to.id, vector.round(vector.multiply(aurum.rpos(from.id, pos), vector.divide(to.size, from.size))))
end

local base_def = {
	description = S"Portal Base",
	-- The flavor dust vanishes into another realm.
	_doc_items_longdesc = S"A slab of golden power. It is perfectly clean; dust vanishes upon touching it.",
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

	is_ground_content = false,
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
local last_teleport = {}

function aurum.portals.teleport(player, from_pos, to_realm)
	-- Check which realm we're teleporting from.
	local from_realm = aurum.pos_to_realm(from_pos)
	if not from_realm then
		minetest.log("warning", ("Invalid portal teleportation attempted at %s to %s by %s."):format(minetest.pos_to_string(from_pos), to_realm, player:get_player_name()))
		return
	end
	local rdef = aurum.realms.get(to_realm)

	local name = player:get_player_name()
	local key = ("%d %d %s"):format(
		minetest.hash_node_position(from_pos),
		minetest.hash_node_position(gnode_augment.players[name].nodes.stand_pos),
		to_realm
	)

	-- If we're already teleporting to the same place, do nothing.
	if teleporting[name] == key then
		return
	end

	-- Not enough time since last teleport.
	if minetest.get_gametime() - (last_teleport[name] or 0) < aurum.portals.min_delay then
		return
	end

	if teleporting[name] then
		aurum.info_message(player, S"Teleportation cancelled.")
	end

	aurum.info_message(player, S("Teleporting to @1...", rdef.description))
	teleporting[name] = key

	-- Find a landing point.
	local function landing_point(search)
		local pos = aurum.portals.relative_pos(from_realm, to_realm, from_pos)
		if search then
			local box = aurum.box.new_radius(pos, RADIUS)
			local poses = minetest.find_nodes_in_area(box.a, box.b, "aurum_portals:portal_" .. from_realm)
			-- There's an existing portal.
			if #poses > 0 then
				return poses[math.random(#poses)]
			-- Create a new portal.
			else
				local poses = aurum.box.poses(box, pos)
				for _,pos in ipairs(poses) do
					local node = minetest.get_node(pos)
					if aurum.is_air(node.name) or node.name == rdef.biome_default.node_stone then
						if not minetest.is_protected(pos, "") then
							minetest.set_node(pos, {name = "aurum_portals:portal_" .. from_realm})
							return pos
						end
					end
				end
			end

			-- No place to build portal.
			return nil
		end
		return pos
	end

	aurum.player.teleport_guarantee(player, aurum.box.new_radius(landing_point(), RADIUS), function(player)
		local pos = landing_point(true)
		if pos then
			aurum.player.teleport(player, vector.add(pos, vector.new(0, 0.5, 0)))
			aurum.info_message(player, S("Teleported to @1.", rdef.description))
		else
			aurum.info_message(player, S"No portal could be opened on the other side.")
		end
		teleporting[name] = nil
		last_teleport[name] = minetest.get_gametime()
	end, function(player)
		-- Recalculate key.
		local key = ("%d %d %s"):format(
			minetest.hash_node_position(from_pos),
			minetest.hash_node_position(gnode_augment.players[name].nodes.stand_pos),
			to_realm
		)

		if teleporting[name] ~= key then
			aurum.info_message(player, S"Teleportation cancelled.")
			teleporting[name] = nil
			return true
		end

		return false
	end)
end

minetest.register_on_leaveplayer(function(player)
	teleporting[player:get_player_name()] = nil
	last_teleport[player:get_player_name()] = nil
end)

function aurum.portals.register(realm, def)
	local rdef = aurum.realms.get(realm)

	local def = b.t.combine({
		color = "#FFFFFF",
		name = "aurum_portals:portal_" .. realm,
	}, def)

	def.node = b.t.combine(base_def, {
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

b.dofile("default_portals.lua")
