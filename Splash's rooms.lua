local OrionLib = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Orion/main/source'))()
OrionLib:MakeNotification({
    Name = "加载中...",
    Content = "可能会有些许卡顿",
    Image = "rbxassetid://4483345998",
    Time = 4
})
local Window = OrionLib:MakeWindow({
	IntroText = "SplashRooms",
	Name = "SplashRooms",
	HidePremium = false,
	SaveConfig = true,
	ConfigFolder = "SplashRooms"
})
local Tab = Window:MakeTab({--main
	Name = "主界面",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})
OrionLib:MakeNotification({
    Name = "加载完成",
    Content = "已成功加载",
    Image = "rbxassetid://4483345998",
    Time = 4
})
--Function设置
local function Notification(name,content)--信息
    OrionLib:MakeNotification({
        Name = name,
        Content = content,
        Image = "rbxassetid://4483345998",
        Time = 3
        })
    end
local function delNotification(delthings)--删除信息
    Notification(delthings,"已成功删除")
    end
local function entityNotification(entityname)--实体提醒
    Notification("实体提醒",entityname)
    end    
local function espmodel(modelname,name,r,g,b)--Esp物品用
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
end
--Function结束
Tab:AddToggle({
	Name = "轻松交互",
	Default = true,
    Flag = "ezuse"
})
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
Tab:AddToggle({--自动转向
	Name = "自动转向",
	Default = true,
    Callback = function(Value)
        local humanoid = game:GetService("Players").LocalPlayer.Character:FindFirstChild("Humanoid")
        if Value == true then
            humanoid.AutoRotate = true
        else
            humanoid.AutoRotate = false
        end
    end
})
Tab:AddSlider({
	Name = "重力",
	Min = 1,
	Max = 500,
	Default = 200,
	Increment = 1,
	ValueName = "Gravity",
	Callback = function(Value)
        game.Workspace.Gravity = Value
    end
})
local Del = Window:MakeTab({
	Name = "删除",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})
Del:AddToggle({
	Name = "删除a90",
	Default = true,
	Flag = "noa90",
	Save = true
})
Del:AddToggle({
	Name = "删除a100",
	Default = true,
    Flag = "noa100",
})
Del:AddToggle({
	Name = "删除桌子",
	Default = true,
	Flag = "notable",
	Save = true
})
Del:AddButton({
    Name = "删除跳杀",
    Callback = function()
        local jcs = game.ReplicatedStorage:GetDescendants()
        for _, jumpscares in pairs(jcs) do
            if jumpscares.Name == "Jumpscare" then
                jumpscares:Destroy()
            end
        end
    end
})
local Esp = Window:MakeTab({--Esp
	Name = "Esp",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})
Esp:AddToggle({--door
    Name = "门Esp",
    Default = true,
    Callback = function(state)
        espmodel("Door","门","0","1","0")
    end
})
Esp:AddToggle({--locker
    Name = "柜子ESP",
    Default = false,
    Callback = function(state)
        espmodel("Locker","柜子","0","1","0")
    end
})
Esp:AddToggle({--物品
    Name = "物品Esp",
    Default = true,
    Callback = function(state)
        espmodel("Battery","电池","25","25","25")
    end
})
Esp:AddToggle({--ItemLocker
    Name = "桌子Esp",
    Default = false,
    Callback = function(state)
        espmodel("table","桌子","1","1","0")
    end
})
local Music = Window:MakeTab({--main
	Name = "音乐盒(客户端)",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})
Music:AddToggle({
	Name = "音乐盒功能",
	Default = true,
    Callback = function(Value)
    if Value == true then
        local musicbox = Instance.new("Sound")
        musicbox.Parent = workspace
        musicbox.Name = "MusicBox"
    else
        workspace.MusicBox:Destroy()
    end
end
})
Music:AddLabel("若无法使用可以尝试重开音乐盒开关")
Music:AddToggle({
	Name = "音乐盒开关",
	Default = true,
    Callback = function(Value)
        if Value == true then
            workspace.MusicBox.Playing = true
        else
            workspace.MusicBox:Pause()
            CoolToggle:Set(true)
        end
    end
})
Music:AddTextbox({
	Name = "音乐ID",
	TextDisappear = true,
	Callback = function(musicid)
		workspace.MusicBox.SoundId = "rbxassetid://" .. musicid
        workspace.MusicBox:Play()
        workspace.MusicBox.Looped = true
        CoolToggle:Set(true)
	end	  
})
Music:AddTextbox({
	Name = "音乐音量",
	TextDisappear = true,
	Callback = function(musicvolume)
		workspace.MusicBox.Volume = musicvolume
        CoolToggle:Set(true)
	end
})
Music:AddTextbox({
	Name = "音乐进度",
	TextDisappear = true,
	Callback = function(musictime)
		workspace.MusicBox.TimePosition = musictime
	end
})
Music:AddToggle({
	Name = "音乐循环",
	Default = true,
    Callback = function(Value)
        if Value == true then
            workspace.MusicBox.Looped = true
        else
            workspace.MusicBox.Looped = false
        end
    end
})
Music:AddButton({
	Name = "清除MusicBox",
	Default = false,
    Callback = function()
    	workspace.MusicBox:Destroy()
        delNotification("MusicBox")
    end
})
local others = Window:MakeTab({--others
	Name = "其他",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})
