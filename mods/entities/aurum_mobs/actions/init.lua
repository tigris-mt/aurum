-- How far should mobs search for objectives?
aurum.mobs.SEARCH_RADIUS = 32

function aurum.mobs.helper_mob_id_to_object(search_pos, search_radius, id)
	for _,object in ipairs(minetest.get_objects_inside_radius(search_pos, search_radius)) do
		if object:get_luaentity() and object:get_luaentity()._aurum_mobs_id == id then
			return object
		end
	end
end

function aurum.mobs.helper_ref_entity(self, ref_table)
	if ref_table.type == "player" then
		local player = minetest.get_player_by_name(ref_table.id)
		return (player and player:get_hp() > 0) and player or nil
	elseif ref_table.type == "aurum_mob" then
		return aurum.mobs.helper_mob_id_to_object(self.entity.object:get_pos(), aurum.mobs.SEARCH_RADIUS, ref_table.id)
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
	if self.data.movement == "swim" then
		return true
	else
		return minetest.line_of_sight(self.entity.object:get_pos(), object:get_pos()) or minetest.line_of_sight(self.entity.object:get_pos(), vector.add(object:get_pos(), vector.new(0, 1, 0)))
	end
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
		self.entity._go.path = nil
	end
	self.entity.object:move_to(pos, true)
end

-- Get the number of players near self.
function aurum.mobs.helper_nearby_players(self)
	local pos = self.entity.object:get_pos()
	return #b.t.imap(minetest.get_connected_players(), function(player)
		if vector.distance(pos, player:get_pos()) <= aurum.mobs.SEARCH_RADIUS then
			return player
		end
	end)
end

function aurum.mobs.helper_same_herd(self, object)
	if self.entity.object == object then
		return true
	end

	local mob = aurum.mobs.get_mob(object)
	local rt = b.ref_to_table(object)

	if self.data.parent and rt and b.ref_table_equal(self.data.parent, rt) then
		return true
	end

	if mob then
		if self.data.parent and mob.data.parent and b.ref_table_equal(self.data.parent, mob.data.parent) then
			return true
		elseif mob.data.herd == self.data.herd then
			return true
		end
	end

	return false
end
