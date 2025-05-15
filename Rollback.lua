local DataStoreService = game:GetService("DataStoreService")
local RollbackStateStore = DataStoreService:GetDataStore("RollbackState")

local Players = game:GetService("Players")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SetRollbackState = Instance.new("RemoteEvent")
SetRollbackState.Name = "SetRollbackState"
SetRollbackState.Parent = ReplicatedStorage

-- Guardar rollback ativado para cada jogador em memória
local rollbackStates = {}

-- Quando o jogador conecta, tenta carregar o estado salvo
Players.PlayerAdded:Connect(function(player)
    local success, savedState = pcall(function()
        return RollbackStateStore:GetAsync(player.UserId)
    end)

    if success and savedState ~= nil then
        rollbackStates[player.UserId] = savedState
    else
        rollbackStates[player.UserId] = false
    end

    -- Enviar estado para o cliente (se quiser)
    SetRollbackState:FireClient(player, rollbackStates[player.UserId])
end)

-- Quando o jogador muda o estado rollback via botão
SetRollbackState.OnServerEvent:Connect(function(player, newState)
    rollbackStates[player.UserId] = newState

    -- Salvar no DataStore
    local success, err = pcall(function()
        RollbackStateStore:SetAsync(player.UserId, newState)
    end)
    if not success then
        warn("Falha ao salvar rollback para "..player.Name..": "..err)
    end
end)

-- Opcional: quando o jogador sai, limpa a memória (não obrigatório)
Players.PlayerRemoving:Connect(function(player)
    rollbackStates[player.UserId] = nil
end)
