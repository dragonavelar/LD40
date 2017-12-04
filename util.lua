util = {}

function util.vec2dmod( vx, vy )
	return math.sqrt( vx*vx + vy*vy )
end

function util.dist2d( x1, y1, x2, y2 )
	return x2 - x1, y2 - y1
end

function util.dist2dmod( x1, y1, x2, y2 )
	return util.vec2dmod( util.dist2d( x1, y1, x2, y2 ) )
end

function util.normalize( vx, vy )
	local vv = util.vec2dmod( vx, vy )
	if vv == 0 then vv = 1 end
	return vx / vv, vy / vv
end