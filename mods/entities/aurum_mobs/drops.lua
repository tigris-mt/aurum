function aurum.mobs.helper_get_drops(t, object)
	-- If plain table passed, just drop them all.
	if not t.items then
		t = {
			max_items = 1,
			items = {
				{
					items = t,
				},
			},
		}
	end

	t = b.t.combine({
		items = {},
	}, t)

	t = b.t.combine({
		max_items = #t.items,
	}, t)

	local ret = {}
	local dropped = 0

	for _,itemlist in ipairs(t.items) do
		itemlist = b.t.combine({
			rarity = 1,
			items = {},
		}, itemlist)
		if math.random() < (1 / itemlist.rarity) then
			b.t.imerge(ret, b.t.imap(itemlist.items, function(v) return ItemStack(v) end))
			dropped = dropped + 1
			if dropped >= t.max_items then
				break
			end
		end
	end

	return ret
end
