local Gameover = {}
Gameover.__index = Gameover
Gameover.state_id = 'Gameover'

function Gameover.load( screenmanager ) -- ::Gameover
	-- Variable initializations
	-- Class stuff
	local self = setmetatable( {}, Gameover )
	self.screenmanager = screenmanager
	self.image = love.graphics.newImage( "assets/gameover.png" )
	
	self.font = love.graphics.newFont("assets/rosicrucian.ttf")
	self.text = love.graphics.newText(self.font, 'Press any key to restart')
	return self
end

function Gameover:free()
end

function Gameover:update( dt ) -- ::Gameover_id!
	
end

function Gameover:draw( ) -- ::void!
	local x,y
	x, y = 100,100
	love.graphics.setColor(255,255,255)
	love.graphics.draw(self.image, x, y, 0, 1, 1)
	love.graphics.draw(self.text, 262, 300, 0, 1.5, 1.5)

	--print(  )
end

function Gameover:input( act, val ) -- ::void!
	if act == "mousereleased" then
		--call transition to main menu
	end

	if act == "keyreleased" then
		--call transition to main menu
	end

	print(act)
end

function Gameover:transition( State ) -- ::Gameover!
	if State == nil then
	end
	new_state = State.new( self.screenmanager )
	self:free()
	return new_state
end

return Gameover
