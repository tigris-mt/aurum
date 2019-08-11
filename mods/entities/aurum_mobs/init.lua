aurum.mobs = {}

aurum.mobs.mobs = {}

function aurum.mobs.register(name, def)
	local def = b.t.combine({
		description = "?",
	}, def, {
		name = name,
	})

	def.gemai = b.t.combine({}, def.gemai or {})

	minetest.register_entity(name, {
		initial_properties = {
			physical = true,
			hp_max = true,

			visual = "wielditem",
			visual_size = {x = 1, y = 1},
			textures = {"aurum_base:regret"},
		},

		_aurum_mob = def,

		_mob_init = function(self)
		end,

		on_activate = function(self, staticdata, dtime)
			self._data = b.t.combine({
				initialized = false,
				gemai = {},
			}, minetest.deserialize(staticdata) or {})

			if not self._data.initialized then
				self._data.initialized = true
				self:_mob_init()
				self.gemai:fire_event("init")
			end

			self.object:set_properties(self._data.properties or {})

			gemai.attach_to_entity(self, def.gemai, self._data.gemai)
			self.gemai:step(dtime)
		end,

		get_staticdata = function(self)
			self._data.properties = self.object:get_properties()
			return minetest.serialize(self._data)
		end,

		on_step = function(self, dtime)
			self.gemai:step(dtime)
		end,

		on_death = function(self)
			self.gemai:fire_event("death")
		end,

		on_punch = function(self, puncher)
			self.gemai:fire_event("punch", {
				other = puncher,
			})
		end,

		on_rightclick = function(self, clicker)
			self.gemai:fire_event("interact", {
				other = clicker,
			})
		end,
	})

	aurum.mobs.mobs[name] = def
end
