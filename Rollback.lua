local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local player = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")

-- Remove GUI antiga
if CoreGui:FindFirstChild("RollbackGUI") then
    CoreGui.RollbackGUI:Destroy()
end

local gui = Instance.new("ScreenGui")
gui.Name = "RollbackGUI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = CoreGui

local savedState = nil
local rollbackAtivo = false

local function esperarPersonagem()
    local char = player.Character or player.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart", 5)
    local hum = char:WaitForChild("Humanoid", 5)
    if hrp and hum then
        return char, hrp, hum
    else
        return nil
    end
end

local function salvarEstado()
    local char, hrp, hum = esperarPersonagem()
    if char and hrp and hum then
        savedState = {
            pos = hrp.Position,
            health = hum.Health
        }
        print("[Rollback] Estado salvo!")
    end
end

local function aplicarRollback()
    if not savedState then
        warn("[Rollback] Nenhum estado salvo para aplicar rollback!")
        return
    end

    local char, hrp, hum = esperarPersonagem()
    if char and hrp and hum then
        hrp.CFrame = CFrame.new(savedState.pos)
        hum.Health = savedState.health
        print("[Rollback] Rollback aplicado!")
    end
end

-- Cria botão genérico
local function criarBotao(texto, yPos)
    local botao = Instance.new("TextButton")
    botao.Size = UDim2.new(0, 200, 0, 40)
    botao.Position = UDim2.new(0, 20, 0, yPos)
    botao.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    botao.TextColor3 = Color3.fromRGB(255, 255, 255)
    botao.Font = Enum.Font.GothamBold
    botao.TextSize = 18
    botao.Text = texto
    botao.Parent = gui
    return botao
end

-- Botão ativar/desativar rollback
local botaoToggle = criarBotao("Rollback: DESLIGADO", 100)
botaoToggle.BackgroundColor3 = Color3.fromRGB(150, 0, 0)

botaoToggle.MouseButton1Click:Connect(function()
    rollbackAtivo = not rollbackAtivo
    if rollbackAtivo then
        salvarEstado()
        botaoToggle.Text = "Rollback: ATIVADO"
        botaoToggle.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
    else
        botaoToggle.Text = "Rollback: DESLIGADO"
        botaoToggle.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
    end
end)

-- Botão aplicar rollback
local botaoRollback = criarBotao("Aplicar Rollback", 150)
botaoRollback.MouseButton1Click:Connect(function()
    if rollbackAtivo then
        aplicarRollback()
    else
        warn("Rollback está desligado!")
    end
end)

-- Botão relogar
local botaoRelogar = criarBotao("Relogar", 200)
botaoRelogar.MouseButton1Click:Connect(function()
    TeleportService:Teleport(game.PlaceId, player)
end)

-- Atualizar estado salvo automaticamente quando personagem aparecer
player.CharacterAdded:Connect(function()
    wait(2)
    if rollbackAtivo then
        salvarEstado()
    end
end)
