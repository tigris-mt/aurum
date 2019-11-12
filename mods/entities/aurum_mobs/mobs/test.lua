local S = minetest.get_translator()

aurum.mobs.register("test", {
	description = S"Test",
	gemai = {
		global_actions = {
			"aurum_mobs:physics",
		},

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

				events = {
					found = "go_place",
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
