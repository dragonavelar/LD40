require( "math" )

local Chao = {}
Chao.__index = Chao

local limiter, feito = 1, 0

function Chao.new(world, x, y, width, height) -- ::Chao
	-- Variable initializations
	x = x or 0
	y = y or 0
	width = width or 1
	height = height or 1
	-- Physics stuff
	local self = setmetatable( {}, Chao )
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

function Chao:free() -- ::void!
	self.fixture:setUserData( nil )
	self.fixture:destroy()
	self.fixture = nil
--	self.shape:destroy()
	self.shape = nil
	self.body:destroy()
	self.body = nil
end

function Chao:update(dt) -- ::void!
	-- Tower is static enviroment
end

function Chao:load() -- ::void!
	
end

function Chao:draw() -- ::void!
	local i, j,x, y, w_imagem, h_imagem, w_tela, h_tela
	--ww = love.window.getWidth()
	i, j, x, y = 0, 0, 0, 0

	w_imagem = self.image:getWidth()
	h_imagem = self.image:getHeight()

	w_tela = love.graphics.getWidth()
	h_tela = love.graphics.getHeight()

	--print(w_tela, h_tela)
	--if feito < limiter then
		for i=0, w_tela do
			for j=0, h_tela do
				love.graphics.draw(self.image, x, y,0, self.width, self.height)
				y = y + h_imagem
			end
			x = x + w_imagem
			y = 0
		end
	--end

	feito = 1
end

function Chao:input(act,val) -- ::void!
end

function Chao:collide( other, collision )
end

return Chao