others:AddButton({
	Name = "注入Infinity Yield",
	Callback = function()
        Notification("注入Infinity Yield","尝试注入中")
        loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
        Notification("注入Infinity Yield","注入完成(如果没有加载就是失败了)")
	end    
})
others:AddButton({
	Name = "注入Dex v2 white(会卡顿)",
	Callback = function()
        Notification("注入Dex v2 white","尝试注入中")
        loadstring(game:HttpGet('https://raw.githubusercontent.com/MariyaFurmanova/Library/main/dex2.0'))()
        Notification("注入Dex v2 white","注入完成(如果没有加载就是失败了)")
	end    
})
others:AddButton({
    Name = "删除此窗口",
    Callback = function()
        OrionLib:Destroy()
    end
})
others:AddButton({
	Name = "关闭Dex",
	Callback = function()
        game.CoreGui.Dex:Destroy()
        Notification("Dex","已关闭")
	end    
})
workspace.DescendantAdded:Connect(function(inst)--删除
    if inst.Name == "table" and OrionLib.Flags.notable.Value then
        inst:Destroy()
    end
    if inst.Name == "pallidus" and OrionLib.Flags.noa90.Value then
        inst:Destroy()
        delNotification("a90")
    end
    if inst.Name == "Stalker" and OrionLib.Flags.noa100.Value then
        inst:Destroy()
        delNotification("a100")
    end
end)
workspace.ChildAdded:Connect(function(child)
    if child.Name == "ooook" and OrionLib.Flags.NotifyEntities.Value then--实体提醒-生成
        entityNotification("a20出现")
    end
    if child.Name == "multi" and OrionLib.Flags.NotifyEntities.Value then
        entityNotification("A60出现")
    end
    if child.Name == "nomnomnom" and OrionLib.Flags.NotifyEntities.Value then
        entityNotification("a75出现")
    end
    if child.Name == "Stalker" and OrionLib.Flags.NotifyEntities.Value then
        entityNotification("a100出现")
    end
    if child.Name == "A120" and OrionLib.Flags.NotifyEntities.Value then
        entityNotification("A120出现")
    end
    if child.Name == "A200" and OrionLib.Flags.NotifyEntities.Value then
        entityNotification("A200出现")
    end
    if child.Name == "Froger" and OrionLib.Flags.NotifyEntities.Value then
        entityNotification("Froger出现")
    end
    if child.Name == "RidgeFroger" and OrionLib.Flags.NotifyEntities.Value then
        entityNotification("Froger出现")
    end
    if child.Name == "Chainsmoker" and OrionLib.Flags.NotifyEntities.Value then
        entityNotification("Chainsmoker出现")
    end
end)
workspace.ChildRemoved:Connect(function(child)--实体提醒-消失
    if child.Name == "ooook" and OrionLib.Flags.NotifyEntities.Value then
        entityNotification("a20消失")
    end
    if child.Name == "multi" and OrionLib.Flags.NotifyEntities.Value then
        entityNotification("A60消失")
    end
    if child.Name == "nomnomnom" and OrionLib.Flags.NotifyEntities.Value then
        entityNotification("a75消失")
    end
    if child.Name == "Stalker" and OrionLib.Flags.NotifyEntities.Value then
        entityNotification("a100消失")
    end
    if child.Name == "A120" and OrionLib.Flags.NotifyEntities.Value then
        entityNotification("A120消失")
    end
    if child.Name == "A200" and OrionLib.Flags.NotifyEntities.Value then
        entityNotification("A200消失")
    end
    if child.Name == "Froger" and OrionLib.Flags.NotifyEntities.Value then
        entityNotification("Froger消失")
    end
    if child.Name == "RidgeFroger" and OrionLib.Flags.NotifyEntities.Value then
        entityNotification("Froger消失")
    end
    if child.Name == "Chainsmoker" and OrionLib.Flags.NotifyEntities.Value then
        entityNotification("Chainsmoker消失")
    end
    if child.Name == "Pandemonium" and OrionLib.Flags.NotifyEntities.Value then
        entityNotification("Pandemonium消失")
    end
end)