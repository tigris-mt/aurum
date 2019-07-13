aurum.player.hp_max_monoid = player_monoids.make_monoid{
    combine = function(a, b)
        return a * b
    end,
    fold = function(tab)
        local r = c_max
        for _,v in pairs(tab) do
            r = r * v
        end
        return r
    end,
    identity = tonumber(minetest.settings:get("aurum_player.hp_max")) or 100,
    apply = function(n, player)
        player:set_properties{hp_max = n}
    end,
    on_change = function() return end,
}

local function set(player)
	player:set_properties{hp_max = aurum.player.hp_max_monoid:value(player)}
	player:set_hp(player:get_properties().hp_max)
end

minetest.register_on_newplayer(set)
minetest.register_on_respawnplayer(set)
