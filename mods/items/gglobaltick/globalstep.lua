gglobaltick.TICK_TIME = 0.05

function gglobaltick.per_second_delay(per_second)
	return math.floor(math.max(0, ((1 / per_second) / gglobaltick.TICK_TIME) - 1))
end

local timer = 0
minetest.register_globalstep(function(dtime)
	timer = timer + dtime
	while timer >= gglobaltick.TICK_TIME do
		timer = timer - gglobaltick.TICK_TIME
		gglobaltick.actions.tick()
	end
end)
