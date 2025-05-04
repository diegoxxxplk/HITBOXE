-- Habilidades Especiais dos Jogadores
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Definição das Habilidades
local skills = {
    SuperSpeed = {
        cooldown = 10,  -- Tempo de recarga
        duration = 5,   -- Duração da habilidade
        activated = false,
        activate = function()
            if skills.SuperSpeed.activated then return end
            skills.SuperSpeed.activated = true
            
            local humanoid = character:WaitForChild("Humanoid")
            humanoid.WalkSpeed = 100  -- Super Velocidade
            
            -- Duração da habilidade
            wait(skills.SuperSpeed.duration)
            
            -- Restaura a velocidade normal
            humanoid.WalkSpeed = 16
            wait(skills.SuperSpeed.cooldown)  -- Espera o tempo de recarga
            skills.SuperSpeed.activated = false
        end
    },

    DoubleJump = {
        cooldown = 15,  -- Tempo de recarga
        activated = false,
        activate = function()
            if skills.DoubleJump.activated then return end
            skills.DoubleJump.activated = true
            
            -- Permite o salto duplo
            local humanoid = character:WaitForChild("Humanoid")
            humanoid.Jumping = true
            wait(0.2)
            humanoid:ChangeState(Enum.HumanoidStateType.Physics)
            humanoid:Move(Vector3.new(0, 100, 0))  -- Salta para cima
            
            wait(skills.DoubleJump.cooldown)
            skills.DoubleJump.activated = false
        end
    }
}

-- Criando a Interface Gráfica
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = player.PlayerGui

-- Função para criar os botões de habilidade e o display de cooldown
local function createSkillButton(skill, skillName, position)
    -- Botão para ativar a habilidade
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 200, 0, 50)
    button.Position = position
    button.Text = "Ativar " .. skillName
    button.BackgroundColor3 = Color3.fromRGB(0, 0, 255)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Parent = ScreenGui

    -- Label de cooldown
    local cooldownLabel = Instance.new("TextLabel")
    cooldownLabel.Size = UDim2.new(0, 200, 0, 30)
    cooldownLabel.Position = UDim2.new(0.5, -100, position.Y.Scale + 0.1, 0)
    cooldownLabel.Text = "Cooldown: 0"
    cooldownLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
    cooldownLabel.BackgroundTransparency = 1
    cooldownLabel.Parent = ScreenGui

    -- Função para atualizar o cooldown
    local function updateCooldown()
        local cooldownTime = skill.cooldown
        while skill.activated do
            cooldownLabel.Text = "Cooldown: " .. tostring(cooldownTime)
            wait(1)
            cooldownTime = cooldownTime - 1
        end
        cooldownLabel.Text = "Cooldown: 0"
    end

    -- Ação de ativar a habilidade quando o botão for pressionado
    button.MouseButton1Click:Connect(function()
        skill.activate()
        updateCooldown()
    end)
end

-- Criar os botões para as habilidades
createSkillButton(skills.SuperSpeed, "Super Velocidade", UDim2.new(0.5, -100, 0.3, 0))
createSkillButton(skills.DoubleJump, "Salto Duplo", UDim2.new(0.5, -100, 0.5, 0))

