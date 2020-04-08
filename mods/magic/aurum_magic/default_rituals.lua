local S = minetest.get_translator()

aurum.magic.register_ritual("aurum_rituals:home", {
	description = S"Go Home",
	longdesc = S"Return to your home realm, or to your totem of Hyperion if you have bound to one.",

	size = b.box.new(vector.new(-1, -1, -1), vector.new(1, 0, 1)),
	protected = false,

	recipe = (function()
		local recipe = {
			{vector.new(0, 0, -1), "aurum_ore:gold_block"},
		}
		for x=-1,1 do
			for z=-1,1 do
				table.insert(recipe, {vector.new(x, -1, z), "aurum_base:foundation"})
			end
		end
		return recipe
	end)(),

	apply = function(at, player)
		return aurum.player.spawn_totem(player) or aurum.player.spawn_realm(player)
	end,
})

aurum.magic.register_spell_ritual("extinguish", {
	longdesc = S"Molds water and lava into the essence of anti-fire.",

	size = b.box.new(vector.new(-1, 0, 0), vector.new(1, 1, 0)),
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
for _,pos in ipairs(b.box.poses(b.box.new(vector.new(-1, 0, -1), vector.new(1, 2, -1)))) do
	table.insert(fertilizer_wall, {pos, "aurum_farming:fertilizer"})
end
aurum.magic.register_spell_ritual("growth", {
	longdesc = S"Extracts the primal energy of fertilizer and burns it into spell scrolls of growth. Requires bananas to appease the elements.",

	size = b.box.new(vector.new(-1, 0, -1), vector.new(1, 2, 0)),

	recipe = b.t.icombine(fertilizer_wall, {
		{vector.new(0, 1, 0), "aurum_storage:scroll_hole"},
		{vector.new(-1, 0, 0), "aurum_trees:banana"},
		{vector.new(1, 0, 0), "aurum_trees:banana"},
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
