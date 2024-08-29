
local NotificationHolder = loadstring(game:HttpGet("https://raw.githubusercontent.com/BocusLuke/UI/main/STX/Module.Lua"))()
local Notification = loadstring(game:HttpGet("https://raw.githubusercontent.com/BocusLuke/UI/main/STX/Client.Lua"))()

Notification:Notify(
    {Title = "Creepy Client V2.4", Description = "Hi "..game.Players.LocalPlayer.Name.." you game id is "..game.GameId.." you executor is "..identifyexecutor""},
    {OutlineColor = Color3.fromRGB(80, 80, 80),Time = 5, Type = "image"},
    {Image = "http://www.roblox.com/asset/?id=6023426923", ImageColor = Color3.fromRGB(255, 255, 255)}
)


local success, Library = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/DarkSuffer/BasicallyAnDoors-EDITED/main/uilibs/Mobile.lua"))()
end)

local GUIWindow = Library:CreateWindow({
    Name = "Creepy Client V2.4",
    Themeable = false
})

local GUI = GUIWindow:CreateTab({
    Name = "主功能"
})

local window_player = GUI:CreateSection({
    Name = "玩家"
})

local camfovslider = window_player:AddSlider({
    Name = "FOV",
    Value = 70,
    Min = 50,
    Max = 120,
    Callback = function(Value)
        game:GetService("Workspace").CurrentCamera.FieldOfView = Value
    end
})

local PlayerWalkSpeedSlider = window_player:AddSlider({
    Name = "Speed",
    Value = 20,
    Min = 1,
    Max = 75,
    Callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
    end
})

local PlayerGravitySlider = window_player:AddSlider({
    Name = "Gravity",
    Value = 1,
    Min = 1,
    Max = 100,
    Callback = function(Value)
        game.Workspace.Gravity = Value
    end
})

local PlayerJumpPowerSlider = window_player:AddSlider({
    Name = "JumpPower",
    Value = 1,
    Min = 1,
    Max = 50,
    Callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = Value
    end
})

local playerESP = window_player:AddToggle({
    Name = "Freecam",
    Default = false,
    Callback = function(state)
        local player = game.Players.LocalPlayer
        local char = player.Character
        local runService = game:GetService("RunService")
        local camera = workspace.CurrentCamera
        local speed = 1
        local touchControls = {}

        local function isMobile()
            return UserInputService.TouchEnabled and not UserInputService.MouseEnabled
        end

        if state then
            camera.CameraType = Enum.CameraType.Scriptable
            if isMobile() then
                _G.Freecam = runService.RenderStepped:Connect(function()
                    local moveDirection = Vector3.new()
                    if touchControls["MoveForward"] then
                        moveDirection = moveDirection + camera.CFrame.LookVector
                    end
                    if touchControls["MoveBackward"] then
                        moveDirection = moveDirection - camera.CFrame.LookVector
                    end
                    if touchControls["MoveLeft"] then
                        moveDirection = moveDirection - camera.CFrame.RightVector
                    end
                    if touchControls["MoveRight"] then
                        moveDirection = moveDirection + camera.CFrame.RightVector
                    end
                    if touchControls["MoveUp"] then
                        moveDirection = moveDirection + camera.CFrame.UpVector
                    end
                    if touchControls["MoveDown"] then
                        moveDirection = moveDirection - camera.CFrame.UpVector
                    end

                    camera.CFrame = camera.CFrame + moveDirection * speed
                end)

                UserInputService.TouchStarted:Connect(function(touch, gameProcessedEvent)
                    if not gameProcessedEvent then
                        if touch.Position.Y < workspace.CurrentCamera.ViewportSize.Y / 2 then
                            touchControls["MoveForward"] = true
                        else
                            touchControls["MoveBackward"] = true
                        end
                    end
                end)

                UserInputService.TouchEnded:Connect(function(touch, gameProcessedEvent)
                    if not gameProcessedEvent then
                        touchControls["MoveForward"] = false
                        touchControls["MoveBackward"] = false
                    end
                end)
            else
                _G.Freecam = runService.RenderStepped:Connect(function()
                    local moveDirection = Vector3.new()
                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                        moveDirection = moveDirection + camera.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                        moveDirection = moveDirection - camera.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                        moveDirection = moveDirection - camera.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                        moveDirection = moveDirection + camera.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Q) then
                        moveDirection = moveDirection - camera.CFrame.UpVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.E) then
                        moveDirection = moveDirection + camera.CFrame.UpVector
                    end

                    camera.CFrame = camera.CFrame + moveDirection * speed
                end)
            end
        else
            if _G.Freecam then
                _G.Freecam:Disconnect()
                _G.Freecam = nil
            end
            camera.CameraType = Enum.CameraType.Custom
        end
    end
})

local vampire = GUI:CreateSection({
    Name = "thirsy Vampire"
})

local playerESP = vampire:AddToggle({
    Name = "Player ESP",
    Default = false,
    Callback = function(state)
        for _, player in pairs(game.Players:GetPlayers()) do
            if player ~= game.Players.LocalPlayer then
                if state then
                    local highlight = Instance.new("Highlight")
                    highlight.Parent = player.Character
                    highlight.Adornee = player.Character

                    local billboard = Instance.new("BillboardGui")
                    billboard.Parent = player.Character
                    billboard.Adornee = player.Character
                    billboard.Size = UDim2.new(0, 100, 0, 100)
                    billboard.StudsOffset = Vector3.new(0, 3, 0)
                    billboard.AlwaysOnTop = true

                    local nameLabel = Instance.new("TextLabel")
                    nameLabel.Parent = billboard
                    nameLabel.Size = UDim2.new(1, 0, 1, 0)
                    nameLabel.BackgroundTransparency = 1
                    nameLabel.Text = player.Name
                    nameLabel.TextColor3 = Color3.new(1, 1, 1)
                    nameLabel.TextStrokeTransparency = 0.5
                    nameLabel.TextScaled = true

                    local circle = Instance.new("ImageLabel")
                    circle.Parent = billboard
                    circle.Size = UDim2.new(0, 50, 0, 50)
                    circle.Position = UDim2.new(0.5, 0, 0.5, 0) -- Center the circle
                    circle.AnchorPoint = Vector2.new(0.5, 0.5) -- Set the anchor point to the center
                    circle.BackgroundTransparency = 1
                    circle.Image = "rbxassetid://2200552246" -- Replace with your circle image asset ID
                else
                    if player.Character:FindFirstChildOfClass("Highlight") then
                        player.Character:FindFirstChildOfClass("Highlight"):Destroy()
                    end
                    if player.Character:FindFirstChildOfClass("BillboardGui") then
                        player.Character:FindFirstChildOfClass("BillboardGui"):Destroy()
                    end
                end
            end
        end
    end
})

