local S = aurum.get_translator()
aurum.cage = {
	MANA_FACTOR = 10,
	MANA_MAX = 50,
}

minetest.register_craftitem("aurum_cage:empty_cage", {
	description = S"Empty Mob Cage",
	inventory_image = "aurum_cage_empty_cage.png",
	stack_max = 1,
	_doc_items_usagehelp = S("Use this cage on a mob to capture it. You must expend @1 times the mana that the mob contains. The mob not contain more than @2 mana.", aurum.cage.MANA_FACTOR, aurum.cage.MANA_MAX),
	on_use = function(itemstack, user, thing)
		if thing.type == "object" and user and user:is_player() and not user.is_fake_player then
			local mob, name = aurum.mobs.get_mob(thing.ref)
			if mob then
				local expense = mob.data.xmana * aurum.cage.MANA_FACTOR
				if xmana.mana(user) >= expense and mob.data.xmana <= aurum.cage.MANA_MAX then
					xmana.mana(user, -expense, true, "mob capture")
					itemstack:set_name("aurum_cage:full_cage")
					local meta = itemstack:get_meta()
					meta:set_string("mob", name)
					meta:set_string("staticdata", mob.entity:get_staticdata())
					aurum.set_stack_description(itemstack, S("Mob Cage of @1", mob.entity._aurum_mob.description))
					thing.ref:remove()
				end
			end
		end
		return itemstack
	end,
})

minetest.register_craftitem("aurum_cage:full_cage", {
	description = S"Mob Cage",
	_doc_items_usagehelp = S"Place this cage to release the mob inside.",
	inventory_image = "aurum_cage_full_cage.png",
	stack_max = 1,
	on_place = function(itemstack, placer, thing)
		local pos = minetest.get_pointed_thing_position(thing, true)
		if pos and not aurum.is_protected(pos, placer) then
			local meta = itemstack:get_meta()
			if aurum.mobs.spawn(pos, meta:get_string("mob"), meta:get_string("staticdata")) then
				itemstack:clear()
			end
		end
		return itemstack
	end,
})

minetest.register_craft{
	output = "aurum_cage:empty_cage",
	recipe = {
		{"aurum_ore:gold_ingot", "aurum_ore:gold_ingot", "aurum_ore:gold_ingot"},
		{"aurum_base:sticky_stick", "aurum_base:aether_shell", "aurum_base:sticky_stick"},
		{"aurum_ore:gold_ingot", "aurum_ore:gold_ingot", "aurum_ore:gold_ingot"},
	},
}
