-- Find a habitat target node.
gemai.register_action("aurum_mobs:find_habitat", function(self)
	aurum.mobs.helper_find_nodes(self, "found_habitat", self.data.habitat_nodes)
end)

-- Find a random target node.
gemai.register_action("aurum_mobs:find_random", function(self)
	self:fire_event("found_random", {target = {
		type = "pos",
		pos = vector.add(self.entity.object:get_pos(), vector.new(math.random(-aurum.mobs.SEARCH_RADIUS, aurum.mobs.SEARCH_RADIUS), 0, math.random(-aurum.mobs.SEARCH_RADIUS, aurum.mobs.SEARCH_RADIUS))),
	}})
end)