local playerESP = vampire:AddToggle({
    Name = "No cilp",
    Default = false,
    Callback = function(state)
        local player = game.Players.LocalPlayer
        local char = player.Character
        local runService = game:GetService("RunService")
        if state then
            _G.NoClip = runService.Stepped:Connect(function()
                for _, v in pairs(char:GetDescendants()) do
                    if v:IsA("BasePart") then
                        v.CanCollide = false
                    end
                end
            end)
        else
            if _G.NoClip then
                _G.NoClip:Disconnect()
                _G.NoClip = nil
            end
            for _, v in pairs(char:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.CanCollide = true
                end
            end
        end
    end
})

local invisibilityToggle = vampire:AddToggle({
    Name = "Invisibility",
    Default = false,
    Callback = function(state)
        local player = game.Players.LocalPlayer
        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            if state then
                humanoid:ChangeState(Enum.HumanoidStateType.Physics)
                player.Character.Head.Transparency = 1
                player.Character.Torso.Transparency = 1
                for _, part in pairs(player.Character:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.Transparency = 1
                        part.CanCollide = false
                    end
                end
            else
                humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
                player.Character.Head.Transparency = 0
                player.Character.Torso.Transparency = 0
                for _, part in pairs(player.Character:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.Transparency = 0
                        part.CanCollide = true
                    end
                end
            end
        else
            warn("Humanoid not found!")
        end
    end
})

local prison = GUI:CreateSection({
    Name = "Prison life"
})

local teleportLocations = {
    ["Yard"] = CFrame.new(50, 10, 50),
    ["Cafeteria"] = CFrame.new(100, 10, 100),
    ["Cells"] = CFrame.new(150, 10, 150),
    ["Armory"] = CFrame.new(200, 10, 200)
}

for location, cframe in pairs(teleportLocations) do
    prison:AddButton({
        Name = "Teleport to " .. location,
        Callback = function()
            local player = game.Players.LocalPlayer
            player.Character.HumanoidRootPart.CFrame = cframe
        end
    })
end

-- Adding buttons to switch teams
prison:AddButton({
    Name = "Switch to Inmate",
    Callback = function()
        local player = game.Players.LocalPlayer
        workspace.Remote.TeamEvent:FireServer("Bright orange")
        workspace.Remote.loadchar:InvokeServer(player.Name)
    end
})

prison:AddButton({
    Name = "Switch to Guards",
    Callback = function()
        local player = game.Players.LocalPlayer
        workspace.Remote.TeamEvent:FireServer("Bright blue")
        workspace.Remote.loadchar:InvokeServer(player.Name)
    end
})

prison:AddButton({
    Name = "Switch to Neutral",
    Callback = function()
        local player = game.Players.LocalPlayer
        workspace.Remote.TeamEvent:FireServer("Medium stone grey")
        workspace.Remote.loadchar:InvokeServer(player.Name)
    end
})

-- Adding button to switch to Criminal
prison:AddButton({
    Name = "Switch to Criminal",
    Callback = function()
        local player = game.Players.LocalPlayer
        player.Character.HumanoidRootPart.CFrame = CFrame.new(500, 10, 500)
        wait(1)
        workspace.Remote.TeamEvent:FireServer("Bright red")
        workspace.Remote.loadchar:InvokeServer(player.Name)
    end
})

local killAuraToggle = prison:AddToggle({
    Name = "Kill Aura(May be invalid)",
    Default = false,
    Callback = function(state)
        local player = game.Players.LocalPlayer
        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            while state do
                for _, target in pairs(game.Players:GetPlayers()) do
                    if target ~= player and target.Character and target.Character:FindFirstChildOfClass("Humanoid") then
                        local distance = (player.Character.HumanoidRootPart.Position - target.Character.HumanoidRootPart.Position).magnitude
                        if distance < 10 then
                            target.Character:FindFirstChildOfClass("Humanoid"):TakeDamage(10)
                        end
                    end
                end
                wait(0.1)
            end
        else
            warn("Humanoid not found!")
        end
    end
})

local playerESP = prison:AddToggle({
    Name = "Player ESP",
    Default = false,
    Callback = function(state)
        for _, player in pairs(game.Players:GetPlayers()) do
            if player ~= game.Players.LocalPlayer then
                if state then
                    local highlight = Instance.new("Highlight")
                    highlight.Parent = player.Character
                    highlight.Adornee = player.Character

                    local billboard = Instance.new("BillboardGui")
                    billboard.Parent = player.Character
                    billboard.Adornee = player.Character
                    billboard.Size = UDim2.new(0, 100, 0, 100)
                    billboard.StudsOffset = Vector3.new(0, 3, 0)
                    billboard.AlwaysOnTop = true

                    local nameLabel = Instance.new("TextLabel")
                    nameLabel.Parent = billboard
                    nameLabel.Size = UDim2.new(1, 0, 1, 0)
                    nameLabel.BackgroundTransparency = 1
                    nameLabel.Text = player.Name
                    nameLabel.TextColor3 = Color3.new(1, 1, 1)
                    nameLabel.TextStrokeTransparency = 0.5
                    nameLabel.TextScaled = true

                    local circle = Instance.new("ImageLabel")
                    circle.Parent = billboard
                    circle.Size = UDim2.new(0, 50, 0, 50)
                    circle.Position = UDim2.new(0.5, 0, 0.5, 0) -- Center the circle
                    circle.AnchorPoint = Vector2.new(0.5, 0.5) -- Set the anchor point to the center
                    circle.BackgroundTransparency = 1
                    circle.Image = "rbxassetid://2200552246" -- Replace with your circle image asset ID
                else
                    if player.Character:FindFirstChildOfClass("Highlight") then
                        player.Character:FindFirstChildOfClass("Highlight"):Destroy()
                    end
                    if player.Character:FindFirstChildOfClass("BillboardGui") then
                        player.Character:FindFirstChildOfClass("BillboardGui"):Destroy()
                    end
                end
            end
        end
    end
})

local playerESP = prison:AddToggle({
    Name = "No cilp",
    Default = false,
    Callback = function(state)
        local player = game.Players.LocalPlayer
        local char = player.Character
        local runService = game:GetService("RunService")
        if state then
            _G.NoClip = runService.Stepped:Connect(function()
                for _, v in pairs(char:GetDescendants()) do
                    if v:IsA("BasePart") then
                        v.CanCollide = false
                    end
                end
            end)
        else
            if _G.NoClip then
                _G.NoClip:Disconnect()
                _G.NoClip = nil
            end
            for _, v in pairs(char:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.CanCollide = true
                end
            end
        end
    end
})

local GUI = GUIWindow:CreateTab({
    Name = "Doors"
})

local Doors = GUI:CreateSection({
    Name = "Function"
})

-- Sliders
local PlayerWalkSpeedSlider = Doors:AddSlider({
    Name = "Speed",
    Value = 20,
    Min = 20,
    Max = 22,
    Callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
    end
})

local playerESP = Doors:AddToggle({
    Name = "Player ESP",
    Default = false,
    Callback = function(state)
        if state then
            _G.espInstances = {}
            for _, player in pairs(game.Players:GetPlayers()) do
                if player.Character then
                    local espInstance = esp(player.Character, Color3.new(0, 1, 0), player.Character:FindFirstChild("HumanoidRootPart"), player.Name)
                    table.insert(_G.espInstances, espInstance)
                end
            end
        else
            if _G.espInstances then
                for _, espInstance in pairs(_G.espInstances) do
                    espInstance.delete()
                end
                _G.espInstances = nil
            end
        end
    end
})

-- ESP function definition (assuming it already exists)
function esp(what, color, core, name)
    local parts
    if typeof(what) == "Instance" then
        if what:IsA("Model") then
            parts = what:GetChildren()
        elseif what:IsA("BasePart") then
            parts = {what, table.unpack(what:GetChildren())}
        end
    elseif typeof(what) == "table" then
        parts = what
    end

    local bill
    local boxes = {}

    for i, v in pairs(parts) do
        if v:IsA("BasePart") then
            local box = Instance.new("BoxHandleAdornment")
            box.Size = v.Size
            box.AlwaysOnTop = true
            box.ZIndex = 1
            box.AdornCullingMode = Enum.AdornCullingMode.Never
            box.Color3 = color
            box.Transparency = 0.7
            box.Adornee = v
            box.Parent = game.CoreGui

            table.insert(boxes, box)

            task.spawn(function()
                while box do
                    if box.Adornee == nil or not box.Adornee:IsDescendantOf(workspace) then
                        box.Adornee = nil
                        box.Visible = false
                        box:Destroy()
                    end
                    task.wait()
                end
            end)
        end
    end

    if core and name then
        bill = Instance.new("BillboardGui", game.CoreGui)
        bill.AlwaysOnTop = true
        bill.Size = UDim2.new(0, 100, 0, 50)
        bill.Adornee = core
        bill.MaxDistance = 2000

        local mid = Instance.new("Frame", bill)
        mid.AnchorPoint = Vector2.new(0.5, 0.5)
        mid.BackgroundColor3 = color
        mid.Size = UDim2.new(0, 8, 0, 8)
        mid.Position = UDim2.new(0.5, 0, 0.5, 0)
        Instance.new("UICorner", mid).CornerRadius = UDim.new(1, 0)
        Instance.new("UIStroke", mid)

        local txt = Instance.new("TextLabel", bill)
        txt.AnchorPoint = Vector2.new(0.5, 0.5)
        txt.BackgroundTransparency = 1
        txt.BackgroundColor3 = color
        txt.TextColor3 = color
        txt.Size = UDim2.new(1, 0, 0, 20)
        txt.Position = UDim2.new(0.5, 0, 0.7, 0)
        txt.Text = name
        Instance.new("UIStroke", txt)

        task.spawn(function()
            while bill do
                if bill.Adornee == nil or not bill.Adornee:IsDescendantOf(workspace) then
                    bill.Enabled = false
                    bill.Adornee = nil
                    bill:Destroy()
                end
                task.wait()
            end
        end)
    end

    local ret = {}

    ret.delete = function()
        for i, v in pairs(boxes) do
            v.Adornee = nil
            v.Visible = false
            v:Destroy()
        end

        if bill then
            bill.Enabled = false
            bill.Adornee = nil
            bill:Destroy()
        end
    end

    return ret
end

-- Define Player ESP function
function playerEsp()
    for _, player in pairs(game.Players:GetPlayers()) do
        if player.Character then
            esp(player.Character, Color3.new(0, 1, 0), player.Character:FindFirstChild("HumanoidRootPart"), player.Name)
        end
    end
end	

local playerESP = Doors:AddToggle({
    Name = "No cilp",
    Default = false,
    Callback = function(state)
        local player = game.Players.LocalPlayer
        local char = player.Character
        local runService = game:GetService("RunService")
        if state then
            _G.NoClip = runService.Stepped:Connect(function()
                for _, v in pairs(char:GetDescendants()) do
                    if v:IsA("BasePart") then
                        v.CanCollide = false
                    end
                end
            end)
        else
            if _G.NoClip then
                _G.NoClip:Disconnect()
                _G.NoClip = nil
            end
            for _, v in pairs(char:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.CanCollide = true
                end
            end
        end
    end
})

vampire:AddLabel({ Name = "Tip:开的时候不要开演都不带演" })

local window_credits_tab = GUIWindow:CreateTab({ Name = "创作者" })
local window_credits = window_credits_tab:CreateSection({
	Name = "创作/公告"
})
window_credits:AddLabel({ Name = "Dev:MrWhite & FHOff" })
window_credits:AddLabel({ Name = "QQ:3756646428" })
window_credits:AddLabel({ Name = "欢迎使用我的朋友:"..game.Players.LocalPlayer.Name.."" })
window_credits:AddLabel({ Name = "注入器:"..identifyexecutor"" })
window_credits:AddLabel({ Name = "你正处在游戏:"..game.GameId.."" })

local playerESP = Doors:AddToggle({
    Name = "Look aura",
    Default = false,
    Callback = function(state)
        if state then
            -- open
            autoInteract = true

            -- getplayer
            local player = game.Players.LocalPlayer

            -- check
            workspace.CurrentRooms.ChildAdded:Connect(function(room)
                room.DescendantAdded:Connect(function(descendant)
                    if descendant:IsA("Model") then
                        local prompt = nil
                        if descendant.Name == "DrawerContainer" then
                            prompt = descendant:WaitForChild("Knobs"):WaitForChild("ActivateEventPrompt")
                        elseif descendant.Name == "GoldPile" then
                            prompt = descendant:WaitForChild("LootPrompt")
                        elseif descendant.Name:sub(1, 8) == "ChestBox" or descendant.Name == "RolltopContainer" then
                            prompt = descendant:WaitForChild("ActivateEventPrompt")
                        end

                        if prompt then
                            local interactions = prompt:GetAttribute("Interactions")
                            if not interactions then
                                task.spawn(function()
                                    while autoInteract and not prompt:GetAttribute("Interactions") do
                                        task.wait(0.1)
                                        if player:DistanceFromCharacter(descendant.PrimaryPart.Position) <= 12 then
                                            fireproximityprompt(prompt)
                                        end
                                    end
                                end)
                            end
                        end
                    end
                end)
            end)

            -- check2
            for _, room in pairs(workspace.CurrentRooms:GetChildren()) do
                for _, descendant in pairs(room:GetDescendants()) do
                    if descendant:IsA("Model") then
                        local prompt = nil
                        if descendant.Name == "DrawerContainer" then
                            prompt = descendant:WaitForChild("Knobs"):WaitForChild("ActivateEventPrompt")
                        elseif descendant.Name == "GoldPile" then
                            prompt = descendant:WaitForChild("LootPrompt")
                        elseif descendant.Name:sub(1, 8) == "ChestBox" or descendant.Name == "RolltopContainer" then
                            prompt = descendant:WaitForChild("ActivateEventPrompt")
                        end

                        if prompt then
                            local interactions = prompt:GetAttribute("Interactions")
                            if not interactions then
                                task.spawn(function()
                                    while autoInteract and not prompt:GetAttribute("Interactions") do
                                        task.wait(0.1)
                                        if player:DistanceFromCharacter(descendant.PrimaryPart.Position) <= 12 then
                                            fireproximityprompt(prompt)
                                        end
                                    end
                                end)
                            end
                        end
                    end
                end
            end
        else
            -- close
            autoInteract = false
        end
    end
})

local playerESP = Doors:AddToggle({
    Name = "Enity Message",
    Default = false,
    Callback = function(state)
        if state then
            local entityNames = {"RushMoving", "AmbushMoving", "Snare", "A60", "A120", "A90", "Eyes", "JeffTheKiller"}  --enity
            local NotificationHolder = loadstring(game:HttpGet("https://raw.githubusercontent.com/BocusLuke/UI/main/STX/Module.Lua"))() --Lib1
            local Notification = loadstring(game:HttpGet("https://raw.githubusercontent.com/BocusLuke/UI/main/STX/Client.Lua"))() --Lib2

            -- Ensure flags and plr are defined
            local flags = flags or {} --Prevent Error
            local plr = game.Players.LocalPlayer --Prevent Error2

            local function notifyEntitySpawn(entity)
                Notification:Notify(
                    {Title = "Creepy client V2", Description = entity.Name:gsub("Moving", ""):lower() .. " Spawned!"},
                    {OutlineColor = Color3.fromRGB(80, 80, 80), Time = 5, Type = "image"},
                    {Image = "http://www.roblox.com/asset/?id=10802751252", ImageColor = Color3.fromRGB(255, 255, 255)}
                )
            end

            local function onChildAdded(child)
                if table.find(entityNames, child.Name) then
                    repeat
                        task.wait()
                    until plr:DistanceFromCharacter(child:GetPivot().Position) < 1000 or not child:IsDescendantOf(workspace)
                    
                    if child:IsDescendantOf(workspace) then
                        notifyEntitySpawn(child)
                    end
                end
            end

            -- Infinite loop to keep the script running and check for hintrush flag
            local running = true
            while running do
                local connection = workspace.ChildAdded:Connect(onChildAdded)
                
                repeat
                    task.wait(1) -- Adjust the wait time as needed
                until not flags.hintrush or not running
                
                connection:Disconnect()
            end 
        else 
            -- Close message or any other cleanup if needed
            running = false
        end
    end
})

local doorESPToggle = Doors:AddToggle({
    Name = "Door ESP",
    Default = false,
    Callback = function(state)
        if state then
            _G.doorESPInstances = {}
            local esptable = {doors = {}}
            local flags = {espdoors = true}

            local function esp(what, color, core, name)
                local parts
                
                if typeof(what) == "Instance" then
                    if what:IsA("Model") then
                        parts = what:GetChildren()
                    elseif what:IsA("BasePart") then
                        parts = {what, table.unpack(what:GetChildren())}
                    end
                elseif typeof(what) == "table" then
                    parts = what
                end
                
                local bill
                local boxes = {}
                
                for i, v in pairs(parts) do
                    if v:IsA("BasePart") then
                        local box = Instance.new("BoxHandleAdornment")
                        box.Size = v.Size
                        box.AlwaysOnTop = true
                        box.ZIndex = 1
                        box.AdornCullingMode = Enum.AdornCullingMode.Never
                        box.Color3 = color
                        box.Transparency = 1
                        box.Adornee = v
                        box.Parent = game.CoreGui
                        
                        table.insert(boxes, box)
                        
                        task.spawn(function()
                            while box do
                                if box.Adornee == nil or not box.Adornee:IsDescendantOf(workspace) then
                                    box.Adornee = nil
                                    box.Visible = false
                                    box:Destroy()
                                end  
                                task.wait()
                            end
                        end)
                    end
                end
                
                if core and name then
                    bill = Instance.new("BillboardGui", game.CoreGui)
                    bill.AlwaysOnTop = true
                    bill.Size = UDim2.new(0, 400, 0, 100)
                    bill.Adornee = core
                    bill.MaxDistance = 2000
                    
                    local mid = Instance.new("Frame", bill)
                    mid.AnchorPoint = Vector2.new(0.5, 0.5)
                    mid.BackgroundColor3 = color
                    mid.Size = UDim2.new(0, 8, 0, 8)
                    mid.Position = UDim2.new(0.5, 0, 0.5, 0)
                    Instance.new("UICorner", mid).CornerRadius = UDim.new(1, 0)
                    Instance.new("UIStroke", mid)
                    
                    local txt = Instance.new("TextLabel", bill)
                    txt.AnchorPoint = Vector2.new(0.5, 0.5)
                    txt.BackgroundTransparency = 1
                    txt.BackgroundColor3 = color
                    txt.TextColor3 = color
                    txt.Size = UDim2.new(1, 0, 0, 20)
                    txt.Position = UDim2.new(0.5, 0, 0.7, 0)
                    txt.Text = name
                    Instance.new("UIStroke", txt)
                    
                    task.spawn(function()
                        while bill do
                            if bill.Adornee == nil or not bill.Adornee:IsDescendantOf(workspace) then
                                bill.Enabled = false
                                bill.Adornee = nil
                                bill:Destroy() 
                            end  
                            task.wait()
                        end
                    end)
                end
                
                local ret = {}
                
                ret.delete = function()
                    for i, v in pairs(boxes) do
                        v.Adornee = nil
                        v.Visible = false
                        v:Destroy()
                    end
                    
                    if bill then
                        bill.Enabled = false
                        bill.Adornee = nil
                        bill:Destroy() 
                    end
                end
                
                return ret 
            end

            local function setup(room)
                local door = room:WaitForChild("Door"):WaitForChild("Door")
                
                task.wait(0.1)
                local h = esp(door, Color3.fromRGB(90, 255, 40), door, "Door")
                table.insert(esptable.doors, h)
                
                door:WaitForChild("Open").Played:Connect(function()
                    h.delete()
                end)
                
                door.AncestryChanged:Connect(function()
                    h.delete()
                end)
            end
            
            local addconnect
            addconnect = workspace.CurrentRooms.ChildAdded:Connect(function(room)
                setup(room)
            end)
            
            for i, room in pairs(workspace.CurrentRooms:GetChildren()) do
                if room:FindFirstChild("Assets") then
                    setup(room) 
                end
            end

            table.insert(_G.doorESPInstances, esptable)

        else
            if _G.doorESPInstances then
                for _, instance in pairs(_G.doorESPInstances) do
                    for _, v in pairs(instance.doors) do
                        v.delete()
                    end
                end
                _G.doorESPInstances = nil
            end
        end
    end
})

local lockerESPToggle = Doors:AddToggle({
    Name = "Locker/Wardrobe ESP",
    Default = false,
    Callback = function(state)
        if state then
            _G.lockerESPInstances = {}
            local esptable = {lockers = {}}
            local flags = {esplocker = true}

            local function esp(what, color, core, name)
                local parts
                
                if typeof(what) == "Instance" then
                    if what:IsA("Model") then
                        parts = what:GetChildren()
                    elseif what:IsA("BasePart") then
                        parts = {what, table.unpack(what:GetChildren())}
                    end
                elseif typeof(what) == "table" then
                    parts = what
                end
                
                local bill
                local boxes = {}
                
                for i, v in pairs(parts) do
                    if v:IsA("BasePart") then
                        local box = Instance.new("BoxHandleAdornment")
                        box.Size = v.Size
                        box.AlwaysOnTop = true
                        box.ZIndex = 1
                        box.AdornCullingMode = Enum.AdornCullingMode.Never
                        box.Color3 = color
                        box.Transparency = 1
                        box.Adornee = v
                        box.Parent = game.CoreGui
                        
                        table.insert(boxes, box)
                        
                        task.spawn(function()
                            while box do
                                if box.Adornee == nil or not box.Adornee:IsDescendantOf(workspace) then
                                    box.Adornee = nil
                                    box.Visible = false
                                    box:Destroy()
                                end  
                                task.wait()
                            end
                        end)
                    end
                end
                
                if core and name then
                    bill = Instance.new("BillboardGui", game.CoreGui)
                    bill.AlwaysOnTop = true
                    bill.Size = UDim2.new(0, 400, 0, 100)
                    bill.Adornee = core
                    bill.MaxDistance = 2000
                    
                    local mid = Instance.new("Frame", bill)
                    mid.AnchorPoint = Vector2.new(0.5, 0.5)
                    mid.BackgroundColor3 = color
                    mid.Size = UDim2.new(0, 8, 0, 8)
                    mid.Position = UDim2.new(0.5, 0, 0.5, 0)
                    Instance.new("UICorner", mid).CornerRadius = UDim.new(1, 0)
                    Instance.new("UIStroke", mid)
                    
                    local txt = Instance.new("TextLabel", bill)
                    txt.AnchorPoint = Vector2.new(0.5, 0.5)
                    txt.BackgroundTransparency = 1
                    txt.BackgroundColor3 = color
                    txt.TextColor3 = color
                    txt.Size = UDim2.new(1, 0, 0, 20)
                    txt.Position = UDim2.new(0.5, 0, 0.7, 0)
                    txt.Text = name
                    Instance.new("UIStroke", txt)
                    
                    task.spawn(function()
                        while bill do
                            if bill.Adornee == nil or not bill.Adornee:IsDescendantOf(workspace) then
                                bill.Enabled = false
                                bill.Adornee = nil
                                bill:Destroy() 
                            end  
                            task.wait()
                        end
                    end)
                end
                
                local ret = {}
                
                ret.delete = function()
                    for i, v in pairs(boxes) do
                        v.Adornee = nil
                        v.Visible = false
                        v:Destroy()
                    end
                    
                    if bill then
                        bill.Enabled = false
                        bill.Adornee = nil
                        bill:Destroy() 
                    end
                end
                
                return ret 
            end

            local function check(v)
                if v:IsA("Model") then
                    task.wait(0.1)
                    if v.Name == "Wardrobe" then
                        local h = esp(v.PrimaryPart, Color3.fromRGB(90, 255, 40), v.PrimaryPart, "Closet")
                        table.insert(esptable.lockers, h) 
                    elseif (v.Name == "Rooms_Locker" or v.Name == "Rooms_Locker_Fridge") then
                        local h = esp(v.PrimaryPart, Color3.fromRGB(90, 255, 40), v.PrimaryPart, "Locker")
                        table.insert(esptable.lockers, h) 
                    end
                end
            end
                
            local function setup(room)
                local assets = room:WaitForChild("Assets")
                
                if assets then
                    local subaddcon
                    subaddcon = assets.DescendantAdded:Connect(function(v)
                        check(v) 
                    end)
                    
                    for i, v in pairs(assets:GetDescendants()) do
                        check(v)
                    end
                    
                    task.spawn(function()
                        repeat task.wait() until not flags.esplocker
                        subaddcon:Disconnect()  
                    end) 
                end 
            end
            
            local addconnect
            addconnect = workspace.CurrentRooms.ChildAdded:Connect(function(room)
                setup(room)
            end)
            
            for i, room in pairs(workspace.CurrentRooms:GetChildren()) do
                setup(room) 
            end

            table.insert(_G.lockerESPInstances, esptable)

	else
            if _G.lockerESPInstances then
                for _, instance in pairs(_G.lockerESPInstances) do
                    for _, v in pairs(instance.lockers) do
                        v.delete()
                    end
                end
                _G.lockerESPInstances = nil
            end
        end
    end
})

local bookESPToggle = Doors:AddToggle({
    Name = "Book ESP",
    Default = false,
    Callback = function(state)
        if state then
            _G.bookESPInstances = {}
            local esptable = {books = {}}
            local flags = {espbooks = true}

            local function esp(what, color, core, name)
                local parts
                
                if typeof(what) == "Instance" then
                    if what:IsA("Model") then
                        parts = what:GetChildren()
                    elseif what:IsA("BasePart") then
                        parts = {what, table.unpack(what:GetChildren())}
                    end
                elseif typeof(what) == "table" then
                    parts = what
                end
                
                local bill
                local boxes = {}
                
                for i, v in pairs(parts) do
                    if v:IsA("BasePart") then
                        local box = Instance.new("BoxHandleAdornment")
                        box.Size = v.Size
                        box.AlwaysOnTop = true
                        box.ZIndex = 1
                        box.AdornCullingMode = Enum.AdornCullingMode.Never
                        box.Color3 = color
                        box.Transparency = 1
                        box.Adornee = v
                        box.Parent = game.CoreGui
                        
                        table.insert(boxes, box)
                        
                        task.spawn(function()
                            while box do
                                if box.Adornee == nil or not box.Adornee:IsDescendantOf(workspace) then
                                    box.Adornee = nil
                                    box.Visible = false
                                    box:Destroy()
                                end  
                                task.wait()
                            end
                        end)
                    end
                end
                
                if core and name then
                    bill = Instance.new("BillboardGui", game.CoreGui)
                    bill.AlwaysOnTop = true
                    bill.Size = UDim2.new(0, 400, 0, 100)
                    bill.Adornee = core
                    bill.MaxDistance = 2000
                    
                    local mid = Instance.new("Frame", bill)
                    mid.AnchorPoint = Vector2.new(0.5, 0.5)
                    mid.BackgroundColor3 = color
                    mid.Size = UDim2.new(0, 8, 0, 8)
                    mid.Position = UDim2.new(0.5, 0, 0.5, 0)
                    Instance.new("UICorner", mid).CornerRadius = UDim.new(1, 0)
                    Instance.new("UIStroke", mid)
                    
                    local txt = Instance.new("TextLabel", bill)
                    txt.AnchorPoint = Vector2.new(0.5, 0.5)
                    txt.BackgroundTransparency = 1
                    txt.BackgroundColor3 = color
                    txt.TextColor3 = color
                    txt.Size = UDim2.new(1, 0, 0, 20)
                    txt.Position = UDim2.new(0.5, 0, 0.7, 0)
                    txt.Text = name
                    Instance.new("UIStroke", txt)
                    
                    task.spawn(function()
                        while bill do
                            if bill.Adornee == nil or not bill.Adornee:IsDescendantOf(workspace) then
                                bill.Enabled = false
                                bill.Adornee = nil
                                bill:Destroy() 
                            end  
                            task.wait()
                        end
                    end)
                end
                
                local ret = {}
                
                ret.delete = function()
                    for i, v in pairs(boxes) do
                        v.Adornee = nil
                        v.Visible = false
                        v:Destroy()
                    end
                    
                    if bill then
                        bill.Enabled = false
                        bill.Adornee = nil
                        bill:Destroy() 
                    end
                end
                
                return ret 
            end

            local function check(v)
                if v:IsA("Model") and (v.Name == "LiveHintBook" or v.Name == "LiveBreakerPolePickup") then
                    task.wait(0.1)
                    
                    local h = esp(v, Color3.fromRGB(255, 255, 255), v.PrimaryPart, "Book")
                    table.insert(esptable.books, h)
                    
                    v.AncestryChanged:Connect(function()
                        if not v:IsDescendantOf(room) then
                            h.delete() 
                        end
                    end)
                end
            end
            
            local function setup(room)
                if room.Name == "50" or room.Name == "100" then
                    room.DescendantAdded:Connect(function(v)
                        check(v) 
                    end)
                    
                    for i, v in pairs(room:GetDescendants()) do
                        check(v)
                    end
                end
            end
            
            local addconnect
            addconnect = workspace.CurrentRooms.ChildAdded:Connect(function(room)
                setup(room)
            end)
            
            for i, room in pairs(workspace.CurrentRooms:GetChildren()) do
                setup(room) 
            end

            table.insert(_G.bookESPInstances, esptable)

	else
            if _G.bookESPInstances then
                for _, instance in pairs(_G.bookESPInstances) do
                    for _, v in pairs(instance.books) do
                        v.delete()
                    end
                end
                _G.bookESPInstances = nil
            end
        end
    end
})

local codeEventToggle = Doors:AddToggle({
    Name = "Code Event",
    Default = false,
    Callback = function(state)
        if state then
            _G.codeEventInstances = {}
            local flags = {getcode = true}

            local function deciphercode()
                local paper = char:FindFirstChild("LibraryHintPaper")
                local hints = plr.PlayerGui:WaitForChild("PermUI"):WaitForChild("Hints")
                
                local code = {[1]="_", [2]="_", [3]="_", [4]="_", [5]="_"}
                    
                if paper then
                    for i, v in pairs(paper:WaitForChild("UI"):GetChildren()) do
                        if v:IsA("ImageLabel") and v.Name ~= "Image" then
                            for i, img in pairs(hints:GetChildren()) do
                                if img:IsA("ImageLabel") and img.Visible and v.ImageRectOffset == img.ImageRectOffset then
                                    local num = img:FindFirstChild("TextLabel").Text
                                    
                                    code[tonumber(v.Name)] = num 
                                end
                            end
                        end
                    end 
                end
                
                return code
            end
            
            local addconnect
            addconnect = char.ChildAdded:Connect(function(v)
                if v:IsA("Tool") and v.Name == "LibraryHintPaper" then
                    task.wait()
                    
                    local code = table.concat(deciphercode())
                    
                    if code:find("_") then
                        Notification:Notify(
                            {Title = "Creepy client V2", Description = "You need Get all Book"},
                            {OutlineColor = Color3.fromRGB(80, 80, 80), Time = 5, Type = "image"},
                            {Image = "http://www.roblox.com/asset/?id=10802751252", ImageColor = Color3.fromRGB(255, 255, 255)}
                        )
                    else
                        Notification:Notify(
                            {Title = "Creepy client V2", Description = "Code is " .. code},
                            {OutlineColor = Color3.fromRGB(80, 80, 80), Time = 5, Type = "image"},
                            {Image = "http://www.roblox.com/asset/?id=10802751252", ImageColor = Color3.fromRGB(255, 255, 255)}
                        )
                    end
                end
            end)
            
            table.insert(_G.codeEventInstances, addconnect)

        else
            if _G.codeEventInstances then
                for _, instance in pairs(_G.codeEventInstances) do
                    instance:Disconnect()
                end
                _G.codeEventInstances = nil
            end
        end
    end
})

local itemESPToggle = Doors:AddToggle({
    Name = "Item ESP",
    Default = false,
    Callback = function(state)
        if state then
            _G.itemESPInstances = {}
            local esptable = {items = {}}
            local flags = {espitems = true}

            local function esp(what, color, core, name)
                local parts
                
                if typeof(what) == "Instance" then
                    if what:IsA("Model") then
                        parts = what:GetChildren()
                    elseif what:IsA("BasePart") then
                        parts = {what, table.unpack(what:GetChildren())}
                    end
                elseif typeof(what) == "table" then
                    parts = what
                end
                
                local bill
                local boxes = {}
                
                for i, v in pairs(parts) do
                    if v:IsA("BasePart") then
                        local box = Instance.new("BoxHandleAdornment")
                        box.Size = v.Size
                        box.AlwaysOnTop = true
                        box.ZIndex = 1
                        box.AdornCullingMode = Enum.AdornCullingMode.Never
                        box.Color3 = color
                        box.Transparency = 1
                        box.Adornee = v
                        box.Parent = game.CoreGui
                        
                        table.insert(boxes, box)
                        
                        task.spawn(function()
                            while box do
                                if box.Adornee == nil or not box.Adornee:IsDescendantOf(workspace) then
                                    box.Adornee = nil
                                    box.Visible = false
                                    box:Destroy()
                                end  
                                task.wait()
                            end
                        end)
                    end
                end
                
                if core and name then
                    bill = Instance.new("BillboardGui", game.CoreGui)
                    bill.AlwaysOnTop = true
                    bill.Size = UDim2.new(0, 400, 0, 100)
                    bill.Adornee = core
                    bill.MaxDistance = 2000
                    
                    local mid = Instance.new("Frame", bill)
                    mid.AnchorPoint = Vector2.new(0.5, 0.5)
                    mid.BackgroundColor3 = color
                    mid.Size = UDim2.new(0, 8, 0, 8)
                    mid.Position = UDim2.new(0.5, 0, 0.5, 0)
                    Instance.new("UICorner", mid).CornerRadius = UDim.new(1, 0)
                    Instance.new("UIStroke", mid)
                    
                    local txt = Instance.new("TextLabel", bill)
                    txt.AnchorPoint = Vector2.new(0.5, 0.5)
                    txt.BackgroundTransparency = 1
                    txt.BackgroundColor3 = color
                    txt.TextColor3 = color
                    txt.Size = UDim2.new(1, 0, 0, 20)
                    txt.Position = UDim2.new(0.5, 0, 0.7, 0)
                    txt.Text = name
                    Instance.new("UIStroke", txt)
                    
                    task.spawn(function()
                        while bill do
                            if bill.Adornee == nil or not bill.Adornee:IsDescendantOf(workspace) then
                                bill.Enabled = false
                                bill.Adornee = nil
                                bill:Destroy() 
                            end  
                            task.wait()
                        end
                    end)
                end
                
                local ret = {}
                
                ret.delete = function()
                    for i, v in pairs(boxes) do
                        v.Adornee = nil
                        v.Visible = false
                        v:Destroy()
                    end
                    
                    if bill then
                        bill.Enabled = false
                        bill.Adornee = nil
                        bill:Destroy() 
                    end
                end
                
                return ret 
            end

            local function check(v)
                if v:IsA("Model") and (v:GetAttribute("Pickup") or v:GetAttribute("PropType")) then
                    task.wait(0.1)
                    
                    local part = (v:FindFirstChild("Handle") or v:FindFirstChild("Prop"))
                    local h = esp(part, Color3.fromRGB(255, 255, 255), part, v.Name)
                    table.insert(esptable.items, h)
                end
            end
            
            local function setup(room)
                local assets = room:WaitForChild("Assets")
                
                if assets then  
                    local subaddcon
                    subaddcon = assets.DescendantAdded:Connect(function(v)
                        check(v) 
                    end)
                    
                    for i, v in pairs(assets:GetDescendants()) do
                        check(v)
                    end
                    
                    task.spawn(function()
                        repeat task.wait() until not flags.espitems
                        subaddcon:Disconnect()  
                    end) 
                end 
            end
            
            local addconnect
            addconnect = workspace.CurrentRooms.ChildAdded:Connect(function(room)
                setup(room)
            end)
            
            for i, room in pairs(workspace.CurrentRooms:GetChildren()) do
                if room:FindFirstChild("Assets") then
                    setup(room) 
                end
            end

            table.insert(_G.itemESPInstances, esptable)

        else
            if _G.itemESPInstances then
                for _, instance in pairs(_G.itemESPInstances) do
                    for _, v in pairs(instance.items) do
                        v.delete()
                    end
                end
                _G.itemESPInstances = nil
            end
        end
    end
})

local entityESPToggle = Doors:AddToggle({
    Name = "Entity ESP",
    Default = false,
    Callback = function(state)
        if state then
            _G.entityESPInstances = {}
            local esptable = {entity = {}}
            local flags = {esprush = true}
            local entitynames = {"RushMoving", "AmbushMoving", "Snare", "A60", "A120", "Eyes", "JeffTheKiller"} 

            local function esp(what, color, core, name)
                local parts
                
                if typeof(what) == "Instance" then
                    if what:IsA("Model") then
                        parts = what:GetChildren()
                    elseif what:IsA("BasePart") then
                        parts = {what, table.unpack(what:GetChildren())}
                    end
                elseif typeof(what) == "table" then
                    parts = what
                end
                
                local bill
                local boxes = {}
                
                for i, v in pairs(parts) do
                    if v:IsA("BasePart") then
                        local box = Instance.new("BoxHandleAdornment")
                        box.Size = v.Size
                        box.AlwaysOnTop = true
                        box.ZIndex = 1
                        box.AdornCullingMode = Enum.AdornCullingMode.Never
                        box.Color3 = color
                        box.Transparency = 1
                        box.Adornee = v
                        box.Parent = game.CoreGui
                        
                        table.insert(boxes, box)
                        
                        task.spawn(function()
                            while box do
                                if box.Adornee == nil or not box.Adornee:IsDescendantOf(workspace) then
                                    box.Adornee = nil
                                    box.Visible = false
                                    box:Destroy()
                                end  
                                task.wait()
                            end
                        end)
                    end
                end
                
                if core and name then
                    bill = Instance.new("BillboardGui", game.CoreGui)
                    bill.AlwaysOnTop = true
                    bill.Size = UDim2.new(0, 400, 0, 100)
                    bill.Adornee = core
                    bill.MaxDistance = 2000
                    
                    local mid = Instance.new("Frame", bill)
                    mid.AnchorPoint = Vector2.new(0.5, 0.5)
                    mid.BackgroundColor3 = color
                    mid.Size = UDim2.new(0, 8, 0, 8)
                    mid.Position = UDim2.new(0.5, 0, 0.5, 0)
                    Instance.new("UICorner", mid).CornerRadius = UDim.new(1, 0)
                    Instance.new("UIStroke", mid)
                    
                    local txt = Instance.new("TextLabel", bill)
                    txt.AnchorPoint = Vector2.new(0.5, 0.5)
                    txt.BackgroundTransparency = 1
                    txt.BackgroundColor3 = color
                    txt.TextColor3 = color
                    txt.Size = UDim2.new(1, 0, 0, 20)
                    txt.Position = UDim2.new(0.5, 0, 0.7, 0)
                    txt.Text = name
                    Instance.new("UIStroke", txt)
                    
                    task.spawn(function()
                        while bill do
                            if bill.Adornee == nil or not bill.Adornee:IsDescendantOf(workspace) then
                                bill.Enabled = false
                                bill.Adornee = nil
                                bill:Destroy() 
                            end  
                            task.wait()
                        end
                    end)
                end
                
                local ret = {}
                
                ret.delete = function()
                    for i, v in pairs(boxes) do
                        v.Adornee = nil
                        v.Visible = false
                        v:Destroy()
                    end
                    
                    if bill then
                        bill.Enabled = false
                        bill.Adornee = nil
                        bill:Destroy() 
                    end
                end
                
                return ret 
            end

            local addconnect
            addconnect = workspace.ChildAdded:Connect(function(v)
                if table.find(entitynames, v.Name) then
                    task.wait(0.1)
                    
                    local h = esp(v, Color3.fromRGB(255, 25, 25), v.PrimaryPart, v.Name:gsub("Moving", ""))
                    table.insert(esptable.entity, h)
                end
            end)

            local function setup(room)
                if room.Name == "50" or room.Name == "100" then
                    local figuresetup = room:WaitForChild("FigureSetup")
                
                    if figuresetup then
                        local fig = figuresetup:WaitForChild("FigureRagdoll")
                        task.wait(0.1)
                        
                        local h = esp(fig, Color3.fromRGB(255, 25, 25), fig.PrimaryPart, "Figure")
                        table.insert(esptable.entity, h)
                    end 
                else
                    local assets = room:WaitForChild("Assets")
                    
                    local function check(v)
                        if v:IsA("Model") and table.find(entitynames, v.Name) then
                            task.wait(0.1)
                            
                            local h = esp(v:WaitForChild("Base"), Color3.fromRGB(255, 25, 25), v.Base, "Snare")
                            table.insert(esptable.entity, h)
                        end
                    end
                    
                    assets.DescendantAdded:Connect(function(v)
                        check(v) 
                    end)
                    
                    for i, v in pairs(assets:GetDescendants()) do
                        check(v)
                    end
                end 
            end
            
            local roomconnect
            roomconnect = workspace.CurrentRooms.ChildAdded:Connect(function(room)
                setup(room)
            end)
            
            for i, room in pairs(workspace.CurrentRooms:GetChildren()) do
                setup(room) 
	    end

	    table.insert(_G.entityESPInstances, esptable)

        else
            if _G.entityESPInstances then
                for _, instance in pairs(_G.entityESPInstances) do
                    for _, v in pairs(instance.entity) do
                        v.delete()
                    end
                end
                _G.entityESPInstances = nil
            end
        end
    end
})

local brightnessToggle = Doors:AddToggle({
    Name = "Full Bright",
    Default = false,
    Callback = function(state)
        local Light = game:GetService("Lighting")

        local function dofullbright()
            Light.Ambient = Color3.new(1, 1, 1)
            Light.ColorShift_Bottom = Color3.new(1, 1, 1)
            Light.ColorShift_Top = Color3.new(1, 1, 1)
        end

        local function resetLighting()
            Light.Ambient = Color3.new(0, 0, 0)
            Light.ColorShift_Bottom = Color3.new(0, 0, 0)
            Light.ColorShift_Top = Color3.new(0, 0, 0)
        end

        if state then
            _G.fullBrightEnabled = true
            task.spawn(function()
                while _G.fullBrightEnabled do
                    dofullbright()
                    task.wait(0)  -- 每秒检查一次
                end
            end)
        else
            _G.fullBrightEnabled = false
            resetLighting()
        end
    end
})

local GUI = GUIWindow:CreateTab({
    Name = "mod1"
})

local script = GUI:CreateSection({
    Name = "script"
})

script:AddButton({
    Name = "V.G",
    Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/1201for/V.G-Hub/main/V.Ghub'))()
    end
})
script:AddButton({
    Name = "DarkHub",
    Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/RandomAdamYT/DarkHub/master/Init'))()
    end
})
script:AddButton({
    Name = "OwlHub",
    Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/CriShoux/OwlHub/master/OwlHub.txt'))()
    end
})

script:AddButton({
    Name = "GhostHub",
    Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/GhostPlayer352/Test4/main/GhostHub'))()
    end
})


script:AddButton({
    Name = "Hohohub",
    Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/acsu123/HohoHub/main/Loader'))()
    end
})

local GUI = GUIWindow:CreateTab({
    Name = "Gui Setting"
})

local gui = GUI:CreateSection({
    Name = "Gui"
})

gui:AddButton({
    Name = "gui close",
    Callback = function()
        Library.unload()
    end
})

local keyESPToggle = Doors:AddToggle({
    Name = "Lever ESP(Warn)",
    Default = false,
    Callback = function(state)
        if state then
            _G.keyESPInstances = {}
            local esptable = {keys = {}}
            local flags = {espkeys = true}

            local function esp(what, color, core, name)
                local parts
                
                if typeof(what) == "Instance" then
                    if what:IsA("Model") then
                        parts = what:GetChildren()
                    elseif what:IsA("BasePart") then
                        parts = {what, table.unpack(what:GetChildren())}
                    end
                elseif typeof(what) == "table" then
                    parts = what
                end
                
                local bill
                local boxes = {}
                
                for i, v in pairs(parts) do
                    if v:IsA("BasePart") then
                        local box = Instance.new("BoxHandleAdornment")
                        box.Size = v.Size
                        box.AlwaysOnTop = true
                        box.ZIndex = 1
                        box.AdornCullingMode = Enum.AdornCullingMode.Never
                        box.Color3 = color
                        box.Transparency = 1
                        box.Adornee = v
                        box.Parent = game.CoreGui
                        
                        table.insert(boxes, box)
                        
                        task.spawn(function()
                            while box do
                                if box.Adornee == nil or not box.Adornee:IsDescendantOf(workspace) then
                                    box.Adornee = nil
                                    box.Visible = false
                                    box:Destroy()
                                end  
                                task.wait()
                            end
                        end)
                    end
                end
                
                if core and name then
                    bill = Instance.new("BillboardGui", game.CoreGui)
                    bill.AlwaysOnTop = true
                    bill.Size = UDim2.new(0, 400, 0, 100)
                    bill.Adornee = core
                    bill.MaxDistance = 2000
                    
                    local mid = Instance.new("Frame", bill)
                    mid.AnchorPoint = Vector2.new(0.5, 0.5)
                    mid.BackgroundColor3 = color
                    mid.Size = UDim2.new(0, 8, 0, 8)
                    mid.Position = UDim2.new(0.5, 0, 0.5, 0)
                    Instance.new("UICorner", mid).CornerRadius = UDim.new(1, 0)
                    Instance.new("UIStroke", mid)
                    
                    local txt = Instance.new("TextLabel", bill)
                    txt.AnchorPoint = Vector2.new(0.5, 0.5)
                    txt.BackgroundTransparency = 1
                    txt.BackgroundColor3 = color
                    txt.TextColor3 = color
                    txt.Size = UDim2.new(1, 0, 0, 20)
                    txt.Position = UDim2.new(0.5, 0, 0.7, 0)
                    txt.Text = name
                    Instance.new("UIStroke", txt)
                    
                    task.spawn(function()
                        while bill do
                            if bill.Adornee == nil or not bill.Adornee:IsDescendantOf(workspace) then
                                bill.Enabled = false
                                bill.Adornee = nil
                                bill:Destroy() 
                            end  
                            task.wait()
                        end
                    end)
                end
                
                local ret = {}
                
                ret.delete = function()
                    for i, v in pairs(boxes) do
                        v.Adornee = nil
                        v.Visible = false
                        v:Destroy()
                    end
                    
                    if bill then
                        bill.Enabled = false
                        bill.Adornee = nil
                        bill:Destroy() 
                    end
                end
                
                return ret 
            end

            local function check(v)
                if v:IsA("Model") and (v.Name == "LeverForGate" or v.Name == "KeyObtain") then
                    task.wait(0.1)
                    if v.Name == "KeyObtain" then
                        local hitbox = v:WaitForChild("Hitbox")
                        local parts = hitbox:GetChildren()
                        table.remove(parts, table.find(parts, hitbox:WaitForChild("PromptHitbox")))
                        
                        local h = esp(parts, Color3.fromRGB(255, 255, 255), hitbox, "Key")
                        table.insert(esptable.keys, h)
                        
                    elseif v.Name == "LeverForGate" then
                        local h = esp(v, Color3.fromRGB(255, 255, 255), v.PrimaryPart, "Lever")
                        table.insert(esptable.keys, h)
                        
                        v.PrimaryPart:WaitForChild("SoundToPlay").Played:Connect(function()
                            h.delete()
                        end) 
                    end
                end
            end
            
            local function setup(room)
                local assets = room:WaitForChild("Assets")
                
                assets.DescendantAdded:Connect(function(v)
                    check(v) 
                end)
                    
                for i, v in pairs(assets:GetDescendants()) do
                    check(v)
                end 
            end
            
            local addconnect
            addconnect = workspace.CurrentRooms.ChildAdded:Connect(function(room)
                setup(room)
            end)
            
            for i, room in pairs(workspace.CurrentRooms:GetChildren()) do
                if room:FindFirstChild("Assets") then
                    setup(room) 
                end
            end

            table.insert(_G.keyESPInstances, esptable) 
				
	else
            if _G.keyESPInstances then
                for _, instance in pairs(_G.keyESPInstances) do
                    for _, v in pairs(instance.keys) do
                        v.delete()
                    end
                end
                _G.keyESPInstances = nil
            end
        end
    end
})

local removeObstructionsToggle = Doors:AddToggle({
    Name = "Remove SeekArm/Chandelier",
    Default = false,
    Callback = function(state)
        if state then
            _G.removeObstructionsEnabled = true

            local function removeObstructions()
                game:GetService("ReplicatedStorage").GameData.LatestRoom:GetPropertyChangedSignal("Value"):Connect(function()
                    task.wait(0.1)
                    for _, descendant in pairs(game:GetService("Workspace").CurrentRooms:GetDescendants()) do
                        if descendant.Name == "Seek_Arm" or descendant.Name == "ChandelierObstruction" then
                            descendant.Parent = nil
                            descendant:Destroy()
                        end
                    end
                end)
            end

            task.spawn(function()
                while _G.removeObstructionsEnabled do
                    removeObstructions()
                    task.wait(1)
                end
            end)
        else
            _G.removeObstructionsEnabled = false
        end
    end
})

local a90BypassToggle = Doors:AddToggle({
    Name = "Bypass A-90",
    Default = false,
    Callback = function(state)
        local a90remote = game.ReplicatedStorage:WaitForChild("EntityInfo"):WaitForChild("A90")
        local plr = game.Players.LocalPlayer
        local flags = {noa90 = state}
        
        local jumpscare = plr.PlayerGui:WaitForChild("MainUI"):WaitForChild("Jumpscare"):FindFirstChild("Jumpscare_A90")
        
        if state then
            if jumpscare then
                jumpscare.Parent = nil
                a90remote.Parent = nil
                
                task.spawn(function()
                    while flags.noa90 do
                        game.SoundService.Main.Volume = 1
                        task.wait()
                    end
                end)
            end
        else
            if jumpscare then
                jumpscare.Parent = plr.PlayerGui.MainUI.Jumpscare
                a90remote.Parent = game.ReplicatedStorage.EntityInfo
            end
        end
    end
})

local playerESP = Doors:AddToggle({
    Name = "Key esp",
    Default = false,
    Callback = function(state)
        local Players = game:GetService("Players")
        local RunService = game:GetService("RunService")
        local markedTargets = {}

        local function createCircularUI(parent, color)
            local mid = Instance.new("Frame", parent)
            mid.AnchorPoint = Vector2.new(0.5, 0.5)
            mid.BackgroundColor3 = color
            mid.Size = UDim2.new(0, 8, 0, 8)
            mid.Position = UDim2.new(0.5, 0, 0.0001, 0) -- Adjusted position
            Instance.new("UICorner", mid).CornerRadius = UDim.new(1, 0)
            Instance.new("UIStroke", mid)
            
            return mid
        end

        local function markTarget(target, customName)
            if not target then return end
            local oldTag = target:FindFirstChild("Batteries")
            if oldTag then
                oldTag:Destroy()
            end
            local oldHighlight = target:FindFirstChild("Highlight")
            if oldHighlight then
                oldHighlight:Destroy()
            end
            local tag = Instance.new("BillboardGui")
            tag.Name = "Batteries"
            tag.Size = UDim2.new(0, 200, 0, 50)
            tag.StudsOffset = Vector3.new(0, 0.7, 0) -- Adjusted offset
            tag.AlwaysOnTop = true
            local textLabel = Instance.new("TextLabel")
            textLabel.Size = UDim2.new(1, 0, 1, 0)
            textLabel.BackgroundTransparency = 1
            textLabel.TextStrokeTransparency = 0 
            textLabel.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
            textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            textLabel.Font = Enum.Font.Jura
            textLabel.TextScaled = true
            textLabel.Text = customName
            textLabel.Parent = tag
            tag.Parent = target
            local highlight = Instance.new("Highlight")
            highlight.Name = "Highlight"
            highlight.Adornee = target
            highlight.FillColor = Color3.fromRGB(255, 255, 255)
            highlight.OutlineColor = Color3.fromRGB(255, 255, 139)
            highlight.Parent = target
            markedTargets[target] = customName
            
            -- 添加优质圆圈 UI
            createCircularUI(tag, Color3.fromRGB(255, 255, 255))
        end

        local function recursiveFindAll(parent, name, targets)
            for _, child in ipairs(parent:GetChildren()) do
                if child.Name == name then
                    table.insert(targets, child)
                end
                recursiveFindAll(child, name, targets)
            end
        end

        local function Itemlocationname(name, customName)
            local targets = {}
            recursiveFindAll(game, name, targets)
            for _, target in ipairs(targets) do
                markTarget(target, customName)
            end
        end

        local function Invalidplayername(playerName, customName)
            for _, player in ipairs(Players:GetPlayers()) do
                if player.Name == playerName and player.Character then
                    local head = player.Character:FindFirstChild("Head")
                    if head then
                        markTarget(head, customName)
                    end
                end
            end
        end

        if state then
            Players.PlayerAdded:Connect(function(player)
                player.CharacterAdded:Connect(function(character)
                    local head = character:FindFirstChild("Head")
                    if head then
                        markTarget(head, player.Name)
                    end
                end)
            end)

            game.DescendantAdded:Connect(function(descendant)
                if descendant.Name == "Key" then
                    markTarget(descendant, "Key")
                end
            end)

            RunService.RenderStepped:Connect(function()
                for target, customName in pairs(markedTargets) do
                    if target and target:FindFirstChild("Batteries") then
                        target.Batteries.TextLabel.Text = customName
                    else
                        if target then
                            markTarget(target, customName)
                        end
                    end
                end
            end)

            Invalidplayername("玩家名称", "玩家")
            Itemlocationname("Key", "Key")
        else
            for target, _ in pairs(markedTargets) do
                if target:FindFirstChild("Batteries") then
                    target.Batteries:Destroy()
                end
                if target:FindFirstChild("Highlight") then
                    target.Highlight:Destroy()
                end
            end
            markedTargets = {}
        end
    end
})

Doors:AddLabel({ Name = "-------------------------" })
Doors:AddLabel({ Name = "Can send Message enity:" })
Doors:AddLabel({ Name = "Rush Ambush" })
Doors:AddLabel({ Name = "Snare A60" })
Doors:AddLabel({ Name = "A90 A120 Eyes" })
Doors:AddLabel({ Name = "-------------------------" })
Doors:AddLabel({ Name = "Can esp enity:" })
Doors:AddLabel({ Name = "Rush Ambush" })
Doors:AddLabel({ Name = "Snare A60" })
Doors:AddLabel({ Name = "A120 Eyes" })
Doors:AddLabel({ Name = "-------------------------" })
Doors:AddLabel({ Name = "April Fools:" })
Doors:AddLabel({ Name = "Jeff" })
Doors:AddLabel({ Name = "-------------------------" })
Doors:AddLabel({ Name = "Tip:有些功能not work" })
Doors:AddLabel({ Name = "Tip:Key esp work" })
Doors:AddLabel({ Name = "-------------------------" })

local GUI = GUIWindow:CreateTab({
    Name = "Pressure"
})

local Pressure = GUI:CreateSection({
    Name = "esp"
})

local keyCardESPToggle = Pressure:AddToggle({
    Name = "KeyCard ESP(钥匙卡ESP)",
    Default = false,
    Callback = function(state)
        if state then
            _G.keyCardESPInstances = {}
            local esptable = {keyCards = {}}

            local function createBillboard(instance, name, color)
                local bill = Instance.new("BillboardGui", game.CoreGui)
                bill.AlwaysOnTop = true
                bill.Size = UDim2.new(0, 100, 0, 50)
                bill.Adornee = instance
                bill.MaxDistance = 2000

                local mid = Instance.new("Frame", bill)
                mid.AnchorPoint = Vector2.new(0.5, 0.5)
                mid.BackgroundColor3 = color
                mid.Size = UDim2.new(0, 8, 0, 8)
                mid.Position = UDim2.new(0.5, 0, 0.5, 0)
                Instance.new("UICorner", mid).CornerRadius = UDim.new(1, 0)
                Instance.new("UIStroke", mid)

                local txt = Instance.new("TextLabel", bill)
                txt.AnchorPoint = Vector2.new(0.5, 0.5)
                txt.BackgroundTransparency = 1
                txt.TextColor3 = color
                txt.Size = UDim2.new(1, 0, 0, 20)
                txt.Position = UDim2.new(0.5, 0, 0.7, 0)
                txt.Text = name
                Instance.new("UIStroke", txt)

                task.spawn(function()
                    while bill do
                        if bill.Adornee == nil or not bill.Adornee:IsDescendantOf(workspace) then
                            bill.Enabled = false
                            bill.Adornee = nil
                            bill:Destroy()
                        end
                        task.wait()
                    end
                end)
            end

            local function monitorNormalKeyCard()
                for _, instance in pairs(workspace:GetDescendants()) do
                    if instance:IsA("Model") and instance.Name == "NormalKeyCard" then
                        createBillboard(instance, "NormalKeyCard", Color3.new(1, 0, 0)) -- Change color as needed
                    end
                end

                workspace.DescendantAdded:Connect(function(instance)
                    if instance:IsA("Model") and instance.Name == "NormalKeyCard" then
                        createBillboard(instance, "NormalKeyCard", Color3.new(1, 0, 0)) -- Change color as needed
                    end
                end)
            end

            local function monitorInnerKeyCard()
                for _, instance in pairs(workspace:GetDescendants()) do
                    if instance:IsA("Model") and instance.Name == "InnerKeyCard" then
                        createBillboard(instance, "InnerKeyCard", Color3.new(255, 255, 255)) -- Change color as needed
                    end
                end

                workspace.DescendantAdded:Connect(function(instance)
                    if instance:IsA("Model") and instance.Name == "InnerKeyCard" then
                        createBillboard(instance, "InnerKeyCard", Color3.new(255, 255, 255)) -- Change color as needed
                    end
                end)
            end

            monitorNormalKeyCard()
            monitorInnerKeyCard()
            table.insert(_G.keyCardESPInstances, esptable)
				
        else
            if _G.keyCardESPInstances then
                for _, instance in pairs(_G.keyCardESPInstances) do
                    for _, v in pairs(instance.keyCards) do
                        v.delete()
                    end
                end
                _G.keyCardESPInstances = nil
            end
        end
    end
})

local a = GUI:CreateSection({
    Name = "function"
})

local playerESP = a:AddToggle({
    Name = "Enity Message(实体消息)",
    Default = false,
    Callback = function(state)
        if state then
            local entityNames = {"Angler", "Eyefestation", "Blitz", "Pinkie", "Froger", "Chainsmoker", "Pandemonium", "Body"}  --enity
            local NotificationHolder = loadstring(game:HttpGet("https://raw.githubusercontent.com/BocusLuke/UI/main/STX/Module.Lua"))() --Lib1
            local Notification = loadstring(game:HttpGet("https://raw.githubusercontent.com/BocusLuke/UI/main/STX/Client.Lua"))() --Lib2

            -- Ensure flags and plr are defined
            local flags = flags or {} --Prevent Error
            local plr = game.Players.LocalPlayer --Prevent Error2

            local function notifyEntitySpawn(entity)
                Notification:Notify(
                    {Title = "Creepy client V2", Description = entity.Name:gsub("Moving", ""):lower() .. " Spawned!"},
                    {OutlineColor = Color3.fromRGB(80, 80, 80), Time = 5, Type = "image"},
                    {Image = "http://www.roblox.com/asset/?id=10802751252", ImageColor = Color3.fromRGB(255, 255, 255)}
                )
            end

            local function onChildAdded(child)
                if table.find(entityNames, child.Name) then
                    repeat
                        task.wait()
                    until plr:DistanceFromCharacter(child:GetPivot().Position) < 1000 or not child:IsDescendantOf(workspace)
                    
                    if child:IsDescendantOf(workspace) then
                        notifyEntitySpawn(child)
                    end
                end
            end

            -- Infinite loop to keep the script running and check for hintrush flag
            local running = true
            while running do
                local connection = workspace.ChildAdded:Connect(onChildAdded)
                
                repeat
                    task.wait(1) -- Adjust the wait time as needed
                until not flags.hint or not running
                
                connection:Disconnect()
            end 
        else 
            -- Close message or any other cleanup if needed
            running = false
        end
    end
})

local playerESP = Pressure:AddToggle({
    Name = "Player ESP(玩家ESP)",
    Default = false,
    Callback = function(state)
        if state then
            _G.aespInstances = {}
            for _, player in pairs(game.Players:GetPlayers()) do
                if player.Character then
                    local aespInstance = esp(player.Character, Color3.new(255, 255, 255), player.Character:FindFirstChild("HumanoidRootPart"), player.Name)
                    table.insert(_G.aespInstances, aespInstance)
                end
            end
        else
            if _G.aespInstances then
                for _, aespInstance in pairs(_G.aespInstances) do
                    aespInstance.delete()
                end
                _G.aespInstances = nil
            end
        end
    end
})

-- ESP function definition (assuming it already exists)
function esp(what, color, core, name)
    local parts
    if typeof(what) == "Instance" then
        if what:IsA("Model") then
            parts = what:GetChildren()
        elseif what:IsA("BasePart") then
            parts = {what, table.unpack(what:GetChildren())}
        end
    elseif typeof(what) == "table" then
        parts = what
    end

    local bill
    local boxes = {}

    for i, v in pairs(parts) do
        if v:IsA("BasePart") then
            local box = Instance.new("BoxHandleAdornment")
            box.Size = v.Size
            box.AlwaysOnTop = true
            box.ZIndex = 1
            box.AdornCullingMode = Enum.AdornCullingMode.Never
            box.Color3 = color
            box.Transparency = 0.75
            box.Adornee = v
            box.Parent = game.CoreGui

            table.insert(boxes, box)

            task.spawn(function()
                while box do
                    if box.Adornee == nil or not box.Adornee:IsDescendantOf(workspace) then
                        box.Adornee = nil
                        box.Visible = false
                        box:Destroy()
                    end
                    task.wait()
                end
            end)
        end
    end

    if core and name then
        bill = Instance.new("BillboardGui", game.CoreGui)
        bill.AlwaysOnTop = true
        bill.Size = UDim2.new(0, 100, 0, 50)
        bill.Adornee = core
        bill.MaxDistance = 2000

        local mid = Instance.new("Frame", bill)
        mid.AnchorPoint = Vector2.new(0.5, 0.5)
        mid.BackgroundColor3 = color
        mid.Size = UDim2.new(0, 8, 0, 8)
        mid.Position = UDim2.new(0.5, 0, 0.5, 0)
        Instance.new("UICorner", mid).CornerRadius = UDim.new(1, 0)
        Instance.new("UIStroke", mid)

        local txt = Instance.new("TextLabel", bill)
        txt.AnchorPoint = Vector2.new(0.5, 0.5)
        txt.BackgroundTransparency = 1
        txt.BackgroundColor3 = color
        txt.TextColor3 = color
        txt.Size = UDim2.new(1, 0, 0, 20)
        txt.Position = UDim2.new(0.5, 0, 0.7, 0)
        txt.Text = name
        Instance.new("UIStroke", txt)

        task.spawn(function()
            while bill do
                if bill.Adornee == nil or not bill.Adornee:IsDescendantOf(workspace) then
                    bill.Enabled = false
                    bill.Adornee = nil
                    bill:Destroy()
                end
                task.wait()
            end
        end)
    end

    local ret = {}

    ret.delete = function()
        for i, v in pairs(boxes) do
            v.Adornee = nil
            v.Visible = false
            v:Destroy()
        end

        if bill then
            bill.Enabled = false
            bill.Adornee = nil
            bill:Destroy()
        end
    end

    return ret
end

-- Define Player ESP function
function playerEsp()
    for _, player in pairs(game.Players:GetPlayers()) do
        if player.Character then
            esp(player.Character, Color3.new(255, 255, 255), player.Character:FindFirstChild("HumanoidRootPart"), player.Name)
        end
    end
end

local brightnessToggle = a:AddToggle({
    Name = "Full Bright(高亮)",
    Default = false,
    Callback = function(state)
        local Light = game:GetService("Lighting")

        local function dofullbright()
            Light.Ambient = Color3.new(1, 1, 1)
            Light.ColorShift_Bottom = Color3.new(1, 1, 1)
            Light.ColorShift_Top = Color3.new(1, 1, 1)
        end

        local function resetLighting()
            Light.Ambient = Color3.new(0, 0, 0)
            Light.ColorShift_Bottom = Color3.new(0, 0, 0)
            Light.ColorShift_Top = Color3.new(0, 0, 0)
        end

        if state then
            _G.fullBrightEnabled = true
            task.spawn(function()
                while _G.fullBrightEnabled do
                    dofullbright()
                    task.wait(0)  -- 每秒检查一次
                end
            end)
        else
            _G.fullBrightEnabled = false
            resetLighting()
        end
    end
})

local entityESPToggle = Pressure:AddToggle({
    Name = "Entity ESP(实体ESP)",
    Default = false,
    Callback = function(state)
        if state then
            _G.entityInstances = {}
            local esptable = {entities = {}}
            local flags = {esprush = true}
            local entitynames = {"Angler", "Eyefestation", "Blitz", "Pinkie", "Froger", "Chainsmoker", "Pandemonium", "Body"}

            local function esp(what, color, core, name)
                local parts

                if typeof(what) == "Instance" then
                    if what:IsA("Model") then
                        parts = what:GetChildren()
                    elseif what:IsA("BasePart") then
                        parts = {what, table.unpack(what:GetChildren())}
                    end
                elseif typeof(what) == "table" then
                    parts = what
                end

                local bill
                local boxes = {}

                for _, v in pairs(parts) do
                    if v:IsA("BasePart") then
                        local box = Instance.new("BoxHandleAdornment")
                        box.Size = v.Size
                        box.AlwaysOnTop = true
                        box.ZIndex = 1
                        box.AdornCullingMode = Enum.AdornCullingMode.Never
                        box.Color3 = color
                        box.Transparency = 0.5
                        box.Adornee = v
                        box.Parent = game.CoreGui

                        table.insert(boxes, box)

                        task.spawn(function()
                            while box do
                                if box.Adornee == nil or not box.Adornee:IsDescendantOf(workspace) then
                                    box.Adornee = nil
                                    box.Visible = false
                                    box:Destroy()
                                end
                                task.wait()
                            end
                        end)
                    end
                end

                if core and name then
                    bill = Instance.new("BillboardGui", game.CoreGui)
                    bill.AlwaysOnTop = true
                    bill.Size = UDim2.new(0, 100, 0, 50)
                    bill.Adornee = core
                    bill.MaxDistance = 2000

                    local mid = Instance.new("Frame", bill)
                    mid.AnchorPoint = Vector2.new(0.5, 0.5)
                    mid.BackgroundColor3 = color
                    mid.Size = UDim2.new(0, 8, 0, 8)
                    mid.Position = UDim2.new(0.5, 0, 0.5, 0)
                    Instance.new("UICorner", mid).CornerRadius = UDim.new(1, 0)
                    Instance.new("UIStroke", mid)

                    local txt = Instance.new("TextLabel", bill)
                    txt.AnchorPoint = Vector2.new(0.5, 0.5)
                    txt.BackgroundTransparency = 1
                    txt.TextColor3 = color
                    txt.Size = UDim2.new(1, 0, 0, 20)
                    txt.Position = UDim2.new(0.5, 0, 0.7, 0)
                    txt.Text = name
                    Instance.new("UIStroke", txt)

                    task.spawn(function()
                        while bill do
                            if bill.Adornee == nil or not bill.Adornee:IsDescendantOf(workspace) then
                                bill.Enabled = false
                                bill.Adornee = nil
                                bill:Destroy()
                            end
                            task.wait()
                        end
                    end)
                end

                local ret = {}

                ret.delete = function()
                    for _, v in pairs(boxes) do
                        v.Adornee = nil
                        v.Visible = false
                        v:Destroy()
                    end

                    if bill then
                        bill.Enabled = false
                        bill.Adornee = nil
                        bill:Destroy()
                    end
                end

                return ret
            end

            local function addEntity(instance)
                for _, name in pairs(entitynames) do
                    if instance:IsA("Model") and instance.Name == name then
                        local espEntity = esp(instance, Color3.fromRGB(255, 0, 0), instance.PrimaryPart, name)
                        table.insert(esptable.entities, espEntity)
                    end
                end
            end

            local function monitorEntities()
                for _, instance in pairs(workspace:GetDescendants()) do
                    addEntity(instance)
                end

                workspace.DescendantAdded:Connect(addEntity)
            end

            monitorEntities()
            table.insert(_G.entityInstances, esptable)
        else
            if _G.entityInstances then
                for _, instance in pairs(_G.entityInstances) do
                    for _, entity in pairs(instance.entities) do
                        entity.delete()
                    end
                end
                _G.entityInstances = nil
            end
        end
    end
})

local playerESP = a:AddToggle({
    Name = "No cilp(穿墙)",
    Default = false,
    Callback = function(state)
        local player = game.Players.LocalPlayer
        local char = player.Character
        local runService = game:GetService("RunService")
        if state then
            _G.NoClip = runService.Stepped:Connect(function()
                for _, v in pairs(char:GetDescendants()) do
                    if v:IsA("BasePart") then
                        v.CanCollide = false
                    end
                end
            end)
        else
            if _G.NoClip then
                _G.NoClip:Disconnect()
                _G.NoClip = nil
            end
            for _, v in pairs(char:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.CanCollide = true
                end
            end
        end
    end
})
local lockerESPToggle = Pressure:AddToggle({
    Name = "Locker ESP(柜子ESP)",
    Default = false,
    Callback = function(state)
        if state then
            _G.espToLocker = {}
            local esptable = {lockers = {}}

            local function createBillboard(instance, name, color)
                local bill = Instance.new("BillboardGui", game.CoreGui)
                bill.AlwaysOnTop = true
                bill.Size = UDim2.new(0, 100, 0, 50)
                bill.Adornee = instance
                bill.MaxDistance = 2000

                local mid = Instance.new("Frame", bill)
                mid.AnchorPoint = Vector2.new(0.5, 0.5)
                mid.BackgroundColor3 = color
                mid.Size = UDim2.new(0, 8, 0, 8)
                mid.Position = UDim2.new(0.5, 0, 0.5, 0)
                Instance.new("UICorner", mid).CornerRadius = UDim.new(1, 0)
                Instance.new("UIStroke", mid)

                local txt = Instance.new("TextLabel", bill)
                txt.AnchorPoint = Vector2.new(0.5, 0.5)
                txt.BackgroundTransparency = 1
                txt.TextColor3 = color
                txt.Size = UDim2.new(1, 0, 0, 20)
                txt.Position = UDim2.new(0.5, 0, 0.7, 0)
                txt.Text = name
                Instance.new("UIStroke", txt)

                task.spawn(function()
                    while bill do
                        if bill.Adornee == nil or not bill.Adornee:IsDescendantOf(workspace) then
                            bill.Enabled = false
                            bill.Adornee = nil
                            bill:Destroy()
                        end
                        task.wait()
                    end
                end)
            end

            local function addLocker(instance)
                if instance:IsA("Model") and instance.Name == "Locker" then
                    createBillboard(instance, "Locker", Color3.new(250, 250, 250)) -- Change color as needed
                    table.insert(esptable.lockers, instance)
                end
            end

            local function monitorLockers()
                for _, instance in pairs(workspace:GetDescendants()) do
                    addLocker(instance)
                end

                workspace.DescendantAdded:Connect(addLocker)
            end

            monitorLockers()
            table.insert(_G.espToLocker, esptable)
				
        else
            if _G.espToLocker then
                for _, instance in pairs(_G.espToLocker) do
                    for _, locker in pairs(instance.lockers) do
                        if locker and locker:FindFirstChildOfClass("BillboardGui") then
                            locker:FindFirstChildOfClass("BillboardGui"):Destroy()
                        end
                    end
                end
                _G.espToLocker = nil
            end
        end
    end
})

local ltemESPToggle = Pressure:AddToggle({
    Name = "NormalDoor ESP(门ESP)",
    Default = false,
    Callback = function(state)
        if state then
            _G.NormalDoorESPInstances = {}
            local esptable = {doors = {}}

            local function createBillboard(instance, name, color)
                local bill = Instance.new("BillboardGui", game.CoreGui)
                bill.AlwaysOnTop = true
                bill.Size = UDim2.new(0, 100, 0, 50)
                bill.Adornee = instance
                bill.MaxDistance = 2000

                local mid = Instance.new("Frame", bill)
                mid.AnchorPoint = Vector2.new(0.5, 0.5)
                mid.BackgroundColor3 = color
                mid.Size = UDim2.new(0, 8, 0, 8)
                mid.Position = UDim2.new(0.5, 0, 0.5, 0)
                Instance.new("UICorner", mid).CornerRadius = UDim.new(1, 0)
                Instance.new("UIStroke", mid)

                local txt = Instance.new("TextLabel", bill)
                txt.AnchorPoint = Vector2.new(0.5, 0.5)
                txt.BackgroundTransparency = 1
                txt.TextColor3 = color
                txt.Size = UDim2.new(1, 0, 0, 20)
                txt.Position = UDim2.new(0.5, 0, 0.7, 0)
                txt.Text = name
                Instance.new("UIStroke", txt)

                task.spawn(function()
                    while bill do
                        if bill.Adornee == nil or not bill.Adornee:IsDescendantOf(workspace) then
                            bill.Enabled = false
                            bill.Adornee = nil
                            bill:Destroy()
                        end
                        task.wait()
                    end
                end)
            end

            local function monitorNormalDoor()
                for _, instance in pairs(workspace:GetDescendants()) do
                    if instance:IsA("Model") and instance.Name == "NormalDoor" then
                        createBillboard(instance, "door(门", Color3.new(125, 125, 125)) -- Change color as needed
                    end
                end

                workspace.DescendantAdded:Connect(function(instance)
                    if instance:IsA("Model") and instance.Name == "NormalDoor" then
                        createBillboard(instance, "door(门", Color3.new(125, 125, 125)) -- Change color as needed
                    end
                end)
            end

            monitorNormalDoor()
            table.insert(_G.NormalDoorESPInstances, esptable)
				
        else
            if _G.NormalDoorESPInstances then
                for _, instance in pairs(_G.NormalDoorESPInstances) do
                    for _, v in pairs(instance.doors) do
                        v.delete()
                    end
                end
                _G.NormalDoorESPInstances = nil
            end
        end
    end
})

local lockerESPToggle = Pressure:AddToggle({
    Name = "generator ESP(发电机ESP)",
    Default = false,
    Callback = function(state)
        if state then
            _G.EncounterGeneratorESPInstances = {}
            local esptable = {doors = {}}

            local function createBillboard(instance, name, color)
                local bill = Instance.new("BillboardGui", game.CoreGui)
                bill.AlwaysOnTop = true
                bill.Size = UDim2.new(0, 100, 0, 50)
                bill.Adornee = instance
                bill.MaxDistance = 2000

                local mid = Instance.new("Frame", bill)
                mid.AnchorPoint = Vector2.new(0.5, 0.5)
                mid.BackgroundColor3 = color
                mid.Size = UDim2.new(0, 8, 0, 8)
                mid.Position = UDim2.new(0.5, 0, 0.5, 0)
                Instance.new("UICorner", mid).CornerRadius = UDim.new(1, 0)
                Instance.new("UIStroke", mid)

                local txt = Instance.new("TextLabel", bill)
                txt.AnchorPoint = Vector2.new(0.5, 0.5)
                txt.BackgroundTransparency = 1
                txt.TextColor3 = color
                txt.Size = UDim2.new(1, 0, 0, 20)
                txt.Position = UDim2.new(0.5, 0, 0.7, 0)
                txt.Text = name
                Instance.new("UIStroke", txt)

                task.spawn(function()
                    while bill do
                        if bill.Adornee == nil or not bill.Adornee:IsDescendantOf(workspace) then
                            bill.Enabled = false
                            bill.Adornee = nil
                            bill:Destroy()
                        end
                        task.wait()
                    end
                end)
            end

            local function monitorEncounterGenerator()
                for _, instance in pairs(workspace:GetDescendants()) do
                    if instance:IsA("Model") and instance.Name == "EncounterGenerator" then
                        createBillboard(instance, "EncounterGenerator", Color3.new(50, 10, 25)) -- Change color as neededPipesDoorESPInstances
                    end
                end

                workspace.DescendantAdded:Connect(function(instance)
                    if instance:IsA("Model") and instance.Name == "EncounterGenerator" then
                        createBillboard(instance, "EncounterGenerator", Color3.new(50, 10, 25)) -- Change color as needed
                    end
                end)
            end

            monitorEncounterGenerator()
            table.insert(_G.EncounterGeneratorESPInstances, esptable)
				
        else
            if _G.EncounterGeneratorESPInstances then
                for _, instance in pairs(_G.EncounterGeneratorESPInstances) do
                    for _, v in pairs(instance.doors) do
                        v.delete()
                    end
                end
                _G.EncounterGeneratorESPInstances = nil
            end
        end
    end
})

local lockedESPToggle = Pressure:AddToggle({
    Name = "locker ESP(储物柜ESP)",
    Default = false,
    Callback = function(state)
        if state then
            _G.ItemLockerESPInstances = {}
            local esptable = {doors = {}}

            local function createBillboard(instance, name, color)
                local bill = Instance.new("BillboardGui", game.CoreGui)
                bill.AlwaysOnTop = true
                bill.Size = UDim2.new(0, 100, 0, 50)
                bill.Adornee = instance
                bill.MaxDistance = 2000

                local mid = Instance.new("Frame", bill)
                mid.AnchorPoint = Vector2.new(0.5, 0.5)
                mid.BackgroundColor3 = color
                mid.Size = UDim2.new(0, 8, 0, 8)
                mid.Position = UDim2.new(0.5, 0, 0.5, 0)
                Instance.new("UICorner", mid).CornerRadius = UDim.new(1, 0)
                Instance.new("UIStroke", mid)

                local txt = Instance.new("TextLabel", bill)
                txt.AnchorPoint = Vector2.new(0.5, 0.5)
                txt.BackgroundTransparency = 1
                txt.TextColor3 = color
                txt.Size = UDim2.new(1, 0, 0, 20)
                txt.Position = UDim2.new(0.5, 0, 0.7, 0)
                txt.Text = name
                Instance.new("UIStroke", txt)

                task.spawn(function()
                    while bill do
                        if bill.Adornee == nil or not bill.Adornee:IsDescendantOf(workspace) then
                            bill.Enabled = false
                            bill.Adornee = nil
                            bill:Destroy()
                        end
                        task.wait()
                    end
                end)
            end

            local function monitorItemLocker()
                for _, instance in pairs(workspace:GetDescendants()) do
                    if instance:IsA("Model") and instance.Name == "ItemLocker" then
                        createBillboard(instance, "Storagecabinet(储物柜", Color3.new(50, 10, 255)) -- Change color as neededPipesDoorESPInstances
                    end
                end

                workspace.DescendantAdded:Connect(function(instance)
                    if instance:IsA("Model") and instance.Name == "ItemLocker" then
                        createBillboard(instance, "Storagecabinet(储物柜", Color3.new(50, 10, 255)) -- Change color as needed
                    end
                end)
            end

            monitorItemLocker()
            table.insert(_G.ItemLockerESPInstances, esptable)
				
        else
            if _G.ItemLockerESPInstances then
                for _, instance in pairs(_G.ItemLockerESPInstances) do
                    for _, v in pairs(instance.doors) do
                        v.delete()
                    end
                end
                _G.ItemLockerESPInstances = nil
            end
        end
    end
})

local CraESPToggle = Pressure:AddToggle({
    Name = "Creature of Darkness ESP(章鱼哥ESP)",
    Default = false,
    Callback = function(state)
        if state then
            _G.BodyESPInstances = {}
            local esptable = {doors = {}}

            local function createBillboard(instance, name, color)
                local bill = Instance.new("BillboardGui", game.CoreGui)
                bill.AlwaysOnTop = true
                bill.Size = UDim2.new(0, 100, 0, 50)
                bill.Adornee = instance
                bill.MaxDistance = 2000

                local mid = Instance.new("Frame", bill)
                mid.AnchorPoint = Vector2.new(0.5, 0.5)
                mid.BackgroundColor3 = color
                mid.Size = UDim2.new(0, 8, 0, 8)
                mid.Position = UDim2.new(0.5, 0, 0.5, 0)
                Instance.new("UICorner", mid).CornerRadius = UDim.new(1, 0)
                Instance.new("UIStroke", mid)

                local txt = Instance.new("TextLabel", bill)
                txt.AnchorPoint = Vector2.new(0.5, 0.5)
                txt.BackgroundTransparency = 1
                txt.TextColor3 = color
                txt.Size = UDim2.new(1, 0, 0, 20)
                txt.Position = UDim2.new(0.5, 0, 0.7, 0)
                txt.Text = name
                Instance.new("UIStroke", txt)

                task.spawn(function()
                    while bill do
                        if bill.Adornee == nil or not bill.Adornee:IsDescendantOf(workspace) then
                            bill.Enabled = false
                            bill.Adornee = nil
                            bill:Destroy()
                        end
                        task.wait()
                    end
                end)
            end

            local function monitorBody()
                for _, instance in pairs(workspace:GetDescendants()) do
                    if instance:IsA("Model") and instance.Name == "Body" then
                        createBillboard(instance, "Body", Color3.new(50, 100, 25)) -- Change color as neededPipesDoorESPInstances
                    end
                end

                workspace.DescendantAdded:Connect(function(instance)
                    if instance:IsA("Model") and instance.Name == "Body" then
                        createBillboard(instance, "Body", Color3.new(50, 100, 25)) -- Change color as needed
                    end
                end)
            end

            monitorBody()
            table.insert(_G.BodyESPInstances, esptable)
				
        else
            if _G.BodyESPInstances then
                for _, instance in pairs(_G.BodyESPInstances) do
                    for _, v in pairs(instance.doors) do
                        v.delete()
                    end
                end
                _G.BodyESPInstances = nil
            end
        end
    end
})

local FAKESPToggle = Pressure:AddToggle({
    Name = "Fake cabinet ESP(假柜子ESP)",
    Default = false,
    Callback = function(state)
        if state then
            _G.MonsterLockerESPInstances = {}
            local esptable = {doors = {}}

            local function createBillboard(instance, name, color)
                local bill = Instance.new("BillboardGui", game.CoreGui)
                bill.AlwaysOnTop = true
                bill.Size = UDim2.new(0, 100, 0, 50)
                bill.Adornee = instance
                bill.MaxDistance = 2000

                local mid = Instance.new("Frame", bill)
                mid.AnchorPoint = Vector2.new(0.5, 0.5)
                mid.BackgroundColor3 = color
                mid.Size = UDim2.new(0, 8, 0, 8)
                mid.Position = UDim2.new(0.5, 0, 0.5, 0)
                Instance.new("UICorner", mid).CornerRadius = UDim.new(1, 0)
                Instance.new("UIStroke", mid)

                local txt = Instance.new("TextLabel", bill)
                txt.AnchorPoint = Vector2.new(0.5, 0.5)
                txt.BackgroundTransparency = 1
                txt.TextColor3 = color
                txt.Size = UDim2.new(1, 0, 0, 20)
                txt.Position = UDim2.new(0.5, 0, 0.7, 0)
                txt.Text = name
                Instance.new("UIStroke", txt)

                task.spawn(function()
                    while bill do
                        if bill.Adornee == nil or not bill.Adornee:IsDescendantOf(workspace) then
                            bill.Enabled = false
                            bill.Adornee = nil
                            bill:Destroy()
                        end
                        task.wait()
                    end
                end)
            end

            local function monitorMonsterLocker()
                for _, instance in pairs(workspace:GetDescendants()) do
                    if instance:IsA("Model") and instance.Name == "MonsterLocker" then
                        createBillboard(instance, "Fake cabinet(假的柜子", Color3.new(50, 10, 25)) -- Change color as neededPipesDoorESPInstances
                    end
                end

                workspace.DescendantAdded:Connect(function(instance)
                    if instance:IsA("Model") and instance.Name == "MonsterLocker" then
                        createBillboard(instance, "Fake cabinet(假的柜子", Color3.new(50, 10, 25)) -- Change color as needed
                    end
                end)
            end

            monitorMonsterLocker()
            table.insert(_G.MonsterLockerESPInstances, esptable)
				
        else
            if _G.MonsterLockerESPInstances then
                for _, instance in pairs(_G.MonsterLockerESPInstances) do
                    for _, v in pairs(instance.doors) do
                        v.delete()
                    end
                end
                _G.MonsterLockerESPInstances = nil
            end
        end
    end
})

local lockerESPToggle = Pressure:AddToggle({
    Name = "blank door ESP(假门ESP)",
    Default = false,
    Callback = function(state)
        if state then
            _G.TricksterRoomESPInstances = {}
            local esptable = {doors = {}}

            local function createBillboard(instance, name, color)
                local bill = Instance.new("BillboardGui", game.CoreGui)
                bill.AlwaysOnTop = true
                bill.Size = UDim2.new(0, 100, 0, 50)
                bill.Adornee = instance
                bill.MaxDistance = 2000

                local mid = Instance.new("Frame", bill)
                mid.AnchorPoint = Vector2.new(0.5, 0.5)
                mid.BackgroundColor3 = color
                mid.Size = UDim2.new(0, 8, 0, 8)
                mid.Position = UDim2.new(0.5, 0, 0.5, 0)
                Instance.new("UICorner", mid).CornerRadius = UDim.new(1, 0)
                Instance.new("UIStroke", mid)

                local txt = Instance.new("TextLabel", bill)
                txt.AnchorPoint = Vector2.new(0.5, 0.5)
                txt.BackgroundTransparency = 1
                txt.TextColor3 = color
                txt.Size = UDim2.new(1, 0, 0, 20)
                txt.Position = UDim2.new(0.5, 0, 0.7, 0)
                txt.Text = name
                Instance.new("UIStroke", txt)

                task.spawn(function()
                    while bill do
                        if bill.Adornee == nil or not bill.Adornee:IsDescendantOf(workspace) then
                            bill.Enabled = false
                            bill.Adornee = nil
                            bill:Destroy()
                        end
                        task.wait()
                    end
                end)
            end

            local function monitorTricksterRoom()
                for _, instance in pairs(workspace:GetDescendants()) do
                    if instance:IsA("Model") and instance.Name == "TricksterRoom" then
                        createBillboard(instance, "blankdoor(假门", Color3.new(50, 10, 25)) -- Change color as neededPipesDoorESPInstances
                    end
                end

                workspace.DescendantAdded:Connect(function(instance)
                    if instance:IsA("Model") and instance.Name == "TricksterRoom" then
                        createBillboard(instance, "blankdoor(假门", Color3.new(50, 10, 25)) -- Change color as needed
                    end
                end)
            end

            monitorTricksterRoom()
            table.insert(_G.TricksterRoomESPInstances, esptable)
				
        else
            if _G.TricksterRoomESPInstances then
                for _, instance in pairs(_G.TricksterRoomESPInstances) do
                    for _, v in pairs(instance.doors) do
                        v.delete()
                    end
                end
                _G.TricksterRoomESPInstances = nil
            end
        end
    end
})

local Player = game.Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local Humanoid = Character:WaitForChild("Humanoid")

local Player = game.Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local Humanoid = Character:WaitForChild("Humanoid")

local tpWalkThread
local flyThread
local isFlying = false
local BodyVelocity

local function tpWalk(speed)
    while true do
        task.wait()
        if Humanoid.MoveDirection.Magnitude > 0 then
            -- Move the player in the direction they are facing, including vertical movement
            local moveDirection = Humanoid.MoveDirection * speed

            -- Adjust for swimming: add upward movement if the player is in water
            if Humanoid:GetState() == Enum.HumanoidStateType.Swimming then
                moveDirection = moveDirection + Vector3.new(0, speed, 0)
            end

            HumanoidRootPart.CFrame = HumanoidRootPart.CFrame + moveDirection
        end
    end
end

local function flatFly(speed)
    BodyVelocity = Instance.new("BodyVelocity")
    BodyVelocity.Velocity = Vector3.new(0, 0, 0)
    BodyVelocity.MaxForce = Vector3.new(1e4, 0, 1e4)
    BodyVelocity.Parent = HumanoidRootPart

    while isFlying do
        task.wait()
        if Humanoid.MoveDirection.Magnitude > 0 then
            -- Move the player in the direction they are facing, but only in the horizontal plane
            local moveDirection = Vector3.new(Humanoid.MoveDirection.X, 0, Humanoid.MoveDirection.Z) * speed
            BodyVelocity.Velocity = moveDirection
        else
            BodyVelocity.Velocity = Vector3.new(0, 0, 0)
        end
    end

    BodyVelocity:Destroy()
end

-- Create a slider to adjust tpWalk speed
local PlayerTPWalkSpeedSlider = a:AddSlider({
    Name = "TP Walk",
    Value = 0,
    Min = 0,
    Max = 2,
    Callback = function(Value)
        if tpWalkThread then
            tpWalkThread:Disconnect()
        end

        -- Start a new tpWalk thread
        tpWalkThread = coroutine.wrap(function()
            tpWalk(Value)
        end)
        tpWalkThread()
    end
})

-- Create a toggle button for flat flying mode
local flatFlyToggleBtn = a:AddToggle({
    Name = "Flat Fly",
    Value = false,
    Callback = function(val)
        isFlying = val
        if isFlying then
            -- Start flat flying thread
            flyThread = coroutine.wrap(function()
                flatFly(2)  -- Default flat fly speed
            end)
            flyThread()
        else
            -- Stop flat flying
            if flyThread then
                flyThread = nil
            end
        end
    end
})

-- Ensure player and humanoid references are updated if the character respawns
Player.CharacterAdded:Connect(function(character)
    Character = character
    HumanoidRootPart = character:WaitForChild("HumanoidRootPart")
    Humanoid = character:WaitForChild("Humanoid")
end)

local Player = game.Players.LocalPlayer
local Camera = workspace.CurrentCamera

local function updateFOV(fov)
    Camera.FieldOfView = fov
end

-- 创建滑动模块来调整 FOV
local PlayerFOVSlider = a:AddSlider({
    Name = "FOV",
    Value = 70,
    Min = 50,
    Max = 120,
    Callback = function(Value)
        updateFOV(Value)
    end
})
local playerESP = a:AddToggle({
    Name = "Entity Bypass",
    Default = false,
    Callback = function(state)
        if state then
            local entityNames = {"Angler", "Blitz", "Pinkie", "Froger", "Chainsmoker", "Pandemonium"} -- List of entities to monitor
            local platformHeight = 900 -- Height for the safe platform
            local platformSize = Vector3.new(1000, 1, 1000) -- Size of the platform
            local platform -- Variable to hold the created platform
            local entityTriggerMap = {} -- Map to keep track of which entities triggered the platform
            local playerOriginalPositions = {} -- Table to store original positions of players
            local isMonitoring = true

            -- Function to create or update the safe platform
            local function createSafePlatform()
                if platform then
                    platform:Destroy() -- Remove existing platform if any
                end

                platform = Instance.new("Part")
                platform.Size = platformSize
                platform.Position = Vector3.new(0, platformHeight, 0) -- Center position
                platform.Anchored = true
                platform.Parent = workspace
            end

            -- Function to teleport a player to the safe platform
            local function teleportPlayerToPlatform(player)
                if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local targetPosition = platform.Position + Vector3.new(0, platform.Size.Y / 2 + 5, 0)
                    playerOriginalPositions[player.UserId] = player.Character.HumanoidRootPart.CFrame -- Store original position
                    player.Character.HumanoidRootPart.CFrame = CFrame.new(targetPosition)
                end
            end

            -- Function to teleport a player back to their original position
            local function teleportPlayerBack(player)
                if playerOriginalPositions[player.UserId] then
                    player.Character.HumanoidRootPart.CFrame = playerOriginalPositions[player.UserId]
                    playerOriginalPositions[player.UserId] = nil -- Clear the stored position
                end
            end

            -- Function to handle entity detection
            local function onChildAdded(child)
                if table.find(entityNames, child.Name) then
                    -- Create platform and teleport players when entity is detected
                    createSafePlatform()
                    entityTriggerMap[child] = true -- Mark entity as having triggered the platform
                    for _, player in pairs(game.Players:GetPlayers()) do
                        teleportPlayerToPlatform(player)
                    end
                end
            end

            -- Function to handle entity removal
            local function onChildRemoved(child)
                if entityTriggerMap[child] then
                    -- Entity was previously responsible for creating the platform
                    entityTriggerMap[child] = nil -- Remove entity from the map
                    -- Teleport players back to their original positions
                    for _, player in pairs(game.Players:GetPlayers()) do
                        teleportPlayerBack(player)
                    end
                end
            end

            -- Connect the ChildAdded and ChildRemoved events
            local addConnection = workspace.ChildAdded:Connect(onChildAdded)
            local removeConnection = workspace.ChildRemoved:Connect(onChildRemoved)

            -- Loop to keep the script running based on the toggle state
            while isMonitoring do
                task.wait(1) -- Adjust the wait time as needed

                if not state then
                    -- Cleanup if defense is turned off
                    if platform then
                        -- Keep the platform, but ensure players are teleported back
                        for _, player in pairs(game.Players:GetPlayers()) do
                            teleportPlayerBack(player)
                        end
                    end
                    isMonitoring = false
                    addConnection:Disconnect() -- Disconnect the event listener
                    removeConnection:Disconnect() -- Disconnect the event listener
                end
            end 
        else
            -- Cleanup if defense is turned off
            if platform then
                -- Keep the platform, but ensure players are teleported back
                for _, player in pairs(game.Players:GetPlayers()) do
                    teleportPlayerBack(player)
                end
            end
        end
    end
})
local lockerESPToggle = Pressure:AddToggle({
    Name = "BigRoomDoor ESP(大门Esp)",
    Default = false,
    Callback = function(state)
        if state then
            _G.bigRoomDoorESPInstances = {}
            local esptable = {doors = {}}

            local function createBillboard(instance, name, color)
                local bill = Instance.new("BillboardGui", game.CoreGui)
                bill.AlwaysOnTop = true
                bill.Size = UDim2.new(0, 100, 0, 50)
                bill.Adornee = instance
                bill.MaxDistance = 2000

                local mid = Instance.new("Frame", bill)
                mid.AnchorPoint = Vector2.new(0.5, 0.5)
                mid.BackgroundColor3 = color
                mid.Size = UDim2.new(0, 8, 0, 8)
                mid.Position = UDim2.new(0.5, 0, 0.5, 0)
                Instance.new("UICorner", mid).CornerRadius = UDim.new(1, 0)
                Instance.new("UIStroke", mid)

                local txt = Instance.new("TextLabel", bill)
                txt.AnchorPoint = Vector2.new(0.5, 0.5)
                txt.BackgroundTransparency = 1
                txt.TextColor3 = color
                txt.Size = UDim2.new(1, 0, 0, 20)
                txt.Position = UDim2.new(0.5, 0, 0.7, 0)
                txt.Text = name
                Instance.new("UIStroke", txt)

                task.spawn(function()
                    while bill do
                        if bill.Adornee == nil or not bill.Adornee:IsDescendantOf(workspace) then
                            bill.Enabled = false
                            bill.Adornee = nil
                            bill:Destroy()
                        end
                        task.wait()
                    end
                end)
            end

            local function monitorBigRoomDoor()
                for _, instance in pairs(workspace:GetDescendants()) do
                    if instance:IsA("Model") and instance.Name == "BigRoomDoor" then
                        createBillboard(instance, "BigRoomDoor", Color3.new(125, 125, 125)) -- Change color as needed
                    end
                end

                workspace.DescendantAdded:Connect(function(instance)
                    if instance:IsA("Model") and instance.Name == "BigRoomDoor" then
                        createBillboard(instance, "BigRoomDoor", Color3.new(125, 125, 125)) -- Change color as needed
                    end
                end)
            end

            monitorBigRoomDoor()
            table.insert(_G.bigRoomDoorESPInstances, esptable)
                
        else
            if _G.bigRoomDoorESPInstances then
                for _, instance in pairs(_G.bigRoomDoorESPInstances) do
                    for _, v in pairs(instance.doors) do
                        if v:FindFirstChild("BillboardGui") then
                            v.BillboardGui:Destroy()
                        end
                    end
                end
                _G.bigRoomDoorESPInstances = nil
            end
        end
    end
})
local keyCardESPToggle = Pressure:AddToggle({
    Name = "Currency and item esp(钱+物品esp)",
    Default = false,
    Callback = function(state)
        if state then
            _G.nahInstances = {}
            local esptable = {nah = {}}

            local function createBillboard(instance, name, color)
                local bill = Instance.new("BillboardGui", game.CoreGui)
                bill.AlwaysOnTop = true
                bill.Size = UDim2.new(0, 100, 0, 50)
                bill.Adornee = instance
                bill.MaxDistance = 2000

                local mid = Instance.new("Frame", bill)
                mid.AnchorPoint = Vector2.new(0.5, 0.5)
                mid.BackgroundColor3 = color
                mid.Size = UDim2.new(0, 8, 0, 8)
                mid.Position = UDim2.new(0.5, 0, 0.5, 0)
                Instance.new("UICorner", mid).CornerRadius = UDim.new(1, 0)
                Instance.new("UIStroke", mid)

                local txt = Instance.new("TextLabel", bill)
                txt.AnchorPoint = Vector2.new(0.5, 0.5)
                txt.BackgroundTransparency = 1
                txt.TextColor3 = color
                txt.Size = UDim2.new(1, 0, 0, 20)
                txt.Position = UDim2.new(0.5, 0, 0.7, 0)
                txt.Text = name
                Instance.new("UIStroke", txt)

                task.spawn(function()
                    while bill do
                        if bill.Adornee == nil or not bill.Adornee:IsDescendantOf(workspace) then
                            bill.Enabled = false
                            bill.Adornee = nil
                            bill:Destroy()
                        end
                        task.wait()
                    end
                end)
            end

            local function monitorFlashBeacon()
                for _, instance in pairs(workspace:GetDescendants()) do
                    if instance:IsA("Model") and instance.Name == "FlashBeacon" then
                        createBillboard(instance, "FlashBeacon", Color3.new(0, 1, 0))
                    end
                end

                workspace.DescendantAdded:Connect(function(instance)
                    if instance:IsA("Model") and instance.Name == "FlashBeacon" then
                        createBillboard(instance, "FlashBeacon", Color3.new(0, 1, 0))
                    end
                end)
            end

            local function monitorCodeBreacher()
                for _, instance in pairs(workspace:GetDescendants()) do
                    if instance:IsA("Model") and instance.Name == "CodeBreacher" then
                        createBillboard(instance, "CodeBreacher", Color3.new(0, 0, 1))
                    end
                end

                workspace.DescendantAdded:Connect(function(instance)
                    if instance:IsA("Model") and instance.Name == "CodeBreacher" then
                        createBillboard(instance, "CodeBreacher", Color3.new(0, 0, 1))
                    end
                end)
            end

            local function monitor25Currency()
                for _, instance in pairs(workspace:GetDescendants()) do
                    if instance:IsA("Model") and instance.Name == "25Currency" then
                        createBillboard(instance, "25Currency", Color3.new(1, 1, 0))
                    end
                end

                workspace.DescendantAdded:Connect(function(instance)
                    if instance:IsA("Model") and instance.Name == "25Currency" then
                        createBillboard(instance, "25Currency", Color3.new(1, 1, 0))
                    end
                end)
            end

            local function monitor50Currency()
                for _, instance in pairs(workspace:GetDescendants()) do
                    if instance:IsA("Model") and instance.Name == "50Currency" then
                        createBillboard(instance, "50Currency", Color3.new(1, 0.5, 0))
                    end
                end

                workspace.DescendantAdded:Connect(function(instance)
                    if instance:IsA("Model") and instance.Name == "50Currency" then
                        createBillboard(instance, "50Currency", Color3.new(1, 0.5, 0))
                    end
                end)
            end

            local function monitor15Currency()
                for _, instance in pairs(workspace:GetDescendants()) do
                    if instance:IsA("Model") and instance.Name == "15Currency" then
                        createBillboard(instance, "15Currency", Color3.new(0.5, 0.5, 0.5))
                    end
                end

                workspace.DescendantAdded:Connect(function(instance)
                    if instance:IsA("Model") and instance.Name == "15Currency" then
                        createBillboard(instance, "15Currency", Color3.new(0.5, 0.5, 0.5))
                    end
                end)
	    end

            local function monitor100Currency()
                for _, instance in pairs(workspace:GetDescendants()) do
                    if instance:IsA("Model") and instance.Name == "100Currency" then
                        createBillboard(instance, "100Currency", Color3.new(1, 0, 1))
                    end
                end

                workspace.DescendantAdded:Connect(function(instance)
                    if instance:IsA("Model") and instance.Name == "100Currency" then
                        createBillboard(instance, "100Currency", Color3.new(1, 0, 1))
                    end
                end)
            end

            local function monitor200Currency()
                for _, instance in pairs(workspace:GetDescendants()) do
                    if instance:IsA("Model") and instance.Name == "200Currency" then
                        createBillboard(instance, "200Currency", Color3.new(0, 1, 1))
                    end
                end

                workspace.DescendantAdded:Connect(function(instance)
                    if instance:IsA("Model") and instance.Name == "200Currency" then
                        createBillboard(instance, "200Currency", Color3.new(0, 1, 1))
		    end
                end)
	    end

	    local function monitorFlashlight()
                for _, instance in pairs(workspace:GetDescendants()) do
                    if instance:IsA("Model") and instance.Name == "Flashlight" then
                        createBillboard(instance, "Flashlight", Color3.new(25, 25, 25))
                    end
                end

                workspace.DescendantAdded:Connect(function(instance)
                    if instance:IsA("Model") and instance.Name == "Flashlight" then
                        createBillboard(instance, "Flashlight", Color3.new(25, 25, 25))
                    end
                end)
	    end

	    local function monitorA()
                for _, instance in pairs(workspace:GetDescendants()) do
                    if instance:IsA("Model") and instance.Name == "Lantern" then
                        createBillboard(instance, "Lantern", Color3.new(99, 99, 99))
                    end
                end

                workspace.DescendantAdded:Connect(function(instance)
                    if instance:IsA("Model") and instance.Name == "Lantern" then
                        createBillboard(instance, "Lantern", Color3.new(99, 99, 99))
                    end
                end)
	    end

	    local function monitorB()
                for _, instance in pairs(workspace:GetDescendants()) do
                    if instance:IsA("Model") and instance.Name == "Blacklight" then
                        createBillboard(instance, "Blacklight", Color3.new(5, 1, 1))
                    end
                end

                workspace.DescendantAdded:Connect(function(instance)
                    if instance:IsA("Model") and instance.Name == "Blacklight" then
                        createBillboard(instance, "Blacklight", Color3.new(5, 1, 1))
                    end
                end)
	    end

	    local function monitorC()
                for _, instance in pairs(workspace:GetDescendants()) do
                    if instance:IsA("Model") and instance.Name == "Gummylight" then
                        createBillboard(instance, "Gummylight", Color3.new(5, 55, 5))
                    end
                end

                workspace.DescendantAdded:Connect(function(instance)
                    if instance:IsA("Model") and instance.Name == "Gummylight" then
                        createBillboard(instance, "Gummylight", Color3.new(5, 55, 5))
                    end
                end)
	    end

	    local function monitorD()
                for _, instance in pairs(workspace:GetDescendants()) do
                    if instance:IsA("Model") and instance.Name == "DwellerPiece" then
                        createBillboard(instance, "DwellerPiece", Color3.new(50, 10, 25))
                    end
                end

                workspace.DescendantAdded:Connect(function(instance)
                    if instance:IsA("Model") and instance.Name == "DwellerPiece" then 
                        createBillboard(instance, "DwellerPiece", Color3.new(50, 10, 25))
                    end
                end)
	    end

            local function monitorE()
                for _, instance in pairs(workspace:GetDescendants()) do
                    if instance:IsA("Model") and instance.Name == "Medkit" then
                        createBillboard(instance, "Medkit", Color3.new(80, 75, 235))
                    end
                end

                workspace.DescendantAdded:Connect(function(instance)
                    if instance:IsA("Model") and instance.Name == "Medkit" then 
                        createBillboard(instance, "Medkit", Color3.new(80, 75, 235))
                    end
                end)
	    end

            local function monitorF()
                for _, instance in pairs(workspace:GetDescendants()) do
                    if instance:IsA("Model") and instance.Name == "Splorglight" then
                        createBillboard(instance, "Splorglight", Color3.new(50, 100, 55))
                    end
                end

                workspace.DescendantAdded:Connect(function(instance)
                    if instance:IsA("Model") and instance.Name == "Splorglight" then 
                        createBillboard(instance, "Splorglight", Color3.new(50, 100, 55))
                    end
                end)
	    end

	    local function monitorG()
                for _, instance in pairs(workspace:GetDescendants()) do
                    if instance:IsA("Model") and instance.Name == "WindupLight" then
                        createBillboard(instance, "WindupLight", Color3.new(85, 100, 66))
                    end
                end

                workspace.DescendantAdded:Connect(function(instance)
                    if instance:IsA("Model") and instance.Name == "WindupLight" then 
                        createBillboard(instance, "WindupLight", Color3.new(85, 100, 66))
                    end
                end)
	    end

				
            monitorFlashBeacon()
            monitorCodeBreacher()
            monitor25Currency()
            monitor50Currency()
            monitor15Currency()
            monitor100Currency()
            monitor200Currency()
	    monitorFlashlight()
            monitorA()
            monitorB()
	    monitorC()
	    monitorD()
	    monitorE()
	    monitorF()
	    monitorG()

            table.insert(_G.nahESPInstances, esptable)
                
        else
            if _G.nahInstances then
                for _, instance in pairs(_G.nahESPInstances) do
                    for _, v in pairs(instance.nah) do
                        v.delete()
                    end
                end
                _G.nahInstances = nil
            end
        end
    end
})
local autoInteract = false

local function fireAllProximityPrompts()
    for _, descendant in pairs(workspace:GetDescendants()) do
        if descendant:IsA("ProximityPrompt") then
            local parentModel = descendant:FindFirstAncestorOfClass("Model")
            if parentModel and parentModel.Name ~= "MonsterLocker" and parentModel.Name ~= "Locker" then
                fireproximityprompt(descendant)
            end
        end
    end
end

local function removeSpecificObjects()
    for _, descendant in pairs(workspace:GetDescendants()) do
        if descendant:IsA("Model") and (descendant.Name == "MonsterLocker" or descendant.Name == "Locker" or descendant.Name == "TricksterRoom") then
            descendant:Destroy()
        end
    end
end

local playerESP = a:AddToggle({
    Name = "Look aura(修电和水下别用)",
    Default = false,
    Callback = function(state)
        autoInteract = state
        if autoInteract then
            while autoInteract do
                removeSpecificObjects()
                fireAllProximityPrompts()
                task.wait(0.01) -- Adjust the wait time as needed
            end
        end
    end
})

local runService = game:GetService("RunService")

local function removeSpecificObjects()
    for _, descendant in pairs(workspace:GetDescendants()) do
        if descendant:IsA("Model") and (descendant.Name == "BubblesLow" or descendant.Name == "EyefestationSpawn" or descendant.Name == "Electricity" or descendant.Name == "DamagePart") then
            descendant:Destroy()
        end
    end
end

local deleteModelsToggle = a:AddToggle({
    Name = "Delete model(Beta)",
    Default = false,
    Callback = function(state)
        if state then
            _G.DeleteModelsConnection = runService.Stepped:Connect(function()
                removeSpecificObjects()
            end)
        else
            if _G.DeleteModelsConnection then
                _G.DeleteModelsConnection:Disconnect()
                _G.DeleteModelsConnection = nil
            end
        end
    end
})

local ab = GUI:CreateSection({
    Name = "Delete list"
})
ab:AddLabel({ Name = "BubblesLow Eyefestation" })
ab:AddLabel({ Name = "Electricity Damage Water?" })

local c = GUI:CreateSection({
    Name = "感谢"
})
c:AddLabel({ Name = "Lookaura 感谢FHOff" })

local b = GUI:CreateSection({
    Name = "使用提示"
})

b:AddLabel({ Name = "用enity bypass遇实体被传平台不要下平台" })
b:AddLabel({ Name = "不然你会后悔因为实体消失后会自动传送原位" })
b:AddLabel({ Name = "如果enity bypass和enity Message一起用" })
b:AddLabel({ Name = "大概率会先执行enity bypass操作" })

local GUI = GUIWindow:CreateTab({
    Name = "SandBox"
})

local SandBox = GUI:CreateSection({
    Name = "1"
})

local autoInteract = false

-- 定义一个函数来查找并触发 MulberryBush 的 ProximityPrompt
local function fireAllProximityPrompts()
    for _, descendant in pairs(workspace:GetDescendants()) do
        if descendant:IsA("ProximityPrompt") then
            local parentModel = descendant:FindFirstAncestorOfClass("Model")
            if parentModel and parentModel.Name == "MulberryBush" then
                fireproximityprompt(descendant)
            end
        end
    end
end

-- 定义玩家的 ESP 切换功能
local playerESP = SandBox:AddToggle({
    Name = "Look aura (MulberryBush)",
    Default = false,
    Callback = function(state)
        autoInteract = state
        if autoInteract then
            while autoInteract do
                fireAllProximityPrompts()
                task.wait(0.25) -- 调整等待时间
            end
        end
    end
})