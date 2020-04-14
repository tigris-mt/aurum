local S = minetest.get_translator()

local form = smartfs.create("aurum_npcs:trading", function(state)
	-- TODO: Trading
end)

gemai.register_action("aurum_npcs:trading_begin", function(self)
	self:fire_event("begin_trading", self.data.params)
end)

gemai.register_action("aurum_npcs:trading", function(self)
	self:fire_event("end_trading", self.data.params)
end)
