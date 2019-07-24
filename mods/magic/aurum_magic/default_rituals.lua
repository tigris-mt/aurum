local S = minetest.get_translator()

aurum.magic.register_spell_ritual("extinguish", {
	longdesc = S"Molds water and lava into the essence of anti-fire.",

	size = aurum.box.new(vector.new(-1, 0, 0), vector.new(1, 1, 0)),
	protected = true,

	recipe = {
		{vector.new(-1, 0, 0), "group:water"},
		{vector.new(1, 0, 0), "aurum_base:lava_source"},
		{vector.new(0, 1, 0), "aurum_storage:scroll_hole"},
	},

	apply = function(at)
		if not aurum.magic.spell_ritual_inv(at(vector.new(0, 1, 0)), "main", "extinguish", 3) then
			return false
		end

		for _,pos in ipairs{
			vector.new(-1, 0, 0),
			vector.new(1, 0, 0),
		} do
			minetest.remove_node(at(pos))
		end

		return true
	end,
})

local fertilizer_wall = {}
for _,pos in ipairs(aurum.box.iterate(aurum.box.new(vector.new(-1, 0, -1), vector.new(1, 2, -1)))) do
	table.insert(fertilizer_wall, {pos, "aurum_farming:fertilizer"})
end
aurum.magic.register_spell_ritual("growth", {
	longdesc = S"Extracts the primal energy of fertilizer and burn it into spell scrolls of growth.",

	size = aurum.box.new(vector.new(-1, 0, -1), vector.new(1, 2, 0)),

	recipe = table.icombine(fertilizer_wall, {
		{vector.new(0, 1, 0), "aurum_storage:scroll_hole"},
		{vector.new(-1, 0, 0), "aurum_flare:flare"},
		{vector.new(1, 0, 0), "aurum_flare:flare"},
	}),

	protected = true,

	apply = function(at)
		if not aurum.magic.spell_ritual_inv(at(vector.new(0, 1, 0)), "main", "growth", 9) then
			return false
		end

		for _,n in ipairs(fertilizer_wall) do
			minetest.remove_node(at(n[1]))
		end

		return true
	end,
})
