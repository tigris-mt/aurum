-- Empty table means all is valid.
aurum.mobs.initial_data.hunt_prey = {}

gemai.register_action("aurum_mobs:find_prey", function(self)
	for _,object in b.t.ro_ipairs(minetest.get_objects_inside_radius(self.entity.object:get_pos(), aurum.mobs.SEARCH_RADIUS)) do
		if object:get_luaentity() and object:get_luaentity()._aurum_mobs_id and object:get_luaentity()._aurum_mobs_def.herd ~= self.entity._aurum_mobs_def.herd and aurum.mobs.helper_can_see(self, object) and ((#self.data.hunt_prey == 0) or aurum.match_item_list(object:get_luaentity().name, self.data.hunt_prey)) then
			local mob = object:get_luaentity()._gemai
			if mob.data.xmana <= self.data.xmana then
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
end)
