local S = minetest.get_translator()

aurum.magic.register_spell("extinguish", {
	description = S"Extinguish",
	longdesc = S"Snuffs out fire in a cube with a radius of the spell's level.",

	apply = function(pointed_thing, level, player)
		local pos = vector.round(minetest.get_pointed_thing_position(pointed_thing) or player:get_pos())

		for _,pos in ipairs(minetest.find_nodes_in_area(vector.subtract(pos, level), vector.add(pos, level), "fire:basic_flame")) do
			minetest.remove_node(pos)
		end

		return true
	end,
})

aurum.magic.register_spell("growth", {
	description = S"Growth",
	longdesc = S"Forces a plant to mature immediately. Higher levels make a plant go through more stages of growth at a time.",

	apply_requirements = function(pointed_thing, _, player)
		local pos = minetest.get_pointed_thing_position(pointed_thing)
		return pointed_thing.type == "node" and minetest.get_item_group(minetest.get_node(pos).name, "grow_plant") > 0 and not aurum.is_protected(pos, player)
	end,

	apply = function(pointed_thing, level, player)
		local pos = minetest.get_pointed_thing_position(pointed_thing)
		for i=1,level do
			local node = minetest.get_node(pos)
			if minetest.get_item_group(node.name, "grow_plant") > 0 then
				if not minetest.registered_nodes[node.name]._on_grow_plant(pos, node) then
					break
				end
			else
				break
			end
		end
	end,
})
