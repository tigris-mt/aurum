local S = minetest.get_translator()

local box = {
	type = "fixed",
	fixed = {{-0.4, -0.5, -0.4, 0.4, 0.5, 0.4}},
}

for i,c in ipairs{
	{
		name = "red",
		desc = "Red",
		heat_range = {75, 100},
	},
	{
		name = "violet",
		desc = "Violet",
		heat_range = {65, 85},
	},
	{
		name = "yellow",
		desc = "Yellow",
		heat_range = {50, 75},
	},
	{
		name = "blue",
		desc = "Blue",
		heat_range = {25, 50},
	},
	{
		name = "cyan",
		desc = "Cyan",
		heat_range = {15, 35},
	},
	{
		name = "white",
		desc = "White",
		heat_range = {0, 25},
	},
} do
	minetest.register_node("aurum_spikes:" .. c.name .. "_spike", {
		description = S(c.desc .. " Crystal Spike"),

		drawtype = "mesh",
		mesh = "aurum_spikes_spike.b3d",
		visual_scale = 0.1,
		tiles = {"aurum_spikes_spike.png^[colorize:" .. b.color.tostring(c.name) .. ":127"},

		paramtype2 = "facedir",
		on_place = minetest.rotate_node,

		selection_box = box,
		collision_box = box,

		paramtype = "light",
		light_source = 10,

		is_ground_content = false,
		groups = {dig_pick = 3},
	})

	aurum.features.register_decoration{
		place_on = {
			"aurum_base:stone",
			"aurum_base:regret",
		},
		noise_params = {
			offset = 0,
			scale = 0.1,
			spread = vector.new(200, 200, 200),
			seed = 0x5914E + i,
			octaves = 3,
			persist = 0.5,
		},
		biomes = b.set.to_array(b.set._and(b.set(aurum.biomes.get_all_group("all", {"under"})), b.set(aurum.biomes.get_all_heat(unpack(c.heat_range))))),
		schematic = aurum.features.schematic(vector.new(1, 1, 1), {{{"aurum_spikes:" .. c.name .. "_spike"}}}),
		force_placement = true,
		on_offset = function(c)
			return vector.add(c.pos, vector.new(0, 1, 0))
		end,
	}
end
