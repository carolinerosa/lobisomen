local loc = {}

loc = {size=0}

function loc.getLoc()
	loc.size = loc.size + 1
	return loc.size
end

function loc.makeLoc(value)
	return {"LOC",value}
end

return loc