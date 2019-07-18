aurum.player.default_hp_max = tonumber(minetest.settings:get("aurum_player.hp_max")) or 100
-- Builtin damage (fall damage, drown damage) must be scaled by this amount.
aurum.player.hp_max_scaling = aurum.player.default_hp_max / minetest.PLAYER_MAX_HP_DEFAULT

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
    identity = aurum.player.default_hp_max,
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

minetest.register_on_joinplayer(function(player)
	player:set_properties{hp_max = aurum.player.hp_max_monoid:value(player)}
end)

minetest.register_on_player_hpchange(function(player, hp_change, reason)
	if reason.type == "fall" or reason.type == "drown" then
		return hp_change * aurum.player.hp_max_scaling * player:get_armor_groups()[reason.type] / 100
	elseif reason.type == "node_damage" then
		local def = minetest.registered_nodes[reason.node]
		return def._damage_type and hp_change * player:get_armor_groups()[def._damage_type] / 100 or hp_change
	else
		return hp_change
	end
end, true)
