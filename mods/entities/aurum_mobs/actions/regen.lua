aurum.mobs.initial_data.regen_rate = 1 / 5

gemai.register_action("aurum_mobs:regen", function(self)
	local damage = -b.random_whole(self.data.step_time * self.data.regen_rate)
	if math.abs(damage) > 0 then
		self.entity.object:punch(self.entity.object, 1, {
			full_punch_interval = 1,
			damage_groups = {
				generic = damage,
			},
		})
		self.entity.object:set_hp(math.min(self.entity.object:get_properties().hp_max, self.entity.object:get_hp()))
	end
end)
