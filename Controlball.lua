-- LocalScript (StarterPlayerScripts)
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRoot = character:WaitForChild("HumanoidRootPart")

-- == UI SETUP ==
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "BlueLockUI"

local activateHitboxBtn = Instance.new("TextButton")
activateHitboxBtn.Size = UDim2.new(0, 150, 0, 40)
activateHitboxBtn.Position = UDim2.new(0.05, 0, 0.85, 0)
activateHitboxBtn.Text = "Ativar Hitbox"
activateHitboxBtn.Parent = screenGui

local controlBallBtn = Instance.new("TextButton")
controlBallBtn.Size = UDim2.new(0, 150, 0, 40)
controlBallBtn.Position = UDim2.new(0.25, 0, 0.85, 0)
controlBallBtn.Text = "Controlar Bola"
controlBallBtn.Parent = screenGui

-- == HITBOX PERSONALIZADA ==
local hitbox = Instance.new("Part")
hitbox.Size = Vector3.new(8, 6, 8)
hitbox.Shape = Enum.PartType.Ball
hitbox.Transparency = 0.6
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
hitbox.Transparency = 1

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

-- == BOLA E CONTROLE ==
local ball = Instance.new("Part")
ball.Size = Vector3.new(2, 2, 2)
ball.Shape = Enum.PartType.Ball
ball.BrickColor = BrickColor.new("Bright red")
ball.Material = Enum.Material.SmoothPlastic
ball.Position = character.HumanoidRootPart.Position + Vector3.new(0, -2, 3)
ball.Anchored = false
ball.CanCollide = true
ball.Parent = workspace

local controlActive = false

controlBallBtn.MouseButton1Click:Connect(function()
	controlActive = not controlActive
	controlBallBtn.Text = controlActive and "Soltar Bola" or "Controlar Bola"
end)

RunService.RenderStepped:Connect(function()
	if controlActive and ball and humanoidRoot then
		local direction = humanoidRoot.CFrame.LookVector * 3
		local targetPos = humanoidRoot.Position + direction - Vector3.new(0, 1.5, 0)
		local tweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Linear)
		local tween = TweenService:Create(ball, tweenInfo, {Position = targetPos})
		tween:Play()
	end
end)

-- == MOVIMENTO COM TECLA (EXEMPLO: CHUTE PARA FRENTE COM 'Q') ==
UIS.InputBegan:Connect(function(input, gpe)
	if gpe then return end
	if input.KeyCode == Enum.KeyCode.Q and controlActive then
		ball.Velocity = humanoidRoot.CFrame.LookVector * 60
	end
end)
