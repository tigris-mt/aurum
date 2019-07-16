-- Combine tables and return the result. Later tables take priority.
function table.combine(...)
	local ret = {}
	for _,t in ipairs({...}) do
		for k,v in pairs(t) do
			ret[k] = v
		end
	end
	return ret
end

-- Combine array tables in order.
function table.icombine(...)
	local ret = {}
	for _,t in ipairs({...}) do
		for _,v in ipairs(t) do
			table.insert(ret, v)
		end
	end
	return ret
end

function table.flagarray(t, i)
	local ret = {}
	for _,v in ipairs(t) do
		if i then
			table.insert(ret, v)
		end
		ret[v] = true
	end
	return ret
end

-- Get an array of all keys from tables.
function table.keys(...)
	assert(#({...}) > 0, "no arguments")
	local ret = {}
	local have = {}
	for _,t in ipairs({...}) do
		for k in pairs(t) do
			if not have[k] then
				table.insert(ret, k)
				have[k] = true
			end
		end
	end
	return ret
end

-- Loop through the parts of t, with keys sorted by f.
function table.spairs(t, f)
	local keys = table.keys(t)
	if f then
		table.sort(keys, function(a, b) return f(t, a, b) end)
	else
		table.sort(keys)
	end

	local i = 0
	return function()
		i = i + 1
		if keys[i] then
			return keys[i], t[keys[i]]
		end
	end
end

function table.map(t, f)
	local ret = {}
	for k,v in pairs(t) do
		ret[k] = f(v, k)
	end
	return ret
end
