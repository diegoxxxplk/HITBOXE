-- ServerScript: RollbackServer.lua (coloque no ServerScriptService)
local DataStoreService = game:GetService("DataStoreService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Cria RemoteEvent para comunicação
local SetRollbackState = Instance.new("RemoteEvent")
SetRollbackState.Name = "SetRollbackState"
SetRollbackState.Parent = ReplicatedStorage

local RollbackStateStore = DataStoreService:GetDataStore("RollbackState")

local rollbackStates = {}

-- Carrega estado rollback do DataStore ao entrar
Players.PlayerAdded:Connect(function(player)
    local success, savedState = pcall(function()
        return RollbackStateStore:GetAsync(player.UserId)
    end)

    if success and type(savedState) == "boolean" then
        rollbackStates[player.UserId] = savedState
    else
        rollbackStates[player.UserId] = false
    end

    -- Envia estado para o cliente atualizar UI
    SetRollbackState:FireClient(player, rollbackStates[player.UserId])
end)

-- Recebe pedido do cliente para mudar estado rollback
SetRollbackState.OnServerEvent:Connect(function(player, newState)
    if type(newState) == "boolean" then
        rollbackStates[player.UserId] = newState

        -- Salva no DataStore
        local success, err = pcall(function()
            RollbackStateStore:SetAsync(player.UserId, newState)
        end)
        if not success then
            warn("Erro ao salvar rollback para "..player.Name..": "..err)
        end
    end
end)

Players.PlayerRemoving:Connect(function(player)
    rollbackStates[player.UserId] = nil
end)
