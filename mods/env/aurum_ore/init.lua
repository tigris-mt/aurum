local S = minetest.get_translator()

aurum.ore = {}

aurum.ore.ores = {}

function aurum.ore.register(name, def)
	local def = b.t.combine({
		description = "?",

		-- Which realms does this ore spawn in?
		realms = {"aurum:aurum"},

		-- The base texture.
		texture = "aurum_ore_white.png",

		-- The digging level of the ore.
		level = 0,

		-- Rarity (<rarity>^3 is used).
		rarity = 8,
		-- Ores per generation.
		num = 9,
		-- Size of generation.
		size = 3,

		-- How deep does this ore start appearing?
		depth = 10,
		-- Growths (e.g. {-100, -200}), will create new generation levels with more of the ore beginning at each specified y-level.
		growths = {},

		-- Names of the sub blocks.
		-- If false, will not create them.
		ore = name .. "_ore",
		ingot = name .. "_ingot",
		block = name .. "_block",

		-- Register default crafts?
		recipes = true,

		-- Override for the ore node registration def.
		ore_override = {},
	}, def)

	if def.ingot then
		minetest.register_craftitem(":" .. def.ingot, {
			_doc_items_longdesc = S"Smelted metal molded into a portable shape.",
			description = S("@1 Ingot", def.description),
			inventory_image = ("(%s^aurum_ore_ingot.png)^[makealpha:255,0,255"):format(def.texture),
		})
	end

	if def.block then
		minetest.register_node(":" .. def.block, {
			_doc_items_longdesc = S"A solid chunk of metal.",
			description = S("@1 Block", def.description),
			tiles = {("%s^aurum_ore_block.png"):format(def.texture)},
			groups = {dig_pick = math.max(1, 3 - def.level), level = math.min(3, def.level + 1)},
			sounds = aurum.sounds.metal(),
		})

		if def.recipes then
			minetest.register_craft{
				output = def.block,
				recipe = {
					{def.ingot, def.ingot, def.ingot},
					{def.ingot, def.ingot, def.ingot},
					{def.ingot, def.ingot, def.ingot},
				},
			}

			minetest.register_craft{
				output = def.ingot .. " 9",
				recipe = {{def.block}},
			}
		end
	end

	if def.ore then
		minetest.register_node(":" .. def.ore, b.t.combine({
			_doc_items_longdesc = S"A mineable block of metal ore.",
			description = S("@1 Ore", def.description),
			tiles = {("aurum_base_stone.png^((%s^aurum_ore_ore.png)^[makealpha:255,0,255)"):format(def.texture)},
			groups = {dig_pick = math.min(3, 3 - def.level + 1), level = def.level, cook_temp = 13 + def.level, cook_xmana = def.level * 2 + 1},
			sounds = aurum.sounds.stone(),
		}, def.ore_override))

		if def.recipes and def.ingot then
			minetest.register_craft{
				type = "cooking",
				output = def.ingot,
				recipe = def.ore,
			}
		end

		for _,realmid in ipairs(def.realms) do
			local realm = aurum.realms.get(realmid)
			local biomes = assert(aurum.biomes.realms[realmid])

			local combined = b.t.icombine({def.depth}, def.growths)
			for index,depth in ipairs(combined) do

				local nextdepth = combined[index + 1] or realm.global_box.a.y

				local d = {
					biomes = biomes,
					ore_type = "scatter",
					ore = def.ore,
					wherein = realm.biome_default.node_stone,
					clust_scarcity = math.floor(math.pow(def.rarity, 3) + 0.5),
					clust_num_ores = def.num,
					clust_size = math.floor(def.size + 0.5),
					y_max = depth + realm.y,
					y_min = nextdepth,
				}

				if index == 1 then
					minetest.register_ore(d)
				else
					local m = index - 1

					minetest.register_ore(b.t.combine(d, {
						clust_scarcity = math.floor(math.pow(def.rarity / (1 + m / 10), 3) + 0.5),
						clust_num_ores = math.floor(def.num * (1 + m / 10) + 0.5),
						clust_size = math.floor(def.size * (1 + m / 10) + 0.5),
						y_max = depth + realm.y,
					}))
				end
			end
		end
	end

	aurum.ore.ores[name] = def
end

aurum.dofile("mana_beans.lua")
aurum.dofile("metals.lua")
