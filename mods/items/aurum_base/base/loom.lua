local S = aurum.get_translator()

minetest.register_node("aurum_base:regret", {
	description = S"Regret",
	_doc_items_longdesc = S"The stuff of the Loom. All old fears, lost hopes, failures, and corruptions are regrets of the world to be regurgitated into existence.",
	tiles = {"aurum_base_stone.png^[colorize:#440000:127"},
	sounds = aurum.sounds.stone(),
	groups = {dig_pick = 2, level = 2, cook_temp = 15, shapable = 1},
})
