return function(def)
	local t = {name = def.trunk, force_place = true}
	local l = def.leaves
	local lp = {name = def.leaves, prob = 127}

	local trunk = {
		{"ignore", "ignore", "ignore", "ignore", "ignore", "ignore"},
		{"ignore", "ignore", "ignore", "ignore", "ignore", "ignore"},
		{"ignore", "ignore", t, t, "ignore", "ignore"},
		{"ignore", "ignore", t, t, "ignore", "ignore"},
		{"ignore", "ignore", "ignore", "ignore", "ignore", "ignore"},
		{"ignore", "ignore", "ignore", "ignore", "ignore", "ignore"},
	}

	return aurum.trees.schematic(vector.new(6, 7, 6), {
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
		trunk,
		trunk,
		trunk,
		trunk,
	})
end
