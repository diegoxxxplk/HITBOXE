-- Hitbox Expander somente para o jogador local

local size = 10 -- Tamanho da hitbox
local transparency = 1 -- 1 = totalmente invisível
local color = Color3.fromRGB(255, 0, 0) -- A cor não importa, porque ficará invisível

local player = game.Players.LocalPlayer

if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
    local part = player.Character.HumanoidRootPart
    part.Size = Vector3.new(size, size, size)
    part.Transparency = transparency
    part.BrickColor = BrickColor.new(color)
    part.Material = Enum.Material.SmoothPlastic
    part.CanCollide = false
end

print("Hitbox Expander aplicado só em você!")
