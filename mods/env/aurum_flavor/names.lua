local syllables = {
	"ae", "bo", "ce", "da", "e", "fi", "gu", "ha", "je", "ko", "lu", "me", "ni", "o", "pe", "qu", "ra", "se", "ti", "u", "vo", "wo", "xy", "y", "zu",
	"a", "bel", "cin", "don", "el", "fra", "gle", "hy", "jes", "kle", "lia", "mae", "nol", "ori", "prai", "ro", "sve", "tri", "ux", "wal", "vim", "xaxa", "zad",
	"ai", "bre", "ca", "det", "ee", "fix", "ge", "hera", "ja", "kev", "luc", "mal", "neiv", "ora", "pen", "rhy", "ske", "ta", "un", "vei", "wak", "xel", "zun",
}

local vowels = "aeiouy"
local consonants = "bcdfghjklmnpqrstvwxyz"

local function schoose(str, random)
	local i = (random or math.random)(#str)
	return str:sub(i, i)
end

local function capitalize(s)
	return s:sub(1, 1):upper() .. s:sub(2)
end

local function syllable(random)
	return (b.t.weighted_choice({
		{function() return b.t.choice(syllables, random) end, 10},
		{function() return schoose(vowels, random) end, 1},
		{function() return schoose(consonants, random) .. schoose(vowels, random) end, 1},
		{function() return schoose(vowels, random) .. schoose(vowels, random) end, 1},
		{function() return schoose(consonants, random) .. schoose(vowels, random) .. schoose(vowels, random) end, 1},
	}, random))()
end

local function single(random)
	return capitalize((b.t.weighted_choice({
		{function() return syllable(random) .. "-" .. syllable(random) end, 0.25},
		{function() return syllable(random) .. syllable(random) end, 1},
		{function() return syllable(random) .. syllable(random) .. syllable(random) end, 1},
	}, random))())
end

function aurum.flavor.generate_name(random)
	return (b.t.choice({
		function() return single(random) .. " of " .. single(random) end,
		function() return single(random) .. " " .. single(random) end,
		function() return single(random) .. " " .. single(random) .. " " .. single(random) end,
		function() return single(random) .. " " .. single(random) end,
	}, random))()
end

local village_suffix = {
	"Town",
	"Hole",
	"Den",
	"Village",
	"Hamlet",
	"Housen",
	"Place",
	"Locale",
}

local village_suffix_immediate = {
	"ton",
	"town",
	"hol",
	"hole",
	"den",
	"vil",
	"ham",
	"house",
	"place",
	"locale",
}

function aurum.flavor.generate_village_name(random)
	return (b.t.choice({
		function() return single(random) end,
		function() return single(random) .. "-" .. single(random) end,
		function() return single(random) .. " " .. b.t.choice(village_suffix, random) end,
		function() return single(random) .. b.t.choice(village_suffix_immediate, random) end,
	}, random))()
end
