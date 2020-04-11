local S = minetest.get_translator()

doc.add_category("aurum_mobs:mobs", {
	name = S"Mobs",
	build_formspec = doc.entry_builders.text,
})

function aurum.mobs.add_doc(name)
	local def = aurum.mobs.mobs[name]

	local docs = {}

	local function a(t)
		if type(t) == "string" then
			t = {t}
		end
		for _,v in ipairs(t) do
			table.insert(docs, v)
		end
	end

	if def.longdesc and #def.longdesc > 0 then
		a(def.longdesc .. "\n")
	end

	local data = b.t.combine(aurum.mobs.initial_data, def.initial_data)

	a{
		S("--- Ordinary Data ---") .. "\n",
		S("This mob moves at a base speed of @1 n/s", data.base_speed),
		S("This mob contains @1 mana", data.xmana),
	}

	if data.adrenaline.time > 0 then
		a(S("This mob has @1 seconds of adrenaline with a @2 second cooldown", data.adrenaline.time, data.adrenaline.cooldown))
	end

	if #data.food > 0 then
		a(S("This mob will eat @1", table.concat(data.food, ", ")))
	end

	a("")

	if data.attack.fire_projectile then
		a(S("This mob attacks at range."))
	end

	local damage = {}
	for name,rating in b.t.spairs(data.attack.damage) do
		table.insert(damage, ("%s: %d"):format(name, rating))
	end
	if #damage > 0 then
		a(S("Attack damage: @1", table.concat(damage, "; ")))
	end

	for name,def in b.t.spairs(data.attack.effects) do
		a(S("Attack effect: @1 @2 for @3 seconds", aurum.effects.effects[name].description, def.level, def.duration))
	end

	local armor = {}
	for name,rating in b.t.spairs(b.t.combine(gdamage.armor_defaults(), def.armor_groups)) do
		if rating ~= 100 then
			table.insert(armor, ("%s: %d%%"):format(name, 100 - rating))
		end
	end
	if #armor > 0 then
		a(S("Damage reduction: @1", table.concat(armor, "; ")))
	end

	doc.add_entry("aurum_mobs:mobs", name, {
		name = def.description,
		data = table.concat(docs, "\n"),
	})
end
