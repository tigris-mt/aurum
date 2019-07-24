local S = minetest.get_translator()

aurum.magic.rituals = {}

function aurum.magic.register_ritual(name, def)
	local def = table.combine({
		-- Description of the ritual.
		description = "",
		longdesc = "",

		-- Box of the recipe/protection area.
		-- There must be room for 0,0,0 and the altar.
		size = aurum.box.new(vector.new(-1, 0, -1), vector.new(1, 0, 1)),

		-- List of {<relative pos>, <node>}. Accepts group:name item strings.
		-- Altar sits at 0,0,0 with -x going up according to the arrows on the altar and -z going to the left.
		recipe = {},

		-- Apply the ritual.
		-- <at> is a function converting a relative position to a rotated, offset global position.
		-- Return true to indicate success, false to indicate failure (no effects).
		apply = function(at, player)
			return true
		end,

		-- Check for protection first?
		protected = false,
	}, def)

	def.size = aurum.box.extremes(def.size)

	-- Saved hashed node positions for easier recall.
	local hashed = {}
	for _,v in ipairs(def.recipe) do
		hashed[minetest.hash_node_position(v[1])] = v[2]
	end
	def.hashed_recipe = hashed

	aurum.magic.rituals[name] = def
end

minetest.register_node("aurum_magic:altar", {
	description = S"Ritual Altar",
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, 0, -0.5, 0.5, 0.5, 0.5},
			{-0.25, -0.5, -0.25, 0.25, 0, 0.25},
		},
	},
	tiles = {"aurum_magic_altar_top.png", "aurum_trees_oak_planks.png"},
	sounds = aurum.sounds.wood(),
	groups = {dig_chop = 3, flammable = 1},
	paramtype2 = "facedir",
	on_place = minetest.rotate_node,

	on_rightclick = function(pos, node, player)
		local function at(offset)
			local actual = vector.new(0, offset.y, 0)
			if node.param2 % 4 == 0 then
				actual.x = offset.x
				actual.z = -offset.z
			elseif node.param2 % 4 == 1 then
				actual.x = -offset.z
				actual.z = -offset.x
			elseif node.param2 % 4 == 2 then
				actual.x = -offset.x
				actual.z = offset.z
			elseif node.param2 % 4 == 3 then
				actual.x = offset.z
				actual.z = offset.x
			end
			return vector.add(pos, actual)
		end

		for k,v in pairs(aurum.magic.rituals) do
			local function check()
				for _,noff in ipairs(aurum.box.iterate(v.size)) do
					if v.protected and aurum.is_protected(at(noff), player, true) then
						return false
					end
					if not vector.equals(noff, vector.new(0, 0, 0)) then
						if not aurum.match_item(minetest.get_node(at(noff)).name, v.hashed_recipe[minetest.hash_node_position(noff)] or "air") then
							return false
						end
					end
				end
				return true
			end

			if check() then
				if v.apply(at, player) then
					return
				else
					break
				end
			end
		end

		-- Smoke effect on failure.
		minetest.add_particlespawner{
			minpos = vector.add(pos, vector.new(0, 0.75, 0)),
			maxpos = vector.add(pos, vector.new(0, 1.25, 0)),

			minvel = vector.new(-0.5, 0.5, -0.5),
			maxvel = vector.new(0.5, 1.5, 0.5),

			collisiondetection = true,
			collision_removal = true,

			minsize = 1,
			maxsize = 2,

			amount = math.random(3, 5),
			time = 1,
			texture = "default_item_smoke.png",

			minexptime = 1,
			maxexptime = 3,
		}
	end,
})

minetest.register_craft{
	output = "aurum_magic:altar",
	recipe = {
		{"group:wood", "aurum_scrolls:scroll", "group:wood"},
		{"group:wood", "group:wood", "group:wood"},
		{"", "group:wood", ""},
	},
}

function aurum.magic.spell_ritual_inv(pos, listname, spell, standard)
	local inv = minetest.get_meta(pos):get_inventory()

	-- Number of scrolls.
	local ns = 0
	for i,v in ipairs(inv:get_list(listname)) do
		if v:get_name() == "aurum_scrolls:scroll" then
			ns = ns + v:get_count()
		end
	end

	ns = math.min(standard, ns)

	local level = math.min(aurum.magic.spells[spell].max_level, math.floor(math.max(1, standard / ns) + 0.5))
	local scroll = aurum.magic.new_spell_scroll(spell, level)

	local applied = 0

	for i=1,ns do
		-- Remove empty scroll.
		local removed = inv:remove_item(listname, "aurum_scrolls:scroll")
		-- Test if new scroll will fit.
		if inv:room_for_item(listname, scroll) then
			inv:add_item(listname, scroll)
			applied = applied + 1
		else
			-- Undo removal and break out of loop, no more room.
			inv:add_item(listname, removed)
			break
		end
	end

	return applied > 0
end
