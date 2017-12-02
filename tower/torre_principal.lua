require( "math" )

local Torre_principal = {}
Torre_principal.__index = Torre_principal

function Torre_principal.new(world, x, y, width, height) -- ::Torre_principal
	-- Variable initializations
	x = x or 500
	y = y or 100
	width = width or 1
	heigth = height or 1

	-- Physics stuff
	local self = setmetatable( {}, Torre_principal )
	-- Let the body hit the floor
	self.body = love.physics.newBody( world, x, y, "dynamic" )

	-- The shape of you
	self.image = love.graphics.newImage("assets/tower1.png")

	-- Object variables
	self.stronkness = 0 -- So stronk
	self.alive = true
	return self
end

function Torre_principal:free() -- ::void!
	self.fixture:setUserData( nil )
	self.fixture:destroy()
	self.fixture = nil
--	self.shape:destroy()
	self.shape = nil
	self.body:destroy()
	self.body = nil
end

function Torre_principal:update(dt) -- ::void!
	-- Tower is static enviroment
end

function Torre_principal:draw() -- ::void!
	local x, y, width, height = 320, 500, 0.25, 0.25

	love.graphics.draw(self.image, x, y,0, width, height)
end

function Torre_principal:input(act,val) -- ::void!
end

function Torre_principal:collide( other, collision )
end

return Torre_principal