local function property(fn)
	local old = tsm_agnostic_dungeon[fn]
	tsm_agnostic_dungeon[fn] = function(pos, ...)
		local realm = screalms.get(screalms.pos_to_realm(pos))
		if realm and realm["aurum_dungeon_" .. fn] then
			local c = realm["aurum_dungeon_" .. fn]
			return c(pos, ...)
		else
			return old(pos, ...)
		end
	end
end

for _,n in ipairs{"loot", "chest", "ratio", "max_rooms"} do
	property(n)
end
