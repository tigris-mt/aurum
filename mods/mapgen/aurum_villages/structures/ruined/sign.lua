local function ruined_sign(random)
	return b.t.choice({
		"XXX",
		"Go bak",
		"Go back!",
		"run",
		"help me, please!",
		"nobody is left",
		"Where has the Supreme One gone?",
		"why did He leave us",
		"help",
		"i will soon be gone",
		aurum.flavor.generate_name() .. " was here",
		aurum.flavor.generate_name() .. ", if you see this, I am gone",
		aurum.flavor.generate_village_name() .. " is already destroyed",
	}, random)
end

for _,def in ipairs({
	{
		name = "aurum_villages:ruined_sign",
		pl = "aurum_trees:drywood_planks",
		si = "aurum_signs:wood_sign_aurum_trees_drywood_yard",
		foundation = {"aurum_base:gravel"},
	},
	{
		name = "aurum_villages:ruined_sign_jungle",
		pl = "aurum_trees:pander_planks",
		si = "aurum_signs:wood_sign_aurum_trees_pander_yard",
		foundation = {"aurum_base:dirt"},
	},
}) do
	local pl = def.pl
	local air = "air"

	aurum.villages.register_structure(def.name, {
		size = vector.new(1, 2, 1),
		foundation = def.foundation,

		schematic = aurum.features.schematic(vector.new(1, 2, 1), {
			{{"aurum_features:ph_1"}},
			{{pl}},
		}),

		on_generated = function(c)
			local village_id = aurum.villages.get_village_id_at(c.base.pos)
			local village = village_id and aurum.villages.get_village(village_id)
			for _,pos in ipairs(c:ph(1)) do
				minetest.set_node(pos, {name = def.si, param2 = c:random(0, 3)})
				if village then
					signs_lib.update_sign(pos, {
						text = b.t.choice({
							("Wel om  to %s!\nFo nded by %s"):format(village.name, village.founder),
							ruined_sign(c.base.random),
						}, c.base.random),
					})
				else
					signs_lib.update_sign(pos, {
						text = ruined_sign(c.base.random),
					})
				end
			end
		end,
	})
end
