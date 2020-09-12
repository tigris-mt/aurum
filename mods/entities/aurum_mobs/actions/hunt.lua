-- Empty table means all is valid.
aurum.mobs.initial_data.hunt_prey = {}

-- Consider xmana value when hunting.
aurum.mobs.initial_data.hunt_consider_xmana = true

gemai.register_action("aurum_mobs:find_prey", function(self)
	for _,object in b.t.ro_ipairs(minetest.get_objects_inside_radius(self.entity.object:get_pos(), aurum.mobs.SEARCH_RADIUS)) do
		if not aurum.mobs.helper_same_herd(self, object) then
			local mob, mob_name = aurum.mobs.get_mob(object)
			if mob and aurum.mobs.helper_can_see(self, object) and ((#self.data.hunt_prey == 0) or aurum.match_item_list(mob_name, self.data.hunt_prey)) then
				if (not self.data.hunt_consider_xmana or mob.data.xmana <= self.data.xmana) then
					self:fire_event("found_prey", {
						target = {
							type = "ref_table",
							ref_table = b.ref_to_table(object),
						},
					})
					return
				end
			elseif object:is_player() and aurum.mobs.helper_can_see(self, object) and ((#self.data.hunt_prey == 0) or aurum.match_item_list("player", self.data.hunt_prey)) then
				self:fire_event("found_prey", {
					target = {
						type = "ref_table",
						ref_table = b.ref_to_table(object),
					},
				})
				return
			end
		end
	end
end)
