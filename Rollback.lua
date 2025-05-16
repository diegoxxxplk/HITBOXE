local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")

local gui = Instance.new("ScreenGui")
gui.Name = "RollbackGUI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = CoreGui

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

-- Esperar personagem real
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
        warn("[✖] Não foi possível detectar o personagem real.")
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
    else
        warn("[✖] Partes do personagem não encontradas.")
    end
end

-- Ativar rollback
local function ativarRollback()
    if not savedState then
        warn("[✖] Nenhum estado salvo ainda.")
        return
    end

    local char = esperarPersonagemReal()
    if not char then
        warn("[✖] Personagem inválido para rollback.")
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

-- Desativar rollback (salva novo estado)
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

-- Salvar quando personagem real carregar
player.CharacterAdded:Connect(function()
    wait(1)
    salvarEstado()
end)
