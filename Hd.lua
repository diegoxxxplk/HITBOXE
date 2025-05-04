-- Serviço necessário
local UserInterfaceService = game:GetService("UserInterfaceService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)

-- Variáveis de qualidade gráfica
local highQuality = {
    -- Configurações para alta qualidade
    TextureQuality = Enum.TextureQuality.Smooth,
    ShadowQuality = Enum.ShadowQuality.High,
    AntiAliasing = Enum.AntiAliasingMode.FXAA,
    BloomEnabled = true,
    GlobalShadows = true,
}

local lowQuality = {
    -- Configurações para baixa qualidade
    TextureQuality = Enum.TextureQuality.Grainy,
    ShadowQuality = Enum.ShadowQuality.None,
    AntiAliasing = Enum.AntiAliasingMode.None,
    BloomEnabled = false,
    GlobalShadows = false,
}

-- Definindo a configuração gráfica inicial
local currentQuality = highQuality

-- Função para aplicar as configurações de qualidade gráfica
local function applyGraphicsSettings(settings)
    -- Aplique as configurações de qualidade gráfica
    Lighting.TextureQuality = settings.TextureQuality
    Lighting.ShadowQuality = settings.ShadowQuality
    Lighting.AntiAliasing = settings.AntiAliasing
    Lighting.BloomEnabled = settings.BloomEnabled
    Lighting.GlobalShadows = settings.GlobalShadows
end

-- Função para criar o botão de alternância
local function createToggleButton()
    -- Criando o botão para alternar a qualidade gráfica
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 200, 0, 50)
    button.Position = UDim2.new(0.5, -100, 0.5, -25)
    button.Text = "Ativar Alta Qualidade"
    button.TextSize = 20
    button.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Parent = game.Players.LocalPlayer.PlayerGui:WaitForChild("ScreenGui")

    -- Função para alternar entre as qualidades
    button.MouseButton1Click:Connect(function()
        if currentQuality == highQuality then
            currentQuality = lowQuality
            button.Text = "Ativar Alta Qualidade"
        else
            currentQuality = highQuality
            button.Text = "Ativar Baixa Qualidade"
        end
        applyGraphicsSettings(currentQuality)
    end)

    -- Animar a aparência do botão
    TweenService:Create(button, TweenInfo, {Position = UDim2.new(0.5, -100, 0.1, 50)}):Play()
end

-- Função para inicializar a interface e configurações
local function initialize()
    -- Aplicar as configurações de alta qualidade inicialmente
    applyGraphicsSettings(highQuality)

    -- Criar o botão de alternância
    createToggleButton()
end

-- Inicializando
initialize()
