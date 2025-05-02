-- Blue Lock Rivals Hub | Interface, Hitbox e Controle de Bola
-- Feito para rodar via loadstring()

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRoot = character:WaitForChild("HumanoidRootPart")
local PlayerGui = player:WaitForChild("PlayerGui")

-- Remove UI antiga se existir
if PlayerGui:FindFirstChild("BlueLockUI") then
	PlayerGui:FindFirstChild("BlueLockUI"):Destroy()
end

-- Criar a interface
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BlueLockUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = PlayerGui

-- Botão: Ativar Hitbox
local activateHitboxBtn = Instance.new("TextButton")
activateHitboxBtn.Size = UDim2.new(0, 150, 0, 40)
activateHitboxBtn.Position = UDim2.new(0.05, 0, 0.85, 0)
activateHitboxBtn.Text = "Ativar Hitbox"
activateHitboxBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
activateHitboxBtn.TextColor3 = Color3.new(1, 1, 1)
activateHitboxBtn.Parent = screenGui

-- Botão: Controlar Bola
local controlBallBtn = Instance.new("TextButton")
controlBallBtn.Size = UDim2.new(0, 150, 0, 40)
controlBallBtn.Position = UDim2.new(0.25, 0, 0.85, 0)
controlBallBtn.Text = "Controlar Bola"
controlBallBtn.BackgroundColor3 = Color3.fromRGB(255, 85, 0)
controlBallBtn.TextColor3 = Color3.new(1, 1, 1)
controlBallBtn.Parent = screenGui

-- Hitbox personalizada
local hitbox = Instance.new("Part")
hitbox.Size = Vector3.new(8, 6, 8)
hitbox.Shape = Enum.PartType.Ball
hitbox.Transparency = 1
hitbox.Anchored = false
hitbox.CanCollide = false
hitbox.BrickColor = BrickColor.new("Bright blue")
hitbox.Material = Enum.Material.ForceField
hitbox.Parent = workspace

local weld = Instance.new("WeldConstraint")
weld.Part0 = humanoidRoot
weld.Part1 = hitbox
weld.Parent = hitbox
hitbox.CFrame = humanoidRoot.CFrame
weld.Enabled = false

-- Bola
local ball = Instance.new("Part")
ball.Size = Vector3.new(2, 2, 2)
ball.Shape = Enum.PartType.Ball
ball.BrickColor = BrickColor.new("Bright red")
ball.Material = Enum.Material.SmoothPlastic
ball.Position = humanoidRoot.Position + Vector3.new(0, -2, 3)
ball.Anchored = false
ball.CanCollide = true
ball.Name = "BlueLockBall"
ball.Parent = workspace

local controlActive = false

-- Eventos dos botões
activateHitboxBtn.MouseButton1Click:Connect(function()
	if weld.Enabled then
		weld.Enabled = false
		hitbox.Transparency = 1
		activateHitboxBtn.Text = "Ativar Hitbox"
	else
		weld.Enabled = true
		hitbox.Transparency = 0.5
		activateHitboxBtn.Text = "Desativar Hitbox"
	end
end)

controlBallBtn.MouseButton1Click:Connect(function()
	controlActive = not controlActive
	controlBallBtn.Text = controlActive and "Soltar Bola" or "Controlar Bola"
end)

-- Movimento da bola quando controlando
RunService.RenderStepped:Connect(function()
	if controlActive and ball and humanoidRoot then
		local direction = humanoidRoot.CFrame.LookVector * 3
		local targetPos = humanoidRoot.Position + direction - Vector3.new(0, 1.5, 0)
		local tweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Linear)
		local tween = TweenService:Create(ball, tweenInfo, {Position = targetPos})
		tween:Play()
	end
end)

-- Chutar a bola com Q
UIS.InputBegan:Connect(function(input, gpe)
	if gpe then return end
	if input.KeyCode == Enum.KeyCode.Q and controlActive then
		ball.Velocity = humanoidRoot.CFrame.LookVector * 60
	end
end)
