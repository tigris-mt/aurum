gglobaltick.actions.TICK_TIME = 0.1

local timer = 0
minetest.register_globalstep(function(dtime)
	timer = timer + dtime
	while timer >= gglobaltick.actions.TICK_TIME do
		timer = timer - gglobaltick.actions.TICK_TIME
		gglobaltick.actions.tick()
	end
end)
