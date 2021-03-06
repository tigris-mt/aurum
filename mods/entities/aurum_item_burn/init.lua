-- Override __builtin:item to destroy itself if within group:item_burn nodes.
local old = minetest.registered_entities["__builtin:item"].on_step
minetest.registered_entities["__builtin:item"].on_step = function(self, ...)
	old(self, ...)

	local pos = self.object:get_pos()
	if not pos then
		return
	end
	local node = minetest.get_node(vector.add(pos, vector.new(0, self.object:get_properties().collisionbox[2] - 0.05, 0)))

	if minetest.get_item_group(node.name, "item_burn") > 0 then
		minetest.sound_play("default_cool_lava", {
			pos = self.object:get_pos(),
			gain = 0.1,
		})
		self.object:remove()
	end
end
