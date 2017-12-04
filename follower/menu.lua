local menu = {}
menu.__index = menu
menu.menu_id = 'menu'
function menu.load( screenmanager ) -- ::menu
	-- Variable initializations
	-- Class stuff
	local self = setmetatable( {}, menu )
	self.screenmanager = screenmanager
	return self
end

function menu:free()
end

function menu:update( dt ) -- ::menu_id!

end

function menu:draw( ) -- ::void!
	  love.graphics.setColor(250, 235, 215, 255)
	love.graphics.print("Press space for start the game!", 50, 100)
	love.graphics.print("Press ESC for quit the game.", 50, 200)	
	love.graphics.print("Press \"R\" for read the rules.", 50, 300)	

end

function menu:input( act, val ) -- ::void!
	
end

function menu:transition( menu ) -- ::menu!
end

return menu
