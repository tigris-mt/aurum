return function(def)
	local t = {name = def.trunk, force_place = true}
	local l = def.leaves
	local lp = {name = def.leaves, prob = 127}

	local trunk = {
		{"air", "air", "air", "air", "air", "air"},
		{"air", "air", "air", "air", "air", "air"},
		{"air", "air", t, t, "air", "air"},
		{"air", "air", t, t, "air", "air"},
		{"air", "air", "air", "air", "air", "air"},
		{"air", "air", "air", "air", "air", "air"},
	}

	return aurum.trees.schematic(vector.new(6, 16, 6), {
		{
			{lp, lp, l, l, lp, lp},
			{lp, l, l, l, l, lp},
			{l, l, l, l, l, l},
			{l, l, l, l, l, l},
			{lp, l, l, l, l, lp},
			{lp, lp, l, l, lp, lp},
		},
		{
			{lp, lp, l, l, lp, lp},
			{lp, l, l, l, l, lp},
			{l, l, t, t, l, l},
			{l, l, t, t, l, l},
			{lp, l, l, l, l, lp},
			{lp, lp, l, l, lp, lp},
		},
		{
			{lp, lp, l, l, lp, lp},
			{lp, l, l, l, l, lp},
			{l, l, t, t, l, l},
			{l, l, t, t, l, l},
			{lp, l, l, l, l, lp},
			{lp, lp, l, l, lp, lp},
		},
		{
			{lp, lp, l, l, lp, lp},
			{lp, l, l, l, l, lp},
			{l, l, t, t, l, l},
			{l, l, t, t, l, l},
			{lp, l, l, l, l, lp},
			{lp, lp, l, l, lp, lp},
		},
		{
			{lp, lp, l, l, lp, lp},
			{lp, l, l, l, l, lp},
			{l, l, t, t, l, l},
			{l, l, t, t, l, l},
			{lp, l, l, l, l, lp},
			{lp, lp, l, l, lp, lp},
		},
		trunk,
		trunk,
		trunk,
		trunk,
		trunk,
		trunk,
		trunk,
		trunk,
		trunk,
		trunk,
		trunk,
	})
end
