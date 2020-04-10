local S = minetest.get_translator()

local BASE_FLIGHT_SPEED = 7.5

local entities = {}
local timers = {}

minetest.register_entity("aurum_wings:active_wings", {
	initial_properties = {
		physical = true,
		collisionbox = {-0.35, -0.35, -0.35, 0.35, 0.35, 0.35},
		texture = "aurum_wings_wings.png",
		pointable = false,
		visual = "wielditem",
		wield_item = "aurum_wings:wings",
		visual_size = vector.new(0.5, 0.5, 0.5),
	},

	groups = {immortal = 1},

	driver = nil,

	on_activate = function(self, staticdata)
		self.driver = staticdata
		self.object:set_velocity(vector.new(0.01, 0.01, 0.01))
	end,

	on_step = function(self, dtime)
		local player = self.driver and minetest.get_player_by_name(self.driver)
		if not player or player:get_attach() ~= self.object then
			self.object:remove()
		else
			local o = player:get_physics_override()
			self.object:set_acceleration(vector.add(vector.add(vector.multiply(player:get_look_dir(), BASE_FLIGHT_SPEED * o.speed), vector.multiply(aurum.GRAVITY, 0.1 * o.gravity)), vector.multiply(self.object:get_velocity(), -0.25)))

			local v = self.object:get_velocity()
			if v and self.old_vel then
				local function t(c)
					if v[c] == 0 then
						return math.max(0, math.abs(v[c] - self.old_vel[c]) - 5), true
					end
					return 0, false
				end
				local damage = 0
				damage = damage + t"x"
				damage = damage + t"z"
				local dy, hy = t"y"
				damage = damage + dy
				if damage >= 1 then
					player:punch(player, 1, {
						full_punch_interval = 1,
						damage_groups = {fall = damage},
					})
				end
				if damage > 0 or hy then
					self.object:remove()
					entities[player:get_player_name()] = nil
					timers[player:get_player_name()] = 0
				end
			end
			self.old_vel = v
		end
	end,
})

local function get_on_ground(pos)
	local def = minetest.registered_nodes[minetest.get_node(pos).name]
	return def and ((def.walkable or (def.liquidtype or "none") ~= "none") or def.climbable)
end

minetest.register_globalstep(function(dtime)
	for _,player in ipairs(minetest.get_connected_players()) do
		local name = player:get_player_name()
		local has_wings = player:get_meta():get_int("aurum_wings:wings") == 1
		local rpos = vector.round(player:get_pos())
		local on_ground = get_on_ground(rpos)
		local block_start = on_ground or get_on_ground(vector.subtract(rpos, vector.new(0, 1, 0)))
		if has_wings and not block_start and not player:get_attach() then
			timers[name] = (timers[name] or 0) + dtime
			if timers[name] >= 1 then
				entities[name] = minetest.add_entity(player:get_pos(), "aurum_wings:active_wings", name)
				if entities[name] then
					player:set_attach(entities[name], "", vector.new(), vector.new())
					entities[name]:set_velocity(vector.multiply(player:get_player_velocity(), vector.new(1, 0.25, 1)))
					timers[name] = 0
				end
			end
		elseif on_ground or not has_wings then
			timers[name] = 0
			if entities[name] then
				entities[name]:remove()
				entities[name] = nil
			end
		elseif block_start then
			timers[name] = 0
		end
	end
end)
