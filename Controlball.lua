-- Blue Lock Rivals - Script de Hitbox + Controle de Bola
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")
local PlayerGui = player:WaitForChild("PlayerGui")

-- Remove UI antiga se existir
if PlayerGui:FindFirstChild("BlueLockUI") then
	PlayerGui:FindFirstChild("BlueLockUI"):Destroy()
end

-- Interface
local screenGui = Instance.new("ScreenGui", PlayerGui)
screenGui.Name = "BlueLockUI"
screenGui.ResetOnSpawn = false

-- Botão 1: Ativar/Desativar Hitbox
local toggleHitboxBtn = Instance.new("TextButton")
toggleHitboxBtn.Size = UDim2.new(0, 160, 0, 40)
toggleHitboxBtn.Position = UDim2.new(0.02, 0, 0.80, 0)
toggleHitboxBtn.Text = "Ativar Hitbox"
toggleHitboxBtn.BackgroundColor3 = Color3.fromRGB(255, 170, 0)
toggleHitboxBtn.TextColor3 = Color3.new(1, 1, 1)
toggleHitboxBtn.Parent = screenGui

-- Botão 2: Aumentar/Diminuir Hitbox
local resizeBtn = Instance.new("TextButton")
resizeBtn.Size = UDim2.new(0, 160, 0, 40)
resizeBtn.Position = UDim2.new(0.02, 0, 0.85, 0)
resizeBtn.Text = "Aumentar Hitbox"
resizeBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
resizeBtn.TextColor3 = Color3.new(1, 1, 1)
resizeBtn.Parent = screenGui

-- Botão 3: Controlar Bola
local controlBallBtn = Instance.new("TextButton")
controlBallBtn.Size = UDim2.new(0, 160, 0, 40)
controlBallBtn.Position = UDim2.new(0.02, 0, 0.90, 0)
controlBallBtn.Text = "Controlar Bola"
controlBallBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
controlBallBtn.TextColor3 = Color3.new(1, 1, 1)
controlBallBtn.Parent = screenGui

-- HITBOX
local hitbox = Instance.new("Part")
hitbox.Size = Vector3.new(8, 5, 8)
hitbox.Shape = Enum.PartType.Block
hitbox.Anchored = true
hitbox.CanCollide = false
hitbox.Transparency = 0.5
hitbox.Material = Enum.Material.ForceField
hitbox.Color = Color3.fromRGB(255, 255, 0)
hitbox.Name = "HitboxArea"
hitbox.Visible = false
hitbox.Parent = workspace

local hitboxEnabled = false
local hitboxSize = 8
local resizeMode = "increase"

toggleHitboxBtn.MouseButton1Click:Connect(function()
	hitboxEnabled = not hitboxEnabled
	hitbox.Visible = hitboxEnabled
	toggleHitboxBtn.Text = hitboxEnabled and "Desativar Hitbox" or "Ativar Hitbox"
end)

resizeBtn.MouseButton1Click:Connect(function()
	if resizeMode == "increase" then
		hitboxSize += 2
		resizeBtn.Text = "Diminuir Hitbox"
		resizeMode = "decrease"
	else
		hitboxSize = math.max(4, hitboxSize - 2)
		resizeBtn.Text = "Aumentar Hitbox"
		resizeMode = "increase"
	end
	hitbox.Size = Vector3.new(hitboxSize, 5, hitboxSize)
end)

-- Atualizar posição da hitbox
RunService.RenderStepped:Connect(function()
	if hitboxEnabled and character and hrp then
		hitbox.CFrame = hrp.CFrame
	end
end)

-- BOLA
local ball = nil

-- Procurar bola no jogo (automaticamente)
local function findBall()
	for _, obj in ipairs(workspace:GetDescendants()) do
		if obj:IsA("Part") and obj.Name:lower():find("ball") and obj:IsDescendantOf(workspace) then
			return obj
		end
	end
	return nil
end

controlBallBtn.MouseButton1Click:Connect(function()
	ball = findBall()
	if ball and (ball.Position - hrp.Position).Magnitude < 60 then
		local goal = hrp.Position + hrp.CFrame.LookVector * 3
		local tween = TweenService:Create(ball, TweenInfo.new(0.3), {Position = goal})
		tween:Play()
	else
		controlBallBtn.Text = "Bola não encontrada"
		wait(1)
		controlBallBtn.Text = "Controlar Bola"
	end
end)
