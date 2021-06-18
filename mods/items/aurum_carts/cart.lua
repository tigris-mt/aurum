aurum.carts.active_carts = {}

local HIT_IGNORE_DELAY = 1
local UNLOADED_DELAY = 3

function aurum.carts.get_active_cart(id)
	local cart = aurum.carts.active_carts[id]
	return (cart and cart.object:get_pos()) and cart or nil
end

function aurum.carts.register(name, def)
	def = b.t.combine({
		description = "?",
		texture = "aurum_base_stone.png",
		node_def = {},
		speed = 10,
	}, def)

	local ticks_per_node = gglobaltick.per_second_delay(def.speed)

	local entity_name = name .. "_entity"
	local action_name = name .. "_action"

	local rlg = minetest.raillike_group("aurum_carts:rail")

	local function rail_at_pos(pos)
		local node = minetest.get_node(pos)
		if minetest.get_item_group(node.name, "connect_to_raillike") == rlg then
			return true, node
		else
			return false, node
		end
	end

	minetest.register_node(name, b.t.combine({
		description = def.description,
		tiles = {def.texture},
		drawtype = "nodebox",
		node_box = {
			type = "fixed",
			fixed = {
				{-0.3, -0.2, -0.3, 0.3, -7/16, 0.3},
				{-0.3, -0.2, -0.3, 0.3, 0.2, -4/16},
				{-0.3, -0.2, -0.3, -4/16, 0.2, 0.3},
				{4/16, -0.2, -0.3, 0.3, 0.2, 0.3},
				{-0.3, -0.2, 4/16, 0.3, 0.2, 0.3},
			},
		},

		groups = {dig_immediate = 3},

		node_placement_prediction = "",

		on_place = function(itemstack, placer, pointed_thing)
			if pointed_thing.type == "node" then
				local rail_pos = minetest.get_pointed_thing_position(pointed_thing)
				if rail_at_pos(rail_pos) then
					local id = b.new_uid()
					local cart_entity = minetest.add_entity(rail_pos, entity_name, minetest.serialize{id = id})
					if cart_entity then
						itemstack:take_item()
						return itemstack
					end
				end
			end

			return itemstack
		end,
	}, def.node_def))

	gglobaltick.actions.register(action_name, {
		func = function(params)
			local entity = aurum.carts.get_active_cart(params.id)
			if entity then
				if vector.equals(entity.object:get_pos(), params.at) then
					local direction = params.direction
					local go_pos

					local next_pos = vector.add(params.at, direction)
					local next_works, next_node = rail_at_pos(next_pos)
					if next_works then
						go_pos = next_pos
					elseif next_node.name == "ignore" then
						-- Hit ignore, try again later.
						gglobaltick.actions.insert(action_name, HIT_IGNORE_DELAY * gglobaltick.TICK_TIME, {
							id = params.id,
							at = params.at,
							direction = direction,
						})
					else
						local above_pos = vector.add(next_pos, vector.new(0, 1, 0))
						if rail_at_pos(above_pos) then
							go_pos = above_pos
						else
							local below_pos = vector.subtract(next_pos, vector.new(0, 1, 0))
							if rail_at_pos(below_pos) then
								go_pos = below_pos
							else
								local angle = math.atan2(direction.z, direction.x)
								for i=1,3 do
									angle = angle + math.pi / 2
									if i ~= 2 then
										local new_direction = vector.new(math.floor(math.cos(angle) + 0.5), 0, math.floor(math.sin(angle) + 0.5))
										local turn_pos = vector.add(params.at, new_direction)
										if rail_at_pos(turn_pos) then
											direction = new_direction
											go_pos = turn_pos
											break
										else
											local above_turn_pos = vector.add(turn_pos, vector.new(0, 1, 0))
											if rail_at_pos(above_turn_pos) then
												direction = new_direction
												go_pos = above_turn_pos
												break
											else
												local below_turn_pos = vector.subtract(turn_pos, vector.new(0, 1, 0))
												if rail_at_pos(below_turn_pos) then
													direction = new_direction
													go_pos = below_turn_pos
													break
												end
											end
										end
									end
								end
							end
						end
					end

					if go_pos then
						entity.object:move_to(go_pos, true)
						gglobaltick.actions.insert(action_name, ticks_per_node, {
							id = params.id,
							at = go_pos,
							direction = direction,
						})
					end
				end
			else
				-- Our cart is unloaded, try again later.
				gglobaltick.actions.insert(action_name, UNLOADED_DELAY * gglobaltick.TICK_TIME, {
					id = params.id,
					at = params.at,
					direction = params.direction,
				})
			end
		end,
	})

	minetest.register_entity(entity_name, {
		initial_properties = {
			physical = false,
			visual = "wielditem",
			visual_size = vector.new(1, 1, 1),
			textures = {name},
		},

		on_activate = function(self, staticdata)
			self.cart = minetest.deserialize(staticdata) or {}
			aurum.carts.active_carts[self.cart.id] = self
		end,

		on_punch = function(self, puncher)
			if puncher:get_player_name() == self.cart.driver then
				local dir = vector.multiply(puncher:get_look_dir(), vector.new(1, 0, 1))
				if math.abs(dir.x) > math.abs(dir.z) then
					dir.z = 0
					dir.x = math.sign(dir.x)
				else
					dir.z = math.sign(dir.z)
					dir.x = 0
				end
				gglobaltick.actions.insert(action_name, 0, {
					id = self.cart.id,
					at = self.object:get_pos(),
					direction = dir,
				})
				return false
			else
				aurum.drop_item(self.object:get_pos(), name)
				self.object:remove()
				aurum.carts.active_carts[self.cart.id] = nil
				return true
			end
		end,

		on_death = function(self)
			aurum.drop_item(self.object:get_pos(), name)
			aurum.carts.active_carts[self.cart.id] = nil
		end,

		get_staticdata = function(self)
			return minetest.serialize(self.cart or {})
		end,

		on_rightclick = function(self, clicker)
			if clicker and clicker:is_player() then
				local attached = clicker:get_attach()
				if attached == self.object then
					clicker:set_detach()
				elseif not attached and not self.cart.driver then
					clicker:set_attach(self.object)
				end
			end
		end,

		on_attach_child = function(self, player)
			self.cart.driver = player:get_player_name()
			player:set_properties{visual_size = vector.multiply(player:get_properties().visual_size, 2)}
			player:set_eye_offset(vector.subtract(player:get_eye_offset(), vector.new(0, 4, 0)))
		end,

		on_detach_child = function(self, player)
			self.cart.driver = nil
			player:set_properties{visual_size = vector.divide(player:get_properties().visual_size, 2)}
			player:set_eye_offset(vector.add(player:get_eye_offset(), vector.new(0, 4, 0)))
		end,
	})
end
