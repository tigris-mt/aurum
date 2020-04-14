local function can_mate(self)
	return math.ceil(self.data.eat.satiation) >= self.data.eat.max_satiation
end

local function get_mate(self)
	local target, type = aurum.mobs.helper_target_entity(self, self.data.params.target)
	return (target and type == "aurum_mob") and target:get_luaentity()._gemai or nil
end

gemai.register_action("aurum_mobs:find_mate", function(self)
	if can_mate(self) then
		for _,object in ipairs(minetest.get_objects_inside_radius(self.entity.object:get_pos(), aurum.mobs.SEARCH_RADIUS)) do
			if object:get_luaentity() and object:get_luaentity().name == self.entity.name and object:get_luaentity()._aurum_mobs_id ~= self.entity._aurum_mobs_id then
				local mob = object:get_luaentity()._gemai
				if can_mate(mob) then
					self:fire_event("found_mate", {
						target = {
							type = "ref_table",
							ref_table = b.ref_to_table(object),
						},
					})
					return
				end
			end
		end
	end
end)

gemai.register_action("aurum_mobs:check_mate", function(self)
	local target = get_mate(self)
	if not target or not can_mate(target) or not can_mate(self) then
		self:fire_event("lost_mate")
	end
end)

gemai.register_action("aurum_mobs:mate", function(self)
	local target = get_mate(self)
	if target then
		self.data.eat.satiation = 0
		target.data.eat.satiation = 0
		aurum.mobs.spawn(vector.round(self.entity.object:get_pos()), self.entity.name)
		self:fire_event("done_mate")
	end
end)
