--[[
  🧠 Modo Hiper Foco — Assistência Inteligente
  Funciona só com a bola, ativa dash automático quando inimigo se aproxima.
  Inclui: Interface ON/OFF, Raycast, Efeito visual + Som
--]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- Interface
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "HiperFocoUI"

local button = Instance.new("TextButton", gui)
button.Size = UDim2.new(0, 180, 0, 40)
button.Position = UDim2.new(0, 10, 0.8, 0)
button.Text = "Modo Hiper Foco: OFF"
button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.Font = Enum.Font.GothamBold
button.TextScaled = true

local ativo = false
button.MouseButton1Click:Connect(function()
    ativo = not ativo
    button.Text = ativo and "Modo Hiper Foco: ON" or "Modo Hiper Foco: OFF"
    button.BackgroundColor3 = ativo and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(30, 30, 30)
end)

-- Função auxiliar: efeito visual
local function efeitoDash(pé)
    if not pé then return end -- evita erro se o pé for nil
    local part = Instance.new("ParticleEmitter", pé)
    part.Texture = "rbxassetid://48374994"
    part.Size = NumberSequence.new(1)
    part.Rate = 100
    part.Lifetime = NumberRange.new(0.3)
    part.Speed = NumberRange.new(4)
    part.Color = ColorSequence.new(Color3.fromRGB(255, 255, 0))
    game.Debris:AddItem(part, 0.4)
end

-- Função auxiliar: som
local function somDash()
    local sound = Instance.new("Sound", character)
    sound.SoundId = "rbxassetid://9127635222" -- som de dash
    sound.Volume = 2
    sound:Play()
    game.Debris:AddItem(sound, 1)
end

-- Drible lateral com verificação de espaço
local function fazerDash()
    if not character or not humanoid then return end
    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then return end

    local direcao = math.random(0, 1) == 0 and -1 or 1 -- esquerda ou direita
    local offset = Vector3.new(direcao * 5, 0, 0)

    -- Raycast pra checar se o espaço está livre
    local rayParams = RaycastParams.new()
    rayParams.FilterDescendantsInstances = {character}
    rayParams.FilterType = Enum.RaycastFilterType.Blacklist

    local result = workspace:Raycast(root.Position, offset, rayParams)

    if not result then
        -- Dash lateral
        local objetivo = root.Position + offset
        local tween = TweenService:Create(root, TweenInfo.new(0.15, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {CFrame = CFrame.new(objetivo)})
        tween:Play()
        efeitoDash(character:FindFirstChild("RightFoot") or root)
        somDash()
    end
end

-- Verifica se o jogador tem posse da bola
local function temBola()
    local bola = workspace:FindFirstChild("Ball")
    if bola and character:FindFirstChild("HumanoidRootPart") then
        local dist = (bola.Position - character.HumanoidRootPart.Position).Magnitude
        local velocidade = bola.Velocity.Magnitude
        return dist < 7 and velocidade < 10
    end
    return false
end

-- Loop principal
RunService.Heartbeat:Connect(function()
    if not ativo then return end
    if not temBola() then return end

    -- Verifica jogadores inimigos próximos
    for _, other in ipairs(Players:GetPlayers()) do
        if other ~= player and other.Character and other.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (other.Character.HumanoidRootPart.Position - character.HumanoidRootPart.Position).Magnitude
            if dist < 7 then
                fazerDash()
                wait(0.8) -- tempo entre dribles
                break
            end
        end
    end
end)
