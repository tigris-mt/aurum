minetest.register_entity("aurum_effects:dummy", {
	initial_properties = {
		visual_size = {x = 0, y = 0},
		static_save = false,
	},

	on_activate = function(self, staticdata)
		self._blame = minetest.deserialize(staticdata)
	end,

	-- Remove on second step.
	on_step = function(self)
		if self._hit then
			self.object:remove()
		else
			self._hit = true
		end
	end,
})

-- Creates a temporary dummy object to punch <object> while blaming <blame>.
-- If unable to create or blame, the punchee will be returned.
function aurum.effects.make_blame_puncher(object, blame)
	return (function()
		if blame then
			return minetest.add_entity(object:get_pos(), "aurum_effects:dummy", minetest.serialize(blame))
		end
	end)() or object
end
