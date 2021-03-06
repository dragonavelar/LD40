require( "math" )
require( "util" )

local Player = {}
Player.__index = Player
Player.id = "player"
Player.sprites = {}
Player.sprites.idle = love.graphics.newImage("assets/player.png")
Player.sprites.pxpm = 1024


function Player.new(world, x, y, radius, maxspeed, linear_damping, angular_damping, mass, strenght) -- ::Player
	-- Variable initializations
	x = x or 4
	y = y or 4.5
	radius = radius or 0.4
	maxspeed = maxspeed or 1.2
	linear_damping = linear_damping or 5
	angular_damping = angular_damping or 1
	mass = mass or 1 -- So dense, wow. o:
	strenght = strenght or 0.02
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
	-- Maximum speed
	self.maxspeed = maxspeed
	-- Object variables
	self.stronkness = strenght -- So stronk
	self.alive = true
	self.last_direction = 1

	self.walk_x = 0
	self.walk_y = 0

	self.key_w = false
	self.key_a = false
	self.key_s = false
	self.key_d = false

	self.throw_fish_cooldown = 3
	self.throw_fish_cooldown_timer = 0
	self.fish_target_x = nil
	self.fish_target_y = nil

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

function Player:update( dt, fishes, Fish ) -- ::void!
	-- Apply movement
	local fx, fy = self.walk_x, self.walk_y
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
	if vx > 0 then
		self.last_direction = 1
	elseif vx < 0 then
		self.last_direction = -1
	end
	-- Throw fish
	if self.throw_fish_cooldown_timer > 0 then
		self.throw_fish_cooldown_timer = self.throw_fish_cooldown_timer - dt
	elseif self.fish_target_x ~= nil and self.fish_target_y ~= nil then
		local x, y = self:get_center()
		local dx, dy = util.dist2d( x, y, self.fish_target_x, self.fish_target_y )
		dx, dy = util.normalize( dx, dy )
		table.insert( fishes, Fish.new( self.body:getWorld(), x, y, dx, dy ) )
		self.throw_fish_cooldown_timer = self.throw_fish_cooldown
		self.fish_target_x, self.fish_target_y = nil, nil
	end
end

function Player:draw( screenmanager ) -- ::void!
	local sm = screenmanager
	local x,y,r
	x, y = self.body:getWorldPoint( self.shape:getPoint() )
	x, y = sm:getScreenPos( x, y )
	--r = self.shape:getRadius()
	--r = sm:getLength( r )
	--love.graphics.setColor(100,0,0)
	--love.graphics.circle('fill', x, y, r )

	love.graphics.setColor(255,255,255)
	local dir = self.last_direction
	local w = self.sprites.idle:getWidth()
	local h = self.sprites.idle:getHeight()
	local sw = sm:getScaleFactor( self.sprites.idle:getWidth(), self.sprites.idle:getWidth() / self.sprites.pxpm )
	local sh = sm:getScaleFactor( self.sprites.idle:getHeight(), self.sprites.idle:getHeight() / self.sprites.pxpm )
	love.graphics.draw( self.sprites.idle, x, y, 0, dir * sw, sh, w/2, h/2 )
end

function Player:input(act,val) -- ::void!
	if act == "mousepressed" then
		if self.throw_fish_cooldown_timer <= 0 then
			self.fish_target_x, self.fish_target_y = val["x"], val["y"]
		end
	elseif act == "keypressed" then
		if ( val["scancode"] == "w" or val["scancode"] == "up" ) then
			if not self.key_w then
				self.walk_y = self.walk_y - 1
				self.key_w = true
			end
		elseif ( val["scancode"] == "s" or val["scancode"] == "down" ) then
			if not self.key_s then
				self.walk_y = self.walk_y + 1
				self.key_s = true
			end
		elseif ( val["scancode"] == "a" or val["scancode"] == "left" ) then
			if not self.key_a then
				self.walk_x = self.walk_x - 1
				self.key_a = true
			end
		elseif ( val["scancode"] == "d" or val["scancode"] == "right" ) then
			if not self.key_d then
				self.walk_x = self.walk_x + 1
				self.key_d = true
			end
		end
	elseif act == "keyreleased" then
		if ( val["scancode"] == "w" or val["scancode"] == "up" ) and self.walk_y <= 0 then
			if self.key_w then
				self.walk_y = self.walk_y + 1
				self.key_w = false
			end
		elseif ( val["scancode"] == "s" or val["scancode"] == "down" ) and self.walk_y >= 0 then
			if self.key_s then
				self.walk_y = self.walk_y - 1
				self.key_s = false
			end
		elseif ( val["scancode"] == "a" or val["scancode"] == "left" ) and self.walk_x <= 0 then
			if self.key_a then
				self.walk_x = self.walk_x + 1
				self.key_a = false
			end
		elseif ( val["scancode"] == "d" or val["scancode"] == "right" ) and self.walk_x >= 0 then
			if self.key_d then
				self.walk_x = self.walk_x - 1
				self.key_d = false
			end
		end
	end
end

function Player:collide( other, collision )
end

function Player:disable_collision( other, collision )
end

function Player:get_center() -- ::(float, float)
	return self.body:getWorldPoint( self.shape:getPoint() )
end

return Player
