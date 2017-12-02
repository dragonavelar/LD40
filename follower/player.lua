require( "math" )
require( "collisions" )

local Player = {}
Player.__index = Player
Player.id = "player"

function Player.new(world, x, y, radius, maxspeed, linear_damping, angular_damping, mass, strenght) -- ::Player
	-- Variable initializations
	x = x or 0
	y = y or 0
	radius = radius or 12
	maxspeed = maxspeed or 220
	linear_damping = linear_damping or 5
	angular_damping = angular_damping or 1
	mass = mass or 0.2 -- So dense, wow. o:
	strenght = strenght or 200
	-- Class stuff
	local self = setmetatable( {}, Player )
	-- Physics stuff
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
	self.fixture:setCategory( COLLISION_MASK_PLAYER )
	self.fixture:setMask()
	-- Maximum speed
	self.maxspeed = maxspeed
	-- Object variables
	self.stronkness = strenght -- So stronk
	self.alive = true
	return self
end

function Player:free() -- ::void!
	self.fixture:setUserData( nil )
	self.fixture:destroy()
	self.fixture = nil
--	self.shape:destroy()
	self.shape = nil
	self.body:destroy()
	self.body = nil
end

function Player:update(dt) -- ::void!
	-- Apply movement
	local fx, fy = 0, 0
	if love.keyboard.isDown( "w", "up" ) then fy = fy - 1 end
	if love.keyboard.isDown( "s", "down" ) then fy = fy + 1 end
	if love.keyboard.isDown( "a", "left" ) then fx = fx - 1 end
	if love.keyboard.isDown( "d", "right" ) then fx = fx + 1 end
	local f = math.sqrt( fx*fx + fy*fy )
	if f == 0 then f = 1 end
	fx = self.stronkness * fx / f
	fy = self.stronkness * fy / f
	self.body:applyForce( fx, fy )
	fx, fy, f = nil, nil, nil
	-- Limit speed for limiting purposes
	local vx, vy = self.body:getLinearVelocity()
	local v = math.sqrt( vx*vx + vy*vy )
	if v > self.maxspeed then
		vx = self.maxspeed * vx / v
		vy = self.maxspeed * vy / v
	end
end

function Player:draw() -- ::void!
	local x,y,r
	x, y = self.body:getWorldPoint( self.shape:getPoint() )
	r = self.shape:getRadius()
	love.graphics.setColor(100,0,0)
	love.graphics.circle('fill', x, y, r )
end

function Player:input(act,val) -- ::void!
end

function Player:collide( other, collision )
end

function Player:get_center() -- ::(float, float)
	return self.body:getWorldPoint( self.shape:getPoint() )
end

function Player:disable_collision( other, collision )
end

return Player
