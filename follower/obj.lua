local Obj = {}
Obj.__index = Obj

function Obj.new( world, x, y, w, h ) -- ::Obj
	-- Variable initializations
	x = x or 0
	y = y or 0
	w = w or 10
	h = h or 10
	-- Class stuff
	local self = setmetatable( {}, Obj )
	-- Physics stuff
	-- Let the body hit the floor
	self.body = love.physics.newBody( world, x, y, "dynamic" )
	self.body:setFixedRotation( true )
	-- The shape of you
	self.shape = love.physics.newRectangleShape( w, h )
	-- Fixin' dem shapes to dat boody
	self.fixture = love.physics.newFixture( self.body, self.shape )
	self.fixture:setUserData(self)
	self.fixture:setCategory( COLLISION_MASK_NONE )
	self.fixture:setMask()
	-- Object variables
	self.alive = true
	return self
end

function Obj:free()
	self.fixture:setUserData( nil )
	self.fixture:destroy()
	self.fixture = nil
--	self.shape:destroy()
	self.shape = nil
	self.body:destroy()
	self.body = nil
end

function Obj:update(dt) -- ::void!
end

function Obj:draw() -- ::void!
	love.graphics.setColor( 100, 0, 0 )
	love.graphics.polygon( 'fill', self.body:getWorldPoints( self.shape:getPoints() ) )
end

function Obj:input( act, val ) -- ::void!
end

function Obj:collide( other, collision )
end

function Obj:disable_collision( other, collision )
end

return Obj
