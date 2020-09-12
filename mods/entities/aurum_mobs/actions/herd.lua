gemai.register_action("aurum_mobs:alert_herd", function(self)
	for _,object in ipairs(minetest.get_objects_inside_radius(self.entity.object:get_pos(), aurum.mobs.SEARCH_RADIUS)) do
		if object ~= self.entity.object and aurum.mobs.helper_same_herd(self, object) then
			local mob = aurum.mobs.get_mob(object)
			local target = aurum.mobs.helper_target_entity(self, self.data.params.target)
			if mob and (not target or not aurum.mobs.helper_same_herd(mob, target)) then
				mob:fire_event("herd_alerted", self.data.params)
			end
		end
	end
end)

minetest.register_on_punchplayer(function(player, puncher)
	local ref_table = aurum.get_blame(puncher) or b.ref_to_table(puncher)
	if ref_table then
		for _,object in ipairs(minetest.get_objects_inside_radius(player:get_pos(), aurum.mobs.SEARCH_RADIUS)) do
			local mob = aurum.mobs.get_mob(object)
			if mob and mob.data.herd == "player:" .. player:get_player_name() then
				mob:fire_event("herd_alerted", {
					other = ref_table,
					target = {
						type = "ref_table",
						ref_table = ref_table,
					},
				})
			end
		end
	end
end)
