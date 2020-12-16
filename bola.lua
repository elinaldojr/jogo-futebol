Bola = Classe:extend()

function Bola:new(escala)
    self.posicao = Vetor(50, 200)
    self.direcao = Vetor(0, 0)
    self.aceleracao = Vetor()
    self.velocidade = Vetor()
    self.velMax = 60

    self.raio = .5
    self.escala = escala
    self.emMovimento = false
end

function Bola:update(dt)
    self.aceleracao = self.aceleracao + self.direcao
    self.velocidade = self.velocidade + self.aceleracao
    self.velocidade:limit(self.velMax)

    self.velocidade = self.velocidade*.997

    if self.velocidade:getmag() < 2 and self.emMovimento then
        self.emMovimento = false
        self.velocidade:set(0, 0)
    end

    self.posicao = self.posicao + self.velocidade*dt

    
    self.direcao:set(0, 0)
    self.aceleracao = self.aceleracao*.93--degradação da aceleração

    if self.aceleracao:getmag()<5 then
        self.aceleracao:set(0, 0)
    end
end

function Bola:draw()
    love.graphics.circle("fill", self.posicao.x, self.posicao.y, self.raio*self.escala)

    --debug
    -- love.graphics.print("direcao: "..self.direcao.x..","..self.direcao.y, 50, 50)
    -- love.graphics.print("aceleracao: "..self.aceleracao.x..","..self.aceleracao.y, 50, 70)
    -- love.graphics.print("velocidade: "..self.velocidade.x..","..self.velocidade.y, 50, 90)
end

function Bola:move(direcao) --força de direcao
    self.emMovimento = true
    self.direcao = direcao
    self.direcao:limit(200)
end
