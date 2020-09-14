aurum.mobs.initial_data.summon = {
	-- Mob to summon.
	mob = "aurum_mobs_monsters:psyche_flare",
	-- Summon one mob every <time> seconds.
	time = 1,
	-- Nearby players make summoning faster by this factor times the number of players.
	-- The whole factor has a lower limit of 1 (no speedup).
	nearby_players_factor = 0,
}

gemai.register_action("aurum_npcs:summon", function(self)
	local npf = 1
	if self.data.summon.nearby_players_factor ~= 0 then
		math.max(1, self.data.summon.nearby_players_factor * aurum.mobs.helper_nearby_players(self))
	end
	if math.random() * self.data.summon.time / npf < self.data.step_time then
		local object = aurum.mobs.spawn(self.entity.object:get_pos(), self.data.summon.mob)
		if object then
			local data = object:get_luaentity()._data.gemai
			data.parent = b.ref_to_table(self.entity.object)
			data.herd = self.data.herd
		end
	end
end)

