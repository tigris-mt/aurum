local S = minetest.get_translator()
aurum.effects = {
	effects = {},
	enchants = {},
	groups = {},
}

doc.add_category("aurum_effects:effects", {
	name = S"Effects",
	build_formspec = doc.entry_builders.text,
})

-- Add the effect <name> at <level> to <object> for <duration>, blaming <blame> ref_table.
-- Will do nothing if <object> already has <name> at a higher level, otherwise will replace any current <name> effect.
-- A duration < 0 indicates infinite duration until cancelled.
function aurum.effects.add(object, name, level, duration, blame)
	local def = aurum.effects.effects[name]

	if object:is_player() then
		-- Don't apply if player is dead.
		if object:get_hp() <= 0 and def.cancel_on_death then
			return false
		end
		local effects = aurum.effects.get_player(object)
		if effects[name] and effects[name].level > level then
			return false
		end
		effects[name] = {
			duration = duration,
			next = def.repeat_interval,
			level = level,
			blame = blame,
			forever = duration < 0,
		}
		aurum.effects.set_player(object, effects)
		def.apply(object, level)
		return true
	else
		local mob = aurum.mobs.get_mob(object)
		if mob then
			if mob.data.status_effects[name] and mob.data.status_effects[name].level > level then
				return false
			end

			mob.data.status_effects[name] = {
				duration = duration,
				next = def.repeat_interval,
				level = level,
				blame = blame,
				forever = duration < 0,
			}

			def.apply(object, level)
			return true
		end
	end
	return false
end

-- Remove the effect <name> from <object> if that effect is active.
function aurum.effects.remove(object, name)
	if object:is_player() then
		local effects = aurum.effects.get_player(object)
		if effects[name] then
			aurum.effects.effects[name].cancel(object, effects[name].level)
			effects[name] = nil
			aurum.effects.set_player(object, effects)
		end
	else
		local mob = aurum.mobs.get_mob(object)
		if mob then
			if mob.data.status_effects[name] then
				aurum.effects.effects[name].cancel(object, mob.data.status_effects[name].level)
				mob.data.status_effects[name] = nil
			end
		end
	end
end

-- Remove all effects of group <group> from <object>.
function aurum.effects.remove_group(object, group)
	for _,effect in ipairs(aurum.effects.groups[group] or {}) do
		aurum.effects.remove(object, effect)
	end
end

-- Get the {level = x, [blame = x]} of effect <name> on <object> or nil if it does not have that effect.
function aurum.effects.has(object, name)
	if object:is_player() then
		return aurum.effects.get_player(object)[name]
	else
		local mob = aurum.mobs.get_mob(object)
		if mob then
			return mob.data.status_effects[name]
		end
	end
end

function aurum.effects.register(name, def)
	local def = b.t.combine({
		-- Maximum effect level.
		max_level = 1,
		-- Human readable description.
		description = "?",
		-- Long description for docs.
		longdesc = nil,
		-- Optional icon for display in the HUD or elsewhere.
		icon = nil,
		-- If set, this effect will apply repeatedly every interval.
		repeat_interval = nil,
		-- Shall this effect be hidden from the player?
		hidden = false,
		-- Cancel the effect on the target's death?
		cancel_on_death = true,
		-- If not false, create an enchantment for this effect that can be placed on the specified groups.
		enchant = b.set{"tool"},
		-- What should the duration of this effect be for a specific enchantment level?
		tool_duration = function(level)
			return 5
		end,
		-- Apply this level of effect to an object.
		apply = function(object, level) end,
		-- Cancel this level of effect to an object.
		cancel = function(object, level) end,
		-- Effect groups.
		groups = {},
	}, def, {name = name})

	for _,group in ipairs(def.groups) do
		aurum.effects.groups[group] = aurum.effects.groups[group] or {}
		table.insert(aurum.effects.groups[group], def.name)
	end

	if def.enchant then
		aurum.tools.register_enchant("effect_" .. name, {
			categories = def.enchant,
			max_level = def.max_level,
			description = S("@1 Essence", def.description),
			longdesc = S("Applies the @1 effect on a hit.", def.description),
		})
		aurum.effects.enchants["effect_" .. name] = def
	end

	if not def.hidden then
		local docs = {}

		if def.longdesc then
			table.insert(docs, def.longdesc)
		end

		table.insert(docs, S("Maximum level: @1", def.max_level))

		if def.enchant then
			local k = b.set.to_array(def.enchant)
			table.sort(k)
			table.insert(docs, S("Can enchant: @1", table.concat(k, ", ")))
		end

		doc.add_entry("aurum_effects:effects", name, {
			name = def.description,
			data = table.concat(docs, "\n\n"),
		})
	end

	aurum.effects.effects[name] = def
end

function aurum.effects.apply_tool_effects(stack, object, blame)
	for k,v in pairs(aurum.tools.get_item_enchants(stack)) do
		local e = aurum.effects.enchants[k]
		if e then
			aurum.effects.add(object, e.name, v, e.tool_duration(v), blame)
		end
	end
end

function aurum.effects.operate(object, effects, dtime)
	local remove = {}

	for name,state in pairs(effects) do
		local def = aurum.effects.effects[name]
		state.duration = state.duration - dtime
		-- Only repeat if next is in the state.
		if state.next then
			state.next = state.next - dtime
			if state.next < 0 then
				def.apply(object, state.level)
				state.next = def.repeat_interval - (-state.next)
			end
		end
		if state.duration < 0 and not state.forever then
			def.cancel(object, state.level)
			table.insert(remove, name)
		end
	end

	for _,name in ipairs(remove) do
		effects[name] = nil
	end
end

minetest.register_on_punchplayer(function(player, hitter)
	if player:get_hp() > 0 then
		aurum.effects.apply_tool_effects(hitter:get_wielded_item(), player, aurum.get_blame(hitter) or b.ref_to_table(hitter))
	end
end)

b.dofile("dummy.lua")
b.dofile("player.lua")

b.dodir("effects")
