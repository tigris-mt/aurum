local default_effects = {
	speed = 1,
	gravity = 1,
	jump = 1,
}

gequip.register_eqdef_init(function(eqdef)
	eqdef.armor = b.t.combine(gdamage.armor_defaults(1), eqdef.armor or {})
	eqdef.durability = eqdef.durability or 1
	eqdef.hp_max = eqdef.hp_max or 1
	eqdef.effects = b.t.combine(default_effects, eqdef.effects or {})
end)

gequip.register_action("aurum_equip:armor", {
	init = function(state)
		state.armor = table.copy(gdamage.armor_defaults(1))
	end,

	add = function(state, r)
		for k,v in pairs(r.armor) do
			state.armor[k] = state.armor[k] * v
		end

		-- Fall armor is half-affected by impact armor.
		state.armor.fall = (state.armor.fall * state.armor.impact + state.armor.fall) / 2
	end,

	apply = function(state, player)
		armor_monoid.monoid:add_change(player, state.armor, "aurum_equip:armor")
	end,
})

gequip.register_action("aurum_equip:effects", {
	init = function(state)
		state.effects = table.copy(default_effects)
	end,

	add = function(state, r)
		for k,v in pairs(r.effects) do
			state.effects[k] = state.effects[k] * v
		end
	end,

	apply = function(state, player)
		player_monoids.gravity:add_change(player, state.effects.gravity, "aurum_equip:effects")
		player_monoids.speed:add_change(player, state.effects.speed, "aurum_equip:effects")
		player_monoids.jump:add_change(player, state.effects.jump, "aurum_equip:effects")
	end,
})

gequip.register_action("aurum_equip:hp", {
	init = function(state)
		state.hp = {
			max = 1,
		}
	end,

	add = function(state, r)
		state.hp.max = state.hp.max * r.hp_max
	end,

	apply = function(state, player)
		aurum.player.hp_max_monoid:add_change(player, state.hp.max, "aurum_equip:hp")
	end,
})
