return function(def)
	local t = {name = def.trunk, force_place = true}
	local l = def.leaves
	local lp = {name = def.leaves, prob = 127}

	local trunk = {
		{"air", "air", "air"},
		{"air", t, "air"},
		{"air", "air", "air"},
	}

	return aurum.trees.schematic(vector.new(3, 5, 3), {
		{
			{lp, l, lp},
			{l, l, l},
			{lp, l, lp},
		},
		{
			{l, l, l},
			{l, t, l},
			{l, l, l},
		},
		trunk,
		trunk,
		trunk,
	})
end
