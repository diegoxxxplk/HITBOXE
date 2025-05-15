local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local RollbackEvent = ReplicatedStorage:WaitForChild("RollbackEvent")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "RollbackGui"
screenGui.Parent = playerGui

local rollbackButton = Instance.new("TextButton")
rollbackButton.Size = UDim2.new(0,150,0,50)
rollbackButton.Position = UDim2.new(0,10,0,10)
rollbackButton.Text = "Rollback: OFF"
rollbackButton.Parent = screenGui

local rejoinButton = Instance.new("TextButton")
rejoinButton.Size = UDim2.new(0,150,0,50)
rejoinButton.Position = UDim2.new(0,10,0,70)
rejoinButton.Text = "Relogar"
rejoinButton.Parent = screenGui

local rollbackEnabled = false

RollbackEvent.OnClientEvent:Connect(function(state)
    rollbackEnabled = state
    rollbackButton.Text = "Rollback: "..(rollbackEnabled and "ON" or "OFF")
end)

rollbackButton.MouseButton1Click:Connect(function()
    rollbackEnabled = not rollbackEnabled
    RollbackEvent:FireServer(rollbackEnabled)
    rollbackButton.Text = "Rollback: "..(rollbackEnabled and "ON" or "OFF")
end)

rejoinButton.MouseButton1Click:Connect(function()
    TeleportService:Teleport(game.PlaceId, player)
end)
