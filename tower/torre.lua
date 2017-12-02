require( "math" )

local Torre = {}
Torre.__index = Torre

function Torre.new(world, x, y, width, height) -- ::Torre
	-- Variable initializations
	x = x or 1000
	y = y or 100
	width = width or 0.1
	heigth = height or 0.1
	-- Physics stuff
	local self = setmetatable( {}, Torre )
	-- Let the body hit the floor
	self.body = love.physics.newBody( world, x, y, "dynamic" )
	--self.body:setAngularDamping( angular_damping )
	--self.body:setLinearDamping( linear_damping )
	--self.body:setMass( mass )
	--self.body:setFixedRotation( true )
	-- The shape of you
	self.image = love.graphics.newImage("assets/towerDefense_tile157.png")
	-- Fixin' dem shapes to dat boody
	--self.fixture = love.physics.newFixture( self.body, self.shape )
	--self.fixture:setUserData(self)
	-- Maximum speed
	--self.maxspeed = maxspeed
	-- Object variables
	self.stronkness = 0 -- So stronk
	self.alive = true
	return self
end

function Torre:free() -- ::void!
	self.fixture:setUserData( nil )
	self.fixture:destroy()
	self.fixture = nil
--	self.shape:destroy()
	self.shape = nil
	self.body:destroy()
	self.body = nil
end

function Torre:update(dt) -- ::void!
	-- Tower is static enviroment
end

function Torre:draw() -- ::void!
	local x,y,r
	x, y = self.body:getWorldPoint(100,100)
	--r = self.shape:getRadius()
	--love.graphics.setColor(100,0,0)
	love.graphics.draw(self.image, self.x,self.y,0,0.1, 0.1)
	print( x, y, r )
end

function Torre:input(act,val) -- ::void!
end

function Torre:collide( other, collision )
end

return Torre