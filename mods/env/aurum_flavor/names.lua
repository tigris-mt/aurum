local syllables = {
	"ae", "bo", "ce", "da", "e", "fi", "gu", "ha", "je", "ko", "lu", "me", "ni", "o", "pe", "qu", "ra", "se", "ti", "u", "vo", "wo", "xy", "y", "zu",
	"a", "bel", "cin", "don", "el", "fra", "gle", "hy", "jes", "kle", "lia", "mae", "nol", "ori", "prai", "ro", "sve", "tri", "ux", "wal", "vim", "xaxa", "zad",
	"ai", "bre", "ca", "det", "ee", "fix", "ge", "hera", "ja", "kev", "luc", "mal", "neiv", "ora", "pen", "rhy", "ske", "ta", "un", "vei", "wak", "xel", "zun",
}

local vowels = "aeiouy"
local consonants = "bcdfghjklmnpqrstvwxyz"

local function choose(list)
	return list[math.random(#list)]
end

local function schoose(str)
	local i = math.random(#str)
	return str:sub(i, i)
end

local function capitalize(s)
	return s:sub(1, 1):upper() .. s:sub(2)
end

local function syllable()
	return (b.t.weighted_choice{
		{function() return choose(syllables) end, 10},
		{function() return schoose(vowels) end, 1},
		{function() return schoose(consonants) .. schoose(vowels) end, 1},
		{function() return schoose(vowels) .. schoose(vowels) end, 1},
		{function() return schoose(consonants) .. schoose(vowels) .. schoose(vowels) end, 1},
	})()
end

local function single()
	return capitalize((b.t.weighted_choice{
		{function() return syllable() .. "-" .. syllable() end, 0.25},
		{function() return syllable() .. syllable() end, 1},
		{function() return syllable() .. syllable() .. syllable() end, 1},
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
