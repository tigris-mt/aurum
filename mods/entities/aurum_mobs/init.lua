local S = minetest.get_translator()
local storage = minetest.get_mod_storage()

aurum.mobs = {
	DEBUG = minetest.settings:get_bool("aurum.mobs.debug", false),
}

aurum.mobs.mobs = {}
aurum.mobs.shortcuts = {}
aurum.mobs.initial_data = {
	-- Items dropped upon death. Tables or strings, not ItemStacks.
	drops = {},
	-- Where does this mob naturally live?
	habitat_nodes = {},
	-- Mana released upon death.
	xmana = 1,
}

local uids = storage:get_int("uids")

local old = gemai.ref_to_table
function gemai.ref_to_table(obj)
	if obj:get_luaentity() and obj:get_luaentity()._aurum_mobs_id then
		return {type = "aurum_mob", id = obj:get_luaentity()._aurum_mobs_id}
	else
		return old(obj)
	end
end

-- For mobs that walk simply.
aurum.mobs.PATHMETHOD_WALK = b.pathfinder.get_pathfinder(b.set{
	"specify_vertical",
})

aurum.mobs.DEFAULT_PATHFINDER = {
	method = aurum.mobs.PATHMETHOD_WALK,
	search_distance = 48,
	jump_height = 2,
	drop_height = 3,
}

function aurum.mobs.register(name, def)
	local def = b.t.combine({
		-- Human readable description.
		description = "?",
		-- More information.
		longdesc = "",
		-- Initial entity properties.
		initial_properties = {},
		-- Initial armor groups.
		armor_groups = {},
		-- Initial gemai data.
		initial_data = {},
		-- Initial collision and selection box.
		box = {-0.35, -0.35, -0.35, 0.35, 0.35, 0.35},
	}, def, {
		name = name,
	})

	aurum.mobs.shortcuts[name:sub(name:find(":") + 1, #name)] = name

	def.gemai = b.t.combine({}, def.gemai or {})

	minetest.register_entity(":" .. name, {
		initial_properties = b.t.combine({
			hp_max = 1,
			physical = 1,

			collisionbox = def.box,
			selectionbox = def.box,
		}, def.initial_properties),

		_aurum_mob = def,

		_mob_init = function(self)
		end,

		_mob_death = function(self, killer)
		end,

		on_activate = function(self, staticdata, dtime)
			uids = uids + 1
			self._aurum_mobs_id = uids
			storage:set_int("uids", uids)

			self._data = b.t.combine({
				initialized = false,
				gemai = {},
			}, minetest.deserialize(staticdata) or {})

			self._data.gemai = b.t.combine(b.t.deep_copy(b.t.combine(aurum.mobs.initial_data, def.initial_data)), self._data.gemai)

			self.object:set_armor_groups(b.t.combine(gdamage.armor_defaults(), def.armor_groups))

			-- If the entity is new, run initialization.
			if not self._data.initialized then
				self:_mob_init()
			end

			-- Update properties from saved data.
			self.object:set_properties(self._data.properties or {})
			self.object:set_nametag_attributes(self._data.nametag_attributes or {})
			if self._data.armor_groups then
				self.object:set_armor_groups(self._data.armor_groups)
			end

			-- Attach gemai.
			gemai.attach_to_entity(self, def.gemai, self._data.gemai)

			self._gemai.debug_desc = function(self)
				return ("(entity) %s %s"):format(self.entity._aurum_mob.name, minetest.pos_to_string(vector.round(self.entity.object:get_pos())))
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
			self._data.armor_groups = self.object:get_armor_groups()
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

		on_death = function(self, killer)
			self:_mob_death(killer)
			if killer and killer:is_player() then
				xmana.sparks(self.object:get_pos(), self._gemai.data.xmana, killer:get_player_name())
			end
			for _,drop in ipairs(self._gemai.data.drops) do
				aurum.drop_item(self.object:get_pos(), ItemStack(drop))
			end
		end,

		on_punch = function(self, puncher)
			if puncher ~= self.object then
				self._gemai:fire_event("punch", {
					other = gemai.ref_to_table(puncher),
					target = {
						type = "ref_table",
						ref_table = gemai.ref_to_table(puncher),
					},
				}, {clear = true})
			end
		end,

		on_rightclick = function(self, clicker)
			self._gemai:fire_event("interact", {
				other = gemai.ref_to_table(clicker),
			}, {clear = true})
		end,
	})

	aurum.mobs.mobs[name] = def
	aurum.mobs.add_doc(name)
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

		local mob = (#param > 0 and aurum.mobs.shortcuts[param]) or param

		if not aurum.mobs.mobs[mob] then
			return false, S"No such mob."
		end

		local obj = aurum.mobs.spawn(vector.add(vector.round(player:get_pos()), vector.new(0, 1, 0)), mob)
		if obj then
			return true, S("Spawned @1 (@2).", mob, aurum.mobs.mobs[mob].description)
		else
			return false, S("Unable to spawn @1.", mob)
		end
	end,
})

b.dodir("actions")
b.dofile("doc.lua")
b.dofile("spawning.lua")
