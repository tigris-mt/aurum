local S = aurum.get_translator()

gprojectiles.register("aurum_magic:ice_shot", {
	initial_properties = {
		collisionbox = {-0.1, -0.1, -0.1, 0.1, 0.1, 0.1},
		visual = "sprite",
		textures = {"aurum_magic_ice_shot.png"},
	},
	on_collide = function(self, thing)
		if thing.type == "object" then
			thing.ref:punch(self.object, 1, {
				full_punch_interval = 1,
				damage_groups = {pierce = 2 * self.data.level, chill = 4 + 3 * self.data.level},
			})
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

aurum.magic.register_spell("ice_shot", {
	description = S"Ice Shot",
	longdesc = S"Launches a powerful bolt of ice.",
	max_level = 3,

	apply = function(_, level, player)
		gprojectiles.spawn("aurum_magic:ice_shot", {
			blame = b.ref_to_table(player),
			gravity = aurum.GRAVITY,
			pos = vector.add(player:get_pos(), vector.new(0, player:get_properties().eye_height, 0)),
			velocity = vector.multiply(player:get_look_dir(), 15 + level * 5),
			skip_first = player,
			data = {
				level = level,
			},
		})
	end,
})

local ice_wall = {}
for _,pos in ipairs(b.box.poses(b.box.new(vector.new(-1, 0, -1), vector.new(1, 2, -1)))) do
	table.insert(ice_wall, {pos, "aurum_base:ice"})
end
aurum.magic.register_spell_ritual("ice_shot", {
	longdesc = S"Extracts the essence of ice into a weapon.",

	size = b.box.new(vector.new(-1, 0, -1), vector.new(1, 2, 0)),
	protected = true,

	recipe = b.t.icombine(ice_wall, {
		{vector.new(0, 1, 0), "aurum_storage:scroll_hole"},
	}),

	apply = function(at)
		if not aurum.magic.spell_ritual_inv(at(vector.new(0, 1, 0)), "main", "ice_shot", 3) then
			return false, S"There was nothing to bind the spell to."
		end

		for _,n in ipairs(ice_wall) do
			minetest.remove_node(at(n[1]))
		end

		return true
	end,
})
