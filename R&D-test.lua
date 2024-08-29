local OrionLib = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Orion/main/source'))()
local Window = OrionLib:MakeWindow({
	IntroText = "R&D",
	Name = "Rooms&Doors",
	HidePremium = false,
	SaveConfig = true,
	ConfigFolder = "RDScript"
})
local Tab = Window:MakeTab({--main
	Name = "主界面",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})
local function espmodel(modelname,name,r,g,b)--Esp
    _G.ESPInstances = {}
    local esptable = {doors = {}}

    local function createBillboard(instance, name, color)
        local bill = Instance.new("BillboardGui", game.CoreGui)
        bill.AlwaysOnTop = true
        bill.Size = UDim2.new(0, 100, 0, 50)
        bill.Adornee = instance
        bill.MaxDistance = 2000
        bill.Name = name .. "esp"

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

    local function monitorEsp()
        for _, instance in pairs(workspace:GetDescendants()) do
            if instance:IsA("Model") and instance.Name == modelname then
                createBillboard(instance, name, Color3.new(r,g,b)) -- Change color as neededPipesDoorESPInstances
            end
        end

        workspace.DescendantAdded:Connect(function(instance)
            if instance:IsA("Model") and instance.Name == modelname then
                createBillboard(instance, name, Color3.new(r,g,b)) -- Change color as needed
            end
        end)
    end

    monitorEsp()
    table.insert(_G.ESPInstances, esptable)
local function esppart(partname,name,r,g,b)--Esp
    _G.ESPInstances = {}
    local esptable = {doors = {}}

    local function createBillboard(instance, name, color)
        local bill = Instance.new("BillboardGui", game.CoreGui)
        bill.AlwaysOnTop = true
        bill.Size = UDim2.new(0, 100, 0, 50)
        bill.Adornee = instance
        bill.MaxDistance = 2000
        bill.Name = name .. "esp"

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

    local function monitorEsp()
        for _, instance in pairs(workspace:GetDescendants()) do
            if instance:IsA("Part") and instance.Name == partname then
                createBillboard(instance, name, Color3.new(r,g,b)) -- Change color as neededPipesDoorESPInstances
            end
        end

        workspace.DescendantAdded:Connect(function(instance)
            if instance:IsA("Part") and instance.Name == partname then
                createBillboard(instance, name, Color3.new(r,g,b)) -- Change color as needed
            end
        end)
    end

    monitorEsp()
    table.insert(_G.ESPInstances, esptable)
local function delNotification(delthings)--删除信息
    Notification(delthings,"已成功删除")
    end
Tab:AddToggle({
	Name = "实体提醒",
	Default = true,
	Flag = "NotifyEntities",
	Save = true
})
Tab:AddToggle({--高亮
	Name = "高亮(低质量)",
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
Tab:AddButton({
	Name = "恢复跳跃",
	Default = true,
    Callback = function()
        local humanoid = game:GetService("Players").LocalPlayer.Character:FindFirstChild("Humanoid")
        humanoid.JumpPower = 50
    end
})
Tab:AddButton({
	Name = "删除此窗口",
	Default = true,
    Callback = function()
        OrionLib:Destroy()
    end
})
local Del = Window:MakeTab({--main
	Name = "删除",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})
Del:AddToggle({
	Name = "删除a60",
	Default = true,
	Flag = "noa60",
	Save = true
})
Del:AddToggle({
	Name = "删除a90",
	Default = true,
	Flag = "noa90",
	Save = true
})
local Esp = Window:MakeTab({--main
	Name = "Esp",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})
Esp:AddToggle({
	Name = "门Esp",
	Default = true,
    Callback = function()
        esppart("door","门","0","1","0")
    end
})
Esp:AddToggle({
	Name = "柜子Esp",
	Default = true,
    Callback = function()
        espmodel("sdgadfasdf","柜子","0","1","0")
    end
})
Esp:AddToggle({
	Name = "电池Esp",
	Default = true,
    Callback = function()
        espmodel("battery","电池","0","0","0")
    end
})
Esp:AddToggle({
	Name = "a45柜Esp",
	Default = true,
    Callback = function()
        espmodel("sdsafagdsa","a45柜","1","0","0")
    end
})
Esp:AddToggle({
	Name = "桌子Esp",
	Default = true,
    Callback = function()
        espmodel("hidetable","桌子","1","1","0")
    end
})
workspace.ChildAdded:Connect(function(child)
    if child.Name == "monster" and OrionLib.Flags.NotifyEntities.Value then
        task.wait(0.1)
        entityNotification("a60出现")
    end
    if child.Name == "monster" and OrionLib.Flags.noa60.Value then
        task.wait(0.1)
        child:Destroy()
        delNotification("a60")
    end
    if child.Name == "remotemonster" and OrionLib.Flags.noa60.Value then
        task.wait(0.1)
        child:Destroy()
    end
    if child.Name == "eater" and OrionLib.Flags.NotifyEntities.Value then
        task.wait(0.1)
        entityNotification("a75出现")
    end
    if child.Name == "Stalker" and OrionLib.Flags.NotifyEntities.Value then
        task.wait(0.1)
        entityNotification("a100出现")
    end
    if child.Name == "Pinkie" and OrionLib.Flags.NotifyEntities.Value then
        task.wait(0.1)
        entityNotification("Pinkie出现")
    end
    if child.Name == "RidgePinkie" and OrionLib.Flags.NotifyEntities.Value then
        task.wait(0.1)
        entityNotification("Pinkie出现")
    end
    if child.Name == "Froger" and OrionLib.Flags.NotifyEntities.Value then
        task.wait(0.1)
        entityNotification("Froger出现")
    end
    if child.Name == "RidgeFroger" and OrionLib.Flags.NotifyEntities.Value then
        task.wait(0.1)
        entityNotification("Froger出现")
    end
    if child.Name == "Chainsmoker" and OrionLib.Flags.NotifyEntities.Value then
        task.wait(0.1)
        entityNotification("Chainsmoker出现")
    end
end)
workspace.ChildRemoved:Connect(function(child)--实体提醒-消失
    if child.Name == "monster" and OrionLib.Flags.NotifyEntities.Value then
        task.wait(0.1)
        entityNotification("A60消失")
    end
    if child.Name == "eater" and OrionLib.Flags.NotifyEntities.Value then
        task.wait(0.1)
        entityNotification("a75消失")
    end
    if child.Name == "Stalker" and OrionLib.Flags.NotifyEntities.Value then
        task.wait(0.1)
        entityNotification("a100消失")
    end
    if child.Name == "Pinkie" and OrionLib.Flags.NotifyEntities.Value then
        task.wait(0.1)
        entityNotification("Pinkie消失")
    end
    if child.Name == "RidgePinkie" and OrionLib.Flags.NotifyEntities.Value then
        task.wait(0.1)
        entityNotification("Pinkie消失")
    end
    if child.Name == "Froger" and OrionLib.Flags.NotifyEntities.Value then
        task.wait(0.1)
        entityNotification("Froger消失")
    end
    if child.Name == "RidgeFroger" and OrionLib.Flags.NotifyEntities.Value then
        task.wait(0.1)
        entityNotification("Froger消失")
    end
    if child.Name == "Chainsmoker" and OrionLib.Flags.NotifyEntities.Value then
        task.wait(0.1)
        entityNotification("Chainsmoker消失")
    end
    if child.Name == "Pandemonium" and OrionLib.Flags.NotifyEntities.Value then
        task.wait(0.1)
        entityNotification("Pandemonium消失")
    end
end)