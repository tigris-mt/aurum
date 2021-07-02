local S = aurum.get_translator()
aurum.cook = {}

local cook_nodes = {}

-- Register a cooker.
function aurum.cook.register(name, def)
	local def = b.t.combine({
		-- Range of cooking.
		range = {0, 10},

		-- General node def.
		node = {},

		-- Active node def.
		active = {},

		name = name,
		active_name = name .. "_active",
	}, def)

	local function valid(stack)
		local temp = minetest.get_item_group(stack:get_name(), "cook_temp")
		return temp >= def.range[1] and temp <= def.range[2] and minetest.get_craft_result({method = "cooking", width = 1, items = {stack}}).time ~= 0
	end

	local function allow_metadata_inventory_put(pos, listname, _, stack, player)
		if aurum.is_protected(pos, player) then
			return 0
		end

		local inv = minetest.get_meta(pos):get_inventory()

		if listname == "fuel" then
			return (minetest.get_craft_result({method = "fuel", width = 1, items = {stack}}).time ~= 0) and stack:get_count() or 0
		elseif listname == "src" then
			return valid(stack) and stack:get_count() or 0
		elseif listname == "dst" then
			return stack:get_count()
		end
	end

	local function allow_metadata_inventory_take(pos, _, _, stack, player)
		if aurum.is_protected(pos, player) then
			return 0
		end
		return stack:get_count()
	end

	local form = smartfs.create(name, function(state)
		local s = aurum.player.inventory_size(state.location.player)
		state:size(math.max(8, s.x), s.y + 4)

		local pos = state.param.pos
		local meta = minetest.get_meta(pos)
		local invloc = ("nodemeta:%d,%d,%d"):format(pos.x, pos.y, pos.z)

		state:inventory(1.5, 0.5, 1, 1, "src"):setLocation(invloc)
		state:image(1.5, 1.5, 1, 1, "fireimage", ("default_furnace_fire_bg.png^[lowpart:%s:default_furnace_fire_fg.png"):format(100 - (state.param.fuel or 100) * 100))
		state:inventory(1.5, 2.5, 1, 1, "fuel"):setLocation(invloc)

		state:image(3, 1.5, 1, 1, "arrowimage", ("gui_furnace_arrow_bg.png^[lowpart:%s:gui_furnace_arrow_fg.png^[transformR270"):format((state.param.cook or 0) * 100))

		state:inventory(4.5, 1, 2, 2, "dst"):setLocation(invloc)

		state:inventory(0, 4, s.x, s.y, "main")

		state:element("code", {name = "listring", code = [[
			listring[]] .. invloc .. [[;dst]
			listring[current_player;main]
			listring[]] .. invloc .. [[;src]
			listring[current_player;main]
			listring[]] .. invloc .. [[;fuel]
			listring[current_player;main]
		]]})
	end)

	def.node = b.t.combine({
		allow_metadata_inventory_put = allow_metadata_inventory_put,
		allow_metadata_inventory_move = aurum.metadata_inventory_move_delegate,
		allow_metadata_inventory_take = allow_metadata_inventory_take,

		_doc_items_usagehelp = S"Insert fuel in the bottom slot and something to smelt in the top slot.",

		on_construct = function(pos)
			local meta = minetest.get_meta(pos)
			local inv = meta:get_inventory()
			inv:set_size("src", 1)
			inv:set_size("dst", 2 * 2)
			inv:set_size("fuel", 1)

			form:attach_to_node(pos)
		end,

		on_receive_fields = smartfs.nodemeta_on_receive_fields,

		on_timer = function(pos, elapsed)
			local node = minetest.get_node(pos)
			local meta = minetest.get_meta(pos)
			local inv = meta:get_inventory()

			local mt = {}
			for _,k in ipairs{
				-- How much time did the last fuel give us?
				"burn_time",
				-- How much time of the last fuel has been burned?
				"burned",
				-- How long has the current src cooked for?
				"cooking",
			} do
				mt[k] = meta:get_float(k)
			end

			local result, replacement

			while elapsed > 0 do
				result, replacement = minetest.get_craft_result({method = "cooking", width = 1, items = inv:get_list("src")})
				-- Is there something to cook?
				local valid = (result.time ~= 0)

				-- Modify cooking time according to temperature.
				-- Add 1/3 second for each temperature above this cooker's minimum.
				result.time = result.time + math.max(0, aurum.cook.get_temp(inv:get_list("src")[1]) - def.range[1]) / 3

				-- Ensure we check according to what fuel remains.
				local run = math.min(elapsed, mt.burn_time - mt.burned)
				-- If something is cooking, then check according to what time remains.
				if valid then
					run = math.min(run, result.time - mt.cooking)
				end

				elapsed = elapsed - run

				-- If we're still on the current fuel...
				if mt.burned < mt.burn_time then
					-- Add burn time.
					mt.burned = mt.burned + run

					if valid then
						-- Add cooking time.
						mt.cooking = mt.cooking + run
						-- If we have enough time and there is room...
						if mt.cooking >= result.time and inv:room_for_item("dst", result.item) then
							-- Add total mana.
							local mana = minetest.get_item_group(inv:get_list("src")[1]:get_name(), "cook_xmana")
							if mana > 0 then
								meta:set_int("mana", meta:get_int("mana") + mana)
								meta:set_int("mana_num", meta:get_int("mana_num") + 1)
							end
							-- Set the items.
							inv:add_item("dst", result.item)
							inv:set_list("src", replacement.items)

							-- Reset the cooking timer.
							mt.cooking = mt.cooking - result.time
						end
					end
				-- Out of current fuel.
				else
					if valid then
						local fresult, freplacement = minetest.get_craft_result({method = "fuel", width = 1, items = inv:get_list("fuel")})

						-- Burn fuel.
						if fresult.time > 0 then
							inv:set_list("fuel", freplacement.items)
							-- Add new fuel to burn time and subtract old fuel.
							mt.burn_time = mt.burn_time + fresult.time - mt.burned
							mt.burned = 0
						-- No fuel, reset and break.
						else
							for k in pairs(mt) do mt[k] = 0 end
							break
						end
					-- Nothing to cook, reset and break.
					else
						for k in pairs(mt) do mt[k] = 0 end
						break
					end
				end
			end

			for k,v in pairs(mt) do
				meta:set_float(k, v)
			end

			-- Reset the formspec.
			form:attach_to_node(pos, {
				fuel = mt.burn_time > 0 and mt.burned / mt.burn_time,
				cook = result.time > 0 and mt.cooking / result.time,
			})

			if mt.burn_time > 0 then
				local above = vector.add(pos, vector.new(0, 1, 0))
				minetest.add_particlespawner{
					minpos = above,
					maxpos = vector.new(above, vector.new(1, 1, 1)),

					minvel = vector.new(-0.5, 0.5, -0.5),
					maxvel = vector.new(0.5, 1.5, 0.5),

					collisiondetection = true,
					collision_removal = true,

					minsize = 0.5,
					maxsize = 3,

					amount = math.random(1, 5),
					time = 0.9,
					texture = "default_item_smoke.png",

					minexptime = 1,
					maxexptime = 3,
				}
			end

			minetest.swap_node(pos, b.t.combine(node, {
				name = (mt.burn_time > 0) and def.active_name or def.name,
			}))

			-- If there is still fuel burning, keep the timer running.
			return mt.burn_time > 0
		end,

		on_metadata_inventory_move = function(pos)
			if not minetest.get_node_timer(pos):is_started() then
				minetest.get_node_timer(pos):start(1)
			end
		end,

		on_metadata_inventory_put = function(pos)
			if not minetest.get_node_timer(pos):is_started() then
				minetest.get_node_timer(pos):start(1)
			end
		end,

		on_metadata_inventory_take = function(pos, listname, _, _, player)
			if listname ~= "dst" then
				return
			end
			local meta = minetest.get_meta(pos)
			aurum.player.mana_sparks(player, vector.add(pos, vector.new(0, 1, 0)), "smelting", meta:get_int("mana_num"), meta:get_int("mana"))
			meta:set_int("mana", 0)
			meta:set_int("mana_num", 0)
		end,

		on_blast = aurum.drop_all_blast,

		on_destruct = aurum.drop_all,

		is_ground_content = false,
	}, def.node)

	def.active = b.t.combine(def.node, {
		drop = def.name,
		light_source = 8,
		_doc_items_create_entry = false,
		groups = b.t.combine(def.node.groups, {
			not_in_creative_inventory = 1,
		}),
	}, def.active)

	minetest.register_node(def.name, def.node)
	minetest.register_node(def.active_name, def.active)

	doc.add_entry_alias("nodes", def.name, "nodes", def.active_name)

	cook_nodes[def.name] = def
	cook_nodes[def.active_name] = def
