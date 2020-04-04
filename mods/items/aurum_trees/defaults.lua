local m = {
	style = {},
}
aurum.trees.defaults = m

m.TREE = {
	simple = 1,
	wide = 1,
	double = 1,
	tall = 1,
	very_tall = 0.1,
	huge = 0.05,
	giant = 0.01,

	["cone,3"] = 1,
	["cone,12"] = 0.005,
	["cone,14,1.5"] = 0.001,
}

m.LOG = {
	["log,3"] = 0.2,
	["log,4"] = 0.2,
	["log,5"] = 0.2,
	["log,8,2"] = 0.1,
	["log,16,4"] = 0.05,
	["log,16,4,0"] = 0.05,
	["log,24,7"] = 0.005,
}

m.ALL = b.t.combine(m.TREE, m.LOG)

m.JUNGLE = {
	very_tall = 1,
	huge = 0.25,
	giant = 0.1,
	["tree,48,16"] = 0.01,

	["log,5"] = 0.2,
	["log,8,2"] = 0.1,
	["log,16,4"] = 0.05,
	["log,16,4,0"] = 0.05,
	["log,24,7"] = 0.005,
}

m.style.HUGE = {
	pre = {
		["tree,32,32"] = 0.01,
		["tree,48,16"] = 0.1,
		["tree,16,48"] = 0.001,
		["cone,16"] = 0.01,
		["cone,14"] = 0.01,
		["cone,24"] = 0.001,
	},
	post = {
		["log,64,8,,-2"] = 0.0025,
		["tree,64,8"] = 0.025,
		["tree,72,24"] = 0.01,
		["tree,144,48"] = 0.001,
		["log,144,16,,-4"] = 0.001,
	},
}

m.style.HUGE_CONE = {
	pre = {
		["cone,16"] = 0.05,
		["cone,14"] = 0.1,
		["cone,24"] = 0.05,
		["cone,28"] = 0.05,
		["cone,30"] = 0.05,
	},
	post = {
		["log,64,8,,-2"] = 0.0035,
		["cone,40"] = 0.05,
	},
}

m.style.TALL = {
	pre = {
		["tree,32,32"] = 0.01,
		["tree,48,16"] = 0.1,
		["tree,16,48"] = 0.001,
	},
	post = {
		["log,64,8,,-2"] = 0.0025,
		["tree,72,6"] = 0.001,
	},
}
