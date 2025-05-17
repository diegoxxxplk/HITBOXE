local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local player = Players.LocalPlayer

-- GUI principal
local gui = Instance.new("ScreenGui")
gui.Name = "RollbackStyleGUI"
gui.Parent = game.CoreGui
gui.ResetOnSpawn = false

-- Container da janela
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 350, 0, 200)
main.Position = UDim2.new(0, 30, 0, 30)
main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
main.BorderSizePixel = 0

-- Título
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
title.Text = "Rollback de Estilo"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 18

-- Estado salvo
local savedStyle = nil
local rollbackAtivo = false

-- Botão tipo "alavanca"
local toggle = Instance.new("TextButton", main)
toggle.Size = UDim2.new(0, 120, 0, 35)
toggle.Position = UDim2.new(0, 20, 0, 60)
toggle.Text = "Rollback: OFF"
toggle.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
toggle.Font = Enum.Font.GothamBold
toggle.TextSize = 16

toggle.MouseButton1Click:Connect(function()
	rollbackAtivo = not rollbackAtivo
	if rollbackAtivo then
		-- Salva o estilo atual
		local styleFolder = player:FindFirstChild("Style") or player:WaitForChild("Style")
		if styleFolder and styleFolder:FindFirstChild("CurrentStyle") then
			savedStyle = styleFolder.CurrentStyle.Value
			toggle.Text = "Rollback: ON"
			toggle.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
			print("[Rollback] Estilo salvo:", savedStyle)
		end
	else
		toggle.Text = "Rollback: OFF"
		toggle.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
	end
end)

-- Botão aplicar rollback
local apply = Instance.new("TextButton", main)
apply.Size = UDim2.new(0, 120, 0, 35)
apply.Position = UDim2.new(0, 20, 0, 110)
apply.Text = "Aplicar Rollback"
apply.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
apply.TextColor3 = Color3.fromRGB(255, 255, 255)
apply.Font = Enum.Font.GothamBold
apply.TextSize = 16

apply.MouseButton1Click:Connect(function()
	if rollbackAtivo and savedStyle then
		local styleFolder = player:FindFirstChild("Style") or player:WaitForChild("Style")
		if styleFolder and styleFolder:FindFirstChild("CurrentStyle") then
			styleFolder.CurrentStyle.Value = savedStyle
			print("[Rollback] Estilo restaurado:", savedStyle)
		end
	else
		warn("[Rollback] Estilo não salvo ou rollback desligado.")
	end
end)
