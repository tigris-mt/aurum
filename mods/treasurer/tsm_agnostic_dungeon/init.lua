tsm_agnostic_dungeon = {
	-- Chest node.
	chest = function(pos)
		return {
			node = minetest.settings:get("tsm_agnostic_dungeon.chest_node") or "default:chest",
			list = minetest.settings:get("tsm_agnostic_dungeon.chest_list") or "main",
		}
	end,

	-- Preciousness ratio per position.
	ratio = function(pos)
		return 0.5 + 0.5 * math.min(1, math.abs(pos.y) / (tonumber(minetest.settings:get("tsm_agnostic_dungeon.max_threshold")) or 1024))
	end,

	-- Treasure groups.
	loot = function(pos)
		return {
			count = math.random(1, 2),
			list = {
				{
					count = math.random(1, 2),
					preciousness = {0, 5},
					groups = nil,
				},
			},
		}
	end,

	-- Maximum rooms to try to place a chest in.
	max_rooms = function(pos)
		return math.random(1, 2)
	end,
}

minetest.set_gen_notify("dungeon")
minetest.register_on_generated(function(minp, maxp)
	local g = minetest.get_mapgen_object("gennotify")
	if g and g.dungeon then
		minetest.after(3, function(rooms)
			for room_index=1,math.min(#rooms, tsm_agnostic_dungeon.max_rooms(vector.divide(vector.add(minp, maxp), 2))) do
				local pos = rooms[room_index]
				local chest = tsm_agnostic_dungeon.chest(pos)
				minetest.set_node(pos, {name = chest.node})

				local ratio = tsm_agnostic_dungeon.ratio(pos)
				local loot = tsm_agnostic_dungeon.loot(pos)

				local shuffled = table.shuffled(loot.list)
				local ti = 0

				for i=1,loot.count do
					ti = ti + 1
					if not shuffled[ti] then
						ti = 1
					end

					local search = shuffled[ti]
					if search then
						local inv = minetest.get_meta(pos):get_inventory()
						for _,stack in ipairs(treasurer.select_random_treasures(
							search.count,
							math.floor(search.preciousness[1] * ratio),
							math.ceil(search.preciousness[2] * ratio),
							search.groups
						) or {}) do
							inv:add_item(chest.list, stack)
						end
					end
				end
			end
		end, table.shuffled(g.dungeon))
	end
end)

if minetest.get_modpath("aurum_realms") then
	function tsm_agnostic_dungeon.ratio(pos)
		local realm = aurum.pos_to_realm(pos)
		if not realm then
			return 0.5
		end
		local rpos = aurum.rpos(realm, pos)
		return 0.5 + 0.5 * math.min(1, math.abs(rpos.y) / (aurum.realms.get(realm).local_box.b.y / 2))
	end
end
