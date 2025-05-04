-- Habilidade de Chute Super
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local UIS = game:GetService("UserInputService")

-- Variáveis de habilidade
local superShotActivated = false
local superShotCooldown = 10
local superShotDuration = 5

-- Função de ativação do chute super
local function activateSuperShot()
    if superShotActivated then
        return
    end
    superShotActivated = true
    print("Chute Super Ativado!")

    -- Aumenta o poder do chute
    humanoid.WalkSpeed = 100  -- Pode aumentar a velocidade do jogador ao ativar
    -- Aqui você pode adicionar lógica para o jogador executar um chute mais forte

    -- Habilidade dura 'superShotDuration' segundos
    wait(superShotDuration)
    
    -- Desativa o poder após o tempo de duração
    humanoid.WalkSpeed = 16  -- Restaura a velocidade normal
    superShotActivated = false

    -- Reinicia o cooldown após a duração da habilidade
    wait(superShotCooldown)
end

-- Criando a Interface Gráfica
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = player.PlayerGui
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 100)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -50)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = ScreenGui

-- Função para criar o botão de ativação do chute
local activateButton = Instance.new("TextButton")
activateButton.Size = UDim2.new(0, 150, 0, 40)
activateButton.Position = UDim2.new(0.5, -75, 0.2, 0)
activateButton.Text = "Ativar Chute Super"
activateButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
activateButton.TextColor3 = Color3.fromRGB(255, 255, 255)
activateButton.Parent = mainFrame

-- Função para ativar/desativar o chute
activateButton.MouseButton1Click:Connect(function()
    activateSuperShot()
end)

-- Botão de Minimizar
local minimizeButton = Instance.new("TextButton")
minimizeButton.Size = UDim2.new(0, 50, 0, 40)
minimizeButton.Position = UDim2.new(0.7, 0, 0, 0)
minimizeButton.Text = "_"
minimizeButton.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
minimizeButton.TextColor3 = Color3.fromRGB(0, 0, 0)
minimizeButton.Parent = mainFrame

-- Função de Minimizar/Restaurar a interface
local isMinimized = false
minimizeButton.MouseButton1Click:Connect(function()
    if isMinimized then
        mainFrame.Size = UDim2.new(0, 300, 0, 100)
        minimizeButton.Text = "_"
        isMinimized = false
    else
        mainFrame.Size = UDim2.new(0, 300, 0, 30)
        minimizeButton.Text = ">"
        isMinimized = true
    end
end)

-- Botão de Fechar
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 50, 0, 40)
closeButton.Position = UDim2.new(0.8, 0, 0, 0)
closeButton.Text = "X"
closeButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Parent = mainFrame

-- Função de Fechar a Interface
closeButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()  -- Remove a interface
end)

-- Função para exibir o cooldown de ativação
local cooldownLabel = Instance.new("TextLabel")
cooldownLabel.Size = UDim2.new(0, 300, 0, 30)
cooldownLabel.Position = UDim2.new(0.5, -150, 0.8, 0)
cooldownLabel.Text = "Cooldown: " .. superShotCooldown
cooldownLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
cooldownLabel.BackgroundTransparency = 1
cooldownLabel.Parent = ScreenGui

-- Atualiza o cooldown na tela
while true do
    if superShotActivated == false then
        local cooldownTime = superShotCooldown
        while cooldownTime > 0 do
            cooldownLabel.Text = "Cooldown: " .. tostring(cooldownTime)
            wait(1)
            cooldownTime = cooldownTime - 1
        end
    end
    wait(1)
end
