local S = aurum.get_translator()

aurum.mobs = {
	DEBUG = minetest.settings:get_bool("aurum.mobs.debug", false),
	CHEAP = minetest.settings:get_bool("aurum.mobs.cheap_pathfinding", false),
	SPAWN_LIMIT = tonumber(minetest.settings:get("aurum.mobs.spawn_limit")) or 1,
	SPAWNER_LIMIT = tonumber(minetest.settings:get("aurum.mobs.spawner_limit")) or 4,
	SPAWN_RADIUS = 40,
	SPAWN_CHECK_RADIUS = 80,
}

aurum.mobs.mobs = {}
aurum.mobs.shortcuts = {}
aurum.mobs.initial_data = {
	-- Items dropped upon death. Tables or strings, not ItemStacks.
	-- Can be complex, see drops.lua
	drops = {},
	-- Where does this mob naturally live?
	habitat_nodes = {},
	-- Mana released upon death.
	xmana = 1,

	-- Generic movement type.
	--- Can be: walk, fly, swim
	movement = "walk",

	status_effects = {},
}

-- Returns:
--- nil
-- or
--- gemai ref, name, id
function aurum.mobs.get_mob(object)
	local l = object:get_luaentity()
	if l and l._aurum_mobs_id then
		return l._gemai, l.name, l._aurum_mobs_id
	end
end

local old = b.ref_to_table
function b.ref_to_table(obj)
	local l = obj:get_luaentity()
	if l and l._aurum_mobs_id then
		return {type = "aurum_mob", id = l._aurum_mobs_id, name = l.name}
	else
		return old(obj)
	end
end

awards.register_trigger("mob_kill", {
	type = "counted_key",
	progress = "@1/@2 killed",
	auto_description = { "Kill: @2", "Kill: @1×@2" },
	auto_description_total = { "Kill @1 mob.", "Kill @1 mobs." },
	get_key = function(self, def)
		return def.trigger.mob
	end,
})

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
		-- Entity def overrides.
		entity_def = {},
		-- Herd identifier. Used to determine who not to hunt and who to help.
		herd = name,
	}, def, {
		name = name,
	})

	aurum.mobs.shortcuts[name:sub(name:find(":") + 1, #name)] = name

	def.gemai = b.t.combine({}, def.gemai or {})

	minetest.register_entity(":" .. name, b.t.combine({
		initial_properties = b.t.combine({
			hp_max = 1,
			physical = false,

			collisionbox = def.box,
			selectionbox = def.box,
		}, def.initial_properties),

		_aurum_mob = def,

		_mob_init = function(self)
		end,

		_mob_death = function(self, killer)
		end,

		on_activate = function(self, staticdata, dtime)
			self._aurum_mobs_id = b.new_uid()
			self._aurum_mobs_def = def

			local deserialized = minetest.deserialize(staticdata) or {}

			self._data = b.t.combine({
				initialized = false,
				gemai = {},
			}, deserialized.compressed and minetest.deserialize(minetest.decompress(deserialized.compressed)) or deserialized)

			self._data.gemai = b.t.combine(b.t.deep_copy(b.t.combine(aurum.mobs.initial_data, {
				herd = def.herd,
			}, def.initial_data)), self._data.gemai)

			self.object:set_armor_groups(b.t.combine(gdamage.armor_defaults(), def.armor_groups))

			-- Create temporary data to hold pathing.
			self._go = {}

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
			self.object:set_hp(self._data.hp or self.object:get_hp())

			-- Attach gemai.
			gemai.attach_to_entity(self, def.gemai, self._data.gemai)

			self._gemai.debug_desc = function(self)
				return ("(entity) %s %s"):format(self.entity._aurum_mob.name, minetest.pos_to_string(vector.round(self.entity.object:get_pos() or vector.new())))
			end

			self._gemai.is_valid = function(self)
				return self.entity.object:get_pos() ~= nil
			end

			-- If the entity is new, fire the init event to start the gemai state.
			if not self._data.initialized then
				self._gemai:fire_event("init")
			end

			self._last_pos = self.object:get_pos()

			-- Tick state if this is a returning mob.
			if self._data.initialized then
				self._gemai:step(dtime)
			end

			self._data.initialized = true
		end,

		get_staticdata = function(self)
			-- Save current properties.
			self._data.hp = self.object:get_hp()
			self._data.properties = self.object:get_properties()
			self._data.nametag_attributes = self.object:get_nametag_attributes()
			self._data.armor_groups = self.object:get_armor_groups()
			self._data.gemai = self._gemai.data

			return minetest.serialize{compressed = minetest.compress(minetest.serialize(self._data))}
		end,

		on_step = function(self, dtime)
			-- Out of map? Don't do anything.
			if minetest.get_node_or_nil(self.object:get_pos()) == nil then
				minetest.log("warning", self._gemai:debug_desc() .. " tried to step inside nil")
				return
			end

			self._last_pos = self.object:get_pos()

			local tag = ("%s %d/%d%s%s"):format(self._aurum_mob.name, self.object:get_hp(), self.object:get_properties().hp_max, minetest.colorize("#ff0000", "♥"),
				aurum.mobs.DEBUG and (" %s %d(%d)"):format(self._gemai.data.state, self._gemai.data.live_time, self._gemai.data.state_time) or "")
			self.object:set_properties{infotext = tag}
			-- self.object:set_nametag_attributes{text = tag}
			self._gemai:step(dtime)

			aurum.effects.operate(self.object, self._gemai.data.status_effects, dtime)
		end,

		on_death = function(self, killer)
			self:_mob_death(killer)
			local blame = aurum.get_blame(killer)
			local player = (blame.type == "player") and minetest.get_player_by_name(blame.id)
			if player then
				awards.notify_mob_kill(player, self.name)
				aurum.player.mana_sparks(player, self.object:get_pos(), "killing", self._gemai.data.xmana)
				for _,drop in ipairs(aurum.mobs.helper_get_drops(self._gemai.data.drops, killer)) do
					aurum.drop_item(self.object:get_pos(), drop)
				end
			end
		end,

		on_punch = function(self, puncher)
			if puncher ~= self.object then
				local ref_table = aurum.get_blame(puncher) or b.ref_to_table(puncher)
				local was_parent = self._gemai.data.parent and b.ref_table_equal(ref_table, self._gemai.data.parent)
				if ref_table and not was_parent then
					aurum.effects.apply_tool_effects(puncher:get_wielded_item(), self.object, ref_table)
					self._gemai:fire_event("punch", {
						other = ref_table,
						target = {
							type = "ref_table",
							ref_table = ref_table,
						},
					}, {clear = true})
				end
			end
		end,

		on_rightclick = function(self, clicker)
			self._gemai:fire_event("interact", {
				other = b.ref_to_table(clicker),
			}, {clear = true})
		end,
	}, def.entity_def))

	aurum.mobs.mobs[name] = def
	aurum.mobs.add_doc(name)
end

function aurum.mobs.spawn(pos, name, data)
	return minetest.add_entity(pos, name, (type(data) == "string") and data or minetest.serialize(data or {}))
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

b.dofile("drops.lua")
b.dofile("pathfinder.lua")

b.dodir("actions")
b.dofile("doc.lua")
b.dofile("spawning.lua")
b.dofile("spawner.lua")
