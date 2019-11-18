-- When should a mob be considered "at" its objective?
local NEAR = 1.5
-- How far should mobs search for objectives?
local SEARCH_RADIUS = 12
-- State timeout.
local TIMEOUT = 15

function aurum.mobs.helper_target_pos(self, target)
	self:assert(target, "invalid target")
	if target.type == "pos" then
		return target.pos
	else
		self:assert(false, "Invalid target type: " .. target.type)
	end
end

function aurum.mobs.helper_find_nodes(self, nodenames)
	local ent = self.entity
	local box = aurum.box.new_radius(ent.object:get_pos(), SEARCH_RADIUS)
	local nodes = minetest.find_nodes_in_area_under_air(box.a, box.b, nodenames)
	if #nodes > 0 then
		self:fire_event("found", {target = {
			type = "pos",
			pos = nodes[math.random(#nodes)],
		}})
	end
end

gemai.register_action("aurum_mobs:go", function(self)
	local pos = self.entity.object:get_pos()
	local target = vector.add(aurum.mobs.helper_target_pos(self, self.data.params.target), vector.new(0, 1, 0))
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

		local blocked = solid(vector.add(pos, vector.new(vel.x, 0, vel.z)))
		if blocked then
			local fok = not solid(vector.add(pos, vector.new(vel.x, 1, vel.z))) and not solid(vector.add(pos, vector.new(vel.x, 2, vel.z)))
			local aok = not solid(vector.add(pos, vector.new(0, 1, 0))) and not solid(vector.add(pos, vector.new(0, 2, 0)))
			if solid(vector.add(pos, vector.new(0, -1, 0))) and fok and aok then
				vel.y = 6
			else
				self:fire_event("stuck")
				return
			end
		end

		self.entity.object:set_velocity(vel)
	end

	if self.data.state_time > TIMEOUT then
		self:fire_event("timeout")
		return
	end
end)

gemai.register_action("aurum_mobs:find_habitat", function(self)
	aurum.mobs.helper_find_nodes(self, self.entity._aurum_mob.habitat_nodes)
end)

gemai.register_action("aurum_mobs:find_random", function(self)
	self:fire_event("found", {target = {
		type = "pos",
		pos = vector.add(self.entity.object:get_pos(), vector.new(math.random(-SEARCH_RADIUS, SEARCH_RADIUS), 0, math.random(-SEARCH_RADIUS, SEARCH_RADIUS))),
	}})
end)

gemai.register_action("aurum_mobs:physics", function(self)
	self.entity.object:set_acceleration(aurum.GRAVITY)
end)
