-- Interface
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local player = Players.LocalPlayer

-- GUI
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "RollbackGUI"

-- Salvar dados temporários
local savedState = nil

-- Função para criar botões
local function createButton(name, position, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 200, 0, 50)
    button.Position = position
    button.Text = name
    button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Parent = screenGui
    button.MouseButton1Click:Connect(callback)
end

-- Função para salvar o estado atual
local function saveCurrentState()
    local char = player.Character
    if char then
        savedState = {
            position = char:FindFirstChild("HumanoidRootPart").Position,
            health = char:FindFirstChild("Humanoid").Health,
        }
        print("Estado salvo.")
    end
end

-- Rollback para o estado salvo
local function activateRollback()
    local char = player.Character
    if char and savedState then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local humanoid = char:FindFirstChild("Humanoid")
        if hrp and humanoid then
            hrp.CFrame = CFrame.new(savedState.position)
            humanoid.Health = savedState.health
            print("Rollback ativado.")
        end
    else
        warn("Nenhum estado salvo.")
    end
end

-- Restaurar para o estado atual (desativar rollback)
local function deactivateRollback()
    saveCurrentState()
    print("Rollback desativado e novo estado salvo.")
end

-- Relogar (reconectar ao jogo)
local function relogar()
    TeleportService:Teleport(game.PlaceId, player)
end

-- Criar botões
createButton("Ativar Rollback", UDim2.new(0, 20, 0, 20), activateRollback)
createButton("Desativar Rollback", UDim2.new(0, 20, 0, 80), deactivateRollback)
createButton("Relogar", UDim2.new(0, 20, 0, 140), relog
