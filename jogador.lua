Jogador = Classe:extend()

function Jogador:new(comportamento, cor, numero, posicaoInicial)
    self.comportamento = FSM(self, comportamento or "parado")
    
    self.posicao = posicaoInicial --posicao atual
    self.posicaoInicial = posicaoInicial

    self.velocidade = Vetor()
    self.velDesejada = Vetor()
    self.direcao = Vetor()
    self.aceleracao = Vetor()
    self.alvo = alvo
    
    self.velMax = love.math.random(20, 30.6) --30.6
    self.forcaMax = 10
    self.raio = 7
    self.massa = 5
    self.cor = cor
    self.numero = numero

end

function Jogador:update(dt, alvo)
    --self.parado()
    --self:busca(alvo)
    self.comportamento:update(dt)
    self:move(dt)
end

function Jogador:draw()
    love.graphics.setColor(self.cor)
    love.graphics.circle("fill", self.posicao.x, self.posicao.y, self.raio)
    love.graphics.setColor(1, 1, 1)
    love.graphics.print(self.comportamento:retornaNome(), self.posicao.x-self.raio*1.5, self.posicao.y-self.raio*2, 0, 0.6, 0.6)
    love.graphics.print(self.numero, self.posicao.x-self.raio, self.posicao.y-self.raio, 0, 0.9, 0.9)
    --love.graphics.line(self.posicao.x, self.posicao.y, self.posicao.x+self.velocidade.x*.5, self.posicao.y+self.velocidade.y*.5)
end

function Jogador:move(dt)
    self.aceleracao = self.direcao / self.massa
    self.velocidade = self.velocidade + self.aceleracao
    self.velocidade:limit(self.velMax)

    self.velocidade = self.velocidade*.985

    if self.velocidade:getmag() < 2 and self.emMovimento then
        self.emMovimento = false
        self.velocidade:set(0, 0)
    end

    self.posicao = self.posicao + self.velocidade*dt

    --manter o jogador na tela
    if self.posicao.x < 0 then
		self.posicao.x = self.posicao.x + largura_tela
	elseif self.posicao.x >= largura_tela then
		self.posicao.x = self.posicao.x - largura_tela
	elseif self.posicao.y < 0 then
		self.posicao.y = self.posicao.y + altura_tela
	elseif self.posicao.y >= altura_tela then
		self.posicao.y = self.posicao.y - altura_tela
	end
end

--------------------
--parado(idle)
function Jogador:parado()
    self.direcao:set(0, 0)
    self.aceleracao:set(0, 0)

    self.alvo =  bola.posicao

    if self.alvo:dist(self.posicao) < 100 then
        self.comportamento:trocaEstado("buscaBola")
    end

    if self.posicao:dist(self.posicaoInicial) > 15 then
        self.comportamento:trocaEstado("voltaPosicaoInicial")
    end
end

--o jogador corre atrás da bola se ela estiver a menos de 50 pixels
function Jogador:buscaBola(alvo)
    self.alvo =  bola.posicao

    if self.alvo then 
        if self.alvo:dist(self.posicao) < 100 then
            self.velDesejada = self.alvo - self.posicao
            self.velDesejada:setmag(self.velMax)
            self.direcao = self.velDesejada - self.velocidade
            self.direcao:setmag(self.forcaMax)
        else
            self.comportamento:trocaEstado("voltaPosicaoInicial")
        end
	end
end

--o jogador volta para a posicao inicial em que iniciou a partida
function Jogador:voltaPosicaoInicial()
    local raioAlvo = 10
    self.alvo = self.posicaoInicial

    if self.alvo then
        if self.alvo:dist(self.posicao) > raioAlvo then
            self.velDesejada = self.alvo - self.posicao
            
            local distanciaAlvo = self.posicao:dist(self.alvo) -- distância do jogador para o alvo
            if distanciaAlvo > raioAlvo then
                self.velDesejada:setmag(self.velMax)
            else
                self.velDesejada:setmag(distanciaAlvo/100)
            end
            
            self.direcao = self.velDesejada - self.velocidade
            self.direcao:setmag(self.forcaMax)
        else
            self.comportamento:trocaEstado("parado")
        end
    end
end

--busca(seek)
function Jogador:busca(alvo)
    self.alvo =  bola.posicao

	if self.alvo then
        self.velDesejada = self.alvo - self.posicao
        self.velDesejada:setmag(self.velMax)
        self.direcao = self.velDesejada - self.velocidade
        self.direcao:setmag(self.forcaMax)
	else
		self.comportamento:trocaEstado("parado")
	end
end

