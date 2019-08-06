local syllables = {
	"ae", "bo", "ce", "da", "e", "fi", "gu", "ha", "je", "ko", "lu", "me", "ni", "o", "pe", "qu", "ra", "se", "ti", "u", "vo", "xy", "y", "zu",
}

local function choose(list)
	return list[math.random(#list)]
end

local function capitalize(s)
	return s:sub(1, 1):upper() .. s:sub(2)
end

function aurum.flavor.generate_name()
	return capitalize(choose(syllables) .. choose(syllables) .. choose(syllables)) .. " " .. capitalize(choose(syllables) .. choose(syllables) .. choose(syllables))
end
