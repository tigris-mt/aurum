aurum.mobs.initial_data.attack = {
	damage = {blade = 2},
	moves = 0,
	speed = 1,
	distance = 2,
	effects = {},
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

	self.data.attack.moves = self.data.attack.moves + self.data.step_time * self.data.attack.speed

	local whole = math.floor(self.data.attack.moves)
	self.data.attack.moves = self.data.attack.moves - whole
	for _=1,whole do
		target:punch(self.entity.object, 1, {
			full_punch_interval = 1.0,
			damage_groups = self.data.attack.damage,
		})

		for name,def in pairs(self.data.attack.effects) do
			aurum.effects.add(target, name, def.level, def.duration)
		end
	end
end)
