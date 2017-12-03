local Rules = {}
Rules.__index = Rules
Rules.Rules_id = 'Rules'

function Rules.load( screenmanager ) -- ::Rules
	-- Variable initializations
	-- Class stuff
	local self = setmetatable( {}, Rules )
	self.screenmanager = screenmanager
	self.image = love.graphics.newImage( "assets/Rules.png" )
	return self
end

function Rules:free()
end

function Rules:update( dt ) -- ::Rules_id!

end

function Rules:draw( ) -- ::void!
	local x,y
	x, y = self.screenmanager_x,self.screenmanager_y	
	local sw = self.screenmanager:getScaleFactor(self.image:getWidth(), self.screenmanager.meter_w)
	local sh = self.screenmanager:getScaleFactor(self.image:getHeight(), self.screenmanager.meter_h)
	love.graphics.setColor(255,255,255)
	love.graphics.draw(self.image, x, y, 0, sw, sh)
end

function Rules:input( act, val ) -- ::void!
	
end

function Rules:transition( State ) -- ::Rules!
	if State == nil then
		return self -- TODO change
	end
	new_state = State.new( self.screenmanager )
	self:free()
	return new_state
end

return Rules
