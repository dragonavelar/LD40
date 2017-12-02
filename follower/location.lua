require( "collisions" )

local Location = {}
Location.__index = Location
Location.id = "location"

function Location.new( world, patrols, Patrol, x, y, w, h, cooldown ) -- ::Location
	-- Variable initializations
	x = x or 0
	y = y or 0
	w = w or 10
	h = h or 10
	cooldown = cooldown or 5
	-- Class stuff
	local self = setmetatable( {}, Location )
	-- Physics stuff
	-- Let the body hit the floor
	self.body = love.physics.newBody( world, x, y, "static" )
	self.body:setFixedRotation( true )
	-- The shape of you
	self.shape = love.physics.newRectangleShape( w, h )
	-- Fixin' dem shapes to dat boody
	self.fixture = love.physics.newFixture( self.body, self.shape )
	self.fixture:setUserData(self)
	self.fixture:setCategory( COLLISION_MASK_LOCATION )
	self.fixture:setMask()--( COLLISION_MASK_PLAYER, COLLISION_MASK_FOLLOWER )
	-- Locationect variables
	self.alive = true
	self.cooldown = cooldown
	self.cooldown_timer = self.cooldown
	self.activated = false
	table.insert( patrols, Patrol.new( world, self, x, y ) )
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

function Location:draw() -- ::void!
	if self.cooldown_timer < self.cooldown then
		love.graphics.setColor( 200, 200, 200 )
	else
		love.graphics.setColor( 255, 255, 255 )
	end
	love.graphics.polygon( 'fill', self.body:getWorldPoints( self.shape:getPoints() ) )
end

function Location:input( act, val ) -- ::void!
end

function Location:collide( other, collision )
	if other.id and other.id == 'player' and self.cooldown_timer >= self.cooldown then
		self.activated = true
	end
end

function Location:disable_collision( other, collision )
	collision:setEnabled( false )
end

function Location:get_center()
	local x1,y1,_,_,_,_,x4,y4 = self.body:getWorldPoints( self.shape:getPoints() )
	return (x1+x4)/2, (y1+y4)/2
end

return Location
