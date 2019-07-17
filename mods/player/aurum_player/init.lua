aurum.player = {}

aurum.dofile("death.lua")
aurum.dofile("hp.lua")

-- "Void" damage.
local timer = 0
minetest.register_globalstep(function(dtime)
	timer = timer + dtime
	if timer > 5 then
		timer = 0

		for _,player in ipairs(minetest.get_connected_players()) do
			if not aurum.pos_to_realm(player:get_pos()) then
				if player:get_hp() > 0 then
					player:set_hp(0)
				end
			end
		end
	end
end)
