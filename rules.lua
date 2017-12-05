local Rules = {}
Rules.__index = Rules
Rules.state_id = 'rules'
Rules.splashscreen = love.graphics.newImage("assets/rules.png")
Rules.fingers = love.graphics.newImage("assets/fingers.png")

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

	love.graphics.setColor(255, 255, 255)
	x, y = sm:getScreenPos( 0, 0 )
	sw = sm:getScaleFactor( Rules.splashscreen:getWidth(), sm.meter_w )
	sh = sm:getScaleFactor( Rules.splashscreen:getHeight(), sm.meter_h )
	love.graphics.draw( Rules.splashscreen, x, y, 0, sw, sh )

	love.graphics.setColor(0, 0, 0)
	local font = love.graphics.getFont()
	sh = sm:getScaleFactor( font:getHeight(), 0.5 )
	sw = sh
	local w = sm:getLength( sm.meter_w * 6/16 ) / sw

	local tablet_of_rules = {
		"I - Thou canst move with the arrow keys",
		"II - Thou canst move with the wasd keys",
		"III - Thou shalt save your people",
		"IV - Thou canst click\nto throw fish",
		"V - Thine people shalt\nbe distracted by fish",
		"VI - Thou shalt avoid the Bromans",
		"VII - Beware the\nBromans' sneakyness",
		"VIII - Thou shalt eat vegetables",
		"IX - Thou shalt not\n be mean",
		"X - Thou canst press ESC to quit"
	}

	for i=1,5 do
		x, y = sm:getScreenPos( 2, 0.5+1.25*i )
		love.graphics.printf( tablet_of_rules[i], x, y, w, "left", 0, sw, sh )
	end
	for i=1,5 do
		local theta = -math.pi/9
		x, y = sm:getScreenPos( 8 + (i-1) * math.sin( -theta ), 1 + 1.25 * i * math.cos( -theta ) )
		love.graphics.printf( tablet_of_rules[5+i], x, y, w, "left", theta, sw, sh )
	end

	love.graphics.setColor(255, 255, 255)
	x, y = sm:getScreenPos( 0, 0 )
	sw = sm:getScaleFactor( Rules.fingers:getWidth(), sm.meter_w )
	sh = sm:getScaleFactor( Rules.fingers:getHeight(), sm.meter_h )
	love.graphics.draw( Rules.fingers, x, y, 0, sw, sh )
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
