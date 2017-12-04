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
	if score ~= nil then
		self.score = score
	end

	self.timer = 1.0
	self.restart = false
	self.exit = false
	
	return self
end

function Gameover:free()
end

function Gameover:update( dt ) -- ::Gameover_id!	
	if self.timer > 0 then
		self.timer = self.timer - dt
	else
		if self.restart then
			return "ingame", nil
		elseif self.exit then
			return "menu", nil
		end
	end
end

function Gameover:draw( ) -- ::void!


	local sm = self.screenmanager
	local x,y, sw, sh

	local sm = self.screenmanager
	local x, y, sw, sh
	local font = love.graphics.getFont()
	sh = sm:getScaleFactor( font:getHeight(), 0.5 )
	sw = sh

	love.graphics.setColor(50, 50, 50)
	x, y = sm:getScreenPos( 0, 0 )
	love.graphics.rectangle( "fill", x, y, sm:getLength( sm.meter_w ), sm:getLength( sm.meter_h ) )

	local w = sm:getLength( sm.meter_w * 14/16 ) / sw
	love.graphics.setColor(128, 0, 0)
	x, y = sm:getScreenPos( sm.meter_w * 1/16, sm.meter_h * 1/9 )
	love.graphics.printf( "BUSTED", x, y, w/4, "center", 0, 4*sw, 4*sh )

	love.graphics.setColor(255, 255, 255)
	x, y = sm:getScreenPos( sm.meter_w * 1/16, sm.meter_h * 6/9 )
	love.graphics.printf( "Score: " .. self.score , x, y, w, "center", 0, sw, sh )
	x, y = sm:getScreenPos( sm.meter_w * 1/16, sm.meter_h * 8/9 )
	love.graphics.printf( "Press any key to continue", x, y, w, "center", 0, sw, sh )
end

function Gameover:input( act, val ) -- ::void!
	if self.timer <= 0 then
		if act == "mousepressed" then
			self.restart = true
		elseif act == "keypressed" then
			if val["key"] == "escape" then
				self.exit = true
			else
				self.restart = true
			end
		end
	end
end

function Gameover:transition( State, extra ) -- ::Ingame!
	if State == nil then
		return self
	end
	local new_state = State.load( self.screenmanager, extra )
	self:free()
	return new_state
end

function Gameover:oldDraw()
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

return Gameover
