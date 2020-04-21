local S = minetest.get_translator()

for k,v in pairs{
	["aurum:aurum"] = {
		color = "#00aa00",
	},
	["aurum:loom"] = {
		color = "#550000",
	},
	["aurum:primus"] = {
		color = "#004400",
	},
	["aurum:aether"] = {
		color = "#aaaaaa",
	},
	["aurum:ultimus"] = {
		color = "#440044",
	},
} do
	aurum.portals.register(k, v)
end

local base_realms = {"aurum:aurum", "aurum:primus", "aurum:ultimus"}
local hub_realms = {"aurum:loom", "aurum:aether"}

function aurum.portals.register_ritual(realm, allowed_from, recipe, replace)
	local rdef = screalms.get(realm)

	allowed_from = b.t.imap(allowed_from, function(v) return (v ~= realm) and v or nil end)

	local allowed_desc = {}
	for _,v in ipairs(allowed_from) do
		table.insert(allowed_desc, screalms.get(v).description)
	end

	aurum.magic.register_ritual("aurum_portals:portal_" .. realm, {
		description = S("Create Portal to @1", rdef.description),
		longdesc = S("This ritual can be performed in @1.", table.concat(allowed_desc, ", ")),

		recipe = b.t.icombine({
			{vector.new(0, 0, -1), "aurum_portals:base"},
		}, recipe),
		size = b.box.new(vector.new(-1, 0, -1), vector.new(1, 3, 0)),

		apply = function(at, player)
			if not b.set(allowed_from)[screalms.pos_to_realm(at(vector.new(0, 0, 0)))] then
				return false
			end

			for _,v in ipairs(recipe) do
				minetest.set_node(at(v[1]), {name = replace})
			end

			minetest.set_node(at(vector.new(0, 0, -1)), {name = "aurum_portals:portal_" .. realm})
			return true
		end,

		protected = true,
	})
end

aurum.portals.register_ritual("aurum:loom", base_realms, {
	{vector.new(-1, 0, -1), "aurum_coredust:dusty_bronze"},
	{vector.new(1, 0, -1), "aurum_coredust:dusty_bronze"},
	{vector.new(-1, 1, -1), "aurum_coredust:dusty_bronze"},
	{vector.new(1, 1, -1), "aurum_coredust:dusty_bronze"},
	{vector.new(-1, 2, -1), "aurum_coredust:dusty_bronze"},
	{vector.new(1, 2, -1), "aurum_coredust:dusty_bronze"},
	{vector.new(-1, 3, -1), "aurum_base:regret"},
	{vector.new(0, 3, -1), "aurum_base:regret"},
	{vector.new(1, 3, -1), "aurum_base:regret"},
}, "aurum_base:regret")

aurum.portals.register_ritual("aurum:aurum", hub_realms, {
	{vector.new(-1, 0, -1), "aurum_ore:gold_block"},
	{vector.new(1, 0, -1), "aurum_ore:gold_block"},
	{vector.new(-1, 1, -1), "aurum_ore:gold_block"},
	{vector.new(1, 1, -1), "aurum_ore:gold_block"},
	{vector.new(-1, 2, -1), "aurum_ore:gold_block"},
	{vector.new(1, 2, -1), "aurum_ore:gold_block"},
	{vector.new(-1, 3, -1), "group:soil"},
	{vector.new(0, 3, -1), "group:soil"},
	{vector.new(1, 3, -1), "group:soil"},
}, "aurum_base:stone")

aurum.portals.register_ritual("aurum:primus", hub_realms, {
	{vector.new(-1, 0, -1), "aurum_farming:fertilizer"},
	{vector.new(1, 0, -1), "aurum_farming:fertilizer"},
	{vector.new(-1, 1, -1), "aurum_farming:fertilizer"},
	{vector.new(1, 1, -1), "aurum_farming:fertilizer"},
	{vector.new(-1, 2, -1), "aurum_farming:fertilizer"},
	{vector.new(1, 2, -1), "aurum_farming:fertilizer"},
	{vector.new(-1, 3, -1), "aurum_trees:pander_trunk"},
	{vector.new(0, 3, -1), "aurum_trees:pander_trunk"},
	{vector.new(1, 3, -1), "aurum_trees:pander_trunk"},
}, "aurum_base:dirt")

aurum.portals.register_ritual("aurum:aether", hub_realms, {
	{vector.new(-1, 0, -1), "aurum_base:aether_shell"},
	{vector.new(1, 0, -1), "aurum_base:aether_shell"},
	{vector.new(-1, 1, -1), "aurum_base:aether_shell"},
	{vector.new(1, 1, -1), "aurum_base:aether_shell"},
	{vector.new(-1, 2, -1), "aurum_base:aether_shell"},
	{vector.new(1, 2, -1), "aurum_base:aether_shell"},
	{vector.new(-1, 3, -1), "group:crystal_tree"},
	{vector.new(0, 3, -1), "group:crystal_tree"},
	{vector.new(1, 3, -1), "group:crystal_tree"},
}, "aurum_base:aether_flesh")

aurum.portals.register_ritual("aurum:ultimus", hub_realms, {
	{vector.new(-1, 0, -1), "group:clay_brick"},
	{vector.new(1, 0, -1), "group:clay_brick"},
	{vector.new(-1, 1, -1), "group:clay_brick"},
	{vector.new(1, 1, -1), "group:clay_brick"},
	{vector.new(-1, 2, -1), "group:clay_brick"},
	{vector.new(1, 2, -1), "group:clay_brick"},
	{vector.new(-1, 3, -1), "group:glass"},
	{vector.new(0, 3, -1), "group:glass"},
	{vector.new(1, 3, -1), "group:glass"},
}, "aurum_base:glowing_glass_white")
