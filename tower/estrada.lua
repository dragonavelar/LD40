require( "math" )

local Estrada = {}
Estrada.__index = Estrada

function Estrada.new(world, x, y, width, height) -- ::Estrada
	-- Variable initializations
	x = x or 0
	y = y or 0
	width = width or 1
	heigth = height or 1

	-- Physics stuff
	local self = setmetatable( {}, Estrada )
	-- Let the body hit the floor
	self.body = love.physics.newBody( world, x, y, "dynamic" )

	-- The shape of you
	self.image_left = love.graphics.newImage("assets/left_path.png")
	self.image_right= love.graphics.newImage("assets/right_path.png")
	self.image_radius1 = love.graphics.newImage("assets/path_radius1.png")
	self.image_radius2 = love.graphics.newImage("assets/path_radius2.png")

	-- Object variables
	self.stronkness = 0 -- So stronk
	self.alive = true
	return self
end

function Estrada:free() -- ::void!
	self.fixture:setUserData( nil )
	self.fixture:destroy()
	self.fixture = nil
--	self.shape:destroy()
	self.shape = nil
	self.body:destroy()
	self.body = nil
end

function Estrada:update(dt) -- ::void!
	-- Tower is static enviroment
end

function Estrada:draw() -- ::void!
	local x, y, width, height = 425.75, 500, 0.25, 0.25

	love.graphics.draw(self.image_left, x, y,0, width, height)
end

function Estrada:input(act,val) -- ::void!
end

function Estrada:collide( other, collision )
end

return Estrada