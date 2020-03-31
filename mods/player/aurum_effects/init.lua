local S = minetest.get_translator()
aurum.effects = {
	effects = {},
}

function aurum.effects.add(player, name, level, duration)
	local def = aurum.effects.effects[name]

	for i=level+1,def.max_level do
		if playereffects.has_effect_type(player:get_player_name(), name .. "_" .. i) then
			return false
		end
	end
	for i=1,level-1 do
		playereffects.cancel_effect_type(name .. "_" .. i, true, player:get_player_name())
	end
	return playereffects.apply_effect_type(name .. "_" .. level, duration, player, 0)
end

function aurum.effects.remove(player, name)
	playereffects.cancel_effect_group(name, player:get_player_name())
end

function aurum.effects.has(player, name)
	for level=1,aurum.effects.effects[name].maxlevel do
		if playereffects.has_effect_type(player:get_player_name(), name .. "_" .. level) then
			return leve
		end
	end
	return false
end

function aurum.effects.register(name, def)
	local def = b.t.combine({
		max_level = 1,
		description = "?",
		icon = nil,
		repeat_interval = nil,
		hidden = false,
		cancel_on_death = true,
		repeat_interval = nil,
		apply = function(player, level) end,
		cancel = function(player) end,
	}, def)

	for level=1,def.max_level do
		playereffects.register_effect_type(name .. "_" .. level, S("@1 @2", def.description, tostring(level)), def.icon, {name, "aurum_effects"},
			function(player)
				def.apply(player, level)
			end,
			function(effect, player)
				def.cancel(player)
			end, def.hidden, def.cancel_on_death, def.repeat_interval)
	end

	aurum.effects.effects[name] = def
end

b.dodir("effects")
