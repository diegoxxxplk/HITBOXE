-- UI Library (pode usar qualquer uma que preferir, como Rayfield, Kavo, etc.)
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/source"))()

local Window = OrionLib:MakeWindow({Name = "Sterling Hub - Blue Lock", HidePremium = false, SaveConfig = false, IntroEnabled = false})

-- Variável de estado do rollback
local rollbackAtivo = false
local estiloSalvo = nil

-- Aba principal
local MainTab = Window:MakeTab({
    Name = "Rollback de Estilo",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})
-- Alavanca de ativar/desativar rollback
MainTab:AddToggle({
    Name = "Rollback",
    Default = false,
    Callback = function(valor)
        rollbackAtivo = valor
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
                    OrionLib:MakeNotification({
   Name = "Rollback Ativado",
Content = "Estilo salvo: " .. estilo,
Time = 3
            })
        else
            estiloSalvo = nil
            OrionLib:MakeNotification({
                Name = "Rollback Desativado",
                Content = "Rollback foi desligado",
                Time = 3
            })
        end
    end
})

-- Botão de aplicar rollback
MainTab:AddButton({
    Name = "Aplicar Rollback",
    Callback = function()
        if rollbackAtivo and estiloSalvo then
            local estiloValue = game.Players.LocalPlayer:WaitForChild("Estilo")
            estiloValue.Value = estiloSalvo
            OrionLib:MakeNotification({
                Name = "Rollback Aplicado",
                Content = "Seu estilo foi revertido para: " .. estiloSalvo,
                Time = 3
            })
        else
            OrionLib:MakeNotification({
                Name = "Erro",
                Content = "Rollback está desligado ou nenhum estilo salvo!",
                Time = 3
            })
        end
    end
})

-- Rejoin automático (opcional)
MainTab:AddButton({
    Name = "Reentrar na Partida",
    Callback = function()
        game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
    end
})
