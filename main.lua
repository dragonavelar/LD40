local Player = require( "player" )
local world = nil
local player = nil

function love.load()
	world = love.physics.newWorld()
	player = Player.new( world )
end

function love.update( dt )
  world:update( dt )
  player:update( dt )
end

function love.draw()
  player:draw()
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
