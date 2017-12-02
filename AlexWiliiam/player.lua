archer = {}

image = love.graphics.newImage("archer.png")

pulo = love.audio.newSource("pulo.ogg")


function archer.load()
	archer.x = 350
	archer.y = 500
	archer.width = 0.1
	archer.height = 0.1
	archer.speed = 300
end

function archer.update(dt)
	function love.keyPressed(key)
		if key == " " then
			love.audio.play(pulo)
		end
	end
end

function archer.draw()
	love.graphics.draw(image, archer.x, archer.y, 0, archer.width, archer.height)
end