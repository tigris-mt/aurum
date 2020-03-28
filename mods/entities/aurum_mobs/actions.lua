local GRAVITY = math.abs(aurum.GRAVITY.y)
-- When should a mob be considered "at" its objective?
local NEAR = 1.5
-- How far should the pathfinder search from endpoints?
local PATH_SEARCH = 48
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
	local box = b.box.new_radius(ent.object:get_pos(), SEARCH_RADIUS)
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

function aurum.mobs.helper_move(self)
	self.data.moves = self.data.moves + self.data.step_time * aurum.mobs.helper_mob_speed(self)

	local whole = math.floor(self.data.moves)
	self.data.moves = self.data.moves - whole
	return whole
end

function aurum.mobs.helper_set_pos(self, pos, keep_path)
	if not keep_path then
		self.data.go.path = false
	end
	self.entity.object:set_pos(pos)
end

function aurum.mobs.helper_go(invert)
	return function(self)
		-- TODO: Implement fleeing.
		if invert then
			self:fire_event("lost")
			return
		end

		local pos = vector.round(self.entity.object:get_pos())
		local target_pos = aurum.mobs.helper_target_pos(self, self.data.params.target)
		if not target_pos then
			self:fire_event("lost")
			return
		end
		local target = vector.round(vector.add(target_pos, vector.new(0, 1, 0)))
		local target_hash = minetest.hash_node_position(target)
		local delta = vector.subtract(target, pos)

		if vector.length(delta) < NEAR and not invert then
			self:fire_event("reached", self.data.params)
		else
			if not self.data.go.path or (self.data.state_time - self.data.go.time) > 3 or self.data.go.target ~= target_hash then
				self.data.go.target = target_hash
				self.data.go.path = minetest.find_path(pos, target, PATH_SEARCH, self.data.pathfinder_jump, self.data.pathfinder_drop)
				self.data.go.time = self.data.state_time
				self.data.go.index = 1
			end

			if not self.data.go.path then
				self:fire_event("stuck")
				return
			end

			local next = self.data.go.index + aurum.mobs.helper_move(self)
			for i=math.max(1, self.data.go.index),math.min(next, #self.data.go.path) do
				if i > self.data.go.index then
					aurum.mobs.helper_set_pos(self, self.data.go.path[i], true)
				end
			end
			self.data.go.index = next
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
	aurum.mobs.helper_find_nodes(self, self.data.habitat_nodes)
end)

-- Find a random target node.
gemai.register_action("aurum_mobs:find_random", function(self)
	self:fire_event("found", {target = {
		type = "pos",
		pos = vector.add(self.entity.object:get_pos(), vector.new(math.random(-SEARCH_RADIUS, SEARCH_RADIUS), 0, math.random(-SEARCH_RADIUS, SEARCH_RADIUS))),
	}})
end)

function aurum.mobs.helper_gravity_move(self)
	self.data.gravity_moves = self.data.gravity_moves + self.data.step_time * GRAVITY

	local whole = math.floor(self.data.gravity_moves)
	self.data.gravity_moves = self.data.gravity_moves - whole
	return whole
end

-- Apply physics.
gemai.register_action("aurum_mobs:physics", function(self)
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
end)

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
		self.data.node_damage_timer = self.data.live_time
	end
end)
