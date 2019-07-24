aurum.set = {}

function aurum.set.new(t)
	local r = {}
	for _,v in ipairs(t) do
		r[v] = true
	end
	return r
end

setmetatable(aurum.set, {__call = function(t, v) return aurum.set.new(v) end})

function aurum.set.union(...)
	local r = {}
	for _,s in ipairs{...} do
		for k in aurum.set.iter(s) do
			r[k] = true
		end
	end
	return r
end

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

function aurum.set.to_array(set)
	return table.keys(set)
end

aurum.set.iter = pairs
