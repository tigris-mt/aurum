local S = aurum.get_translator()

awards.register_award("aurum_awards:join", {
	title = S"The Titan is Here",
	description = S"Arrive in the world of Aurum.",
	icon = minetest.registered_items["aurum_scrolls:scroll_full"].inventory_image,
	sound = false,
})

minetest.register_on_joinplayer(function(player)
	awards.unlock(player:get_player_name(), "aurum_awards:join")
end)
