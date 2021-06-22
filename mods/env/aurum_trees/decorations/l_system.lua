local l_default = {
	iterations = 2,
	random_level = 2,
	fruit_chance = 10,
}

for k,l_def in pairs{
	l_flowing_fruit = {
		axiom = "FFFFFAFFBF",
		rules_a = "[&&&FFFFF&&FFFF][&&&++++FFFFF&&FFFF][&&&----FFFFF&&FFFF]",
		rules_b = "[&&&++FFFFF&&FFFF][&&&--FFFFF&&FFFF][&&&------FFFFF&&FFFF]",
		trunk_type = "single",
		thin_branches = true,
	},
	l_tall_flowing_fruit = {
		axiom = "FFFFFFFFFAFFFBFF",
		rules_a = "[&&&FFFFF&&FFFF][&&&++++FFFFF&&FFFF][&&&----FFFFF&&FFFF]",
		rules_b = "[&&&++FFFFF&&FFFF][&&&--FFFFF&&FFFF][&&&------FFFFF&&FFFF]",
		trunk_type = "double",
		thin_branches = true,
	},
} do
	aurum.trees.register_generator(k, {
		type = "l_system",
		func = function(def, fruit)
			return b.t.combine(l_default, l_def, {
				trunk = def.trunk,
				leaves = def.leaves,
				fruit = fruit,
			})
		end,
	})
end
