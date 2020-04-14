gemai.register_action("aurum_mobs:alert_herd", function(self)
	for _,object in ipairs(minetest.get_objects_inside_radius(self.entity.object:get_pos(), aurum.mobs.SEARCH_RADIUS)) do
		if object:get_luaentity() and object:get_luaentity()._aurum_mobs_id and object:get_luaentity()._aurum_mobs_def.herd == self.entity._aurum_mobs_def.herd and object:get_luaentity()._aurum_mobs_id ~= self.entity._aurum_mobs_id then
			local mob = object:get_luaentity()._gemai
			mob:fire_event("herd_alerted", self.data.params)
		end
	end
end)
