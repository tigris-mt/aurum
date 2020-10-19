local S = aurum.get_translator()

aurum.magic.register_spell("growth", {
	description = S"Growth",
	longdesc = S"Forces a plant to mature immediately. Higher levels make a plant go through more stages of growth at a time.",

	apply_requirements = function(pointed_thing, _, player)
		local pos = minetest.get_pointed_thing_position(pointed_thing)
		return pointed_thing.type == "node" and minetest.get_item_group(minetest.get_node(pos).name, "grow_plant") > 0 and not aurum.is_protected(pos, player)
	end,

	apply = function(pointed_thing, level, player)
		local pos = minetest.get_pointed_thing_position(pointed_thing)
		-- Apply grow function multiple times for each spell level.
		for i=1,level do
			local node = minetest.get_node(pos)
			-- Only continue if the node is still growable.
			if minetest.get_item_group(node.name, "grow_plant") > 0 then
				-- Try to grow the node; if unsuccessful then stop trying.
				if not minetest.registered_nodes[node.name]._on_grow_plant(pos, node) then
					break
				end
			else
				break
			end
		end
	end,
})

local fertilizer_wall = {}
for _,pos in ipairs(b.box.poses(b.box.new(vector.new(-1, 0, -1), vector.new(1, 2, -1)))) do
	table.insert(fertilizer_wall, {pos, "aurum_farming:fertilizer"})
end
aurum.magic.register_spell_ritual("growth", {
	longdesc = S"Extracts the primal energy of fertilizer and burns it into spell scrolls of growth. Requires bananas to appease the elements.",

	size = b.box.new(vector.new(-1, 0, -1), vector.new(1, 2, 0)),

	recipe = b.t.icombine(fertilizer_wall, {
		{vector.new(0, 1, 0), "aurum_storage:scroll_hole"},
		{vector.new(-1, 0, 0), "aurum_trees:banana"},
		{vector.new(1, 0, 0), "aurum_trees:banana"},
	}),

	protected = true,

	apply = function(at)
		if not aurum.magic.spell_ritual_inv(at(vector.new(0, 1, 0)), "main", "growth", 9) then
			return false, S"There was nothing to bind the spell to."
		end

		for _,n in ipairs(fertilizer_wall) do
			minetest.remove_node(at(n[1]))
		end

		return true
	end,
})
