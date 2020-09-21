local function noun(random)
	return b.t.choice({
		"gut",
		"liver",
		"lung",
		"fool",
		"cur",
		"idiot",
		"dunce",
		"one",
		"loon",
		"lunatic",
		"witch",
		"lump",
		"mass",
		"dullard",
	}, random)
end

local function single_adjective(random)
	return b.t.choice({
		"odious",
		"horrid",
		"odorous",
		"decrepit",
		"vile",
		"pale",
		"cretinous",
		"miserable",
		"terrible",
		"turgid",
		"lukewarm",
		"nauseous",
		"ugly",
		"insignificant",
		"stupid",
		"raging",
		"inflexible",
		"stubborn",
		"useless",
	}, random)
end

local function adjective(random)
	return b.t.choice({
		single_adjective(random),
		single_adjective(random) .. "-" .. single_adjective(random),
	}, random)
end

function aurum.flavor.generate_mocking(n, random)
	local t = {}
	for i=1,n do
		table.insert(t, adjective(random))
	end
	table.insert(t, noun(random))
	return table.concat(t, " ")
end
