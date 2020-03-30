-- State timeout.
local TIMEOUT = 15

gemai.register_action("aurum_mobs:timeout", function(self)
	if self.data.state_time > TIMEOUT then
		self:fire_event("timeout")
		return
	end
end)
