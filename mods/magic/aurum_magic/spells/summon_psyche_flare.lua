local S = minetest.get_translator()

aurum.magic.register_spell("summon_psyche_flare", {
	description = S"Summon Psyche Flare",
	max_level = 3,

	apply_requirements = function(pointed_thing)
		return not not minetest.get_pointed_thing_position(pointed_thing)
	end,

	apply = function(pointed_thing, level, player)
		local object = aurum.mobs.spawn(minetest.get_pointed_thing_position(pointed_thing), "aurum_mobs_monsters:psyche_flare")
		if object then
			local data = object:get_luaentity()._data.gemai
			data.attack.damage.psyche = 5 * level
			data.parent = b.ref_to_table(player)
			return true
		end
		return false
	end,
})

