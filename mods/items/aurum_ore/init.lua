local S = minetest.get_translator()

aurum.ore = {}

aurum.ore.ores = {}

function aurum.ore.register(name, def)
	local def = table.combine({
		description = "?",

		-- Which realms does this ore spawn in?
		realms = {"aurum:aurum"},

		-- The base texture.
		texture = "aurum_ore_white.png",

		-- The digging level of the ore.
		level = 0,

		rarity = 8,
		num = 9,
		size = 3,

		depth = 10,
		growths = {},

		ore = true,
		ingot = true,
		block = true,
	}, def)

	if def.ingot then
		minetest.register_craftitem(":" .. name .. "_ingot", {
			_doc_items_longdesc = S"Smelted metal molded into a portable shape.",
			description = S("@1 Ingot", def.description),
			inventory_image = ("(%s^aurum_ore_ingot.png)^[makealpha:255,0,255"):format(def.texture),
		})
	end

	if def.block then
		minetest.register_node(":" .. name .. "_block", {
			_doc_items_longdesc = S"A solid chunk of metal.",
			description = S("@1 Block", def.description),
			tiles = {("%s^aurum_ore_block.png"):format(def.texture)},
			groups = {dig_pick = math.min(3, def.level + 1), level = math.min(3, def.level + 1)},
			sounds = aurum.sounds.metal(),
		})
	end

	if def.ore then
		minetest.register_node(":" .. name .. "_ore", {
			_doc_items_longdesc = S"A mineable block of metal ore.",
			description = S("@1 Ore", def.description),
			tiles = {("aurum_base_stone.png^((%s^aurum_ore_ore.png)^[makealpha:255,0,255)"):format(def.texture)},
			groups = {dig_pick = math.max(1, def.level), level = def.level},
			sounds = aurum.sounds.stone(),
		})

		for _,realmid in ipairs(def.realms) do
			local realm = aurum.realms.get(realmid)
			local biomes = assert(aurum.biomes.realms[realmid])

			local combined = table.icombine({def.depth}, def.growths)
			for index,depth in ipairs(combined) do

				local nextdepth = combined[index + 1] or realm.global_box.a.y

				local d = {
					biomes = biomes,
					ore_type = "scatter",
					ore = name .. "_ore",
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

					minetest.register_ore(table.combine(d, {
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

aurum.ore.register("aurum_ore:copper", {
	description = S"Copper",
	texture = "aurum_ore_white.png^[colorize:#b87333:255",
	level = 0, depth = 10,
	rarity = 9, num = 6, size = 3,
	growths = {-200, -400},
})

aurum.ore.register("aurum_ore:tin", {
	description = S"Tin",
	texture = "aurum_ore_white.png^[colorize:#d3d4d5:255",
	level = 1, depth = -100,
	rarity = 10, num = 6, size = 3,
	growths = {-300, -600},
})

aurum.ore.register("aurum_ore:bronze", {
	description = S"Bronze",
	texture = "aurum_ore_white.png^[colorize:#9c5221:255",
	level = 1,
	ore = false,
})

aurum.ore.register("aurum_ore:iron", {
	description = S"Iron",
	texture = "aurum_ore_white.png^[colorize:#50676b:255",
	level = 1, depth = -150,
	rarity = 11, num = 5, size = 4,
	growths = {-400, -600},
})

aurum.ore.register("aurum_ore:gold", {
	description = S"Gold",
	texture = "aurum_ore_white.png^[colorize:#ffc300:255",
	level = 2, depth = -250,
	rarity = 12, num = 3, size = 3,
	growths = {-600, -700},
})
