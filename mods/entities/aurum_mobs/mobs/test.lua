local S = minetest.get_translator()

aurum.mobs.register("test", {
	description = S"Test",
	gemai = {
		states = {
			init = {
				events = {
					init = "roam",
				},
			},

			roam = {
				actions = {
					"aurum_mobs:find_habitat",
				},
			},

			go_place = {
				actions = {
					"aurum_mobs:go_place",
				},

				events = {
					reached = "roam",
				},
			},
		},
	},
	habitat_nodes = {"group:soil", "group:sand"},
})
