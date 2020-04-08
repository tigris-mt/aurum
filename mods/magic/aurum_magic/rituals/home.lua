local S = minetest.get_translator()

aurum.magic.register_ritual("aurum_rituals:home", {
	description = S"Go Home",
	longdesc = S"Return to your respawn point.\nThis ritual can only be performed in Aurum.",

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
		-- Require Aurum.
		if screalms.pos_to_realm(at(vector.new(0, 0, 0))) ~= "aurum:aurum" then
			return false, S"Only the energies of Aurum could support this ritual."
		end
		return (aurum.player.spawn_totem(player) or aurum.player.spawn_realm(player)), S"There is nowhere for you to go."
	end,
})
