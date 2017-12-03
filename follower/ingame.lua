require( "collisions" )
local Ingame = {}
Ingame.__index = Ingame
Ingame.state_id = "Ingame"

function Ingame.load( screenmanager ) -- ::Ingame
	-- Variable initializations
	-- Class stuff
	local self = setmetatable( {}, Ingame )

	self.Player = require( "player" )
	self.Follower = require( "follower" )
	self.Patrol = require( "patrol" )
	self.Location = require( "location" )

	self.screenmanager = screenmanager
	self.followers = {}
	self.patrols = {}
	self.locations = {}

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
	self.world = nil
	self.screenmanager = nil
	self.player = nil
	self.followers = nil
	self.patrols = nil
	self.locations = nil
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
	self.player:update( dt )
	local px, py = self.player:get_center()
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
		print( "PERDEEEU" )
		local counter = 0
		for k, v in pairs( self.followers ) do
			if v.alive then
				counter = counter + 1
			end
		end
		print( "Pontuacao: " .. counter )
		love.event.quit()
	end
end

function Ingame:draw() -- ::void!
	local k, v = nil, nil
	for k, v in pairs( self.locations ) do
		v:draw( self.screenmanager )
	end

	local sorted = {}
	table.insert( sorted, self.player )
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

	self.screenmanager:update( 1 )
	self.screenmanager:draw()
end

function Ingame:input( act, val ) -- ::void!
	if act == "mousereleased" then
		if val["button"] == 1 then
			local sx, sy = self.screenmanager:getWorldPos( val["x"], val["y"] )
			table.insert( self.followers, self.Follower.new( self.world, sx, sy ) )
		end
	end
end

function Ingame:transition( State ) -- ::Ingame!
	if State == nil then
	end
	new_state = State.new( self.screenmanager )
	self:free()
	return new_state
end

return Ingame