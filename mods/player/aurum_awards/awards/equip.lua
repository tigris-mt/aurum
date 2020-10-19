local S = aurum.get_translator()

awards.register_award("aurum_awards:full_set", {
	title = S"Complete Coverage",
	description = S"Equip your head, chest, legs, and feet slots as the same time.",
	icon = minetest.registered_items["aurum_equip:iron_hauberk"].inventory_image,
	difficulty = 75,
})

awards.register_award("aurum_awards:wings", {
	title = S"Rival of the Archons",
	description = S"Equip a pair of wings.",
	icon = "aurum_wings_wings.png",
	difficulty = 1000,
})

local old = gequip.refresh
function gequip.refresh(player)
	local ret = old(player)
	local slots = b.set{}
	local items = b.set{}
	for k,v in pairs(gequip.types) do
		for _,item in ipairs(player:get_inventory():get_list(v.list_name)) do
			if item:get_count() > 0 then
				items[item:get_name()] = true
				slots[k] = true
			end
		end
	end
	if slots.head and slots.chest and slots.legs and slots.feet then
		awards.unlock(player:get_player_name(), "aurum_awards:full_set")
	end
	if items["aurum_wings:wings"] or items["aurum_wings:wings_enchanted"] then
		awards.unlock(player:get_player_name(), "aurum_awards:wings")
	end
	return ret
end
