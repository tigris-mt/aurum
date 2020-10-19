local S = aurum.get_translator()

screalms.register("aurum:ultimus", {
	description = S"Ultimus Hortum",
	size = vector.new(16000, 2048, 16000),
	y = 16000,
	aurum_default_spawn = vector.new(7, 2, 7),
	apply_player = function(player)
		player:set_sky("#330033", "plain", {})
		player:set_clouds{
			color = "#00000000",
		}
	end,
})

