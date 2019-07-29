return function(def)
	local t = {name = def.trunk, force_place = true}
	local l = def.leaves
	local lp = {name = def.leaves, prob = 127}

	local trunk = {
		{"air", "air", "air"},
		{"air", t, "air"},
		{"air", "air", "air"},
	}

	return aurum.trees.schematic(vector.new(3, 8, 3), {
		{
			{l, l, l},
			{l, l, l},
			{l, l, l},
		},
		{
			{l, l, l},
			{l, t, l},
			{l, l, l},
		},
		{
			{lp, lp, lp},
			{lp, t, lp},
			{lp, lp, lp},
		},
		trunk,
		trunk,
		trunk,
		trunk,
		trunk,
	})
end
