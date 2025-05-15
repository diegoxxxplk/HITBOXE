-- LocalScript: RollbackClient.lua (coloque em StarterPlayerScripts ou carregue via loadstring)
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local SetRollbackState = ReplicatedStorage:WaitForChild("SetRollbackState")

-- Criar GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "RollbackGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Botão Relogar
local rejoinButton = Instance.new("TextButton")
rejoinButton.Name = "RejoinButton"
rejoinButton.Size = UDim2.new(0, 150, 0, 50)
rejoinButton.Position = UDim2.new(0, 10, 0, 10)
rejoinButton.Text = "Relogar"
rejoinButton.Parent = screenGui

-- Botão Rollback
local rollbackButton = Instance.new("TextButton")
rollbackButton.Name = "RollbackToggle"
rollbackButton.Size = UDim2.new(0, 150, 0, 50)
rollbackButton.Position = UDim2.new(0, 10, 0, 70)
rollbackButton.Text = "Rollback: OFF"
rollbackButton.Parent = screenGui

local rollbackEnabled = false

-- Atualiza o botão de rollback ao receber estado do servidor
SetRollbackState.OnClientEvent:Connect(function(state)
    rollbackEnabled = state
    rollbackButton.Text = "Rollback: " .. (rollbackEnabled and "ON" or "OFF")
end)

-- Botão relogar teleporta o jogador para o jogo atual
rejoinButton.MouseButton1Click:Connect(function()
    TeleportService:Teleport(game.PlaceId, player)
end)

-- Botão rollback alterna estado e avisa servidor
rollbackButton.MouseButton1Click:Connect(function()
    rollbackEnabled = not rollbackEnabled
    rollbackButton.Text = "Rollback: " .. (rollbackEnabled and "ON" or "OFF")
    SetRollbackState:FireServer(rollbackEnabled)
end)
