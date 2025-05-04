-- Super Chute com efeito visual (local), pronto para integrar com RemoteEvents
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")

local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "SuperShotUI"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 250, 0, 80)
frame.Position = UDim2.new(0.5, -125, 0.1, 0)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 0
frame.Name = "MainFrame"

local shotButton = Instance.new("TextButton", frame)
shotButton.Size = UDim2.new(1, 0, 1, 0)
shotButton.Text = "Ativar Super Chute"
shotButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
shotButton.TextColor3 = Color3.new(1, 1, 1)
shotButton.Font = Enum.Font.GothamBold
shotButton.TextScaled = true

-- Função que ativa o "super chute"
local function activateSuperChute()
	if not char then return end
	if not humanoid then return end

	local leg = char:FindFirstChild("RightFoot") or char:FindFirstChild("Right Leg")
	if not leg then return end

	-- Efeito visual no pé
	local attachment = Instance.new("Attachment", leg)
	local trail = Instance.new("Trail", leg)
	trail.Attachment0 = attachment
	trail.Attachment1 = attachment
	trail.Lifetime = 0.3
	trail.Color = ColorSequence.new(Color3.new(0, 1, 0))
	trail.WidthScale = NumberSequence.new(2)

	-- Efeito de brilho
	local fire = Instance.new("ParticleEmitter", leg)
	fire.Texture = "rbxassetid://48374994"
	fire.Color = ColorSequence.new(Color3.new(1, 1, 0), Color3.new(1, 0, 0))
	fire.Size = NumberSequence.new(1)
	fire.Rate = 50
	fire.Lifetime = NumberRange.new(0.3)
	fire.Speed = NumberRange.new(2)

	-- Efeito sonoro (opcional)
	local sound = Instance.new("Sound", leg)
	sound.SoundId = "rbxassetid://12222225" -- Coloque um ID de som de chute ou energia
	sound.Volume = 3
	sound:Play()

	-- Temporariamente aumenta a velocidade do personagem (efeito de força)
	local oldSpeed = humanoid.WalkSpeed
	humanoid.WalkSpeed = 75

	wait(1.5) -- duração do super chute

	humanoid.WalkSpeed = oldSpeed
	trail:Destroy()
	fire:Destroy()
	sound:Destroy()
	attachment:Destroy()
end

shotButton.MouseButton1Click:Connect(activateSuperChute)
