require( "collisions" )
local Player = require( "player" )
local Follower = require( "follower" )
local Patrol = require( "patrol" )
local Location = require( "location" )
local Screenmanager = require( "screenmanager" )
local world = nil
local screenmanager = nil
local player = nil
local followers = {}
local patrols = {}
local locations = {}


function love.load()
	screenmanager = Screenmanager.new()
	world = love.physics.newWorld()
	world:setCallbacks(
		collisions.beginContact,
		collisions.endContact,
		collisions.preSolve,
		collisions.postSolve )
	player = Player.new( world )
	table.insert( followers, Follower.new( world, 2, 2 ) )

	table.insert( locations, Location.new( world, patrols, Patrol, 9, 1 ) )
	table.insert( locations, Location.new( world, patrols, Patrol, 12, 5 ) )
	table.insert( locations, Location.new( world, patrols, Patrol, 1, 7 ) )
end

function love.update( dt )
	if not player.alive then
		print( "PERDEEEU" )
		love.event.quit()
	end
	-- Updating
	world:update( dt )
	player:update( dt )
	local px, py = player:get_center()
	for k, v in pairs( followers ) do
		if v.alive then
			v:update( dt, px, py )
		end
	end
	for k, v in pairs( patrols ) do
		if v.alive then
			v:update( dt, px, py )
		end
	end
	for k, v in pairs( locations ) do
		if v.alive then
			v:update( dt, world, followers, Follower, patrols, Patrol )
		end
	end
	-- Cleaning up
	for k, v in pairs( followers ) do
		if not v.alive then
			v:free()
			followers[ k ] = nil
		end
	end
	for k, v in pairs( locations ) do
		if not v.alive then
			v:free()
			followers[ k ] = nil
		end
	end
	for k, v in pairs( patrols ) do
		if not v.alive or v.parent == nil or not v.parent.alive then
			v:free()
			followers[ k ] = nil
		end
	end
end

function sort_by_y(obj1, obj2)
	local x1,y1 = obj1:get_center()
	local x2,y2 = obj2:get_center()
	return y1 < y2
end

function love.draw()
	for k, v in pairs( locations ) do
		v:draw(screenmanager)
	end

	local sorted = {}, {}
	table.insert( sorted, player )
	for k, v in pairs( followers ) do
		table.insert( sorted, v )
	end
	for k, v in pairs( patrols ) do
		table.insert( sorted, v )
	end
	
	table.sort( sorted, sort_by_y )
	for k, v in pairs( sorted ) do
		v:draw(screenmanager)
	end

	screenmanager:update( 1 )
	screenmanager:draw()
end


function love.mousereleased( x, y, button, istouch )
	if button == 1 then
		sx, sy = screenmanager.getWorldPos( x, y )
		table.insert( followers, Follower.new( world, sx, sy ) )
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
