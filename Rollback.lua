-- Orion Library
local OrionLib = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Orion/main/source'))()

-- Janela principal
local Window = OrionLib:MakeWindow({
    Name = "Rollback de Estilo",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "EstiloRollback"
})

-- Variáveis de controle
local rollbackAtivo = false
local estiloSalvo = nil

-- Aba do menu
local Tab = Window:MakeTab({
    Name = "Rollback",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- Seção de rollback
Tab:AddToggle({
    Name = "Rollback",
    Default = false,
    Callback = function(Value)
        rollbackAtivo = Value
        local estado = rollbackAtivo and "ON" or "OFF"
        OrionLib:MakeNotification({
            Name = "Rollback",
            Content = "Rollback: " .. estado,
            Time = 2
        })
        if rollbackAtivo then
            local estilo = game.Players.LocalPlayer:FindFirstChild("Estilo")
            if estilo then
                estiloSalvo = estilo.Value
                OrionLib:MakeNotification({
                    Name = "Estilo Salvo",
                    Content = "Estilo salvo: " .. estiloSalvo,
                    Time = 3
                })
            else
                OrionLib:MakeNotification({
                    Name = "Erro",
                    Content = "Não foi possível encontrar o estilo!",
                    Time = 3
                })
            end
        end
    end    
})

-- Botão de aplicar rollback
Tab:AddButton({
    Name = "Aplicar Rollback",
    Callback = function()
        local estiloValue = game.Players.LocalPlayer:FindFirstChild("Estilo")
        if estiloValue and rollbackAtivo and estiloSalvo then
            estiloValue.Value = estiloSalvo
            OrionLib:MakeNotification({
                Name = "Rollback Aplicado",
                Content = "Estilo restaurado: " .. estiloSalvo,
                Time = 3
            })
        else
            OrionLib:MakeNotification({
                Name = "Erro",
                Content = "Rollback falhou. Estilo não encontrado ou não salvo.",
                Time = 3
            })
        end
    end    
})

-- Finalizar a interface
OrionLib:Init()
