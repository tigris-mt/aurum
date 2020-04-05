local S = minetest.get_translator()

for _,c in ipairs{
	{
		name = "red",
		desc = "Red",
	},
	{
		name = "yellow",
		desc = "Yellow",
	},
	{
		name = "white",
		desc = "White",
	},
	{
		name = "blue",
		desc = "Blue",
	},
} do
	local tb = "aurum_trees_crystal_%s.png^[colorize:" .. b.color.tostring(c.name) .. ":127"
	aurum.trees.register("aurum_trees:" .. c.name .. "_crystal", {
		description = S(c.desc .. " Crystal"),
		texture_base = tb,
		terrain = {"aurum_base:regret", "aurum_base:aether_shell"},
		terrain_desc = S"regret and aether shells",

		trunk = {
			paramtype = "light",
			drawtype = "glasslike",
			light_source = 7,
			sunlight_propagates = true,
			use_texture_alpha = true,
			tiles = {tb:format("trunk")},
			sounds = aurum.sounds.glass(),
			groups = {dig_chop = 0, dig_pick = 3, flammable = 0, crystal_tree = 1},
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
