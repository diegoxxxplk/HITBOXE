local gui = Instance.new("ScreenGui")
gui.Name = "RollbackGui"
gui.ResetOnSpawn = false
gui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Botão de rollback ON/OFF
local rollbackButton = Instance.new("TextButton")
rollbackButton.Size = UDim2.new(0, 200, 0, 50)
rollbackButton.Position = UDim2.new(0.5, -100, 0.5, -25)
rollbackButton.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
rollbackButton.Text = "Rollback: OFF"
rollbackButton.TextColor3 = Color3.new(1, 1, 1)
rollbackButton.Font = Enum.Font.SourceSansBold
rollbackButton.TextSize = 20
rollbackButton.Parent = gui

-- Variável de estado
local rollbackAtivo = false

-- Função de clique
rollbackButton.MouseButton1Click:Connect(function()
	rollbackAtivo = not rollbackAtivo

	if rollbackAtivo then
		rollbackButton.Text = "Rollback: ON"
		rollbackButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
	else
		rollbackButton.Text = "Rollback: OFF"
		rollbackButton.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
	end
end)
