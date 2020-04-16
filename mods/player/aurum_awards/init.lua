local S = minetest.get_translator()

aurum.awards = {}

awards.register_on_unlock(function(name, def)
	minetest.chat_send_all(S("@1 unlocked @2", minetest.colorize("#00aaff", name), minetest.colorize("#ffaa00", def.title)))
end)

b.dodir("awards")
