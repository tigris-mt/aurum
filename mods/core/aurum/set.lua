aurum.set = {}

-- Convert an array to a set.
function aurum.set.new(t)
	local r = {}
	for _,v in ipairs(t) do
		r[v] = true
	end
	return r
end

-- Alias aurum.set() to aurum.set.new().
setmetatable(aurum.set, {__call = function(t, v) return aurum.set.new(v) end})

-- Get a set with all entries from parameter sets.
function aurum.set.union(...)
	local r = {}
	for _,s in ipairs{...} do
		for k in aurum.set.iter(s) do
			r[k] = true
		end
	end
	return r
end

-- Get a set with only the entries that are in every parameter set.
function aurum.set.intersection(...)
	local r = {}
	local p = {...}
	for _,s in ipairs(p) do
		for k in aurum.set.iter(s) do
			r[k] = (r[k] or 0) + 1
		end
	end
	return table.map(r, function(v) return (v == #p) and v or nil end)
end

-- Get a set with only the entries that are in a single parameter set.
function aurum.set.difference(...)
	local r = {}
	local p = {...}
	for _,s in ipairs(p) do
		for k in aurum.set.iter(s) do
			r[k] = (r[k] or 0) + 1
		end
	end
	return table.map(r, function(v) return (v == 1) and v or nil end)
end

-- Convert a set to an array.
function aurum.set.to_array(set)
	return table.keys(set)
end

-- Set iterator, iterates over entries.
aurum.set.iter = pairs
