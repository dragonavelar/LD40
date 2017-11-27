player={}

function player.load()
	player.width = 50
	player.height = 100
	player.x=100
	player.y=300
	player.speed = 300
end

function player.update(dt)
	if love.keyboard.isDown("left") then 
		player.x = player.x - (player.speed*dt)
	elseif love.keyboard.isDown("right") then 
		player.x = player.x + (player.speed*dt)
	end
end

function player.draw()
	love.graphics.rectangle("fill", player.x, player.y, player.width, player.height)
end
