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
	elseif target.type == "ref_table" then
		if target.ref_table.type == "player" then
			local player = minetest.get_player_by_name(target.ref_table.id)
			return player and player:get_pos()
		elseif target.ref_table.type == "aurum_mob" then
			for _,object in ipairs(minetest.get_objects_inside_radius(self.entity.object:get_pos(), SEARCH_RADIUS)) do
				if object:get_luaentity() and object:get_luaentity()._aurum_mobs_id == target.ref_table.id then
					return object:get_pos()
				end
			end
		end
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

function aurum.mobs.helper_mob_speed(self)
	local speed = self.data.base_speed
	if self.data.adrenaline >= self.data.live_time then
		speed = speed * 2
	end
	return speed
end

function aurum.mobs.helper_go(invert)
	return function(self)
		local pos = self.entity.object:get_pos()
		local target_pos = aurum.mobs.helper_target_pos(self, self.data.params.target)
		if not target_pos then
			self:fire_event("lost")
			return
		end
		local target = vector.add(target_pos, vector.new(0, 1, 0))
		local delta = vector.subtract(target, pos)

		if vector.length(delta) < NEAR and not invert then
			self:fire_event("reached", self.data.params)
		else
			local dir = vector.multiply(vector.normalize(delta), invert and -1 or 1)
			local vel = vector.multiply(dir, vector.multiply(vector.new(1, 0, 1), aurum.mobs.helper_mob_speed(self)))
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
	end
end

-- Travel toward target.
gemai.register_action("aurum_mobs:go", aurum.mobs.helper_go(false))
-- Escape from target.
gemai.register_action("aurum_mobs:flee", aurum.mobs.helper_go(true))

-- For adrenaline-inducing states.
gemai.register_action("aurum_mobs:adrenaline", function(self)
	if self.data.adrenaline - self.data.live_time > -self.data.adrenaline_cooldown then
		self.data.adrenaline = self.data.live_time + self.data.adrenaline_time
	end
end)

-- Find a habitat target node.
gemai.register_action("aurum_mobs:find_habitat", function(self)
	aurum.mobs.helper_find_nodes(self, self.entity._aurum_mob.habitat_nodes)
end)

-- Find a random target node.
gemai.register_action("aurum_mobs:find_random", function(self)
	self:fire_event("found", {target = {
		type = "pos",
		pos = vector.add(self.entity.object:get_pos(), vector.new(math.random(-SEARCH_RADIUS, SEARCH_RADIUS), 0, math.random(-SEARCH_RADIUS, SEARCH_RADIUS))),
	}})
end)

-- Apply physics.
gemai.register_action("aurum_mobs:physics", function(self)
	self.entity.object:set_acceleration(aurum.GRAVITY)
end)
