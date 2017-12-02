require( "math" )

local Follower = {}
Follower.__index = Follower

function Follower.new(world, x, y, radius, maxspeed, linear_damping, angular_damping, mass, strenght) -- ::Follower
	-- Variable initializations
	x = x or 0
	y = y or 0
	radius = radius or 50
	maxspeed = maxspeed or 1000
	linear_damping = linear_damping or 5
	angular_damping = angular_damping or 1
	mass = mass or 0.25 -- So dense, wow. o:
	strenght = strenght or 2500
	-- Physics stuff
	local self = setmetatable( {}, Follower )
	-- Let the body hit the floor
	self.body = love.physics.newBody( world, x, y, "dynamic" )
	self.body:setAngularDamping( angular_damping )
	self.body:setLinearDamping( linear_damping )
	self.body:setMass( mass )
	self.body:setFixedRotation( true )
	-- The shape of you
	self.shape = love.physics.newCircleShape( radius )
	-- Fixin' dem shapes to dat boody
	self.fixture = love.physics.newFixture( self.body, self.shape )
	self.fixture:setUserData(self)
	-- Maximum speed
	self.maxspeed = maxspeed
	-- Object variables
	self.stronkness = strenght -- So stronk
	self.alive = true
	return self
end

function Follower:free() -- ::void!
	self.fixture:setUserData( nil )
	self.fixture:destroy()
	self.fixture = nil
--	self.shape:destroy()
	self.shape = nil
	self.body:destroy()
	self.body = nil
end

function Follower:update(dt, target_x, target_y) -- ::void!
	-- Apply movement
	local x, y = self.body:getWorldPoint( self.shape:getPoint() )
	local fx, fy = 0,0
	if ( target_x ~= nil and target_y ~= nil )
		and
		( x ~= target_x and y ~= target_y )
	then
		fx = target_x - x
		fy = target_y - y
		local f = math.sqrt( fx*fx + fy*fy )
		if f == 0 then f = 1 end
		fx = self.stronkness * fx / f
		fy = self.stronkness * fy / f
	end
	self.body:applyForce( fx, fy )
	x, y = nil, nil
	fx, fy, f = nil, nil, nil
	-- Limit speed for limiting purposes
	local vx, vy = self.body:getLinearVelocity()
	local v = math.sqrt( vx*vx + vy*vy )
	if v > self.maxspeed then
		vx = self.maxspeed * vx / v
		vy = self.maxspeed * vy / v
	end
end

function Follower:draw() -- ::void!
	local x,y,r
	x, y = self.body:getWorldPoint( self.shape:getPoint() )
	r = self.shape:getRadius()
	love.graphics.setColor(100,0,100)
	love.graphics.circle('fill', x, y, r )
	print( x, y, r )
end

function Follower:input(act,val) -- ::void!
end

function Follower:collide( other, collision )
end

return Follower
