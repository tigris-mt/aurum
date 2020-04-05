local S = minetest.get_translator()

awards.register_award("aurum_awards:join", {
	title = S"The Titan Cometh in Power",
	description = S"Make your arrival in the world of Aurum.",
})

minetest.register_on_joinplayer(function(player)
	awards.unlock(player:get_player_name(), "aurum_awards:join")
end)
