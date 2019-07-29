local S = minetest.get_translator()

for k,v in pairs{
	["aurum:aurum"] = {
		color = "#009900",
	},
	["aurum:loom"] = {
		color = "#550000",
	},
} do
	aurum.portals.register(k, v)
end

local base_realms = {"aurum:aurum"}
local hub_realms = {"aurum:loom"}

function aurum.portals.register_ritual(realm, allowed_from, recipe, replace)
	local rdef = aurum.realms.get(realm)

	local allowed_desc = {}
	for _,v in ipairs(allowed_from) do
		table.insert(allowed_desc, aurum.realms.get(v).description)
	end

	aurum.magic.register_ritual("aurum_portals:portal_" .. realm, {
		description = S("Create Portal to @1", rdef.description),
		longdesc = S("This ritual can be performed in @1.", table.concat(allowed_desc, ", ")),

		recipe = table.icombine({
			{vector.new(0, 0, -1), "aurum_portals:base"},
		}, recipe),
		size = aurum.box.new(vector.new(-1, 0, -1), vector.new(1, 3, 0)),

		apply = function(at, player)
			if not aurum.set.new(allowed_from)[aurum.pos_to_realm(at(vector.new(0, 0, 0)))] then
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
