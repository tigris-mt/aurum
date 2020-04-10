local S = minetest.get_translator()

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
			self.object:set_acceleration(vector.add(vector.add(vector.multiply(player:get_look_dir(), 5 * o.speed), vector.multiply(aurum.GRAVITY, 0.1 * o.gravity)), vector.multiply(self.object:get_velocity(), -0.25)))

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
				end
			end
			self.old_vel = v
		end
	end,
})

local entities = {}
local timers = {}

minetest.register_globalstep(function(dtime)
	for _,player in ipairs(minetest.get_connected_players()) do
		local name = player:get_player_name()
		local standing = minetest.registered_nodes[gnode_augment.players[name].nodes.stand.name]
		local on_ground = (standing.walkable or (standing.liquidtype or "none") ~= "none") or standing.climbable
		if player:get_meta():get_int("aurum_wings:wings") == 1 and not on_ground and not player:get_attach() then
			timers[name] = (timers[name] or 0) + dtime
			if timers[name] >= 1 then
				entities[name] = minetest.add_entity(player:get_pos(), "aurum_wings:active_wings", name)
				if entities[name] then
					player:set_attach(entities[name], "", vector.new(), vector.new())
					timers[name] = 0
				end
			end
		elseif on_ground or player:get_meta():get_int("aurum_wings:wings") ~= 1 then
			timers[name] = 0
			if entities[name] then
				entities[name]:remove()
				entities[name] = nil
			end
		end
	end
end)
