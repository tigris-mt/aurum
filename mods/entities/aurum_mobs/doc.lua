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

	a{
		S("Ordinarily, this mob moves at a base speed of @1 n/s", def.initial_data.base_speed),
		S("Ordinarily, this mob contains @1 mana", def.initial_data.xmana),
	}

	if def.initial_data.adrenaline_time > 0 then
		a(S("Ordinarily, this mob has @1 seconds of adrenaline with a @2 second cooldown", def.initial_data.adrenaline_time, def.initial_data.adrenaline_cooldown))
	end

	doc.add_entry("aurum_mobs:mobs", name, {
		name = def.description,
		data = table.concat(docs, "\n"),
	})
end
