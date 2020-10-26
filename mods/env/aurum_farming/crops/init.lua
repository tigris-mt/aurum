local S = aurum.get_translator()

local function new_uid(pos)
	minetest.get_meta(pos):set_int("uid", math.random(0x1000000))
end

-- Grow plant <def> at stage <i> with the next node being <next_name>.
function aurum.farming.grow_plant(i, next_name, def, pos, node)
	local below = vector.add(pos, vector.new(0, -1, 0))
	local bnode = minetest.get_node(below)

	-- Ensure there's wet soil of our level.
	if minetest.get_item_group(bnode.name, "soil_wet") < def.level then
		return false
	end

	-- And enough light.
	if (minetest.get_node_light(pos) or 0) < def.light then
		return false
	end

	-- And we're allowed.
	if not def.allow_growth(pos, def, i + 1, node) then
		return false
	end

	-- Save previous UID.
	local uid = minetest.get_meta(pos):get_int("uid")
	-- Warn if there was no UID.
	if uid == 0 then
		minetest.log("warning", ("%s has no UID while growing at %s"):format(node.name, minetest.pos_to_string(pos)))
	end

	-- To the next stage.
	minetest.set_node(pos, {name = next_name})

	-- Restore UID if it existed.
	if uid ~= 0 then
		minetest.get_meta(pos):set_int("uid", uid)
	end

	-- Callback.
	def.on_growth(pos, def, i + 1, node)

	-- If our stage was the second-to-last (so we just went to the last stage), then there's a chance to "final fail", which can be using up the fertilizer or killing the plant.
	if (i + 1) == def.max then
		if math.random() < def.final_fail_chance then
			def.final_fail(pos, def, node)
		end
	end

	return true
end

-- Plant timer handler (with addition def parameter).
function aurum.farming.timer(def, pos, dtime)
	local d = dtime
	local n = {name = "ignore"}
	while d > 0 do
		n = minetest.get_node(pos)
		-- At end of growth.
		if minetest.get_item_group(n.name, "farming_plant") == 2 then
			return false
		end
		if minetest.registered_items[n.name]._on_grow_plant(pos, n) then
			local next_time = def.time()
			if d > next_time then
				d = d - next_time
				-- Try again on next loop around.
			else
				next_time = next_time - d
				minetest.get_node_timer(pos):start(next_time)
				return false
			end
		else
			return true
		end
	end

	-- If this farming_plant is not final, then restart the timer.
	return minetest.get_item_group(n.name, "farming_plant") < 2
end

-- Register a crop <base_name> with <def> and optional decoration parameters <decodef>.
function aurum.farming.register_crop(base_name, def, decodef)
	local def = b.t.combine({
		-- What level of soil/fertilizer does this plant require?
		level = 1,

		-- How many stages?
		max = 1,

		-- How much light to grow?
		light = 10,

		-- Definition overrides for the nodes.
		node = {},

		-- How much time does it take this plant to grow a stage?
		time = function()
			return math.random(300, 900)
		end,

		-- Node names.
		seed_name = base_name .. "_seed",
		product_name = base_name .. "_product",

		-- Define seed as a table to create and override a seed item (empty table to just create).
		seed = nil,
		-- Define product as a table to create and override a product item (empty table to just create).
		product = nil,

		-- Define drops as function(i) where i is the stage number to return a standard MT node drop table.
		drops = function(i) end,

		-- Functions called on growth.
		-- The target stage is passed as `stage`.
		allow_growth = function(pos, def, stage, node) return true end,
		on_growth = function(pos, def, stage, node) end,

		-- Function called on initial planting.
		on_plant = function(pos, def) end,

		final_fail_chance = 0.25,
		final_fail = function(pos, def, node)
			minetest.set_node(vector.add(pos, vector.new(0, -1, 0)), {name = "aurum_base:dirt"})
		end,

		-- Group overrides.
		groups = {},
	}, def)
	local last_name = base_name .. "_" .. def.max

	for i=1,def.max do
		local name = (i == 1) and base_name or (base_name .. "_" .. i)
		local next_name = (i < def.max) and (base_name .. "_" .. (i + 1))

		-- Register with flora defaults.
		aurum.flora.register(":" .. name, b.t.combine({
			_aurum_farming = def,
			description = S("@1 Plant", def.description),
			_doc_items_usagehelp = S("Give this plant at least @1 light and wet, fertilized soil of level @2 or higher for growth and harvest. It grows in @3 stages.", def.light, def.level, def.max),
			groups = b.t.combine({
				-- Disable default flora handling.
				flora = 0,
				not_in_creative_inventory = (i ~= 1) and 1 or 0,
				-- 1 = potential to grow, 2 = fully mature.
				farming_plant = next_name and 1 or 2,
				grow_plant = next_name and 1 or 0
			}, def.groups),
			_doc_items_create_entry = (i == 1),
			_on_grow_plant = next_name and (function(...)
				return aurum.farming.grow_plant(i, next_name, def, ...)
			end),
			on_timer = function(...) return aurum.farming.timer(def, ...) end,
			on_construct = function(pos)
				-- Ensure that a UID exists.
				if i == 1 or minetest.get_meta(pos):get_int("uid") == 0 then
					new_uid(pos)
				end
				if i == 1 then
					def.on_plant(pos, def)
				end
				if next_name then
					minetest.get_node_timer(pos):start(def.time())
				end
			end,
			selection_box = {
				type = "fixed",
				fixed = {-0.25, -0.5, -0.25, 0.25, 0.25, 0.25},
			},
			drop = def.drops(i) or "",
			tiles = {def.texture .. "_" .. i .. ".png"},

			-- Give this plant's level in mana after digging if this is the mature plant.
			after_dig_node = function(pos, _, _, player)
				if not next_name then
					aurum.player.mana_sparks(player, pos, "digging", 1, def.level)
				end
			end,
		}, def.node or {}))
	end

	if def.seed then
		-- Register the seed as a node.
		minetest.register_node(def.seed_name, b.t.combine({
			_doc_items_usagehelp = S("Plant this seed on wet, fertilized soil of level @1 or higher.", def.level),
			description = S("@1 Seed", def.description),
			inventory_image = def.texture .. "_seed.png",
			wield_image = def.texture .. "_seed.png",

			-- Replace prediction with first stage crop.
			node_placement_prediction = base_name,

			groups = {farming_seed = 1},

			-- Immediately replace with the first stage.
			on_construct = function(pos)
				minetest.set_node(pos, {name = base_name})
			end,

			-- Only enable placement on wet soil.
			on_place = function(itemstack, placer, pointed_thing)
				local pos = minetest.get_pointed_thing_position(pointed_thing)
				if minetest.get_item_group(minetest.get_node(pos).name, "soil_wet") < def.level then
					return itemstack
				else
					return minetest.item_place(itemstack, placer, pointed_thing)
				end
			end,
		}, def.seed))
	end

	if def.product then
		-- Simple product, should be overridden for effects in the def.
		minetest.register_craftitem(def.product_name, b.t.combine({
			description = def.description,
			inventory_image = def.texture .. "_product.png",
		}, def.product))
	end

	if decodef then
		-- Simple decoration of the mature stage.
		minetest.register_decoration(b.t.combine({
			name = last_name,
			decoration = last_name,
			deco_type = "simple",
			sidelen = 16,
		}, decodef))
	end
end
