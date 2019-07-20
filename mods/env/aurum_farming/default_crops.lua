local S = minetest.get_translator()

aurum.farming.register_crop("aurum_farming:carrot", {
	texture = "aurum_farming_carrot",
	description = S"Carrot",
	max = 3,

	seed = {},
	product = {
		on_use = minetest.item_eat(2),
	},

	drops = function(i)
		if i == 3 then
			return {
				items = {
					{items = {"aurum_farming:carrot_product"}, rarity = 1},
					{items = {"aurum_farming:carrot_seed"}, rarity = 1},
					{items = {"aurum_farming:carrot_seed"}, rarity = 2},
					{items = {"aurum_farming:carrot_seed"}, rarity = 5},
				},
			}
		elseif i == 2 then
			return {
				items = {
					{items = {"aurum_farming:carrot_product"}, rarity = 2},
					{items = {"aurum_farming:carrot_seed"}, rarity = 3},
				},
			}
		end
	end,
}, {
	place_on = {"group:soil"},
	noise_params = {
		offset = 0,
		scale = 0.01,
		spread = vector.new(50, 50, 50),
		seed = 526,
		octaves = 3,
		persist = 0.5,
	},
	biomes = aurum.biomes.get_all_group("green", {"base"}),
})
