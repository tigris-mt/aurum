local S = aurum.get_translator()

doc.sub.items.register_factoid("tools", "use", function(itemstring, def)
	if def._eqdef and def._eqdef.armor then
		local t = {}
		for k,v in b.t.spairs(def._eqdef.armor) do
			table.insert(t, S(k .. ": @1%", 100 - math.floor(v * 100)))
		end
		return S("By itself, this armor provides protection: @1", table.concat(t, ", "))
	end
	return ""
end)

doc.sub.items.register_factoid("tools", "use", function(itemstring, def)
	if def._eqdef and def._eqdef.durability then
		return S("By itself, this equipment lasts around @1 uses.", def._eqdef.durability)
	end
	return ""
end)
