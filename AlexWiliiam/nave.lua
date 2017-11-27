nave = {}

image = love.graphics.newImage("nave.png")

somTiro = love.audio.newSource("lazer.ogg")

tiro = 


local i = 0


function nave.load()
	nave.x = 350
	nave.y = 500
	nave.width = 0.1
	nave.height = 0.1
	nave.speed = 400
end

function nave.update(dt)
	if love.keyboard.isDown("left") then 
		nave.x = nave.x - (nave.speed*dt)
	elseif love.keyboard.isDown("right") then 
		nave.x = nave.x + (nave.speed*dt)
	elseif love.keyboard.isDown("up") then
		nave.y = nave.y - (nave.speed*dt)
	elseif love.keyboard.isDown("down") then
		nave.y = nave.y + (nave.speed*dt)
	end

	if love.keyboard.isDown("space") then
		love.audio.play(somTtiro)
		
		for i=0,i<= 1000 do
			tiro = llove.graphics.rectangle("fill", nave, tiro.y, 10, 50)
			tiro.x = tiro.x + (i*10)
		end
	end
end

function nave.draw()
	love.graphics.draw(image, nave.x, nave.y, 0, nave.width, nave.height)
end