--fuga(fleeing)
function Jogador:fuga()
    if self.alvo then
        self.velDesejada = self.posicao - self.alvo
        self.velDesejada:setmag(self.velMax)
        self.direcao = self.velDesejada - self.velocidade
        self.direcao:setmag(self.forcaMax)
	else
		self.comportamento:trocaEstado("parado")
	end
end

--chegada(arriving)
function Jogador:chegada()
    local raioAlvo = 100

    if self.alvo then
        self.velDesejada = self.alvo - self.posicao
        
        local distanciaAlvo = self.posicao:dist(self.alvo) -- distância do jogador para o alvo
        if distanciaAlvo > raioAlvo then
            self.velDesejada:setmag(self.velMax)
        else
            self.velDesejada:setmag(distanciaAlvo/100)
        end
        
        self.direcao = self.velDesejada - self.velocidade
        self.direcao:setmag(self.forcaMax)
	else
		self.comportamento:trocaEstado("parado")
    end
end

--errante(wandering)
function Jogador:errante()
    local angulo = love.math.random(0, 2*math.pi)
    local raio = 30
    local posicaoProjetada = self.posicao + self.direcao*15

    local xAlvo = posicaoProjetada.x + math.cos(angulo)*raio
    local yAlvo = posicaoProjetada.y + math.sin(angulo)*raio

    self.alvo:set(xAlvo, yAlvo)

    self.velDesejada = self.alvo + posicaoProjetada
    self.velDesejada:setmag(self.velMax)
    self.direcao = self.velDesejada - self.velocidade
    self.direcao:setmag(self.forcaMax)
end

--persegue(pursuit)
function Jogador:persegue()
    self.alvo = jogador.posicao + jogador.velocidade

    local dist = self.posicao:dist(self.alvo)

    if dist > 100 then
        self.velDesejada = self.alvo - self.posicao
        self.velDesejada:setmag(self.velMax)
        self.direcao = self.velDesejada - self.velocidade
        self.direcao:setmag(self.forcaMax)
    else
        self.comportamento:trocaEstado("busca")
    end
end

function Jogador:separacao()
    local somaPosicoes = Vetor()
    local cont = 0 --conta jogadors proximos

    for i=1, #jogadors do
        local distancia = self.posicao:dist(jogadors[i].posicao)
        if distancia >0 and distancia < 100 and self.jogador ~= jogadors[i] then
            somaPosicoes =  somaPosicoes + (self.posicao - jogadors[i].posicao)*(100-distancia)
            cont = cont+1
        end
    end

    if cont > 0 then
        somaPosicoes = somaPosicoes/cont
    else
        somaPosicoes = Vetor(0, 0)
    end

    return somaPosicoes
    --[[
    self.velDesejada = self.posicao - somaPosicoes/cont
    self.velDesejada:setmag(self.velMax)
    self.direcao = self.direcao + self.velDesejada - self.velocidade
    --self.direcao = somaPosicoes/cont
    self.direcao:setmag(self.forcaMax)
    ]]
end

function Jogador:alinhamento()
    local somaVelocidades = Vetor()
    local cont = 0

    for i=1, #jogadors do
        if self.posicao:dist(jogadors[i].posicao) < 100 and self.jogador ~= jogadors[i] then
            somaVelocidades =  somaVelocidades + jogadors[i].velocidade
            cont = cont+1
        end
    end

    return somaVelocidades/cont

    -- self.velDesejada = somaVelocidades/cont - self.posicao
    -- self.velDesejada:setmag(self.velMax)
    -- self.direcao = self.direcao + self.velDesejada - self.velocidade
    -- self.direcao:setmag(self.forcaMax)
end

function Jogador:coesao()
    local somaPosicoes = Vetor()
    local cont = 0 --conta jogadors proximos

    for i=1, #jogadors do
        if self.posicao:dist(jogadors[i].posicao) < 150 and self.jogador ~= jogadors[i] then
            somaPosicoes =  somaPosicoes + jogadors[i].posicao
            cont = cont+1
        end
    end

    return somaPosicoes/cont - self.posicao
    -- self.velDesejada = somaPosicoes/cont - self.posicao
    -- self.velDesejada:setmag(self.velMax)
    -- self.direcao = self.direcao + self.velDesejada - self.velocidade
    -- self.direcao:setmag(self.forcaMax)
end

function Jogador:agrupa()
    local separacao = self:separacao()
    local coesao = self:coesao()
    local alinhamento = self:alinhamento()

    self.direcao = self.direcao + separacao + coesao + alinhamento
    self.direcao:setmag(self.forcaMax)
end

function Jogador:verificaColisao(Objeto)
    if self.posicao:dist(Objeto.posicao) < self.raio + Objeto.raio then
        return true
    end
end