-- Auto Chat para MOBILE - Por ChatGPT

local frases = {
    "Passa aqui! 👟",
    "Boa jogada! 🙌",
    "To livre! ⚽",
    "Marca ele! 🛡️",
    "GG! 🔥"
}

local player = game:GetService("Players").LocalPlayer
local chatEvent = game:GetService("ReplicatedStorage"):WaitForChild("DefaultChatSystemChatEvents"):WaitForChild("SayMessageRequest")

-- Interface
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoChatMobileGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 230, 0, #frases * 60 + 10)
frame.Position = UDim2.new(0, 10, 1, -(#frases * 60 + 20))
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BackgroundTransparency = 0.2
frame.BorderSizePixel = 0
frame.Parent = screenGui

-- Criar botões de frase
for i, msg in ipairs(frases) do
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -10, 0, 50)
    button.Position = UDim2.new(0, 5, 0, (i - 1) * 60 + 5)
    button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Text = msg
    button.Font = Enum.Font.SourceSansBold
    button.TextSize = 18
    button.BorderSizePixel = 0
    button.Parent = frame

    button.MouseButton1Click:Connect(function()
        chatEvent:FireServer(msg, "All")
    end)
end
