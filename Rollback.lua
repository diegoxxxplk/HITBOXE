-- GUI com rollback e relogar
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Criar GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "RollbackGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Dados salvos do jogador
local savedState = nil

-- Função utilitária para criar botões
local function createButton(name, position, callback)
    local button = Instance.new("TextButton")
    button.Name = name
    button.Size = UDim2.new(0, 200, 0, 40)
    button.Position = position
    button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Font = Enum.Font.SourceSansBold
    button.TextSize = 18
    button.Text = name
    button.Parent = screenGui
    button.MouseButton1Click:Connect(callback)
end

-- Salvar estado atual
local function saveState()
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") then
        savedState = {
            position = char.HumanoidRootPart.Position,
            health = char.Humanoid.Health
