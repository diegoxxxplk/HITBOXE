-- FPS Booster com GUI - Por ChatGPT

-- Criação da Interface
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FPSBoosterGUI"
ScreenGui.ResetOnSpawn = false

local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "ToggleButton"
ToggleButton.Size = UDim2.new(0, 200, 0, 50)
ToggleButton.Position = UDim2.new(0, 20, 0, 20)
ToggleButton.Text = "Ativar Modo FPS 🚀"
ToggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.TextSize = 18
ToggleButton.BorderSizePixel = 0
ToggleButton.AutoButtonColor = true
ToggleButton.Parent = ScreenGui

ScreenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

-- Variáveis
local fpsModeAtivo = false

-- Função para alterar qualidade
local function setFPSMode(ativo)
    local Lighting = game:GetService("Lighting")

    if ativo then
        -- Reduz qualidade
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 1000000
        Lighting.Brightness = 1

        -- Remove efeitos desnecessários
        for _, effect in pairs(Lighting:GetChildren()) do
            if effect:IsA("BlurEffect") or effect:IsA("SunRaysEffect") or effect:IsA("ColorCorrectionEffect") or effect:IsA("BloomEffect") then
                effect.Enabled = false
            end
        end

        -- Texturas e detalhes
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("Decal") or obj:IsA("Texture") then
                obj.Transparency = 1
            elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") then
                obj.Enabled = false
            end
        end

        print("[FPS BOOST] Modo FPS ativado.")
    else
        -- Restaurar qualidade
        settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic
        Lighting.GlobalShadows = true
        Lighting.FogEnd = 1000
        Lighting.Brightness = 2

        for _, effect in pairs(Lighting:GetChildren()) do
            if effect:IsA("BlurEffect") or effect:IsA("SunRaysEffect") or effect:IsA("ColorCorrectionEffect") or effect:IsA("BloomEffect") then
                effect.Enabled = true
            end
        end

        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("Decal") or obj:IsA("Texture") then
                obj.Transparency = 0
            elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") then
                obj.Enabled = true
            end
        end

        print("[FPS BOOST] Modo FPS desativado.")
    end
end

-- Evento do botão
ToggleButton.MouseButton1Click:Connect(function()
    fpsModeAtivo = not fpsModeAtivo
    setFPSMode(fpsModeAtivo)
    ToggleButton.Text = fpsModeAtivo and "Desativar Modo FPS ❌" or "Ativar Modo FPS 🚀"
end)
