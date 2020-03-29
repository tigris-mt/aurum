aurum.mobs.initial_data.food = {}

local function has_food(player, mob)
	for _,v in ipairs(mob.data.food) do
		if aurum.match_item(player:get_wielded_item():get_name(), v) then
			return true
		end
	end
	return false
end

gemai.register_action("aurum_mobs:find_food", function(self)
	for _,obj in ipairs(minetest.get_objects_inside_radius(self.entity.object:get_pos(), aurum.mobs.SEARCH_RADIUS)) do
		if obj:is_player() then
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
end)

gemai.register_action("aurum_mobs:check_target_food", function(self)
	local player = aurum.mobs.helper_target_entity(self, self.data.params.target)
	if not player or not has_food(player, self) then
		self:fire_event("lost_food")
	end
end)
