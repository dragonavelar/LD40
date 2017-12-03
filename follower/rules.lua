local rules = {}
rules.__index = rules
rules.rules_id = 'rules'

function rules.load( screenmanager ) -- ::rules
	-- Variable initializations
	-- Class stuff
	local self = setmetatable( {}, rules )
	self.screenmanager = screenmanager
	self.image = love.graphics.newImage( "assets/rules.png" )
	return self
end

function rules:free()
end

function rules:update( dt ) -- ::rules_id!

end

function rules:draw( ) -- ::void!
	local x,y
	x, y = self.screenmanager_x,self.screenmanager_y	
	local sw = self.screenmanager:getScaleFactor(self.image:getWidth(), self.screenmanager.meter_w)
	local sh = self.screenmanager:getScaleFactor(self.image:getHeight(), self.screenmanager.meter_h)
	love.graphics.setColor(255,255,255)
	love.graphics.draw(self.image, x, y, 0, sw, sh)
end

function rules:input( act, val ) -- ::void!
	
end

function rules:transition( rules ) -- ::rules!
end

return rules
