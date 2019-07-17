local default_effects = {
	speed = 1,
	gravity = 1,
	jump = 1,
}

gequip.register_eqdef_init(function(eqdef)
	eqdef.armor = gdamage.armor_defaults(1)
	eqdef.effects = default_effects
end)

gequip.register_action("aurum_equip:armor", {
	init = function(state)
		state.armor = gdamage.armor_defaults(1)
	end,

	add = function(state, r)
		for k,v in pairs(r.armor) do
			state.armor[k] = state.armor[k] * v
		end
	end,

	apply = function(state, player)
		armor_monoid.monoid:add_change(player, state.armor, "aurum_equip:armor")
	end,
})

gequip.register_action("aurum_equip:effects", {
	init = function(state)
		state.effects = default_effects
	end,

	add = function(state, r)
		for k,v in pairs(r.effects) do
			state.effects[k] = state.effects[k] * v
		end
	end,

	apply = function(state, player)
		player_monoids.gravity:add_change(player, state.effects.gravity, "aurum_equip:gravity")
		player_monoids.speed:add_change(player, state.effects.speed, "aurum_equip:speed")
		player_monoids.jump:add_change(player, state.effects.jump, "aurum_equip:jump")
	end,
})
