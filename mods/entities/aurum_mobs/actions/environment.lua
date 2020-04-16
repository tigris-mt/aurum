local GRAVITY = math.abs(aurum.GRAVITY.y)

aurum.mobs.initial_data.gravity_moves = 0
function aurum.mobs.helper_gravity_move(self)
	self.data.gravity_moves = self.data.gravity_moves + self.data.step_time * GRAVITY

	local whole = math.floor(self.data.gravity_moves)
	self.data.gravity_moves = self.data.gravity_moves - whole
	return whole
end

-- Apply physics.
gemai.register_action("aurum_mobs:physics", function(self)
	if self.data.movement == "walk" then
		local pos = vector.round(self.entity.object:get_pos())
		local node = minetest.get_node(vector.add(pos, vector.new(0, -1, 0)))
		if not minetest.registered_nodes[node.name].walkable then
			for i=1,aurum.mobs.helper_gravity_move(self) do
				local below = vector.add(pos, vector.new(0, -i, 0))
				local node = minetest.get_node(below)
				if minetest.registered_nodes[node.name].walkable then
					return
				else
					aurum.mobs.helper_set_pos(self, below)
				end
			end
		end
	elseif self.data.movement == "swim" then
		local pos = vector.round(self.entity.object:get_pos())
		local node = minetest.get_node(pos)
		if (minetest.registered_nodes[node.name].liquidtype or "none") == "none" then
			for i=1,aurum.mobs.helper_gravity_move(self) do
				local below = vector.add(pos, vector.new(0, -i, 0))
				local node = minetest.get_node(below)
				if not minetest.registered_nodes[node.name].walkable then
					if (minetest.registered_nodes[node.name].liquidtype or "none") ~= "none" then
						aurum.mobs.helper_set_pos(self, below)
						return
					else
						aurum.mobs.helper_set_pos(self, below)
					end
				end
			end
		end
	end
end)

aurum.mobs.initial_data.node_damage_timer = 0

-- Apply environment.
gemai.register_action("aurum_mobs:environment", function(self)
	if self.data.node_damage_timer < self.data.live_time - 1 then
		local pos = vector.round(self.entity.object:get_pos())
		local node = minetest.get_node(pos)
		local ndef = minetest.registered_nodes[node.name]
		if (ndef.damage_per_second or 0) > 0 then
			self.entity.object:punch(self.entity.object, 1, {
				full_punch_interval = 1.0,
				damage_groups = {[ndef._damage_type or "generic"] = ndef.damage_per_second},
			})
		end
		if (self.data.movement == "swim" and not aurum.match_item_list(node.name, self.data.habitat_nodes)) or ndef.walkable then
			self.entity.object:punch(self.entity.object, 1, {
				full_punch_interval = 1.0,
				damage_groups = {drown = 5},
			})
		end
		self.data.node_damage_timer = self.data.live_time
	end
end)
