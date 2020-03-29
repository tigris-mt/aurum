aurum.mobs.initial_data.attack = {
	damage = {blade = 2},
	moves = 0,
	speed = 1,
	time = 0,
	distance = 2,
}

gemai.register_action("aurum_mobs:attack", function(self)
	local target = aurum.mobs.helper_target_entity(self, self.data.params.target)
	if not target then
		self:fire_event("lost")
		return
	end

	if vector.distance(target:get_pos(), self.entity.object:get_pos()) > self.data.attack.distance then
		self:fire_event("noreach", self.data.params)
		return
	end

	self.data.attack.moves = ((self.data.state_time - self.data.attack.time > 5) and 0 or self.data.attack.moves) + self.data.step_time * self.data.attack.speed
	self.data.attack.time = self.data.state_time

	local whole = math.floor(self.data.attack.moves)
	self.data.attack.moves = self.data.attack.moves - whole
	for _=1,whole do
		target:punch(self.entity.object, 1, {
			full_punch_interval = 1.0,
			damage_groups = self.data.attack.damage,
		})
	end
end)
