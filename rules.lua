local Rules = {}
Rules.__index = Rules
Rules.state_id = 'rules'
function Rules.load( screenmanager ) -- ::Rules
	-- Variable initializations
	-- Class stuff
	local self = setmetatable( {}, Rules )
	self.screenmanager = screenmanager
	self.timer = 1.0
	self.start = false
	return self
end

function Rules:free()
end

function Rules:update( dt ) -- ::state_id,table!
	if self.timer > 0 then
		self.timer = self.timer - dt
	else
		if self.start then
			return "ingame", nil
		elseif self.exit then
			return "exit", nil
		end
	end
end

function Rules:draw( ) -- ::void!
	local sm = self.screenmanager
	local x, y, sw, sh
	local font = love.graphics.getFont()
	sh = sm:getScaleFactor( font:getHeight(), 0.5 )
	sw = sh

	love.graphics.setColor(50, 50, 50)
	x, y = sm:getScreenPos( 0, 0 )
	love.graphics.rectangle( "fill", x, y, sm:getLength( sm.meter_w ), sm:getLength( sm.meter_h ) )

	local w = sm:getLength( sm.meter_w * 14/16 ) / sw
	love.graphics.setColor(255, 255, 255)
	x, y = sm:getScreenPos( sm.meter_w * 1/16, sm.meter_h * 1/9 )
	love.graphics.printf( "ULTRA MESUS VS BROMANS", x, y, w/2, "center", 0, 2*sw, 2*sh )

	x, y = sm:getScreenPos( sm.meter_w * 1/16, sm.meter_h * 3/9 )
	love.graphics.printf( "Move you character using the arrow keys or wasd.", x, y, w, "center", 0, sw, sh )
	x, y = sm:getScreenPos( sm.meter_w * 1/16, sm.meter_h * 4/9 )
	love.graphics.printf( "Convert followers to your cause by rescuing them.\nThe more followers you have,\nthe harder it is to move through the masses", x, y, w, "center", 0, sw, sh )
	x, y = sm:getScreenPos( sm.meter_w * 1/16, sm.meter_h * 6/9 )
	love.graphics.printf( "Be careful with the Broman patrols,\nthey can pass through the followers and poles!", x, y, w, "center", 0, sw, sh )
	x, y = sm:getScreenPos( sm.meter_w * 1/16, sm.meter_h * 7.5/9 )
	love.graphics.printf( "Click to throw a fish and distract your followers", x, y, w, "center", 0, sw, sh )
	x, y = sm:getScreenPos( sm.meter_w * 1/16, sm.meter_h * 8/9 )
	love.graphics.printf( "Press any key to continue", x, y, w, "center", 0, sw, sh )

end

function Rules:input( act, val ) -- ::void!
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

function Rules:transition( State ) -- ::State!
	if State == nil then
		return self
	end
	local new_state = State.load( self.screenmanager, extra )
	self:free()
	return new_state
end

return Rules
