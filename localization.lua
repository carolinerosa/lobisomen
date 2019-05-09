local loc = {}

loc = {size=0}

function loc.getLoc()
	loc.size = loc.size + 1
	return loc.size
end

return loc