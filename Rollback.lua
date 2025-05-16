local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")

-- Remover GUI anterior, se existir
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

-- Função para aguardar personagem real
local function esperarPersonagemReal()
    local tentativas = 0
    repeat
        local char = player.Character or player.CharacterAdded:Wait()
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChild("Humanoid")
        local isReal = hrp and hum and hum.Health > 0
        if isReal then return char end
        tentativas += 1
        wait(1)
    until tentativas >= 10
    return nil
end

-- Salvar estado atual
local function salvarEstado()
    local char = esperarPersonagemReal()
    if not char then
        warn("[✖] Personagem inválido.")
        return
    end

    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChild("Humanoid")

    if hrp and hum then
        savedState = {
            pos = hrp.Position,
            vida = hum.Health
        }
        print("[✔] Estado salvo.")
    end
end

-- Aplicar rollback
local function aplicarRollback()
    if not savedState then
        warn("[✖] Nenhum estado salvo.")
        return
    end

    local char = esperarPersonagemReal()
    if not char then
        warn("[✖] Personagem inválido.")
        return
    end

    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChild("Humanoid")

    if hrp and hum then
        hrp.CFrame = CFrame.new(savedState.pos)
        hum.Health = savedState.vida
        print("[✔] Rollback aplicado.")
    end
end

-- Criar botão genérico
local function criarBotao(nome, posY)
    local botao = Instance.new("TextButton")
    botao.Size = UDim2.new(0, 200, 0, 40)
    botao.Position = UDim2.new(0, 20, 0, posY)
    botao.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    botao.TextColor3 = Color3.fromRGB(255, 255, 255)
    botao.Font = Enum.Font.GothamBold
    botao.TextSize = 16
    botao.Text = nome
    botao.Parent = gui
    return botao
end

-- Botão rollback toggle
local rollbackBotao = criarBotao("Rollback: DESLIGADO", 100)
rollbackBotao.BackgroundColor3 = Color3.fromRGB(70, 70, 70)

rollbackBotao.MouseButton1Click:Connect(function()
    rollbackAtivo = not rollbackAtivo
    if rollbackAtivo then
        salvarEstado()
        rollbackBotao.Text = "Rollback: ATIVADO"
        rollbackBotao.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
    else
        rollbackBotao.Text = "Rollback: DESLIGADO"
        rollbackBotao.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    end
end)

-- Botão aplicar rollback (só funciona se tiver ativado)
local aplicarBotao = criarBotao("Ativar Rollback", 150)
aplicarBotao.MouseButton1Click:Connect(function()
    if rollbackAtivo then
        aplicarRollback()
    else
        warn("Rollback está desligado.")
    end
end)

-- Botão de relogar
local relogarBotao = criarBotao("Relogar", 200)
relogarBotao.MouseButton1Click:Connect(function()
    TeleportService:Teleport(game.PlaceId, player)
end)

-- Salvamento automático quando personagem real entrar
player.CharacterAdded:Connect(function()
    wait(2)
    if rollbackAtivo then
        salvarEstado()
    end
end)
