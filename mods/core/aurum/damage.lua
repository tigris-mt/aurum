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
} do
	gdamage.register(v)
end
