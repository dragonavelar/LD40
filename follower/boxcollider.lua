local Boxcollider = {}
Boxcollider.__index = Boxcollider

function Boxcollider.new( world, x, y, w, h ) -- ::Boxcollider
	-- Variable initializations
	x = x + w /2
	y = y + h / 2
	w = w
	h = h
	-- Class stuff
	local self = setmetatable( {}, Boxcollider )
	-- Physics stuff
	-- Let the body hit the floor
	self.body = love.physics.newBody( world, x, y, "static" )
	self.body:setFixedRotation( true )
	-- The shape of you
	self.shape = love.physics.newRectangleShape( w, h )
	-- Fixin' dem shapes to dat boody
	self.fixture = love.physics.newFixture( self.body, self.shape )
	self.fixture:setUserData(self)
	-- Boxcolliderect variables
	self.alive = true
	return self
end

function Boxcollider:free()
	self.fixture:setUserData( nil )
	self.fixture:destroy()
	self.fixture = nil
--	self.shape:destroy()
	self.shape = nil
	self.body:destroy()
	self.body = nil
end

function Boxcollider:update(dt) -- ::void!
end

function Boxcollider:draw( screenmanager ) -- ::void!
	local sm = screenmanager
	local x1,y1,x2,y2,x3,y3,x4,y4 = self.body:getWorldPoints( self.shape:getPoints() )
	x1,y1 = sm:getScreenPos( x1, y1 )
	x2,y2 = sm:getScreenPos( x2, y2 )
	x3,y3 = sm:getScreenPos( x3, y3 )
	x4,y4 = sm:getScreenPos( x4, y4 )
	love.graphics.setColor( 0, 0, 0, 100 )
	love.graphics.polygon( 'fill', x1,y1,x2,y2,x3,y3,x4,y4 )
end

function Boxcollider:input( act, val ) -- ::void!
end

function Boxcollider:collide( other, collision )
end

function Boxcollider:disable_collision( other, collision )
end

return Boxcollider
