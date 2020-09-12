aurum.mobs.initial_data.summon = {
	mob = "aurum_mobs_monsters:psyche_flare",
	time = 1,
}

gemai.register_action("aurum_npcs:summon", function(self)
	if math.random() * self.data.summon.time < self.data.step_time then
		local object = aurum.mobs.spawn(self.entity.object:get_pos(), self.data.summon.mob)
		if object then
			local data = object:get_luaentity()._data.gemai
			data.parent = b.ref_to_table(self.entity.object)
			data.herd = self.data.herd
		end
	end
end)

