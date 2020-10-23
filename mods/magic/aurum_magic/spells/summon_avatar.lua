local S = aurum.get_translator()

local MANA = 200

aurum.magic.register_spell("summon_avatar", {
	description = S"Summon Avatar",
	max_level = 1,
	rod_cost = 1000,
	preciousness = 10,
	longdesc = table.concat({
		S"When used on a realm artifact in that realm; this spell will summon the avatar of that realm's Archon.",
		S("It consumes @1 mana.", MANA),
		S"It may be used on:",
		S"- A gravestone (Aurum)",
		S"- A hidden record (Primus Hortum)",
		S"- A law pillar (Ultimus Hortum)",
		S"- A fiendish mocking (The Loom)",
	}, "\n"),

	apply_requirements = function(pointed_thing, _, player)
		return xmana.mana(player) >= MANA
	end,

	apply = function(pointed_thing, _, player)
		if pointed_thing.type == "node" then
			local occur = ({
				["aurum_structures:gravestone"] = {mob = "aurum_npcs:avatar_headstoner", realm = "aurum:aurum"},
				["aurum_structures:hidden_record"] = {mob = "aurum_npcs:avatar_mors_vivi", realm = "aurum:primus"},
				["aurum_structures:fiendish_mocking"] = {mob = "aurum_npcs:avatar_decadence", realm = "aurum:loom"},
				["aurum_ultimus:glowing_obelisk"] = {mob = "aurum_npcs:avatar_caligula", realm = "aurum:ultimus"},
			})[(gtextitems.get_node(pointed_thing.under) or {}).id or minetest.get_node(pointed_thing.under).name] or {}

			return (function(mob)
				if mob and screalms.pos_to_realm(pointed_thing.above) == occur.realm and aurum.mobs.spawn(pointed_thing.above, mob) then
					xmana.mana(player, -MANA, true, "summon avatar spell")
					return true
				else
					return false
				end
			end)(occur.mob)
		end
		return false
	end,
})
