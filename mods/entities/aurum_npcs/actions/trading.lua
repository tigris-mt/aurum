local S = minetest.get_translator()
local TIMEOUT = 60
local SECONDS_PER_REGEN = 60

aurum.mobs.initial_data.trades = {}

local function get(name, id)
	local player = minetest.get_player_by_name(name)
	local object = player and aurum.mobs.helper_mob_id_to_object(player:get_pos(), 8, id)
	local mob = object and aurum.mobs.get_mob(object)
	return mob, player
end

local form
form = smartfs.create("aurum_npcs:trading", function(state)
	if state.param.error then
		state:size(6, 0.25)
		state:label(0, 0, "error_label", S("Could not trade: @1", state.param.error))
	else
		local mob, player = get(state.location.player, state.param.id)
		if mob then
			local trades = b.t.imap(mob.data.trades, function(v, i) return (ItemStack(v.item):get_count() > 0 and v.has >= 1) and {v, i} or nil end)
			state:size(8, #trades + 5)
			local x = 1.25
			for i,t in ipairs(trades) do
				local trade, trade_index = unpack(t)
				local item = ItemStack(trade.item)
				local item_button = state:item_image_button(x + 0, i - 1, 1, 1, "item_" .. i, item:get_count(), item:get_name())
				local d = item:get_meta():get_string("description")
				item_button:setTooltip(S("Qty. @1", item:get_count()) .. "\n" .. ((#d > 0) and d or item:get_definition().description))

				state:label(x + 1.25, i - 1 + 0.25, "for_" .. i, S"for")

				local cost = ItemStack(trade.cost)
				local cost_button = state:item_image_button(x + 2, i - 1, 1, 1, "cost_" .. i, cost:get_count(), cost:get_name())
				local d = cost:get_meta():get_string("description")
				cost_button:setTooltip(S("Qty. @1", cost:get_count()) .. "\n" .. ((#d > 0) and d or cost:get_definition().description))

				state:button(x + 3.25, i - 1, 2, 1, "purchase_" .. i, S"Purchase", true):onClick(function(self, state, name)
					local mob, player = get(name, state.param.id)
					if mob and player then
						if mob:state().flags["aurum_npcs:trading"] then
							local do_trade = mob.data.trades[trade_index]
							if do_trade.item == trade.item and do_trade.cost == trade.cost and do_trade.has >= 1 then
								local inv = player:get_inventory()
								if inv:contains_item("main", ItemStack(do_trade.cost)) then
									if inv:room_for_item("main", ItemStack(do_trade.item)) then
										inv:remove_item("main", ItemStack(do_trade.cost))
										inv:add_item("main", ItemStack(do_trade.item))
										do_trade.has = do_trade.has - 1
										mob:fire_event("traded", mob.data.params)
										minetest.after(0, form.show, form, name, table.copy(state.param))
									else
										state.param.error = S"You cannot hold this trade"
										minetest.after(0, form.show, form, name, table.copy(state.param))
									end
								else
									state.param.error = S"You cannot pay for this trade"
									minetest.after(0, form.show, form, name, table.copy(state.param))
								end
							else
								state.param.error = S"Trader no longer offers this trade"
								minetest.after(0, form.show, form, name, table.copy(state.param))
							end
						else
							state.param.error = S"Trader lost interest in trading"
							minetest.after(0, form.show, form, name, table.copy(state.param))
						end
					else
						state.param.error = S"Trader not found"
						minetest.after(0, form.show, form, name, table.copy(state.param))
					end
				end)
			end
			state:inventory(0, #trades + 1, 8, 4, "main")
		else
			state.param.error = S"Trader not found"
			minetest.after(0, form.show, form, name, table.copy(state.param))
		end
	end
end)

gemai.register_action("aurum_npcs:trading_begin", function(self)
	local other = self.data.params.other
	if other.type == "player" then
		local player = minetest.get_player_by_name(other.id)
		if player then
			form:show(other.id, {id = self.entity._aurum_mobs_id})
			self:fire_event("begin_trading", self.data.params)
		end
	end
end)

gemai.register_action("aurum_npcs:trading", function(self)
	if self.data.state_time > TIMEOUT then
		self:fire_event("end_trading", self.data.params)
	end
end)

gemai.register_action("aurum_npcs:trading_regen", function(self)
	for _,trade in ipairs(self.data.trades) do
		trade.has = math.min(trade.max, trade.has + self.data.step_time / SECONDS_PER_REGEN)
	end
end)
