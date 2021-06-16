local S = aurum.get_translator()

screalms.register("aurum:primus", {
	description = S"Primus Hortum",
	size = vector.new(16000, 2048, 16000),

	apply_player = function(player)
		player:set_sky{
			type = "plain",
			base_color = "#336633",
		}

		player:set_clouds{
			color = "#004400bb",
			speed = {x = 0, z = -4},
			thickness = 32,
			density = 0.6,
			height = 400,
		}

		player:set_sun{
			sunrise_visible = false,
		}

		screalms.apply_underground(player)
	end,

	aurum_dungeon_loot = function(pos)
		return {
			count = math.random(1, 2),
			list = {
				{
					count = math.random(1, 2),
					preciousness = {0, 5},
					groups = {"raw_food", "seed", "raw"},
				},
			},
		}
	end,
})

-- Spreading fire is snuffed out in Primus Hortum.
local old = fire.on_spread
function fire.on_spread(pos, ...)
	if screalms.pos_to_realm(pos) == "aurum:primus" then
		local box = b.box.new_radius(pos, 3)
		for _,fpos in ipairs(minetest.find_nodes_in_area(box.a, box.b, "fire:basic_flame")) do
			minetest.remove_node(fpos)
		end
	end
	old(pos, ...)
end
