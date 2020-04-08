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
