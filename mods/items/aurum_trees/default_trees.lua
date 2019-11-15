local S = minetest.get_translator()
local m = aurum.trees

m.register("aurum_trees:oak", {
	description = "Oak",
	texture_base = "aurum_trees_oak_%s.png",
})

m.register("aurum_trees:birch", {
	description = "Birch",
	texture_base = "aurum_trees_birch_%s.png",
})

-- "Pander"? I dunno, "jungle tree" sounded too generic.
m.register("aurum_trees:pander", {
	description = "Pander",
	texture_base = "aurum_trees_oak_%s.png^[colorize:#001100:160",
	decorations = {
		simple = 0,
		wide = 0,
		very_tall = 1,
		huge = 0.25,
		giant = 0.1,
	},
})

m.register("aurum_trees:drywood", {
	description = "Drywood",
	texture_base = "aurum_trees_drywood_%s.png",
	terrain = {"group:soil", "aurum_base:gravel"},
	terrain_desc = S"any dirt, soil, or gravel",
	decorations = {
		very_tall = 0.5,
		huge = 0.15,
	},
})

m.register("aurum_trees:pine", {
	description = "Pine",
	texture_base = "aurum_trees_pine_%s.png",
	terrain = {"group:soil", "group:snow"},
	terrain_desc = S"any dirt, soil, or snow",
	-- Pine trees only use cone schematics.
	decorations = b.t.combine(
		-- Map out default decorations.
		b.t.map(m.default_tree_decorations, function(v) return 0 end),
		{
			["cone,2"] = 0.1,
			["cone,3"] = 1,
			["cone,4"] = 1,
			["cone,5"] = 1,
			["cone,8"] = 0.25,
			["cone,9,0.5,3"] = 0.15,
			["cone,12"] = 0.1,
			["cone,14"] = 0.05,
			["cone,14,1.5"] = 0.05,
		}
	),
})

for _,c in ipairs{
	{
		name = "red",
		desc = "Red",
		texture = "[colorize:#FF0000:127",
	},
	{
		name = "yellow",
		desc = "Yellow",
		texture = "[colorize:#FFFF00:127",
	},
	{
		name = "white",
		desc = "White",
		texture = "[colorize:#FFFFFF:127",
	},
	{
		name = "blue",
		desc = "Blue",
		texture = "[colorize:#0000FF:127",
	},
} do
	local tb = "aurum_trees_crystal_%s.png^" .. c.texture
	m.register("aurum_trees:" .. c.name .. "_crystal", {
		description = c.desc .. " Crystal",
		texture_base = tb,
		terrain = {"aurum_base:regret"},
		terrain_desc = S"regret",

		trunk = {
			paramtype = "light",
			drawtype = "glasslike",
			light_source = 7,
			sunlight_propagates = true,
			use_texture_alpha = true,
			tiles = {tb:format("trunk")},
			sounds = aurum.sounds.glass(),
			groups = {dig_chop = 0, dig_pick = 3, flammable = 0},
		},

		leaves = {
			paramtype = "light",
			light_source = 11,
			sunlight_propagates = true,
			sounds = aurum.sounds.glass(),
			groups = {flammable = 0, leaves = 0, dye_source = 1, ["color_" .. c.name] = 1},
		},

		sapling = {
			paramtype = "light",
			light_source = 7,
			sounds = aurum.sounds.glass(),
			groups = {flammable = 0},
		},

		planks = "",
	})
end
