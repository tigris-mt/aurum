aurum.mobs.initial_data.regen_rate = 1 / 5

gemai.register_action("aurum_mobs:regen", function(self)
	self.entity.object:set_hp(math.min(self.entity.object:get_properties().hp_max, self.entity.object:get_hp() + b.random_whole(self.data.step_time * self.data.regen_rate)))
end)
