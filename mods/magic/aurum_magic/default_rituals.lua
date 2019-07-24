local S = minetest.get_translator()

local fertilizer_wall = {}
for _,pos in ipairs(aurum.box.iterate(aurum.box.new(vector.new(-1, 0, -1), vector.new(1, 2, -1)))) do
	table.insert(fertilizer_wall, {pos, "aurum_farming:fertilizer"})
end
aurum.magic.register_ritual("spell_growth", {
	description = S"Spell Creation: Growth",
	longdesc = S"Extract the primal energy of fertilizer and burn it into spell scrolls of growth.",

	size = aurum.box.new(vector.new(-1, 0, -1), vector.new(1, 2, 0)),

	recipe = table.icombine(fertilizer_wall, {
		{vector.new(0, 1, 0), "aurum_storage:box"},
		{vector.new(-1, 0, 0), "aurum_flare:flare"},
		{vector.new(1, 0, 0), "aurum_flare:flare"},
	}),

	protected = true,

	apply = function(at, player)
		if not aurum.magic.spell_ritual_inv(at(vector.new(0, 1, 0)), "main", "growth", 9) then
			return false
		end

		for _,n in ipairs(fertilizer_wall) do
			minetest.remove_node(at(n[1]))
		end

		return true
	end,
})
