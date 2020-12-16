largura_tela, altura_tela = love.graphics.getDimensions()

function love.load()
    require "requerimentos"
    require "jogo"
    require "campo"
    require "bola"
    require "jogador"

    jogo = Jogo()
end

function love.update(dt)
    jogo:update(dt)
end

function love.draw()
    jogo:draw()
end