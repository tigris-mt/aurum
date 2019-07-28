for k,v in pairs{
	["aurum:aurum"] = {
		color = "#009900",
	},
	["aurum:loom"] = {
		color = "#550000",
	},
} do
	aurum.portals.register(k, v)
end
