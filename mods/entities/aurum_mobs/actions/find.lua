-- Parent ref table.
aurum.mobs.initial_data.parent = nil

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
		return true
	end
	return false
end

-- Find the mob's parent (within SEARCH_RADIUS * 2).
gemai.register_action("aurum_mobs:find_parent", function(self)
	if self.data.parent then
		local object = aurum.mobs.helper_ref_entity(self, self.data.parent)
		if object and vector.distance(self.entity.object:get_pos(), object:get_pos()) < aurum.mobs.SEARCH_RADIUS * 2 then
			self:fire_event("found_parent", {
				target = {
					type = "ref_table",
					ref_table = self.data.parent,
				},
			})
		end
	end
end)

-- Find a habitat target node.
gemai.register_action("aurum_mobs:find_habitat", function(self)
	aurum.mobs.helper_find_nodes(self, "found_habitat", self.data.habitat_nodes)
end)

gemai.register_action("aurum_mobs:find_habitat_prio", function(self)
	for _,node in ipairs(self.data.habitat_nodes) do
		if aurum.mobs.helper_find_nodes(self, "found_habitat", {node}) then
			break
		end
	end
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
