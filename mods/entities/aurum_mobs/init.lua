local S = minetest.get_translator()
aurum.mobs = {
	DEBUG = minetest.settings:get_bool("aurum.mobs.debug", false),
}

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
			hp_max = 1,

			visual = "wielditem",
			visual_size = {x = 0.6, y = 0.6},
			textures = {"aurum_base:regret"},

			collisionbox = {-0.4, -0.4, -0.4, 0.4, 0.4, 0.4},
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
			self.object:set_nametag_attributes(self._data.nametag_attributes or {})

			-- Attach gemai.
			gemai.attach_to_entity(self, def.gemai, self._data.gemai)

			self._gemai.debug_desc = function(self)
				return ("(entity) %s %s"):format(self.entity._aurum_mob.name, minetest.pos_to_string(self.entity.object:get_pos()))
			end

			-- If the entity is new, fire the init event to start the gemai state.
			if not self._data.initialized then
				self._gemai:fire_event("init")
			end

			-- Tick state.
			self._gemai:step(dtime)

			self._data.initialized = true
		end,

		get_staticdata = function(self)
			-- Save current properties.
			self._data.properties = self.object:get_properties()
			self._data.nametag_attributes = self.object:get_nametag_attributes()
			self._data.gemai = self._gemai.data
			return minetest.serialize(self._data)
		end,

		on_step = function(self, dtime)
			local tag = ("%s %d/%d%s%s"):format(self._aurum_mob.name, self.object:get_hp(), self.object:get_properties().hp_max, minetest.colorize("#ff0000", "♥"),
				aurum.mobs.DEBUG and (" %s %d(%d)"):format(self._gemai.data.state, self._gemai.data.live_time, self._gemai.data.state_time) or "")
			self.object:set_properties{infotext = tag}
			self.object:set_nametag_attributes{text = tag}
			self._gemai:step(dtime)
		end,

		on_death = function(self)
			self._gemai:fire_event("death", {terminate = true})
			self._gemai:step(0)
		end,

		on_punch = function(self, puncher)
			self._gemai:fire_event("punch", {
				other = gemai.ref_to_table(puncher),
			})
		end,

		on_rightclick = function(self, clicker)
			self._gemai:fire_event("interact", {
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
