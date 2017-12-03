local State = {}
State.__index = State
State.state_id = 'State'

function State.load( screenmanager ) -- ::State
	-- Variable initializations
	-- Class stuff
	local self = setmetatable( {}, State )
	self.screenmanager = screenmanager
	return self
end

function State:free()
end

function State:update( dt ) -- ::State_id!
end

function State:draw( ) -- ::void!
end

function State:input( act, val ) -- ::void!
end

function State:transition( State ) -- ::State!
	if State == nil then
		return self -- TODO change
	end
	new_state = State.new( self.screenmanager )
	self:free()
	return new_state
end

return State
