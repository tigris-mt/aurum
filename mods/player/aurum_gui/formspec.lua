local mt = {
	show = function(self, pos, player_or_name, params)
		local player_name = type(player_or_name) == "string" and player_or_name or player_or_name:get_player_name()
		local state = self.form:show(player_name, self:make_params(pos, params))
		local k = minetest.pos_to_string(pos)
		self.poses[k] = self.poses[k] or {}
		self.poses[k][player_name] = state
	end,

	_reshow = function(self, pos, params)
		local k = minetest.pos_to_string(pos)
		for name,state in pairs(self.poses[k] or {}) do
			if state.players:get_first() then
				self.poses[k][name] = self.form:show(name, self:make_params(pos, params))
			end
		end
	end,

	reshow = function(self, ...)
		minetest.after(0, self._reshow, self, ...)
	end,

	make_params = function(self, pos, params)
		return b.t.combine(params or {}, {
			pos = pos,
		})
	end,
}

function aurum.gui.node_fs(form)
	return setmetatable({
		form = form,
		poses = {},
	}, {__index = mt})
end

function aurum.gui.node_smartfs(...)
	return aurum.gui.node_fs(smartfs.create(...))
end
