Campo = Classe:extend()

function Campo:new(largura, altura, escala)
    self.largura = largura or 110
    self.altura = altura or 75
    self.x, self.y = 50, 50

    self.largura = self.largura*5
    self.altura = self.altura*5
end

function Campo:update(dt)
    
end

function Campo:draw()
    love.graphics.setColor(0, .6, .1)
    love.graphics.rectangle("fill", self.x, self.y, self.largura, self.altura)
    love.graphics.setColor(1, 1, 1)
end

function Campo:mantemNoCampo(e)

end