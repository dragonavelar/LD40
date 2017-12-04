require( "math" )
require( "util" )

local Patrol = {}
Patrol.__index = Patrol
Patrol.id = "patrol"
Patrol.sprites = {}
Patrol.sprites.idle = love.graphics.newImage("assets/broman.png")
Patrol.sprites.pxpm = 1024

Patrol.audios = {}
Patrol.audios.barks = { love.audio.newSource( "assets/audio/broman1.ogg", "static" ), love.audio.newSource( "assets/audio/broman2.ogg", "static" ) , love.audio.newSource( "assets/audio/broman3.ogg", "static" ) }

Patrol.PATROL_STATE = "patrolling"
Patrol.CHASE_STATE = "chasing"

function Patrol.new(world, parent_location, x, y, radius, patrol_radius, maxspeed, linear_damping, angular_damping, mass, strenght, sight_radius) -- ::Patrol
	-- Variable initializations
	x = x or 0
	y = y or 0
	radius = radius or 0.6
	maxspeed = maxspeed or 1
	linear_damping = linear_damping or 5
	angular_damping = angular_damping or 1
	mass = mass or 2 -- So dense, wow. o:
	strenght = strenght or 0.01
	sight_radius = sight_radius or 4 + radius
	patrol_radius = patrol_radius or sight_radius + 0.5
	-- Class stuff
	local self = setmetatable( {}, Patrol )
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
	self.alive = true
	self.parent = parent_location
	self.patrol_radius = patrol_radius
	local px, py = self.parent:get_center()
	self.patrol_x = px
	self.patrol_y = py
	self.objective_distance_threshold  = radius
	self.state = Patrol.PATROL_STATE
	self.passing_through = 0

	self.barked = false
	self.audio_cooldown = 2
	self.audio_cooldown_timer = 0
	return self
end

function Patrol:free() -- ::void!
	self.fixture:setUserData( nil )
	self.fixture:destroy()
	self.fixture = nil
--	self.shape:destroy()
	self.shape = nil
	self.body:destroy()
	self.body = nil
end

function Patrol:update(dt, target_x, target_y) -- ::void!
	-- Apply movement
	local x, y = self:get_center()
	if ( target_x ~= nil and target_y ~= nil ) then
		local d = util.dist2dmod( x, y, target_x, target_y )
		if d > self.sight_radius then
			self.state = Patrol.PATROL_STATE
		else
			self.state = Patrol.CHASE_STATE
		end
	end
	if self.audio_cooldown_timer > 0 then
		self.audio_cooldown_timer = self.audio_cooldown_timer - dt
	end

	if self.state == Patrol.CHASE_STATE then
		if not self.barked then 
			self.barked = true
			self.audios.barks[ math.random(3) ]:play()
		end
		self:force_towards( target_x, target_y )
	elseif self.state == Patrol.PATROL_STATE then
		if self.barked and self.audio_cooldown_timer <= 0 then
			self.barked = false
		end
		self:force_towards( self.patrol_x, self.patrol_y )
		if util.dist2dmod( x, y, self.patrol_x, self.patrol_y ) < self.objective_distance_threshold then
			local r = math.random() * self.patrol_radius
			local o = math.random() * 2 * math.pi
			local x,y = self.parent:get_center()
			self.patrol_x = x + r * math.cos( o )
			self.patrol_y = y + r * math.sin( o )
		end
	end
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

function Patrol:draw( screenmanager ) -- ::void!
	local sm = screenmanager
	local x,y,r
	x, y = self.body:getWorldPoint( self.shape:getPoint() )
	x, y = sm:getScreenPos( x, y )
	--r = self.shape:getRadius()
	--r = sm:getLength( r )
	--love.graphics.setColor(0,128,0)
	--love.graphics.circle('fill', x, y, r )


	love.graphics.setColor(255,255,255)
	local dir = -self.last_direction
	local w = self.sprites.idle:getWidth()
	local h = self.sprites.idle:getHeight()
	local sw = screenmanager:getScaleFactor( self.sprites.idle:getWidth(), self.sprites.idle:getWidth() / self.sprites.pxpm )
	local sh = screenmanager:getScaleFactor( self.sprites.idle:getWidth(), self.sprites.idle:getWidth() / self.sprites.pxpm )
	love.graphics.draw( self.sprites.idle, x, y, 0, dir * sw, sh, w/2, h/2 )
end

function Patrol:input(act,val) -- ::void!
end

function Patrol:collide( other, collision )
	if other.id == "player" then
		other.alive = false
	end
	if other.id == "follower" then
		if collision then 
			self.passing_through = self.passing_through + 1
		else
			self.passing_through = self.passing_through - 1
		end
	end
end

function Patrol:disable_collision( other, collision )
	if other.id == "follower" or other.id == "location" then
		collision:setEnabled( false )
	end
end

function Patrol:get_center()
	return self.body:getWorldPoint( self.shape:getPoint() )
end

function Patrol:force_towards( tx, ty )
	local x, y = self:get_center()
	local fx, fy = util.dist2d( x, y, tx, ty )
	local fmod = util.vec2dmod( fx, fy )
	local mult = 1
	if self.state == Patrol.CHASE_STATE then
		mult = mult * 2
	elseif self.state == Patrol.PATROL_STATE then 
		mult = mult * 1/2
	end
	if self.passing_through > 0 then
		mult = mult * 2/3
	end
	fx = mult * self.stronkness * fx / fmod
	fy = mult * self.stronkness * fy / fmod
	self.body:applyForce( fx, fy )
end

return Patrol
