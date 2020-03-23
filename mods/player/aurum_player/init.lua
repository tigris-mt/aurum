aurum.player = {}

b.dofile("death.lua")
b.dofile("hp.lua")
b.dofile("realm.lua")
b.dofile("spawn.lua")

-- "Void" damage.
local timer = 0
minetest.register_globalstep(function(dtime)
	timer = timer + dtime
	if timer > 5 then
		timer = 0

		for _,player in ipairs(minetest.get_connected_players()) do
			if not screalms.pos_to_realm(player:get_pos()) and not minetest.check_player_privs(player, "noclip") then
				if player:get_hp() > 0 then
					player:set_hp(0)
				end
			end
		end
	end
end)

-- Drop mana sparks in the world. May be influenced by equipment.
-- If <max> is omitted, <min> will be used.
-- Reasons: digging, smelting, killing
function aurum.player.mana_sparks(player, pos, reason, min, max)
	xmana.sparks(pos, math.random(min, max or min), player:get_player_name())
end
