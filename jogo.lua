Jogo = Classe:extend()

function Jogo:new()
    campo = Campo(110, 75, 5)
    bola = Bola(5)
    alvo = Vetor()
    alvo:set(love.mouse.getX(), love.mouse.getY())

    timeA, timeB = {}, {}
    posicaoA = {}

    r = love.math.random(0, 100)
    g = love.math.random(0, 100)
    b = love.math.random(0, 100)

    r = r/100
    g = g/100
    b = b/100

    for i=1, 11 do
        local x = love.math.random(campo.x, campo.x + campo.largura/2)
        local y = love.math.random(campo.y, campo.y + campo.altura)
        local jogador = Jogador("buscaBola", {r, g, b}, i, Vetor(x, y)) --estado, cor, numero, posicaoInicial
        table.insert(timeA, jogador)
    end

    for i=1, 11 do
        local x = love.math.random(campo.x + campo.largura/2, campo.x + campo.largura)
        local y = love.math.random(campo.y, campo.y + campo.altura)
        local jogador = Jogador("buscaBola", {1-r, 1-g, 1-b}, i, Vetor(x, y))
        table.insert(timeB, jogador)
    end
end

function Jogo:update(dt)
    campo:update(dt)
    bola:update(dt)

    for _, jogador in pairs(timeA) do 
        jogador:update(dt, bola.posicao)
    end

    for _, jogador in pairs(timeB) do 
        jogador:update(dt, bola.posicao)
    end

    for _, jogadorA in pairs(timeA) do
        for _, jogadorA2 in pairs(timeA) do
            if jogadorA ~= jogadorA2 and jogadorA:verificaColisao(jogadorA2) then
                jogadorA.velocidade = jogadorA.velocidade + jogadorA.posicao - jogadorA2.posicao
                jogadorA2.velocidade = jogadorA2.velocidade + jogadorA2.posicao - jogadorA.posicao
            end
        end

        for _, jogadorB in pairs(timeB) do
            if jogadorA:verificaColisao(jogadorB) then
                jogadorA.velocidade = jogadorA.velocidade + jogadorA.posicao - jogadorB.posicao
                jogadorB.velocidade = jogadorB.velocidade + jogadorB.posicao - jogadorA.posicao
            end
        end
    end

    for _, jogadorB in pairs(timeB) do
        for _, jogadorB2 in pairs(timeB) do
            if jogadorB ~= jogadorB2 and jogadorB:verificaColisao(jogadorB2) then
                jogadorB.velocidade = jogadorB.velocidade + jogadorB.posicao - jogadorB2.posicao
                jogadorB2.velocidade = jogadorB2.velocidade + jogadorB2.posicao - jogadorB.posicao
            end
        end
    end

    --alvo:set(love.mouse.getX(), love.mouse.getY())

    if love.mouse.isDown(1) then
        local posicao = Vetor(love.mouse.getX()-bola.posicao.x, love.mouse.getY()-bola.posicao.y)
        bola:move(posicao)
    end

    -- if love.keyboard.isDown("space") then
    --     bola:move(Vetor(100, 0))
    -- end
end

function Jogo:draw()
    campo:draw()
    
    for _, jogador in pairs(timeA) do 
       jogador:draw()
    end

    for _, jogador in pairs(timeB) do 
        jogador:draw()
    end

    bola:draw()
end

function Jogo:checaColisaoCirculo(A, B) --A.posicao e B.posicao
    if Vetor.dist(A.posicao, B.posicao) < A.raio + B.raio then
        return true
    end
end