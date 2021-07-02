local default_size = {
	x = 8,
	y = 4,
}

local function scale(p)
	-- Delay so that items aren't dropped before the inventory sizes reaches its final value.
	minetest.after(0, function(name)
		local player = minetest.get_player_by_name(name)
		if player then
			local s = aurum.player.inventory_size(player)
			local total_size = s.x * s.y
			local inv = player:get_inventory()
			for i=total_size+1,inv:get_size("main") do
				local stack = inv:get_stack("main", i)
				if not stack:is_empty() then
					aurum.drop_item(player:get_pos(), stack)
				end
			end
			inv:set_size("main", total_size)
			player:hud_set_hotbar_itemcount(s.x)
		end
	end, p:get_player_name())
end

aurum.player.inventory_x_monoid = player_monoids.make_monoid{
    combine = function(a, b)
        return a + b
    end,
    fold = function(tab)
        local r = default_size.x
        for _,v in pairs(tab) do
            r = r + v
        end
        return r
    end,
    identity = default_size.x,
    apply = function(n, player)
		scale(player)
    end,
    on_change = function() return end,
}

aurum.player.inventory_y_monoid = player_monoids.make_monoid{
    combine = function(a, b)
        return a + b
    end,
    fold = function(tab)
        local r = default_size.y
        for _,v in pairs(tab) do
            r = r + v
        end
        return r
    end,
    identity = default_size.y,
    apply = function(n, player)
		scale(player)
    end,
    on_change = function() return end,
}

function aurum.player.inventory_size(player)
	if type(player) == "string" then
		local p = minetest.get_player_by_name(player)
		return p and aurum.player.inventory_size(p) or default_size
	else
		return {
			x = aurum.player.inventory_x_monoid:value(player),
			y = aurum.player.inventory_y_monoid:value(player),
		}
	end
end
