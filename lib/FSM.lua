FSM = Classe:extend()


function FSM:new(objeto, nomeEstado)
    self.objeto = objeto
    self.estado = nil
    self.estadoAnt = nil

    self:trocaEstado(nomeEstado)
end

function FSM:trocaEstado(nomeEstado)
    self.nomeEstado = nomeEstado
    self.estadoAnt = self.estado

    self.estado = self.objeto[self.nomeEstado]
end

function FSM:update(dt)
    --print(self.nomeEstado)

    self.estado(self.objeto, dt)
end

function FSM:retornaNome()
    return self.nomeEstado
end

return FSM