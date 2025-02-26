-------------------------------
-- ESP & BigHead Script with UI
-------------------------------

-- Services and Variables
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local lplr = Players.LocalPlayer

-- Set or Default Global Settings
getgenv().HealthESP   = getgenv().HealthESP   or false
getgenv().NameESP     = getgenv().NameESP     or true
getgenv().BoxESP      = getgenv().BoxESP      or false
getgenv().bigHead     = getgenv().bigHead     or true
getgenv().bigHeadSize = getgenv().bigHeadSize or 2




--------------------------------
-- BigHead Functions
--------------------------------




local function applyBigHead(character)
    if character and character:IsA("Model") and character ~= lplr.Character then
        local head = character:FindFirstChild("Head")
        if head and (head:IsA("MeshPart") or head:IsA("Part")) then
            -- Store original size if not already stored
            if not head:GetAttribute("OriginalSize") then
                head:SetAttribute("OriginalSize", head.Size)
            end
            head.Size = Vector3.new(getgenv().bigHeadSize, getgenv().bigHeadSize, getgenv().bigHeadSize)
            head.CanCollide = false
            head.CanTouch = true
            head.CanQuery = true
            head:SetAttribute("BigHeadApplied", true)
        end
    end
end

local function removeBigHead(character)
    if character and character:IsA("Model") and character ~= lplr.Character then
        local head = character:FindFirstChild("Head")
        if head and head:GetAttribute("BigHeadApplied") then
            local originalSize = head:GetAttribute("OriginalSize")
            if originalSize then
                head.Size = originalSize
            end
            head:SetAttribute("BigHeadApplied", nil)
            head:SetAttribute("OriginalSize", nil)
        end
    end
end

local function updateBigHead()
    for _, character in ipairs(Workspace:GetChildren()) do
        if character:IsA("Model") and character ~= lplr.Character then
            if getgenv().bigHead then
                applyBigHead(character)
            else
                removeBigHead(character)
            end
        end
    end
end



--------------------------------
-- ESP Functions
--------------------------------



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

local function createESP(character)
    removeESP(character)
    
    local head = character:FindFirstChild("Head")
    local HRP = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChild("Humanoid")
    
    if HRP and HRP:IsA("Part") and humanoid then
        -- Main ESP Gui
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
            frame.BackgroundColor3 = Color3.new(255/255, 98/255, 239/255)
            frame.BackgroundTransparency = 0.2
            frame.BorderColor3 = Color3.new(255/255, 98/255, 239/255)
            frame.BorderSizePixel = 1
            frame.Parent = f0
            frame.Visible = getgenv().BoxESP
        end

        createBoxFrame(UDim2.new(0, 0, 0, 0), UDim2.new(1, 0, 0.01, 0))
        createBoxFrame(UDim2.new(0, 0, 0.999, 0), UDim2.new(1, 0, 0.01, 0))
        createBoxFrame(UDim2.new(1, 0, 0, 0), UDim2.new(-0.01, 0, 1, 0))
        createBoxFrame(UDim2.new(0, 0, 0, 0), UDim2.new(0.01, 0, 1, 0))

        -- Name ESP (if enabled)
        if head and getgenv().NameESP then
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
            n.TextColor3 = Color3.new(255/255, 98/255, 239/255)
            n.TextSize = 16
            n.TextStrokeColor3 = Color3.new(0, 0, 0)
            n.TextStrokeTransparency = 0.4
        end

        -- Health ESP
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
        pv1.Visible = getgenv().HealthESP

        local function updateHealth()
            if humanoid.Health >= 80 then
                pv1.BackgroundColor3 = Color3.new(37/255, 255/255, 25/255)
            elseif humanoid.Health < 80 and humanoid.Health >= 60 then
                pv1.BackgroundColor3 = Color3.new(235/255, 255/255, 15/255)
            elseif humanoid.Health < 60 and humanoid.Health >= 40 then
                pv1.BackgroundColor3 = Color3.new(220/255, 127/255, 16/255)
            elseif humanoid.Health < 40 and humanoid.Health >= 20 then
                pv1.BackgroundColor3 = Color3.new(157/255, 15/255, 7/255)
            else
                pv1.BackgroundColor3 = Color3.new(1, 0, 0)
            end
            pv1.Size = UDim2.new(0.81, 0, -(humanoid.Health / humanoid.MaxHealth), 0)
        end

        updateHealth()
        humanoid.HealthChanged:Connect(updateHealth)
    end
end

local function updateESP()
    for _, character in ipairs(Workspace:GetChildren()) do
        if character:IsA("Model") and character ~= lplr.Character then
            createESP(character)
        end
    end
end

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        wait(1)
        createESP(character)
        if getgenv().bigHead then
            applyBigHead(character)
        else
            removeBigHead(character)
        end
    end)
end)

for _, player in ipairs(Players:GetPlayers()) do
    if player ~= lplr then
        player.CharacterAdded:Connect(function(character)
            wait(1)
            createESP(character)
            if getgenv().bigHead then
                applyBigHead(character)
            else
                removeBigHead(character)
            end
        end)
        if player.Character then
            createESP(player.Character)
            if getgenv().bigHead then
                applyBigHead(player.Character)
            else
                removeBigHead(player.Character)
            end
        end
    end
end


getgenv().updateESP = updateESP
getgenv().updateBigHead = updateBigHead

updateESP()
updateBigHead()
