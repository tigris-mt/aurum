local storage = minetest.get_mod_storage()
local areastore = AreaStore()

if storage:contains("villages_areastore") then
	areastore:from_string(minetest.decode_base64(storage:get_string("villages_areastore")))
end

function aurum.villages.save_areastore()
	storage:set_string("villages_areastore", minetest.encode_base64(areastore:to_string()))
end

function aurum.villages.get_village_id_at(pos)
	return b.t.keys(areastore:get_areas_for_pos(pos))[1]
end

function aurum.villages.get_village_ids_in(box)
	return b.t.keys(areastore:get_areas_in_area(box.a, box.b, true))
end

function aurum.villages.get_village(id)
	if storage:contains("village_" .. tostring(id)) then
		return minetest.deserialize(storage:get_string("village_" .. tostring(id)))
	end
end

function aurum.villages.set_village(id, data)
	storage:set_string("village_" .. tostring(id), minetest.serialize(data))
end

function aurum.villages.new_village(box)
	local id = assert(areastore:insert_area(box.a, box.b, ""), "could not add village to areastore")
	aurum.villages.save_areastore()
	return id
end

function aurum.villages.delete_village(id)
	areastore:remove_area(id)
	aurum.villages.save_areastore()
	storage:set_string("village_" .. tostring(id), "")
end
