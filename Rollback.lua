local DataStoreService = game:GetService("DataStoreService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- RemoteEvent para comunicação
local RollbackEvent = Instance.new("RemoteEvent")
RollbackEvent.Name = "RollbackEvent"
RollbackEvent.Parent = ReplicatedStorage

-- DataStores para dados normais e rollback
local PlayerDataStore = DataStoreService:GetDataStore("BlueLockPlayerData")
local RollbackDataStore = DataStoreService:GetDataStore("BlueLockRollbackData")
local RollbackStateStore = DataStoreService:GetDataStore("RollbackState")

local rollbackStates = {}

-- Função para carregar dados do jogador
local function LoadPlayerData(player)
    local success, data = pcall(function()
        return PlayerDataStore:GetAsync(player.UserId)
    end)
    if success and data then
        return data
    else
        return {}
    end
end

-- Função para salvar dados do jogador
local function SavePlayerData(player, data)
    pcall(function()
        PlayerDataStore:SetAsync(player.UserId, data)
    end)
end

-- Função para salvar backup rollback
local function SaveRollbackData(player, data)
    pcall(function()
        RollbackDataStore:SetAsync(player.UserId, data)
    end)
end

Players.PlayerAdded:Connect(function(player)
    -- Carregar rollback ligado ou não
    local success, rollbackState = pcall(function()
        return RollbackStateStore:GetAsync(player.UserId)
    end)
    rollbackStates[player.UserId] = (success and rollbackState == true)

    -- Enviar estado para cliente
    RollbackEvent:FireClient(player, "UpdateState", rollbackStates[player.UserId])

    -- Aqui você pode carregar os dados do jogador normalmente (de PlayerDataStore)
    -- e aplicar no personagem, stats etc (depende do jogo)
end)

-- Evento para trocar estado rollback pelo cliente
RollbackEvent.OnServerEvent:Connect(function(player, action, value)
    if action == "ToggleRollback" and type(value) == "boolean" then
        rollbackStates[player.UserId] = value
        RollbackStateStore:SetAsync(player.UserId, value)
        RollbackEvent:FireClient(player, "UpdateState", value)
    elseif action == "RequestSave" then
        if rollbackStates[player.UserId] then
            -- Pega os dados atuais do jogador (você deve adaptar isso para seu jogo)
            local currentData = LoadPlayerData(player) -- Ou você pega dados da memória
            SaveRollbackData(player, currentData)
            RollbackEvent:FireClient(player, "Notify", "Rollback salvo com sucesso!")
        else
            RollbackEvent:FireClient(player, "Notify", "Rollback não está ativado.")
        end
    elseif action == "RequestRestore" then
        local success, rollbackData = pcall(function()
            return RollbackDataStore:GetAsync(player.UserId)
        end)
        if success and rollbackData then
            -- Aqui você deve aplicar rollbackData no jogador (adaptar pro seu jogo)
            -- Exemplo genérico: salvar dados normais do jogador para rollbackData
            SavePlayerData(player, rollbackData)
            RollbackEvent:FireClient(player, "Notify", "Rollback restaurado! Por favor, relogue.")
        else
            RollbackEvent:FireClient(player, "Notify", "Nenhum rollback disponível.")
        end
    end
end)
