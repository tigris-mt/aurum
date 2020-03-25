local S = minetest.get_translator()

local stages = {
	NEW = 1,
	FLOWERING = 2,
	GREEN = 3,
	MATURE = 4,
}

minetest.register_node("aurum_farming:green_pumpkin", {
	description = S"Green Pumpkin",
	tiles = {"aurum_farming_pumpkin.png^[colorize:#00ff00:127"},
	sounds = aurum.sounds.wood(),
	groups = {dig_chop = 3},
})

minetest.register_node("aurum_farming:ripe_pumpkin", {
	description = S"Ripe Pumpkin",
	tiles = {"aurum_farming_pumpkin.png"},
	sounds = aurum.sounds.wood(),
	groups = {dig_chop = 3},

	after_dig_node = function(pos, _, oldmetadata, player)
		if oldmetadata.fields.uid and oldmetadata.fields.uid ~= 0 then
			aurum.player.mana_sparks(player, pos, "digging", 1, 1)
		end
	end,
})

minetest.register_craft{
	output = "aurum_base:pumpkin_seed 9",
	recipe = {{"aurum_base:pumpkin"}},
}

local function find_spot(pos)
	local box = b.box.new_radius(pos, 1)
	for _,target in ipairs(b.t.shuffled(minetest.find_nodes_in_area_under_air(box.a, box.b, {"group:soil"}))) do
		local place = vector.add(target, vector.new(0, 1, 0))
		if vector.distance(pos, place) <= 1 then
			return place
		end
	end
end

local function find_green(pos)
	local uid = minetest.get_meta(pos):get_int("uid")
	local box = b.box.new_radius(pos, 1)
	for _,target in ipairs(b.t.shuffled(minetest.find_nodes_in_area(box.a, box.b, {"aurum_farming:green_pumpkin"}))) do
		if minetest.get_meta(target):get_int("uid") == uid then
			return target
		end
	end
end

aurum.farming.register_crop("aurum_farming:pumpkin", {
	texture = "aurum_farming_pumpkin",
	description = S"Pumpkin",
	max = stages.MATURE,

	time = function()
		return math.random(600, 1200)
	end,

	seed = {},

	final_fail = function(pos, def, node)
		minetest.set_node(pos, {name = "aurum_flora:desert_weed"})
	end,

	on_growth = function(pos, def, stage)
		-- Ripen all green pumpkins in every stage.
		local green
		repeat
			green = find_green(pos)
			if green then
				minetest.swap_node(green, {name = "aurum_farming:ripe_pumpkin"})
			end
		until not green

		-- Green stage, add new green pumpkin.
		if stage == stages.GREEN then
			local spot = find_spot(pos)
			if spot then
				minetest.set_node(spot, {name = "aurum_farming:green_pumpkin"})
				minetest.get_meta(spot):set_int("uid", minetest.get_meta(pos):get_int("uid"))
			end
		-- Mature stage, go back to flowering.
		elseif stage == stages.MATURE then
			minetest.set_node(pos, {name = "aurum_farming:pumpkin_" .. stages.FLOWERING})
		end
	end,
})

