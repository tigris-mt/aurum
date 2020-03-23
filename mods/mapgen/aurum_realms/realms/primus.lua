local S = minetest.get_translator()

screalms.register("aurum:primus", {
	description = S"Primus Hortum",
	size = vector.new(16000, 1600, 16000),

	apply_player = function(player)
		player:set_sky("#336633", "plain", {})
		player:set_clouds{
			color = "#004400bb",
			speed = {x = 0, z = -4},
			thickness = 32,
			density = 0.6,
			height = 400,
		}

		screalms.apply_underground(player)
	end,
})

-- Spreading fire is snuffed out in Primus Hortum.
local old = fire.on_spread
function fire.on_spread(pos)
	if screalms.pos_to_realm(pos) == "aurum:primus" then
		local box = b.box.new_radius(pos, 3)
		for _,fpos in ipairs(minetest.find_nodes_in_area(box.a, box.b, "fire:basic_flame")) do
			minetest.remove_node(fpos)
		end
	end
	old(pos)
end
