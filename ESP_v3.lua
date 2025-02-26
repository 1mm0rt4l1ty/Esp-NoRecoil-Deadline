local plrs = game.Workspace
local plr = game:GetService("Players")
local lplr = plr.LocalPlayer

local isRunning = true 

local function stopScript()
    isRunning = false
    print("Script arrêté.")
end

local lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Consistt/Ui/main/UnLeaked"))()

local HealthESP = false
local BoxESP = false
local NameESP = false
local bigHead = false


task.spawn(function()
    while isRunning and bigHead == true do
        for _, character in ipairs(plrs:GetChildren()) do
            if character:IsA("Model") and character ~= lplr.Character then
                local head = character:FindFirstChild("Head")
                if head and head:IsA("MeshPart") or head and head:IsA("Part") then 
                    head.Size = Vector3.new(7, 7, 7)
                    head.CanCollide = false
                    head.CanTouch = true
                    head.CanQuery = true
                end
            end
        end
        wait(1) 
    end
end)

local function createESP(character, HealthESP, BoxESP, NameESP)
    local head = character:FindFirstChild("Head")
    local HRP = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChild("Humanoid")

    if HRP and HRP:IsA("Part") and humanoid then
        if HRP:FindFirstChild("Esp") then
            HRP.Esp:Destroy()
        end

        local bg1 = Instance.new("BillboardGui")
        bg1.Name = "Esp"
        bg1.Adornee = HRP
        bg1.Size = UDim2.new(4, 0, 6, 0)
        bg1.StudsOffset = Vector3.new(0, 0.2, 0)
        bg1.AlwaysOnTop = true
        bg1.Parent = HRP

        local f0 = Instance.new("Frame")
        f0.Size = UDim2.new(1, 0, 1, 0)
        f0.BackgroundTransparency = 1
        f0.Parent = bg1

        local function createBoxFrame(position, size)
            local frame = Instance.new("Frame")
            frame.Position = position
            frame.Size = size
            frame.BackgroundColor3 = Color3.new(255 / 255, 98 / 255, 239 / 255)
            frame.BackgroundTransparency = 0.2
            frame.BorderColor3 = Color3.new(255 / 255, 98 / 255, 239 / 255)
            frame.BorderSizePixel = 1
            frame.Parent = f0
            frame.Visible = BoxESP
        end

        createBoxFrame(UDim2.new(0, 0, 0, 0), UDim2.new(1, 0, 0.01, 0)) 
        createBoxFrame(UDim2.new(0, 0, 0.999, 0), UDim2.new(1, 0, 0.01, 0)) 
        createBoxFrame(UDim2.new(1, 0, 0, 0), UDim2.new(-0.01, 0, 1, 0)) 
        createBoxFrame(UDim2.new(0, 0, 0, 0), UDim2.new(0.01, 0, 1, 0))

        if head and not HRP:FindFirstChild("Nesp") then
            local bg2 = Instance.new("BillboardGui")
            bg2.Name = "Nesp"
            bg2.Adornee = head
            bg2.Size = UDim2.new(0, 200, 0, 50)
            bg2.StudsOffset = Vector3.new(0, 2.5, 0)
            bg2.AlwaysOnTop = true
            bg2.Parent = HRP

            local n = Instance.new("TextLabel")
            n.Name = "Name"
            n.Parent = bg2
            n.BackgroundTransparency = 1
            n.Position = UDim2.new(0, 0, 0, 0)
            n.Size = UDim2.new(0, 200, 0, 50)
            n.Font = Enum.Font.Michroma
            n.Text = character.Name
            n.TextColor3 = Color3.new(255 / 255, 98 / 255, 239 / 255)
            n.TextSize = 16
            n.TextStrokeColor3 = Color3.new(0, 0, 0)
            n.TextStrokeTransparency = 0.4
            n.Visible = NameESP
        end


        local pv0 = Instance.new("BillboardGui")
        pv0.Name = "HealthUI"
        pv0.Adornee = HRP
        pv0.AlwaysOnTop = true
        pv0.Parent = HRP
        pv0.Size = UDim2.new(0.5, 0, 6, 0)
        pv0.StudsOffset = Vector3.new(-2.5, 0.2, 0)

        local pv1 = Instance.new("Frame")
        pv1.Name = "Health"
        pv1.BackgroundTransparency = 0.2
        pv1.Parent = pv0
        pv1.Position = UDim2.new(0.2, 0, 1, 0)
        pv1.Visible = HealthESP


        if humanoid and humanoid.Health >= 80 then
            pv1.BackgroundColor3 = Color3.new(37/255, 255/255, 25/255)
            pv1.Size = UDim2.new(0.81, 0, -(humanoid.Health / humanoid.MaxHealth), 0)
        else
            if humanoid.Health <= 0 then
                pv1.Size = UDim2.new(0.81, 0, 0, 0)
            else
                if humanoid.Health < 80 and humanoid.Health >= 60 then
                    pv1.BackgroundColor3 = Color3.new(235/255, 255/255, 15/255)
                    pv1.Size = UDim2.new(0.81, 0, -(humanoid.Health / humanoid.MaxHealth), 0)
                else
                    if humanoid.Health < 60 and humanoid.Health >= 40 then
                        pv1.BackgroundColor3 = Color3.new(220/255, 127/255, 16/255)
                        pv1.Size = UDim2.new(0.81, 0, -(humanoid.Health / humanoid.MaxHealth), 0)
                    else
                        if humanoid.Health < 40 and humanoid.Health >= 20 then
                            pv1.BackgroundColor3 = Color3.new(157/255, 15/255, 7/255)
                            pv1.Size = UDim2.new(0.81, 0, -(humanoid.Health / humanoid.MaxHealth), 0)
                        end
                    end
                end
            end
        end
    end
end

local function removeESP(character)
    local HRP = character:FindFirstChild("HumanoidRootPart")
    if HRP then
        for _, child in ipairs(HRP:GetChildren()) do
            if child:IsA("BillboardGui") and (child.Name == "Esp" or child.Name == "Nesp" or child.Name == "HealthUI") then
                child:Destroy()
            end
        end
    end
end

local function updateESP()
    for _, character in ipairs(plrs:GetChildren()) do
        if character:IsA("Model") and character ~= lplr.Character then
            removeESP(character)
            createESP(character, HealthESP, BoxESP, NameESP)
        end
    end
end

plr.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        local humanoid = character:WaitForChild("Humanoid")
        wait(1)
        createESP(character, HealthESP, BoxESP, NameESP)
    end)
end)

for _, player in ipairs(plr:GetPlayers()) do
    if player ~= lplr then
        player.CharacterAdded:Connect(function(character)
            local humanoid = character:WaitForChild("Humanoid")
            wait(1)
            createESP(character, HealthESP, BoxESP, NameESP)
        end)
        if player.Character then
            local humanoid = player.Character:WaitForChild("Humanoid")
            createESP(player.Character, HealthESP, BoxESP, NameESP)
        end
    end
end

while wait(1) do
    updateESP()
end