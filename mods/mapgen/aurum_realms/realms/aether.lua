local S = minetest.get_translator()

screalms.register("aurum:aether", {
	description = S"The Aether",
	size = vector.new(8000, 800, 8000),

	apply_player = function(player)
		local x = math.floor((math.sin(minetest.get_gametime() / 100) + 1) / 2 * 127) + 127
		player:set_sky{
			sky_color = {
				day_sky = ("#%x%xfa"):format(x, x),
				day_horizon = ("#%x%xfa"):format(x, x),
			},
		}
		player:set_clouds{
			speed = {x = 0, z = -40},
			color = ("#%02x%02x00e5"):format(x, x),
		}
		screalms.apply_underground(player)
	end,
})
