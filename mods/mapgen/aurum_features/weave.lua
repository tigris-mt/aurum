-- Long weaves of regret twisting through the loom.

local cache = {}
local function make(size, sign)
	local key = ("%d:%d"):format(minetest.hash_node_position(size), sign)
	if cache[key] then
		return cache[key]
	end

	local limit = vector.subtract(size, 1)
	local data = {}
	local area = VoxelArea:new({MinEdge=vector.new(0, 0, 0), MaxEdge=limit})
	for i in area:iterp(vector.new(0, 0, 0), limit) do
		data[i] = {name = "ignore"}
	end

	local c = "aurum_base:regret"

	-- Half-circle arch.
	local r = math.min(size.x / 2, size.y / 2)
	for x=0,limit.x,0.1 do
		-- Use half-circle equation to get y.
		local y = math.floor(math.sqrt(math.pow(r, 2) - math.pow(x - r, 2)) + 0.5)
		if sign == -1 then
			y = math.floor((limit.y / 2) - y + 0.5)
		end
		data[area:indexp(vector.new(math.floor(x + 0.5), math.max(0, math.min(y, limit.y)), 0))] = {name = c}
	end

	local ret = {
		size = size,
		data = data,
	}
	cache[key] = ret
	return ret
end

aurum.features.register_decoration{
	place_on = {"aurum_base:regret"},
	rarity = 0.001,
	biomes = aurum.biomes.get_all_group("aurum:loom", {"base"}),

	make_schematic = function(pos, random)
		local size = vector.new(random(10, 20), random(10, 30), 1)
		-- Offset position.
		pos.y = math.ceil(pos.y - (size.y - 1) / 3)

		return make(size, (random(0, 1) == 1) and 1 or -1)
	end,
}
