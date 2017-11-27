require("nave")

function love.load()
	nave.load()
	love.window.setMode(800,600)
end

function love.update(dt)
	nave.update(dt)
end

function love.draw()
	nave.draw()
end