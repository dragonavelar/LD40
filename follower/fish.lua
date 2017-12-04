require( "math" )
local Fish = {}
Fish.__index = Fish
Fish.id = "fish"

function Fish.new( world, x, y, ix, iy, imod, ir, radius, maxspeed, linear_damping, angular_damping, mass ) -- ::Fish
	-- Variable initializations
	imod = imod or 0.001
	ir = ir or 1
	radius = radius or 0.2
	maxspeed = maxspeed or 2.0
	linear_damping = linear_damping or 10
	angular_damping = angular_damping or 2
	mass = mass or 0.1 -- So dense, wow. o:
	-- Class stuff
	local self = setmetatable( {}, Fish )
	-- Physics stuff
	-- Let the body hit the floor
	self.body = love.physics.newBody( world, x, y, "dynamic" )
	self.body:setLinearDamping( 0 )
	self.body:setAngularDamping( 0 )
	self.body:setMass( mass )
	-- The shape of you
	self.shape = love.physics.newCircleShape( radius )
	-- Fixin' dem shapes to dat boody
	self.fixture = love.physics.newFixture( self.body, self.shape )
	self.fixture:setUserData(self)
	-- Object variables
	self.alive = true
	self.fly_time = 0.2 -- TODO take the magic away
	self.live_time = 3.0
	self.linear_damping = linear_damping
	self.angular_damping = angular_damping

	ix, iy = util.normalize( ix, iy )
	print( "Impulse: " .. ix * imod .. " " .. iy * imod )
	self.body:applyLinearImpulse( ix * imod, iy * imod )
	self.body:applyAngularImpulse( ir )
	return self
end

function Fish:free()
	self.fixture:setUserData( nil )
	self.fixture:destroy()
	self.fixture = nil
--	self.shape:destroy()
	self.shape = nil
	self.body:destroy()
	self.body = nil
end

function Fish:update(dt) -- ::void!
	if self.live_time <= 0 then
		self.alive = false
	else
		self.live_time = self.live_time - dt
	end
	
	if self.fly_time > 0 then
		self.fly_time = self.fly_time - dt
	else
		self.body:setLinearDamping( self.linear_damping )
		self.body:setAngularDamping( self.angular_damping )
	end
end

function Fish:draw( screenmanager ) -- ::void!
	local sm = screenmanager
	local x,y,r
	x, y = self.body:getWorldPoint( self.shape:getPoint() )
	x, y = sm:getScreenPos( x, y )
	r = self.shape:getRadius()
	r = sm:getLength( r )
	love.graphics.setColor(0,0,100)
	love.graphics.circle('fill', x, y, r )
end

function Fish:input( act, val ) -- ::void!
end

function Fish:collide( other, collision )
end

function Fish:disable_collision( other, collision )
	collision:setEnabled( false )
end

function Fish:get_center() -- ::(float, float)
	return self.body:getWorldPoint( self.shape:getPoint() )
end

return Fish
