aurum.mobs.initial_data.milk = {
	value = 1,
	speed = 1 / 600,
}

gemai.register_action("aurum_mobs:regen_milk", function(self)
	self.data.milk.value = self.data.milk.value + self.data.step_time * self.data.milk.speed
end)

gemai.register_action("aurum_mobs:milk", function(self)
	if self.data.milk.value >= 1 then
		local other = self.data.params.other
		if other.type == "player" then
			local player = minetest.get_player_by_name(other.id)
			if player then
				local pos = vector.round(self.entity.object:get_pos())
				local wielded = player:get_wielded_item()
				if wielded:get_name() == "bucket:bucket_empty" then
					wielded:take_item()
					player:set_wielded_item(wielded)
					aurum.drop_item(player:get_pos(), player:get_inventory():add_item("main", "aurum_animals:bucket_milk"))

					self.data.milk.value = 0
					self:fire_event("milked")
				end
			end
		end
	end
end)
