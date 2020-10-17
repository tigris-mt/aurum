local S = minetest.get_translator()

local MANA = 200

aurum.magic.register_spell("summon_avatar", {
	description = S"Summon Avatar",
	max_level = 1,
	rod_cost = 1000,
	preciousness = 10,
	longdesc = table.concat({
		S"When used on a realm artifact; this spell will summon the avatar of that realm's Archon.",
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
			return (function(mob)
				if mob and aurum.mobs.spawn(pointed_thing.above, mob) then
					xmana.mana(player, -MANA, true, "summon avatar spell")
					return true
				else
					return false
				end
			end)(({
				["aurum_structures:gravestone"] = "aurum_npcs:avatar_headstoner",
				["aurum_structures:hidden_record"] = "aurum_npcs:avatar_mors_vivi",
				["aurum_structures:fiendish_mocking"] = "aurum_npcs:avatar_decadence",
				["aurum_ultimus:glowing_obelisk"] = "aurum_npcs:avatar_caligula",
			})[gtextitems.get_node(pointed_thing.under).id or minetest.get_node(pointed_thing.under).name])
		end
		return false
	end,
})
