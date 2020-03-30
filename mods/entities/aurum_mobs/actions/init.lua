-- How far should mobs search for objectives?
aurum.mobs.SEARCH_RADIUS = 32

function aurum.mobs.helper_ref_entity(self, ref_table)
	if ref_table.type == "player" then
		return minetest.get_player_by_name(ref_table.id)
	elseif ref_table.type == "aurum_mob" then
		for _,object in ipairs(minetest.get_objects_inside_radius(self.entity.object:get_pos(), aurum.mobs.SEARCH_RADIUS)) do
			if object:get_luaentity() and object:get_luaentity()._aurum_mobs_id == ref_table.id then
				return object
			end
		end
	end
end

function aurum.mobs.helper_target_entity(self, target)
	if target.type == "ref_table" then
		return aurum.mobs.helper_ref_entity(self, target.ref_table), target.ref_table.type
	end
end

function aurum.mobs.helper_target_pos(self, target)
	self:assert(target, "invalid target")
	if target.type == "pos" then
		return target.pos
	elseif target.type == "ref_table" then
		local obj = aurum.mobs.helper_target_entity(self, target)
		if obj then
			return obj:get_pos()
		end
	else
		self:assert(false, "Invalid target type: " .. target.type)
	end
end

function aurum.mobs.helper_can_see(self, object)
	return minetest.line_of_sight(self.entity.object:get_pos(), object:get_pos()) or minetest.line_of_sight(self.entity.object:get_pos(), vector.add(object:get_pos(), vector.new(0, 1, 0)))
end

aurum.mobs.initial_data.base_speed = 1

function aurum.mobs.helper_mob_speed(self)
	local speed = self.data.base_speed
	if self.data.adrenaline.value >= self.data.live_time then
		speed = speed * 2
	end
	return speed
end

function aurum.mobs.helper_move(self)
	self.data.moves = self.data.moves + self.data.step_time * aurum.mobs.helper_mob_speed(self)

	local whole = math.floor(self.data.moves)
	self.data.moves = self.data.moves - whole
	return whole
end

function aurum.mobs.helper_set_pos(self, pos, keep_path)
	if not keep_path then
		self.data.go.path = false
	end
	self.entity.object:set_pos(pos)
end
