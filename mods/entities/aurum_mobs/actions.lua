local GRAVITY = vector.new(0, -9.8, 0)
local NEAR = 2
local SEARCH_RADIUS = 8

function aurum.mobs.helper_find_nodes(self, nodenames)
	local ent = self.entity
	local box = aurum.box.new_radius(ent.object:get_pos(), SEARCH_RADIUS)
	local nodes = minetest.find_nodes_in_area_under_air(box.a, box.b, nodenames)
	if #nodes > 0 then
		self:fire_event("found", {target_pos = nodes[math.random(#nodes)]})
	end
end

gemai.register_action("aurum_mobs:go_place", function(self)
	local pos = self.entity.object:get_pos()
	local target = vector.add(self:assert(self.data.params.target_pos, "invalid target_pos"), vector.new(0, 1, 0))
	local delta = vector.subtract(target, pos)

	if vector.length(delta) < NEAR then
		self:fire_event("reached", {target_pos = self.data.params.target_pos})
	else
		local dir = vector.normalize(delta)
		local vel = vector.multiply(dir, vector.new(3, 0, 3))
		vel.y = self.entity.object:get_velocity().y

		local function solid(pos)
			local n = minetest.registered_nodes[minetest.get_node(pos).name]
			return n.walkable
		end

		if solid(vector.add(pos, vector.new(vel.x, 0, vel.z))) and solid(vector.add(pos, vector.new(0, -1, 0))) then
			vel.y = 4
		end

		self.entity.object:set_velocity(vel)
	end
end)

gemai.register_action("aurum_mobs:find_habitat", function(self)
	aurum.mobs.helper_find_nodes(self, self.entity._aurum_mob.habitat_nodes)
end)

gemai.register_action("aurum_mobs:physics", function(self)
	self.entity.object:set_acceleration(GRAVITY)
end)
