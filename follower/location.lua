local Location = {}
Location.__index = Location
Location.id = "location"
Location.sprites = {}
Location.sprites.idle = love.graphics.newImage("assets/fanatic_pole.png")
Location.sprites.free = love.graphics.newImage("assets/empty_pole.png")
Location.sprites.pxpm = 1024

function Location.new( world, patrols, Patrol, x, y, radius, cooldown ) -- ::Location
	-- Variable initializations
	x = x or 0
	y = y or 0
	radius = radius or 0.1
	cooldown = cooldown or 5
	-- Class stuff
	local self = setmetatable( {}, Location )
	-- Physics stuff
	-- Let the body hit the floor
	self.body = love.physics.newBody( world, x, y, "static" )
	self.body:setFixedRotation( true )
	-- The shape of you
	self.shape = love.physics.newCircleShape( radius )
	-- Fixin' dem shapes to dat boody
	self.fixture = love.physics.newFixture( self.body, self.shape )
	self.fixture:setUserData(self)
	-- Locationect variables
	self.alive = true
	self.cooldown = cooldown
	self.cooldown_timer = self.cooldown
	self.activated = false
	table.insert( patrols, Patrol.new( world, self, x + 1, y + 1 ) )
	return self
end

function Location:free()
	self.fixture:setUserData( nil )
	self.fixture:destroy()
	self.fixture = nil
--	self.shape:destroy()
	self.shape = nil
	self.body:destroy()
	self.body = nil
end

function Location:update(dt, world, followers, Follower, patrols, Patrol ) -- ::void!
	if self.cooldown_timer < self.cooldown then
		self.cooldown_timer = self.cooldown_timer + dt
	end
	if self.activated then
		self.activated = false
		self.cooldown_timer = 0
		local x, y = self:get_center()
		table.insert( followers, Follower.new( world, x, y ) )
	end
end

function Location:draw( screenmanager ) -- ::void!
	local sm = screenmanager
	local img = nil
	if self.cooldown_timer < self.cooldown then
		img = self.sprites.free
		love.graphics.setColor( 200, 200, 200 )
	else
		img = self.sprites.idle
		love.graphics.setColor( 0, 0, 0 )
	end

	local x,y,r
	x, y = self.body:getWorldPoint( self.shape:getPoint() )
	x, y = sm:getScreenPos( x, y )
	r = self.shape:getRadius()
	r = sm:getLength( r )
	love.graphics.circle('fill', x, y, r )

	love.graphics.setColor(255,255,255)
	local w = img:getWidth()
	local h = img:getHeight()
	local sw = sm:getScaleFactor( img:getWidth(), img:getWidth() / self.sprites.pxpm )
	local sh = sm:getScaleFactor( img:getHeight(), img:getHeight() / self.sprites.pxpm )
	love.graphics.draw( img, x, y, 0, sw, sh, w/2, h/2 )



	--local x1,y1,x2,y2,x3,y3,x4,y4 = self.body:getWorldPoints( self.shape:getPoints() )
	--x1,y1 = sm:getScreenPos( x1, y1 )
	--x2,y2 = sm:getScreenPos( x2, y2 )
	--x3,y3 = sm:getScreenPos( x3, y3 )
	--x4,y4 = sm:getScreenPos( x4, y4 )
	--love.graphics.polygon( 'fill', x1,y1,x2,y2,x3,y3,x4,y4 )
end

function Location:input( act, val ) -- ::void!
end

function Location:collide( other, collision )
	if other.id and other.id == 'player' and self.cooldown_timer >= self.cooldown then
		self.activated = true
	end
end

function Location:disable_collision( other, collision )
	--collision:setEnabled( false )
end

function Location:get_center()
	return self.body:getWorldPoint( self.shape:getPoint() )
	--local x1,y1,_,_,_,_,x4,y4 = self.body:getWorldPoints( self.shape:getPoints() )
	--return (x1+x4)/2, (y1+y4)/2
end

return Location
