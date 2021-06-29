version() {
	lua -e 'dofile("mods/core/aurum/aurum_table.lua"); print(aurum.VERSION)'
}

mtversion() {
	lua -e 'dofile("mods/core/aurum/aurum_table.lua"); print(aurum.MT_VERSION)'
}

screenshot() {
	lua -e 'dofile("mods/core/aurum/aurum_table.lua"); print(aurum.SCREENSHOT)'
}
