-- The mob will regenerate ~regen_rate hp per second. Can be negative.
aurum.mobs.initial_data.regen_rate = 1 / 5

gemai.register_action("aurum_mobs:regen", function(self)
	local object = self.entity.object
	local hp_max = object:get_properties().hp_max
	-- Regen is expressed in absolute HP change, convert to damage.
	local damage = -b.random_whole(self.data.step_time * self.data.regen_rate)
	-- Only punch if a change would be made.
	if math.abs(damage) > 0 and ((damage < 0 and object:get_hp() < hp_max) or (damage > 0) and object:get_hp() > 0) then
		-- Apply damage.
		object:punch(object, 1, {
			full_punch_interval = 1,
			damage_groups = {
				generic = damage,
			},
		})
		-- Ensure our HP stays within bounds.
		if damage < 0 then
			object:set_hp(math.min(hp_max, object:get_hp()))
		end
	end
end)
