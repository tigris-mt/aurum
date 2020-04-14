gprojectiles.register("aurum_npcs:ice_shot", {
	initial_properties = {
		collisionbox = {-0.1, -0.1, -0.1, 0.1, 0.1, 0.1},
		visual = "sprite",
		textures = {"aurum_magic_ice_shot.png"},
	},
	on_collide = function(self, thing)
		if thing.type == "object" then
			aurum.mobs.helper_do_attack(self.object, self.data.attack, thing.ref)
			self:cancel()
		elseif thing.type == "node" then
			local nn = minetest.get_node(thing.under).name
			local def = minetest.registered_items[nn]
			if def then
				if minetest.get_item_group(nn, "water") > 0 then
					minetest.set_node(thing.under, {name = "aurum_base:ice"})
					self:cancel()
				elseif def.walkable or (def._liquidtype or "none") ~= "none" then
					self:cancel()
				end
			end
		end
	end,
})
