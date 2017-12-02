image = love.graphics.newImage("archer.png")
pulo = love.audio.newSource("pulo.ogg")
archer = {}

alturaTela = love.graphics.getHeight()
larguraTela = love.graphics.getWidth()

function archer.load()
	archer.posx = 350
	archer.posy = alturaTela / 1.5
	archer.largura = 0.1
	archer.altura = 0.1
	archer.velocidade = 400
	archer.pulo = 0
	
	gravidade = 800
	alturaPulo = 100
end

function archer.update(dt)
	
	if archer.pulo ~= 0 then
		archer.posy = archer.posy - (archer.pulo * dt)
		archer.pulo = archer.posy - (gravidade * dt)

		if archer.posy > alturaTela/1.5 then
			archer.pulo = 0
			archer.posy = alturaTela/1.5
		end

	end

	if love.keyboard.isDown("left") then 
		archer.posx = archer.posx - (archer.velocidade*dt)
	end

	if love.keyboard.isDown("right") then 
		archer.posx = archer.posx + (archer.velocidade*dt)
	end
end

function archer.draw()
	love.graphics.draw(image, archer.posx, archer.posy, 0, archer.largura, archer.altura)
end

function love.keypressed(key)
	if key == "up" then
		if archer.pulo == 0 then
			archer.pulo = alturaPulo
		end
	end
end