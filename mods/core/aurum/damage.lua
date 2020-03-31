-- Register standard damage types with gdamage.
for _,v in ipairs{
	"impact",
	"blade",
	"pierce",

	"burn",
	"chill",
	"psyche",

	"fall",
	"drown",
	"poison",
} do
	gdamage.register(v)
end
