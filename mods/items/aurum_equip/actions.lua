local default_effects = {
	speed = 1,
	gravity = 1,
	jump = 1,
}

gequip.register_eqdef_init(function(eqdef)
	eqdef.armor = b.t.combine(gdamage.armor_defaults(1), eqdef.armor or {})
	eqdef.durability = eqdef.durability or 1
	eqdef.hp_max = eqdef.hp_max or 1
	eqdef.breath_regen = eqdef.breath_regen or 0
	eqdef.effects = b.t.combine(default_effects, eqdef.effects or {})
	eqdef.inv_size = b.t.combine({x = 0, y = 0}, eqdef.inv_size or {})
	eqdef.food_storage = eqdef.food_storage or 1
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

gequip.register_action("aurum_equip:inv_size", {
	init = function(state)
		state.inv_size = {x = 0, y = 0}
	end,

	add = function(state, r)
		for k,v in pairs(r.inv_size) do
			state.inv_size[k] = state.inv_size[k] + v
		end
	end,

	apply = function(state, player)
		aurum.player.inventory_x_monoid:add_change(player, state.inv_size.x, "aurum_equip:armor")
		aurum.player.inventory_y_monoid:add_change(player, state.inv_size.y, "aurum_equip:armor")
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

gequip.register_action("aurum_equip:food_storage", {
	init = function(state)
		state.food_storage = 1
	end,

	add = function(state, r)
		state.food_storage = state.food_storage * r.food_storage
	end,

	apply = function(state, player)
		aurum.hunger.MAX:add_change(player, state.food_storage, "aurum_equip:food_storage")
	end,
})

gequip.register_action("aurum_equip:minimap", {
	init = function(state)
		state.minimap = false
		state.minimap_radar = false
	end,

	add = function(state, r)
		state.minimap = r.minimap or state.minimap
		state.minimap_radar = r.minimap_radar or state.minimap_radar
	end,

	apply = function(state, player)
		player:hud_set_flags{
			minimap = state.minimap,
			minimap_radar = state.minimap_radar,
		}
	end,
})

gequip.register_action("aurum_equip:breath", {
	init = function(state)
		state.breath_regen = 0
	end,

	add = function(state, r)
		state.breath_regen = state.breath_regen + r.breath_regen
	end,

	apply = function(state, player)
		if state.breath_regen > 0 then
			aurum.effects.add(player, "aurum_effects:breath_regen", state.breath_regen, -1)
		else
			aurum.effects.remove(player, "aurum_effects:breath_regen")
		end
	end,
})
