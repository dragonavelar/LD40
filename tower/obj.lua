local Obj = {}
Obj.__index = Obj

function Obj.new( world ) -- ::Obj
	local self = setmetatable( {}, Obj )
	local w = 10
	local h = 10
	self.body = love.physics.newBody( world, 0, 0, "static" )
	self.shape = love.physics.newRectangleShape( w, h )
	self.fixture = love.physics.newFixture( self.body, self.shape )
	self.fixture:setUserData( self )
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

return Obj
