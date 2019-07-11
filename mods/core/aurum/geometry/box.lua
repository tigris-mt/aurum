aurum.box = {}

-- Returns true if box a and box b have collided.
function aurum.box.collide_box(a, b)
    local e = {
        a = aurum.box.extremes(a),
        b = aurum.box.extremes(b),
    }

    local function beyond(axis)
        if e.a.min[axis] < e.b.min[axis] and e.a.max[axis] < e.b.min[axis] then
            return true
        elseif e.a.min[axis] > e.b.max[axis] and e.a.max[axis] > e.b.max[axis] then
            return true
        elseif e.b.min[axis] < e.a.min[axis] and e.b.max[axis] < e.a.min[axis] then
            return true
        elseif e.b.min[axis] > e.a.max[axis] and e.b.max[axis] > e.a.max[axis] then
            return true
        else
            return false
        end
    end

    for _,axis in ipairs({"x", "y", "z"}) do
        if beyond(axis) then
            return false
        end
    end
    return true
end

function aurum.box.collide_point(box, point)
	return aurum.box.collide_box(box, aurum.box.new(point, point))
end

-- Get the extremes of the box.
function aurum.box.extremes(box)
	local min, max = vector.sort(box.a, box.b)
	return {min = min, max = max}
end

-- Get the box translated to a position
function aurum.box.translate(box, pos)
	return aurum.box.new(vector.add(box.a, pos), vector.add(box.b, pos))
end

-- From corners.
function aurum.box.new(a, b)
	return {a = a, b = b}
end

-- From entity collision box.
function aurum.box.new_cbox(box)
    return aurum.geometry.Box.new(vector.new(box[1], box[2], box[3]), vector.new(box[4], box[5], box[6]))
end

-- From radius
function aurum.box.new_radius(center, radius)
	return aurum.box.new(vector.sub(center, radius), vector.add(center, radius))
end
