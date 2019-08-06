local syllables = {
	"ae", "bo", "ce", "da", "e", "fi", "gu", "ha", "je", "ko", "lu", "me", "ni", "o", "pe", "qu", "ra", "se", "ti", "u", "vo", "xy", "y", "zu",
	"a", "bel", "cin", "don", "el", "fra", "gle", "hy", "kle", "lia", "mae", "nol", "ori", "prai", "ro", "sve", "tri", "ux", "vim", "xaxa", "zad",
}

local function choose(list)
	return list[math.random(#list)]
end

local function capitalize(s)
	return s:sub(1, 1):upper() .. s:sub(2)
end

local function single()
	return capitalize((choose{
		function() return choose(syllables) .. "-" .. choose(syllables) end,
		function() return choose(syllables) .. choose(syllables) end,
		function() return choose(syllables) .. choose(syllables) .. choose(syllables) end,
	})())
end

function aurum.flavor.generate_name()
	return (choose{
		function() return single() .. " of " .. single() end,
		function() return single() .. " " .. single() end,
		function() return single() .. " " .. single() .. " " .. single() end,
		function() return single() .. " " .. single() end,
	})()
end
