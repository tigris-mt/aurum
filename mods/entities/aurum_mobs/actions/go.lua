-- When should a mob be considered "at" its objective?
local NEAR = 2
-- State timeout.
local TIMEOUT = 15

b.t.merge(aurum.mobs.initial_data, {
	moves = 0,
	go = {},
	pathfinder = aurum.mobs.DEFAULT_PATHFINDER,
})

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
				self.data.go.path = b.pathfinder.path(b.t.combine(self.data.pathfinder, {from = pos, to = target}))
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
