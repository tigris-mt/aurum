aurum.mobs.initial_data.daylight = 13
aurum.mobs.initial_data.sun_damage = 2

gemai.register_action("aurum_mobs:light_switch", function(self)
	self:fire_event((minetest.get_node_light(self.entity.object:get_pos()) >= self.data.daylight) and "light_day" or "light_night")
end)

gemai.register_action("aurum_mobs:sunlight_damage", function(self)
	if minetest.get_node_light(self.entity.object:get_pos()) >= self.data.daylight then
		local d = self.data.sun_damage * self.data.step_time
		self.entity.object:punch(self.entity.object, 1, {
			full_punch_interval = 1,
			damage_groups = {burn = b.random_whole(d * 0.75), psyche = b.random_whole(d * 0.25)},
		})
	end
end)
