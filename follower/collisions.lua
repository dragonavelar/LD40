-- Collision masks

COLLISION_MASK_NONE = 1
COLLISION_MASK_PLAYER = 2
COLLISION_MASK_FOLLOWER = 3
COLLISION_MASK_LOCATION = 4
COLLISION_MASK_E = 5
COLLISION_MASK_F = 6
COLLISION_MASK_G = 7
COLLISION_MASK_H = 8
COLLISION_MASK_I = 9
COLLISION_MASK_J = 10
COLLISION_MASK_K = 11
COLLISION_MASK_L = 12
COLLISION_MASK_M = 13
COLLISION_MASK_N = 14
COLLISION_MASK_O = 15
COLLISION_MASK_P = 16

collisions = {}

collisions.debug = false

function collisions.beginContact( a, b, coll )
	if collisions.debug and a:getUserData() and b:getUserData() then
		print( 'Colliding a ' .. a:getUserData().id .. ' with a ' .. b:getUserData().id )
	end
	if a:getUserData() then
		if a:getUserData().collide then
			a:getUserData():collide( b:getUserData(), true )
		end
	end
	if b:getUserData() then
		if b:getUserData().collide then
			b:getUserData():collide( a:getUserData(), true )
		end
	end
end

function collisions.endContact( a, b, coll )
	if collisions.debug and a:getUserData() or b:getUserData() then
		local audi, budi = "nil", "nil"
		if a:getUserData() then
			audi = a:getUserData().id
		end
		if b:getUserData() then
			budi = b:getUserData().id
		end
		print( 'Uncolliding a ' .. audi ..
			' with a ' .. budi )
	end
	if a:getUserData() then
		if a:getUserData().collide and b:getUserData() then
			a:getUserData():collide( b:getUserData(), false )
		end
	end
	if b:getUserData() then
		if b:getUserData().collide and a:getUserData() then
			b:getUserData():collide( a:getUserData(), false )
		end
	end
end

function collisions.preSolve( a, b, coll ) -- TODO
	if a:getUserData() and a:getUserData().disable_collision and b:getUserData() and b:getUserData().disable_collision then
		a:getUserData():disable_collision( b:getUserData(), coll )
		b:getUserData():disable_collision( a:getUserData(), coll )
	end
	return false
end

function collisions.postSolve( a, b, coll, nimpulse, timpulse ) -- TODO
end
