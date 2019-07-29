return function(def)
	local t = {name = def.trunk, force_place = true}
	local l = def.leaves
	local lp = {name = def.leaves, prob = 127}

	local trunk = {
		{"air", "air", "air", "air", "air", "air", "air", "air", "air"},
		{"air", "air", "air", "air", "air", "air", "air", "air", "air"},
		{"air", "air", "air", "air", "air", "air", "air", "air", "air"},
		{"air", "air", "air", t, t, t, "air", "air", "air"},
		{"air", "air", "air", t, t, t, "air", "air", "air"},
		{"air", "air", "air", t, t, t, "air", "air", "air"},
		{"air", "air", "air", "air", "air", "air", "air", "air", "air"},
		{"air", "air", "air", "air", "air", "air", "air", "air", "air"},
		{"air", "air", "air", "air", "air", "air", "air", "air", "air"},
	}

	local leaves = {
		{lp, lp, lp, l, l, l, lp, lp, lp},
		{lp, lp, lp, l, l, l, lp, lp, lp},
		{lp, lp, lp, l, l, l, lp, lp, lp},
		{l, l, l, t, t, t, l, l, l},
		{l, l, l, t, t, t, l, l, l},
		{l, l, l, t, t, t, l, l, l},
		{lp, lp, lp, l, l, l, lp, lp, lp},
		{lp, lp, lp, l, l, l, lp, lp, lp},
		{lp, lp, lp, l, l, l, lp, lp, lp},
	}

	local top = {
		{lp, lp, lp, l, l, l, lp, lp, lp},
		{lp, lp, lp, l, l, l, lp, lp, lp},
		{lp, lp, lp, l, l, l, lp, lp, lp},
		{l, l, l, l, l, l, l, l, l},
		{l, l, l, l, l, l, l, l, l},
		{l, l, l, l, l, l, l, l, l},
		{lp, lp, lp, l, l, l, lp, lp, lp},
		{lp, lp, lp, l, l, l, lp, lp, lp},
		{lp, lp, lp, l, l, l, lp, lp, lp},
	}

	return aurum.trees.schematic(vector.new(9, 25, 9), {
		top,
		leaves,
		leaves,
		leaves,
		leaves,
		leaves,
		leaves,
		leaves,
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
		trunk,
		trunk,
		trunk,
		trunk,
		trunk,
		trunk,
	})
end
