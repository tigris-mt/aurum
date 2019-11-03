local S = minetest.get_translator()
aurum.mobs = {}

aurum.mobs.mobs = {}

function aurum.mobs.register(name, def)
	local def = b.t.combine({
		description = "?",
	}, def, {
		name = name,
	})

	def.gemai = b.t.combine({}, def.gemai or {})

	minetest.register_entity(":" .. name, {
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

			-- If the entity is new, run initialization.
			if not self._data.initialized then
				self:_mob_init()
			end

			-- Update properties from saved data.
			self.object:set_properties(self._data.properties or {})

			-- Attach and tick gemai state.
			gemai.attach_to_entity(self, def.gemai, self._data.gemai)

			-- If the entity is new, fire the init event to start the gemai state.
			if not self._data.initialized then
				self.gemai:fire_event("init")
			end
			self.gemai:step(dtime)

			self._data.initialized = true
		end,

		get_staticdata = function(self)
			-- Save current properties.
			self._data.properties = self.object:get_properties()
			return minetest.serialize(self._data)
		end,

		on_step = function(self, dtime)
			self.gemai:step(dtime)
		end,

		on_death = function(self)
			self.gemai:fire_event("death", {terminate = true})
			self.gemai:step(0)
		end,

		on_punch = function(self, puncher)
			self.gemai:fire_event("punch", {
				other = gemai.ref_to_table(puncher),
			})
		end,

		on_rightclick = function(self, clicker)
			self.gemai:fire_event("interact", {
				other = gemai.ref_to_table(clicker),
			})
		end,
	})

	aurum.mobs.mobs[name] = def
end

function aurum.mobs.spawn(pos, name, data)
	return minetest.add_entity(pos, name, minetest.serialize(data or {}))
end

minetest.register_privilege("aurum_mobs", {
	description = S"Can create and modify mobs",
	give_to_singleplayer = false,
})

minetest.register_chatcommand("mob_spawn", {
	description = S"Spawn a mob.",
	privs = {aurum_mobs = true},
	func = function(name, param)
		local player = minetest.get_player_by_name(name)
		if not player then
			return false, S"No player."
		end

		local mob = param

		if not aurum.mobs.mobs[mob] then
			return false, S"No such mob."
		end
		local obj = aurum.mobs.spawn(player:get_pos(), mob)
		if obj then
			return true, S("Spawned @1 (@2).", mob, aurum.mobs.mobs[mob].description)
		else
			return false, S("Unable to spawn @1.", mob)
		end
	end,
})

b.dofile("actions.lua")
b.dofile("mobs/test.lua")
