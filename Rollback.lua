local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local player = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")

-- Criar GUI dentro do CoreGui
local gui = Instance.new("ScreenGui")
gui.Name = "RollbackGUI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = CoreGui

-- Estado salvo
local savedState = nil

-- Criar botão
local function criarBotao(nome, posY, callback)
    local botao = Instance.new("TextButton")
    botao.Size = UDim2.new(0, 200, 0, 40)
    botao.Position = UDim2.new(0, 20, 0, posY)
    botao.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    botao.TextColor3 = Color3.fromRGB(255, 255, 255)
    botao.Font = Enum.Font.GothamBold
    botao.TextSize = 16
    botao.Text = nome
    botao.Parent = gui
    botao.MouseButton1Click:Connect(callback)
end

-- Salvar estado atual
local function salvarEstado()
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") then
        savedState = {
            pos = char.HumanoidRootPart.Position,
            vida = char.Humanoid.Health
        }
        print("[✔] Estado salvo.")
    end
end

-- Ativar rollback
local function ativarRollback()
    if not savedState then
        warn("[✖] Nenhum estado salvo.")
        return
    end

    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") then
        char.HumanoidRootPart.CFrame = CFrame.new(savedState.pos)
        char.Humanoid.Health = savedState.vida
        print("[✔] Rollback ativado.")
    end
end

-- Desativar rollback
local function desativarRollback()
    salvarEstado()
    print("[✔] Novo estado salvo.")
end

-- Relogar
local function relogar()
    TeleportService:Teleport(game.PlaceId, player)
end

-- Criar botões
criarBotao("Ativar Rollback", 100, ativarRollback)
criarBotao("Desativar Rollback", 150, desativarRollback)
criarBotao("Relogar", 200, relogar)

-- Salvar estado inicial
player.CharacterAdded:Connect(function()
    wait(1)
    salvarEstado()
end)
