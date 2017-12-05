local Screenmanager = require( "screenmanager" )
local Menu = require( "menu" )
local Rules = require( "rules" )
local Ingame = require( "ingame" )
local Gameover = require( "gameover" )
local screenmanager = nil
local current_state = nil
local font = nil

function love.load()
	screenmanager = Screenmanager.new()
	current_state = Menu.load( screenmanager )
	font = love.graphics.newFont( "assets/rosicrucian.ttf", 64 )
	love.graphics.setFont( font )
end

function love.update( dt )
	if current_state then
		local new_state, extra_arguments = nil, nil
		new_state, extra_arguments = current_state:update( dt )
		if new_state ~= nil then
			if new_state == "ingame" then
				new_state = current_state:transition( Ingame, extra_arguments )
			elseif new_state == "menu" then
				new_state = current_state:transition( Menu, extra_arguments )
			elseif new_state == "rules" then
				new_state = current_state:transition( Rules, extra_arguments )
			elseif new_state == "gameover" then
				new_state = current_state:transition( Gameover, extra_arguments )
			elseif new_state == "exit" then
				print( "Bye bye!" )
				love.event.quit()
				return nil
			else
				print( "Something is fishy" )
				new_state = current_state:transition()
			end
			current_state = nil
			current_state = new_state
		end
	end
end

function love.draw()
	if current_state then
		current_state:draw()
		screenmanager:update( 1 )
		screenmanager:draw()
	end
end


function love.mousereleased( x, y, button, istouch )
	local vals = {}
	vals["button"] = button
	vals["x"] = x
	vals["y"] = y
	vals["istouch"] = istouch
	if current_state then
		current_state:input( "mousereleased", vals )
	end
end

function love.mousepressed( x, y, button, istouch )
	local vals = {}
	vals["button"] = button
	vals["x"] = x
	vals["y"] = y
	vals["istouch"] = istouch
	if current_state then
		current_state:input( "mousepressed", vals )
	end
end

function love.keypressed( key, scancode )
	local vals = {}
	vals["key"] = key
	vals["scancode"] = scancode
	if current_state then
		current_state:input( "keypressed", vals )
	end
end

function love.keyreleased( key, scancode )
	local vals = {}
	vals["key"] = key
	vals["scancode"] = scancode
	if current_state then
		current_state:input( "keyreleased", vals )
	end
end










-- Altered main function that caps fps at 60 and lets update to run indefinetely

function love.run()
	if love.math then
		love.math.setRandomSeed( os.time() )
	end
	math.randomseed( os.time() )
	math.random(); math.random(); math.random();

	if love.load then love.load( arg ) end

	love.timer.step()
	local dt = 0
	local u_dt = 0
	local acc = 0
	local tbu = 0
	local tau = 0
	local rest_time = 0.001

	-- Main loop
	while true do
		-- Process events.
		if love.event then
			love.event.pump()
			for name, a, b, c, d, e, f in love.event.poll() do
				if name == "quit" then
					if not love.quit or not love.quit() then
						if love.audio then
							love.audio.stop()
						end
						return a
					end
				end
				love.handlers[ name ]( a, b, c, d, e, f )
			end
		end

		love.timer.step()
		dt = love.timer.getDelta()
		if dt > 1/30 then u_dt = 1/30 else u_dt = dt end

		tbu = love.timer.getTime()
		love.update( u_dt )
		tau = love.timer.getTime()

		-- Update screen, frames capped at 60 fps for drawing
		if love.graphics and love.graphics.isActive() then
			acc = acc + dt
			if acc > 1/60 then
				love.graphics.clear( love.graphics.getBackgroundColor() )
	love.graphics.origin()
				love.draw()
				love.graphics.present()
				while acc > 1/60 do acc = acc - 1/60 end
			end
		end

		-- Rest for a while if we haven't done a lot of processing already
		if tau - tbu < rest_time then
			love.timer.sleep( rest_time - tau + tbu )
		end
	end
end
