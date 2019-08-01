return function(def)
	local t = {name = def.trunk, force_place = true}
	local l = def.leaves
	local lp = {name = def.leaves, prob = 127}

	local trunk = {
		{"ignore", "ignore", "ignore"},
		{"ignore", t, "ignore"},
		{"ignore", "ignore", "ignore"},
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
