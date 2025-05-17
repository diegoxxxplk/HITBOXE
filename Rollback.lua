-- UI Setup (simples)
local ScreenGui = Instance.new("ScreenGui", game.Players.LocalPlayer:WaitForChild("PlayerGui"))
ScreenGui.Name = "RollbackUI"
ScreenGui.ResetOnSpawn = false

-- Variável de controle
local rollbackAtivo = false
local estiloSalvo = nil

-- Frame
local frame = Instance.new("Frame", ScreenGui)
frame.Size = UDim2.new(0, 300, 0, 150)
frame.Position = UDim2.new(0.5, -150, 0.5, -75)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0

-- Título
local titulo = Instance.new("TextLabel", frame)
titulo.Text = "Rollback de Estilo"
titulo.Size = UDim2.new(1, 0, 0, 30)
titulo.BackgroundTransparency = 1
titulo.TextColor3 = Color3.fromRGB(255, 255, 255)
titulo.Font = Enum.Font.SourceSansBold
titulo.TextSize = 20

-- Botão ON/OFF
local toggleBtn = Instance.new("TextButton", frame)
toggleBtn.Size = UDim2.new(0, 260, 0, 40)
toggleBtn.Position = UDim2.new(0, 20, 0, 40)
toggleBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
toggleBtn.Text = "Rollback: OFF"
toggleBtn.TextColor3 = Color3.new(1, 1, 1)
toggleBtn.Font = Enum.Font.SourceSansBold
toggleBtn.TextSize = 18
toggleBtn.BorderSizePixel = 0

-- Botão aplicar rollback
local applyBtn = Instance.new("TextButton", frame)
applyBtn.Size = UDim2.new(0, 260, 0, 40)
applyBtn.Position = UDim2.new(0, 20, 0, 90)
applyBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
applyBtn.Text = "Aplicar Rollback"
applyBtn.TextColor3 = Color3.new(1, 1, 1)
applyBtn.Font = Enum.Font.SourceSansBold
applyBtn.TextSize = 18
applyBtn.BorderSizePixel = 0

-- FUNÇÃO: alternar rollback
toggleBtn.MouseButton1Click:Connect(function()
    rollbackAtivo = not rollbackAtivo

    if rollbackAtivo then
        toggleBtn.Text = "Rollback: ON"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 0)

        -- Salvar estilo atual
        local estiloAtual = game.Players.LocalPlayer:FindFirstChild("Style") and game.Players.LocalPlayer.Style:FindFirstChild("CurrentStyle")
        if estiloAtual then
            estiloSalvo = estiloAtual.Value
        end
    else
        toggleBtn.Text = "Rollback: OFF"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
    end
end)

-- FUNÇÃO: aplicar rollback
applyBtn.MouseButton1Click:Connect(function()
    if rollbackAtivo and estiloSalvo then
        local estiloAtual = game.Players.LocalPlayer:FindFirstChild("Style") and game.Players.LocalPlayer.Style:FindFirstChild("CurrentStyle")
        if estiloAtual then
            estiloAtual.Value = estiloSalvo
        end
    end
end)
