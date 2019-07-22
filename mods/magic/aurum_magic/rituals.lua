local S = minetest.get_translator()

aurum.magic.rituals = {}

function aurum.magic.register_ritual(name, def)
	local def = table.combine({
		description = "",
		size = aurum.box.new(vector.new(-1, 0, -1), vector.new(1, 0, 1)),
		recipe = {},
		apply = function(at, player) end,
		protected = false,
	}, def)

	-- Saved hashed node positions for easier recall.
	local hashed = {}
	for _,v in ipairs(def.recipe) do
		hashed[minetest.hash_node_position(v[1])] = v[2]
	end
	def.hashed_recipe = hashed

	aurum.magic.rituals[name] = def
end

minetest.register_node("aurum_magic:altar", {
	description = S"Ritual Altar",
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, 0, -0.5, 0.5, 0.5, 0.5},
			{-0.25, -0.5, -0.25, 0.25, 0, 0.25},
		},
	},
	tiles = {"aurum_magic_altar_top.png", "aurum_trees_oak_planks.png"},
	sounds = aurum.sounds.wood(),
	groups = {dig_chop = 3, flammable = 1},
	paramtype2 = "facedir",
	on_place = minetest.rotate_node,

	on_rightclick = function(pos, node, player)
		local function at(offset)
			local actual = vector.new(0, 0, 0)
			if node.param2 % 4 == 0 then
				actual.z = -offset.x
				actual.x = offset.z
			elseif node.param2 % 4 == 1 then
				actual.x = -offset.x
				actual.z = -offset.z
			elseif node.param2 % 4 == 2 then
				actual.z = offset.x
				actual.x = -offset.z
			elseif node.param2 % 4 == 3 then
				actual.x = offset.x
				actual.z = offset.z
			end
			return vector.add(pos, actual)
		end

		for k,v in pairs(aurum.magic.rituals) do
			local function check()
				for x=v.size.a.x,v.size.b.x do
					for y=v.size.a.y,v.size.b.y do
						for z=v.size.a.z,v.size.b.z do
							local noff = vector.new(x, y, z)
							if not vector.equals(noff, vector.new(0, 0, 0)) then
								if not aurum.match_item(minetest.get_node(at(noff)).name, v.hashed_recipe[minetest.hash_node_position(noff)] or "air") then
									return false
								end
							end
						end
					end
				end
				return true
			end

			if check() then
				v.apply(at, player)
				return
			end
		end
	end,
})

minetest.register_craft{
	output = "aurum_magic:altar",
	recipe = {
		{"group:wood", "aurum_scrolls:scroll", "group:wood"},
		{"group:wood", "group:wood", "group:wood"},
		{"", "group:wood", ""},
	},
}
