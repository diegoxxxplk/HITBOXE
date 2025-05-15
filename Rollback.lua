-- LocalScript dentro do ScreenGui

local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Referências aos botões
local rejoinButton = script.Parent:WaitForChild("RejoinButton")
local rollbackButton = script.Parent:WaitForChild("RollbackToggle")

-- Estado do rollback (começa desligado)
local rollbackEnabled = false

-- Função: Reentrar no jogo
rejoinButton.MouseButton1Click:Connect(function()
	local player = Players.LocalPlayer
	TeleportService:Teleport(game.PlaceId, player)
end)

-- Função: Ativar/desativar rollback
rollbackButton.MouseButton1Click:Connect(function()
	rollbackEnabled = not rollbackEnabled

	-- Atualiza o texto do botão
	rollbackButton.Text = "Rollback: " .. (rollbackEnabled and "ON" or "OFF")

	-- Envia comando ao servidor
	if ReplicatedStorage:FindFirstChild("SetRollbackState") then
		ReplicatedStorage.SetRollbackState:FireServer(rollbackEnabled)
	end
end)
