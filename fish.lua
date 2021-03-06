require( "math" )
local Fish = {}
Fish.__index = Fish
Fish.id = "fish"
Fish.sprites = {}
Fish.sprites.idle = love.graphics.newImage("assets/dead_fish.png")
Fish.sprites.pxpm = 1024

Fish.audios = {}
Fish.audios.splats = { love.audio.newSource( "assets/audio/splat1.ogg", "static" ), love.audio.newSource( "assets/audio/splat2.ogg", "static" ) }
Fish.audios.thrown = love.audio.newSource( "assets/audio/throw.ogg", "static" )

function Fish.new( world, x, y, ix, iy, imod, ir, radius, maxspeed, linear_damping, angular_damping, mass ) -- ::Fish
	-- Variable initializations
	imod = imod or 0.002
	ir = ir or 0.0001
	radius = radius or 0.2
	maxspeed = maxspeed or 2.0
	linear_damping = linear_damping or 10
	angular_damping = angular_damping or 10
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
	self.fly_time = 0.3 -- TODO take the magic away
	self.live_time = 8.0
	self.linear_damping = linear_damping
	self.angular_damping = angular_damping
	self.splatted = false

	ix, iy = util.normalize( ix, iy )
	self.body:applyLinearImpulse( ix * imod, iy * imod )
	self.body:applyAngularImpulse( ir )
	self.audios.thrown:play()
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
		if not self.splatted then
			self.splatted = true
			self.audios.splats[ math.random(2) ]:play()
		end
		self.body:setLinearDamping( self.linear_damping )
		self.body:setAngularDamping( self.angular_damping )
	end
end

function Fish:draw( screenmanager ) -- ::void!
	local sm = screenmanager
	local x,y,r
	x, y = self.body:getWorldPoint( self.shape:getPoint() )
	x, y = sm:getScreenPos( x, y )
	--r = self.shape:getRadius()
	--r = sm:getLength( r )
	--love.graphics.setColor(0,0,100)
	--love.graphics.circle('fill', x, y, r )
	
	love.graphics.setColor(255,255,255)
	local w = self.sprites.idle:getWidth()
	local h = self.sprites.idle:getHeight()
	local o = self.body:getAngle()
	local sw = sm:getScaleFactor( self.sprites.idle:getWidth(), self.sprites.idle:getWidth() / self.sprites.pxpm )
	local sh = sm:getScaleFactor( self.sprites.idle:getHeight(), self.sprites.idle:getHeight() / self.sprites.pxpm )
	love.graphics.draw( self.sprites.idle, x, y, o, sw, sh, w/2, h/2 )
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
