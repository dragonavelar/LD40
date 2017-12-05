local Menu = {}
Menu.__index = Menu
Menu.state_id = 'menu'
Menu.splashscreen = love.graphics.newImage("assets/intro.png")

function Menu.load( screenmanager ) -- ::Menu
	-- Variable initializations
	-- Class stuff
	local self = setmetatable( {}, Menu )
	self.screenmanager = screenmanager
	self.timer = 1.0
	self.start = false
	self.exit = false
	return self
end

function Menu:free()
end

function Menu:update( dt ) -- ::state_id,table!
	if self.timer > 0 then
		self.timer = self.timer - dt
	else
		if self.start then
			return "rules", nil
		elseif self.exit then
			return "exit", nil
		end
	end
end

function Menu:draw( ) -- ::void!
	local sm = self.screenmanager
	local x, y, sw, sh

	love.graphics.setColor(255, 255, 255)
	x, y = sm:getScreenPos( 0, 0 )
	sw = sm:getScaleFactor( Menu.splashscreen:getWidth(), sm.meter_w )
	sh = sm:getScaleFactor( Menu.splashscreen:getHeight(), sm.meter_h )
	love.graphics.draw( Menu.splashscreen, x, y, 0, sw, sh )

	love.graphics.setColor(0, 0, 0)
	local font = love.graphics.getFont()
	sh = sm:getScaleFactor( font:getHeight(), 0.5 )
	sw = sh
	local w = sm:getLength( sm.meter_w * 6/16 ) / sw
	x, y = sm:getScreenPos( sm.meter_w * 1/16, sm.meter_h * 1/9 )
	love.graphics.printf( "MESUS VS THE BROMAN EMPIRE", x, y, w/2, "center", 0, 2*sw, 2*sh )
	x, y = sm:getScreenPos( sm.meter_w * 1/16, sm.meter_h * 5/9 )
	love.graphics.printf( "Press any key to continue", x, y, w, "center", 0, sw, sh )
	x, y = sm:getScreenPos( sm.meter_w * 1/16, sm.meter_h * 6/9 )
	love.graphics.printf( "Press ESC to quit", x, y, w, "center", 0, sw, sh )
end

function Menu:input( act, val ) -- ::void!
	if self.timer <= 0 then
		if act == "mousepressed" then
			self.start = true
		elseif act == "keypressed" then
			if val["key"] == "escape" then
				self.exit = true
			else
				self.start = true
			end
		end
	end
end

function Menu:transition( State ) -- ::State!
	if State == nil then
		return self
	end
	local new_state = State.load( self.screenmanager, extra )
	self:free()
	return new_state
end

return Menu
