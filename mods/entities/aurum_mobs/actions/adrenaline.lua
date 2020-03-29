-- For adrenaline-inducing states.
aurum.mobs.initial_data.adrenaline = {
	value = 0,
	time = 10,
	cooldown = 20,
}

gemai.register_action("aurum_mobs:adrenaline", function(self)
	if self.data.adrenaline.value - self.data.live_time > -self.data.adrenaline.cooldown then
		self.data.adrenaline.value = self.data.live_time + self.data.adrenaline.time
	end
end)
