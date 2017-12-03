require( "math" )
local Gameover = {}
Gameover.__index = Gameover
Gameover.state_id = 'Gameover'

function Gameover.load( screenmanager, extra ) -- ::Gameover
	-- Variable initializations
	
	local score = (extra and extra["score"]) or nil
	-- Class stuff
	
	local self = setmetatable( {}, Gameover )

	self.screenmanager = screenmanager
	self.image = love.graphics.newImage( "assets/gameover.png" )
	
	self.font = love.graphics.newFont("assets/rosicrucian.ttf")
	self.text = love.graphics.newText(self.font, 'Press any key to restart')
	if score ~= nil then
		self.score = love.graphics.newText( self.font, "Score: " .. score )
	end

	self.quit = false
	
	return self
end

function Gameover:free()
end

function Gameover:update( dt ) -- ::Gameover_id!	
	if self.quit == true then
		return "ingame", nil
	end
end

function Gameover:draw( ) -- ::void!
	local sm = self.screenmanager
	local x,y, sw, sh

	x, y = sm.screen_x + sm.screen_w * 0.5, sm.screen_y
	x, y = math.floor( x ), math.floor( y )
	sw = sm:getScaleFactor( self.image:getWidth(), sm.meter_w )
	sh = sm:getScaleFactor( self.image:getHeight(), sm.meter_h * 0.5 )
	love.graphics.setColor(255,255,255)
	love.graphics.draw(self.image, x, y, 0, sw, sh, self.image:getWidth()/2 )

	x, y = sm.screen_x + sm.screen_w * 0.5, sm.screen_y + sm.screen_h * 0.7
	x, y = math.floor( x ), math.floor( y )
	sw = sm:getScaleFactor( self.text:getWidth(), sm.meter_w * 0.5 )
	sh = sw -- sm:getScaleFactor( self.image:getHeight(), sm.meter_h * 0.1 )
	love.graphics.setColor(255,255,255)
	love.graphics.draw( self.text, x, y, 0, sw, sh, self.text:getWidth()/2 )

	if self.score ~= nil then
		x, y = sm.screen_x + sm.screen_w * 0.2, sm.screen_y + sm.screen_h * 0.2
		x, y = math.floor( x ), math.floor( y )
		sw = sm:getScaleFactor( self.score:getWidth(), sm.meter_w * 0.2 )
		sh = sw -- sm:getScaleFactor( self.image:getHeight(), sm.meter_h * 0.1 )
		love.graphics.setColor(255,255,255)
		love.graphics.draw( self.score, x, y, 0, sw, sh)
	end
end

function Gameover:input( act, val ) -- ::void!
	if act == "mousereleased" or act == "mousepressed" or act == "keypressed" then
		self.quit = true
	elseif act == "keyreleased" then
		if val["scancode"] ~= "w"
			and val["scancode"] ~= "s"
			and val["scancode"] ~= "a"
			and val["scancode"] ~= "d"
		then
			self.quit = true
		end
	end
end

function Gameover:transition( State, extra ) -- ::Ingame!
	if State == nil then
		return self -- TODO change
	end
	local new_state = State.load( self.screenmanager, extra )
	self:free()
	return new_state
end

return Gameover
