require( "collisions" )
local Player = require( "player" )
local Follower = require( "follower" )
local Location = require( "location" )
local world = nil
local player = nil
local followers = {}
local locations = {}

function love.load()
	world = love.physics.newWorld()
	world:setCallbacks(
		collisions.beginContact,
		collisions.endContact,
		collisions.preSolve,
		collisions.postSolve )
	player = Player.new( world )
	table.insert( followers, Follower.new( world, 100, 100 ) )

	table.insert( locations, Location.new( world, 150, 50 ) )
	table.insert( locations, Location.new( world, 300, 200 ) )
	table.insert( locations, Location.new( world, 400, 600 ) )
end

function love.update( dt )
	-- Updating
	world:update( dt )
	player:update( dt )
	local px, py = player:get_center()
	for k, v in pairs( followers ) do
		if v.alive then
			v:update( dt, px, py )
		end
	end
	for k, v in pairs( locations ) do
		if v.alive then
			v:update( dt )
		end
	end
	-- Cleaning up
	for k, v in pairs( followers ) do
		if not v.alive then
			v:free()
			followers[ k ] = nil
		end
	end
	for k, v in pairs( followers ) do
		if not v.alive then
			v:free()
			followers[ k ] = nil
		end
	end
end

function love.draw()
	player:draw()
	for k, v in pairs( followers ) do
		v:draw()
	end
	for k, v in pairs( locations ) do
		v:draw()
	end
end


function love.mousereleased( x, y, button, istouch )
	if button == 1 then
		table.insert( followers, Follower.new( world, x, y ) )
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
