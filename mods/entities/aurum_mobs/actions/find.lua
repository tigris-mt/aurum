-- TODO: Find only pathable nodes.
function aurum.mobs.helper_find_nodes(self, event, nodenames)
	local ent = self.entity
	local box = b.box.new_radius(ent.object:get_pos(), aurum.mobs.SEARCH_RADIUS)
	local nodes = minetest.find_nodes_in_area_under_air(box.a, box.b, nodenames)
	if #nodes > 0 then
		self:fire_event(event, {target = {
			type = "pos",
			pos = nodes[math.random(#nodes)],
		}})
	end
end

-- Find a habitat target node.
gemai.register_action("aurum_mobs:find_habitat", function(self)
	aurum.mobs.helper_find_nodes(self, "found_habitat", self.data.habitat_nodes)
end)

-- Find a random target node.
gemai.register_action("aurum_mobs:find_random", function(self)
	local y = 0
	if self.data.movement ~= "walk" then
		y = math.random(-aurum.mobs.SEARCH_RADIUS, aurum.mobs.SEARCH_RADIUS)
	end
	self:fire_event("found_random", {target = {
		type = "pos",
		pos = vector.add(self.entity.object:get_pos(), vector.new(math.random(-aurum.mobs.SEARCH_RADIUS, aurum.mobs.SEARCH_RADIUS), y, math.random(-aurum.mobs.SEARCH_RADIUS, aurum.mobs.SEARCH_RADIUS))),
	}})
end)
