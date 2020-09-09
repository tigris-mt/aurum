local S = minetest.get_translator()

local MANA = 400

aurum.magic.register_spell("summon_avatar", {
	description = S"Summon Avatar",
	max_level = 1,
	rod_cost = 1000,
	longdesc = table.concat({
		S"When used on a realm artifact; this spell will summon the avatar of that realm's Archon.",
		S("It consumes @1 mana.", MANA),
		S"It may be used on:",
		S"- A gravestone (Aurum)",
		S"- A hidden record (Primus Hortum)",
		S"- A law pillar (Ultimus Hortum)",
		S"- A fiendish mocking (The Loom)",
		S"- A lesser throne (The Aether)",
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
			})[gtextitems.get_node(pointed_thing.under).id])
		end
		return false
	end,
})
