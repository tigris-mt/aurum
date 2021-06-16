local S = aurum.get_translator()

local BASE_FLIGHT_SPEED = 7.5

local entities = {}
local timers = {}

local function stuck_in(pos)
	local def = minetest.registered_nodes[minetest.get_node(pos).name]
	return def and (((def.liquidtype or "none") ~= "none") or def.climbable)
end

minetest.register_entity("aurum_wings:active_wings", {
	initial_properties = {
		physical = true,
		collide_with_objects = false,
		collisionbox = {-0.35, -0.35, -0.35, 0.35, 0.35, 0.35},
		texture = "aurum_wings_wings.png",
		pointable = false,
		visual = "wielditem",
		wield_item = "aurum_wings:wings",
		static_save = false,
	},

	groups = {immortal = 1},

	driver = nil,
	player_damage = 0,
	wear_timer = 0,

	on_activate = function(self, staticdata)
		self.driver = staticdata
		self.object:set_velocity(vector.new(0.01, 0.01, 0.01))
	end,

	on_step = function(self, dtime, moveresult)
		local player = self.driver and minetest.get_player_by_name(self.driver)
		if not player or player:get_attach() ~= self.object then
			self.object:remove()
		else
			local o = player:get_physics_override()
			self.object:set_acceleration(vector.add(vector.add(vector.add(vector.multiply(player:get_look_dir(), BASE_FLIGHT_SPEED * o.speed), vector.multiply(aurum.GRAVITY, 0.1 * o.gravity)), vector.multiply(self.object:get_velocity(), -0.25)), vector.new(math.random() - 0.5, math.random() - 0.5, math.random() - 0.5)))

			self.object:set_rotation(vector.new(-player:get_look_vertical() - math.pi / 2, player:get_look_horizontal(), 0))

			self.wear_timer = self.wear_timer + dtime
			if self.wear_timer > 5 then
				aurum.wings.apply_wear(player, self.wear_timer)
				self.wear_timer = 0
			end

			local function stop_flying()
				player:set_detach()
				player:set_pos(self.object:get_pos())
				self.object:remove()
				entities[player:get_player_name()] = nil
				timers[player:get_player_name()] = 0
			end

			if stuck_in(self.object:get_pos()) or player:get_meta():get_int("aurum_wings:wings") ~= 1 then
				stop_flying()
			end

			if moveresult.collides then
				local total = 0
				local y_hit = false
				for _,collision in ipairs(moveresult.collisions) do
					y_hit = y_hit or (collision.axis == "y")
					if collision.type == "node" then
						if minetest.registered_nodes[minetest.get_node(collision.node_pos).name].walkable then
							total = total + vector.distance(collision.old_velocity, collision.new_velocity)
						end
					end
				end

				local damage = b.random_whole(math.max(0, total - 5))
				self.player_damage = damage
				player:punch(player, 1, {
					full_punch_interval = 1,
					damage_groups = {fall = damage},
				})

				if damage > 0 or y_hit then
					stop_flying()
				end
			end
		end
	end,

	on_attach_child = function(self, player)
		aurum.wings.on_start_fly(player)
	end,

	on_detach_child = function(self, player)
		aurum.wings.on_stop_fly(player, self.player_damage or 0)
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
		local rpos = player:get_pos()
		local on_ground = get_on_ground(rpos) or get_on_ground(vector.subtract(rpos, vector.new(0, 1, 0)))
		local block_start = on_ground or get_on_ground(vector.subtract(rpos, vector.new(0, 2, 0)))
		if has_wings and not block_start and not player:get_attach() and player:get_player_control().jump then
			timers[name] = (timers[name] or 0) + dtime
			if timers[name] >= 0.5 then
				entities[name] = minetest.add_entity(player:get_pos(), "aurum_wings:active_wings", name)
				if entities[name] then
					entities[name]:set_velocity(vector.multiply(player:get_velocity(), vector.new(1, 0.25, 1)))
					player:set_pos(entities[name]:get_pos())
					player:set_attach(entities[name], "", vector.new(), vector.new())
					timers[name] = 0
				end
			end
		else
			timers[name] = 0
		end
	end
end)
