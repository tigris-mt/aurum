aurum.mobs.initial_data.food = {}
aurum.mobs.initial_data.eat = {
	satiation = 0,
	max_satiation = 5,
	restore_hp = 0.1,
	satiation_reduction = 1 / 300,
}

local function has_food(player, mob)
	for _,v in ipairs(mob.data.food) do
		if aurum.match_item(player:get_wielded_item():get_name(), v) then
			return true
		end
	end
	return false
end

gemai.register_action("aurum_mobs:find_food", function(self)
	if self.data.eat.satiation < self.data.eat.max_satiation then
		for _,obj in b.t.ro_ipairs(minetest.get_objects_inside_radius(self.entity.object:get_pos(), aurum.mobs.SEARCH_RADIUS)) do
			if obj:is_player() and aurum.mobs.helper_can_see(self, obj) then
				if has_food(obj, self) then
					self:fire_event("found_food", {
						target = {
							type = "ref_table",
							ref_table = gemai.ref_to_table(obj),
						},
					})
					return
				end
			end
		end
	end
end)

gemai.register_action("aurum_mobs:check_target_food", function(self)
	local player = aurum.mobs.helper_target_entity(self, self.data.params.target)
	if not player or not has_food(player, self) then
		self:fire_event("lost_food")
	end
end)

gemai.register_action("aurum_mobs:reduce_satiation", function(self)
	self.data.eat.satiation = math.max(0, self.data.eat.satiation - self.data.eat.satiation_reduction * self.data.step_time)
end)

gemai.register_action("aurum_mobs:eat_hand", function(self)
	if self.data.eat.satiation < self.data.eat.max_satiation then
		local player = aurum.mobs.helper_ref_entity(self, self.data.params.other)
		if player and player:is_player() then
			if has_food(player, self) then
				local wielded = player:get_wielded_item()
				wielded:take_item()
				player:set_wielded_item(wielded)

				self.data.eat.satiation = self.data.eat.satiation + 1
				self.entity.object:set_hp(math.ceil(self.entity.object:get_hp() + self.entity.object:get_hp() * self.data.eat.restore_hp))
				self:fire_event("ate")
			end
		end
	end
end)
