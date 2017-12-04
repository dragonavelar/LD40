require( "collisions" )
local Ingame = {}
Ingame.__index = Ingame
Ingame.state_id = "Ingame"
Ingame.sprites = {}
Ingame.sprites.pxpm = 256
Ingame.sprites.floor = love.graphics.newImage("assets/floor.png")
Ingame.sprites.houses_back = {
	love.graphics.newImage("assets/house-04.png"),
	love.graphics.newImage("assets/house-05.png"),
	love.graphics.newImage("assets/house-06.png")
}
Ingame.sprites.houses_front = {
	love.graphics.newImage("assets/house-01.png"),
	love.graphics.newImage("assets/house-02.png"),
	love.graphics.newImage("assets/house-03.png")
}

function Ingame.load( screenmanager, extra ) -- ::Ingame
	-- Variable initializations
	-- Class stuff
	local self = setmetatable( {}, Ingame )

	self.Player = require( "player" )
	self.Follower = require( "follower" )
	self.Patrol = require( "patrol" )
	self.Location = require( "location" )
	self.Fish = require( "fish" )

	self.screenmanager = screenmanager
	self.followers = {}
	self.patrols = {}
	self.locations = {}
	self.fishes = {}
	self.Gameover = Gameover

	self.world = love.physics.newWorld()
	self.world:setCallbacks(
		collisions.beginContact,
		collisions.endContact,
		collisions.preSolve,
		collisions.postSolve )
	self.player = self.Player.new( self.world )
	table.insert( self.followers, self.Follower.new( self.world, 2, 2 ) )

	table.insert( self.locations, self.Location.new( self.world, self.patrols, self.Patrol, 9, 1 ) )
	table.insert( self.locations, self.Location.new( self.world, self.patrols, self.Patrol, 12, 5 ) )
	table.insert( self.locations, self.Location.new( self.world, self.patrols, self.Patrol, 1, 7 ) )
	return self
end

function Ingame:free()
	self.Player = nil
	self.Follower = nil
	self.Patrol = nil
	self.Location = nil
	self.Fish = nil
	self.world = nil
	self.screenmanager = nil
	self.player = nil
	self.followers = nil
	self.patrols = nil
	self.locations = nil
	self.fishes = nil
end

function Ingame.sort_by_y(obj1, obj2)
	local x1,y1 = obj1:get_center()
	local x2,y2 = obj2:get_center()
	return y1 < y2
end


function Ingame:update( dt ) -- ::Ingame_id!
	local k, v = nil, nil
	-- Updating
	self.world:update( dt )
	self.player:update( dt, self.fishes, self.Fish )
	local px, py = self.player:get_center()
	for k, v in pairs( self.fishes ) do
		if v.alive then
			v:update( dt )
		end
	end
	for k, v in pairs( self.followers ) do
		if v.alive then
			v:update( dt, px, py )
		end
	end
	for k, v in pairs( self.patrols ) do
		if v.alive then
			v:update( dt, px, py )
		end
	end
	for k, v in pairs( self.locations ) do
		if v.alive then
			v:update( dt, self.world, self.followers, self.Follower, self.patrols, self.Patrol )
		end
	end

	-- Cleaning up
	for k, v in pairs( self.fishes ) do
		if not v.alive then
			v:free()
			self.fishes[ k ] = nil
		end
	end
	for k, v in pairs( self.followers ) do
		if not v.alive then
			v:free()
			self.followers[ k ] = nil
		end
	end
	for k, v in pairs( self.locations ) do
		if not v.alive then
			v:free()
			self.followers[ k ] = nil
		end
	end
	for k, v in pairs( self.patrols ) do
		if not v.alive or v.parent == nil or not v.parent.alive then
			v:free()
			self.patrols[ k ] = nil
		end
	end
	if not self.player.alive then
		local extra = {}
		extra["score"] = 0
		for k, v in pairs( self.followers ) do
			if v.alive then
				extra["score"] = extra["score"] + 1
			end
		end
		print( "PERDEEEU" )
		print( "Pontuacao: " .. extra["score"] )
		return "gameover", extra
	end
end

function Ingame:draw() -- ::void!
	local sm = self.screenmanager
	local x, y, sw, sh

	love.graphics.setColor(255,255,255)
	x, y = sm:getScreenPos( 0, 0 )
	sw = sm:getScaleFactor( self.sprites.floor:getWidth(), self.sprites.floor:getWidth() / self.sprites.pxpm )
	sh = sm:getScaleFactor( self.sprites.floor:getHeight(), self.sprites.floor:getHeight() / self.sprites.pxpm )
	love.graphics.draw( self.sprites.floor, x, y, 0, sw, sh )

	for k, house in pairs( self.sprites.houses_back ) do
		love.graphics.setColor(255,255,255)
		x, y = sm:getScreenPos( 0, 0 )
		sw = sm:getScaleFactor( house:getWidth(), house:getWidth() / self.sprites.pxpm )
		sh = sm:getScaleFactor( house:getHeight(), house:getHeight() / self.sprites.pxpm )
		love.graphics.draw( house, x, y, 0, sw, sh )
	end

	local k, v = nil, nil
	for k, v in pairs( self.locations ) do
		v:draw( self.screenmanager )
	end

	local sorted = {}
	table.insert( sorted, self.player )
	for k, v in pairs( self.fishes ) do
		table.insert( sorted, v )
	end
	for k, v in pairs( self.followers ) do
		table.insert( sorted, v )
	end
	for k, v in pairs( self.patrols ) do
		table.insert( sorted, v )
	end
	
	table.sort( sorted, Ingame.sort_by_y )
	for k, v in pairs( sorted ) do
		v:draw( self.screenmanager )
	end

	for k, house in pairs( self.sprites.houses_front ) do
		love.graphics.setColor(255,255,255)
		x, y = sm:getScreenPos( 0, 0 )
		sw = sm:getScaleFactor( house:getWidth(), house:getWidth() / self.sprites.pxpm )
		sh = sm:getScaleFactor( house:getHeight(), house:getHeight() / self.sprites.pxpm )
		love.graphics.draw( house, x, y, 0, sw, sh )
	end

	self.screenmanager:update( 1 )
	self.screenmanager:draw()
end

function Ingame:input( act, val ) -- ::void!
	if act == "mousereleased" or act == "mousepressed" then
		val["x"], val["y"] = self.screenmanager:getWorldPos( val["x"], val["y"] )
	end
	self.player:input( act, val )
end

function Ingame:transition( State, extra ) -- ::Ingame!
	if State == nil then
		return self -- TODO change
	end
	local new_state = State.load( self.screenmanager, extra )
	self:free()
	return new_state
end

return Ingame