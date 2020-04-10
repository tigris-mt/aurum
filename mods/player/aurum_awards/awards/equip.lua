local S = minetest.get_translator()

awards.register_award("aurum_awards:wings", {
	title = S"Rival of the Archons",
	description = S"Equip a pair of wings.",
	icon = "aurum_wings_wings.png",
	difficulty = 1000,
})

local old = gequip.refresh
function gequip.refresh(player)
	local ret = old(player)
	local items = b.set{}
	for k,v in pairs(gequip.types) do
		for _,item in ipairs(player:get_inventory():get_list(v.list_name)) do
			items[item:get_name()] = true
		end
	end
	if items["aurum_wings:wings"] then
		awards.unlock(player:get_player_name(), "aurum_awards:wings")
	end
	return ret
end
