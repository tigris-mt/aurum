local S = minetest.get_translator()
aurum.magic.spells = {}

function aurum.magic.new_spell_scroll(spell, level)
	return aurum.scrolls.new{
		type = "spell",
		name = spell,
		level = level,
		description = S("Spell Scroll: @1 @2", aurum.magic.spells[spell].description, level),
	}
end

function aurum.magic.register_spell(name, def)
	local def = table.combine({
		description = "",
		longdesc = nil,
		max_level = 3,

		-- Attempt to apply spell requirements. Return true if all is ok.
		apply_requirements = function(pointed_thing, level, owner)
			return true
		end,

		-- Apply the spell.
		apply = function(pointed_thing, level, owner) end,
	}, def)

	aurum.magic.spells[name] = def

	local docs = {}

	if def.longdesc then
		table.insert(docs, def.longdesc)
	end

	doc.add_entry("spells", name, {
		name = def.description,
		data = table.concat(docs, "\n\n"),
	})
end
