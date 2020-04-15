-- When should a mob be considered "at" its objective?
local NEAR = 2

b.t.merge(aurum.mobs.initial_data, {
	moves = 0,
	pathfinder = aurum.mobs.DEFAULT_PATHFINDER,
})

-- Random offset so mobs are not always exactly in the center of a node.
local function roff()
	return (math.random() - 0.5) / 2
end

function aurum.mobs.helper_acceptable_node(pos)
	return not minetest.registered_nodes[minetest.get_node(pos).name].walkable
end

function aurum.mobs.helper_go(invert)
	return function(self)
		-- TODO: Implement fleeing.
		if invert then
			self:fire_event("lost")
			return
		end

		-- Get the positions.
		local pos = vector.round(self.entity.object:get_pos())
		local target_pos = aurum.mobs.helper_target_pos(self, self.data.params.target)
		if not target_pos or vector.distance(pos, target_pos) > aurum.mobs.SEARCH_RADIUS then
			self:fire_event("lost")
			return
		end

		-- Try to move to the node above the target.
		local target = vector.round(vector.add(target_pos, vector.new(0, 1, 0)))
		local target_hash = minetest.hash_node_position(target)

		local function reached()
			return vector.length(vector.subtract(target, pos)) < NEAR
		end

		-- If we're close enough and not fleeing, fire reached.
		if reached() and not invert then
			self:fire_event("reached", self.data.params)
		else
			local go = self.entity._go
			-- Rebuild the path if there was no path or the target changed.
			if not go.path or go.target ~= target_hash then
				go.target = target_hash
				go.path = b.pathfinder.path(b.t.combine(self.data.pathfinder, {from = pos, to = target}))
			end

			-- If no path was found, we're stuck.
			if not go.path then
				self:fire_event("stuck")
				return
			end

			-- Use our move points to move through the path.
			for _=1,aurum.mobs.helper_move(self) do
				local next_pos = go.path:next()
				if next_pos and aurum.mobs.helper_acceptable_node(next_pos)then
					aurum.mobs.helper_set_pos(self, vector.add(next_pos, vector.new(roff(), 0, roff())), true)
				-- No next position, but we've reached our destination...
				elseif reached() then
					go.path = nil
					self:fire_event("reached", self.data.params)
					return
				else
					self:fire_event("stuck")
					return
				end
			end
		end
	end
end

-- Travel toward target.
gemai.register_action("aurum_mobs:go", aurum.mobs.helper_go(false))
-- Escape from target.
gemai.register_action("aurum_mobs:flee", aurum.mobs.helper_go(true))
