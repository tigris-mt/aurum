local S = aurum.get_translator()

local box = {
	type = "fixed",
	fixed = {{-0.3, -0.5, -0.3, 0.3, 0.4, 0.3}},
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
		name = "green",
		desc = "Green",
		heat_range = {25, 75},
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

		inventory_image = "aurum_spikes_spike_inv.png^[colorize:" .. b.color.tostring(c.name) .. ":127",
		wield_image = "aurum_spikes_spike_inv.png^[colorize:" .. b.color.tostring(c.name) .. ":127",

		tiles = {"aurum_spikes_spike.png^[colorize:" .. b.color.tostring(c.name) .. ":127"},

		paramtype2 = "facedir",

		selection_box = box,
		collision_box = box,
		walkable = false,

		paramtype = "light",
		light_source = 10,

		is_ground_content = false,
		groups = {dig_pick = 3, attached_node = 1},

		sounds = aurum.sounds.crystal(),
	})

	local place_on = {
		"aurum_base:aether_shell",
		"aurum_base:regret",
		"aurum_base:gravel",
		"aurum_base:stone",
	}

	aurum.features.register_decoration{
		place_on = place_on,
		noise_params = {
			offset = -0.025,
			scale = 0.1,
			spread = vector.new(480, 200, 480),
			seed = 0x5914E + math.abs(c.heat_range[2] - c.heat_range[1]),
			octaves = 3,
			persist = 0.5,
		},
		biomes = aurum.biomes.find(function(def)
			return def.heat_point >= c.heat_range[1] and def.heat_point <= c.heat_range[2] and (aurum.match_item_list(def.node_stone, place_on) or aurum.match_item_list(def.node_top, place_on))
		end),
		schematic = aurum.features.schematic(vector.new(1, 1, 1), {{{"aurum_spikes:" .. c.name .. "_spike"}}}),
		force_placement = true,
		on_offset = function(c)
			return vector.add(c.pos, vector.new(0, 1, 0))
		end,
	}
end