end

function aurum.cook.get_temp(item)
	return minetest.get_item_group(ItemStack(item):get_name(), "cook_temp")
end

doc.sub.items.register_factoid("nodes", "use", function(itemstring, def)
	if cook_nodes[itemstring] then
		return S("This node cooks items requiring a temperature level from @1 to @2.", cook_nodes[itemstring].range[1], cook_nodes[itemstring].range[2])
	end
	return ""
end)

doc.sub.items.register_factoid(nil, "use", function(itemstring, def)
	if minetest.get_craft_result({method = "cooking", width = 1, items = {ItemStack(itemstring)}}).time ~= 0 then
		return S("This item cooks at a temperature level of @1.", aurum.cook.get_temp(itemstring))
	end
	return ""
end)

aurum.cook.register("aurum_cook:smelter", {
	range = {10, 20},
	node = {
		description = S"Smelter",
		_doc_items_longdesc = S"Stone piled into a smelting furnace.",
		_doc_items_hidden = false,

		tiles = {
			"aurum_cook_smelter_top.png", "aurum_cook_smelter.png",
			"aurum_cook_smelter.png", "aurum_cook_smelter.png",
			"aurum_cook_smelter.png", "aurum_cook_smelter_front.png",
		},

		paramtype2 = "facedir",
		sounds = aurum.sounds.stone(),

		groups = {dig_pick = 2},
	},
	active = {
		tiles = {
			"aurum_cook_smelter_top.png", "aurum_cook_smelter.png",
			"aurum_cook_smelter.png", "aurum_cook_smelter.png",
			"aurum_cook_smelter.png",
			{
				image = "aurum_cook_smelter_front_active.png",
				animation = {
					type = "vertical_frames",
					aspect_w = 16,
					aspect_h = 16,
					length = 1,
				},
			},
		},
	},
})

