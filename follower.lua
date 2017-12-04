require( "math" )
require( "util" )

local Follower = {}
Follower.__index = Follower
Follower.id = "follower"

Follower.sprites = {}
Follower.sprites.idle = { love.graphics.newImage("assets/fanatic.png"), love.graphics.newImage("assets/fanatic_alternative.png") }
Follower.sprites.pxpm = 1024

Follower.audios = {}
Follower.audios.oohs = { love.audio.newSource( "assets/audio/fanatic1.ogg", "static" ), love.audio.newSource( "assets/audio/fanatic2.ogg", "static" ) , love.audio.newSource( "assets/audio/fanatic3.ogg", "static" ) }

function Follower.new(world, x, y, type, radius, maxspeed, linear_damping, angular_damping, mass, strenght, sight_radius) -- ::Follower
	-- Variable initializations
	x = x or 0
	y = y or 0
	type = type or math.random(2)
	radius = radius or 0.5
	maxspeed = maxspeed or 0.9
	linear_damping = linear_damping or 5
	angular_damping = angular_damping or 1
	mass = mass or 0.5 -- So dense, wow. o:
	strenght = strenght or 0.01
	sight_radius = sight_radius or 2 + radius
	-- Class stuff
	local self = setmetatable( {}, Follower )
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
	-- Maximum speed
	self.maxspeed = maxspeed
	-- Object variables
	self.stronkness = strenght -- So stronk
	self.sight_radius = sight_radius
	self.last_direction = 1
	self.type = type
	self.alive = true
	
	self.oohed = false
	self.audio_cooldown = 2
	self.audio_cooldown_timer = 0
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

function Follower:get_vector_to( tx, ty )
	local x, y = self:get_center()
	return util.dist2d( x, y, tx, ty )
end

function Follower:update( dt, target_x, target_y, fishes ) -- ::void!
	-- Apply movement
	local x, y = self.body:getWorldPoint( self.shape:getPoint() )
	local fx, fy = 0,0
	local saw_mesus = false

	if ( target_x ~= nil and target_y ~= nil )
		and
		( x ~= target_x and y ~= target_y )
	then
		fx, fy = self:get_vector_to( target_x, target_y )
		local f = util.vec2dmod( fx, fy )
		if f == 0 then f = 1 end
		if f > self.sight_radius then
			fx, fy = 0, 0
		else
			saw_mesus = true
			fx = self.stronkness * fx / f
			fy = self.stronkness * fy / f
		end
	end

	for k, v in pairs( fishes ) do
		if v.alive then
			local ffx, ffy = self:get_vector_to( v:get_center() )
			local ff = util.vec2dmod( ffx, ffy )
			if ff == 0 then ff = 1 end
			if ff <= self.sight_radius then
				saw_mesus = false
				fx = self.stronkness * ffx / ff
				fy = self.stronkness * ffy / ff
			end
			v:update( dt, px, py, fishes )
		end
	end

	if self.audio_cooldown_timer > 0 then
		self.audio_cooldown_timer = self.audio_cooldown_timer - dt
	end

	if saw_mesus then
		if not self.oohed then 
			self.oohed = true
			self.audios.oohs[ math.random(3) ]:play()
		end
	elseif self.oohed and self.audio_cooldown_timer <= 0 then
		self.oohed = false
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
	if vx > 0 then
		self.last_direction = 1
	elseif vx < 0 then
		self.last_direction = -1
	end
end

function Follower:draw( screenmanager ) -- ::void!
	local sm = screenmanager
	local x,y,r
	x, y = self.body:getWorldPoint( self.shape:getPoint() )
	x, y = sm:getScreenPos( x, y )
	--r = self.shape:getRadius()
	--r = sm:getLength( r )
	--love.graphics.setColor(100,0,100)
	--love.graphics.circle('fill', x, y, r )

	love.graphics.setColor(255,255,255)
	local img = self.sprites.idle[self.type]
	local dir = self.last_direction
	local w = img:getWidth()
	local h = img:getHeight()
	local sw = screenmanager:getScaleFactor( img:getWidth(), img:getWidth() / self.sprites.pxpm )
	local sh = screenmanager:getScaleFactor( img:getWidth(), img:getWidth() / self.sprites.pxpm )
	love.graphics.draw( img, x, y, 0, dir * sw, sh, w/2, h/2 )
end

function Follower:input(act,val) -- ::void!
end

function Follower:collide( other, collision )
end

function Follower:disable_collision( other, collision )
end

function Follower:get_center() -- ::(float, float)
	return self.body:getWorldPoint( self.shape:getPoint() )
end

return Follower
