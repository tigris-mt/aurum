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
		growth = -400,
	}, def)

	minetest.register_node(":" .. name .. "_ore", {
		_doc_items_longdesc = S"A mineable block of metal ore.",
		description = S("@1 Ore", def.description),
		tiles = {("aurum_base_stone.png^((%s^aurum_ore_ore.png)^[makealpha:255,0,255)"):format(def.texture)},
		groups = {dig_pick = math.max(1, def.level), level = def.level},
		sounds = aurum.sounds.stone(),
	})

	minetest.register_craftitem(":" .. name .. "_ingot", {
		_doc_items_longdesc = S"Smelted metal molded into a portable shape.",
		description = S("@1 Ingot", def.description),
		inventory_image = ("(%s^aurum_ore_ingot.png)^[makealpha:255,0,255"):format(def.texture),
	})

	minetest.register_node(":" .. name .. "_block", {
		_doc_items_longdesc = S"A solid chunk of metal.",
		description = S("@1 Block", def.description),
		tiles = {("%s^aurum_ore_block.png"):format(def.texture)},
		groups = {dig_pick = math.min(3, def.level + 1), level = math.min(3, def.level + 1)},
		sounds = aurum.sounds.metal(),
	})

	for _,realmid in ipairs(def.realms) do
		local realm = aurum.realms.get(realmid)
		local biomes = assert(aurum.biomes.realms[realmid])

		local d = {
			biomes = biomes,
			ore_type = "scatter",
			ore = name .. "_ore",
			wherein = realm.stone,
			clust_scarcity = math.pow(def.rarity, 3),
			clust_num_ores = def.num,
			clust_size = def.size,
			y_max = def.depth + realm.y,
			y_min = realm.global_box.a.y,
		}
		minetest.register_ore(d)

		if def.growth then
			minetest.register_ore(table.combine(d, {
				clust_scarcity = math.pow(def.rarity * 0.75, 3),
				clust_num_ores = def.num * 1.25,
				clust_size = def.size * 1.25,
				y_max = def.growth + realm.y,
			}))
		end
	end

	aurum.ore.ores[name] = def
end

aurum.ore.register("aurum_ore:copper", {
	description = S"Copper",
	texture = "aurum_ore_white.png^[colorize:#B87333:255",
	level = 0, depth = 0, growth = -200,
	rarity = 9, num = 6, size = 3,
})