minetest.register_craft{
	output = "aurum_cook:smelter",
	recipe = {
		{"aurum_base:stone", "aurum_base:stone", "aurum_base:stone"},
		{"aurum_base:stone", "", "aurum_base:stone"},
		{"aurum_base:stone", "aurum_base:stone", "aurum_base:stone"},
	},
}

aurum.cook.register("aurum_cook:oven", {
	range = {0, 10},
	node = {
		description = S"Flare Oven",
		_doc_items_longdesc = S"A fuel-fired flare furnace.",
		_doc_items_hidden = false,

		drawtype = "nodebox",
		node_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5, -0.5, 0.5, 0.25, 0.5},
				{-0.2, 0.25, -0.2, 0.2, 0.8, 0.2},
			},
		},

		tiles = {
			"aurum_cook_oven_top.png", "aurum_cook_oven.png",
			"aurum_cook_oven.png", "aurum_cook_oven.png",
			"aurum_cook_oven.png", "aurum_cook_oven_front.png",
		},

		paramtype2 = "facedir",
		sounds = aurum.sounds.stone(),

		groups = {dig_pick = 2},
	},
	active = {
		tiles = {
			"aurum_cook_oven_top.png", "aurum_cook_oven.png",
			"aurum_cook_oven.png", "aurum_cook_oven.png",
			"aurum_cook_oven.png",
			{
				image = "aurum_cook_oven_front_active.png",
				animation = {
					type = "vertical_frames",
					aspect_w = 16,
					aspect_h = 16,
					length = 1,
				},
			},
		},
	},
})

minetest.register_craft{
	output = "aurum_cook:oven",
	recipe = {
		{"aurum_base:stone", "aurum_base:stone", "aurum_base:stone"},
		{"aurum_base:stone", "aurum_flare:flare", "aurum_base:stone"},
	},
}
