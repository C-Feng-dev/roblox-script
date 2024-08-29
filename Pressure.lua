local OrionLib = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Orion/main/source'))()
OrionLib:MakeNotification({
    Name = "加载中...",
    Content = "可能会有些许卡顿",
    Image = "rbxassetid://4483345998",
    Time = 4
})
local Window = OrionLib:MakeWindow({
	IntroText = "Pressure",
	Name = "Pressure",
	HidePremium = false,
	SaveConfig = true,
	ConfigFolder = "PressureScript"
})
--local设置
local entityNames = {"Angler","RidgeAngler","Blitz","RidgeBlitz","Pinkie","RidgePinkie","Froger","RidgeFroger","Chainsmoker","RidgeChainsmoker","Pandemonium","RidgePandemonium","Eyefestation","A60"}--实体
local playerPositions = {}--玩家坐标
local Entitytoavoid = {}--自动躲避用-检测实体
local Platform--平台
local humanoid = game:GetService("Players").LocalPlayer.Character:FindFirstChild("Humanoid")--本地玩家homanoid
--local结束->Function设置
local function Notification(name,content)--信息
    OrionLib:MakeNotification({
        Name = name,
        Content = content,
        Image = "rbxassetid://4483345998",
        Time = 3
        })
end
local function copyNotification(copyitemname)--复制信息
    Notification(copyitemname,"已成功复制")
end
local function delNotification(delthings)--删除信息
    Notification(delthings,"已成功删除")
end
local function entityNotification(entityname)--实体提醒
    Notification("实体提醒",entityname)
end    
local function copyitems(copyitem)--复制物品
    local create_NumberValue = Instance.new("NumberValue")--copy items-type NumberValue
    create_NumberValue.Name = copyitem
	create_NumberValue.Parent = game.Players.LocalPlayer.PlayerFolder.Inventory
end
local function espmodel(modelname,name,r,g,b)--Esp物品用
    _G.ESPInstances = {}
    local esptable = {doors = {}}

    local function createBillboard(themodel, name, color)

        local bill = Instance.new("BillboardGui", themodel)
        bill.AlwaysOnTop = true
        bill.Size = UDim2.new(0, 100, 0, 50)
        bill.Adornee = themodel
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
        local GD = workspace:GetDescendants()
        for _, themodel in pairs(GD) do
            if themodel:IsA("Model") and themodel.Parent ~= game:GetService("Players").LocalPlayer and themodel.Name == modelname then
                createBillboard(themodel, name, Color3.new(r,g,b)) -- Change color as neededPipesDoorESPInstances
            end
        end

        workspace.DescendantAdded:Connect(function(themodel)
            if themodel:IsA("Model") and themodel.Parent ~= game:GetService("Players").LocalPlayer and themodel.Name == modelname then
                createBillboard(themodel, name, Color3.new(r,g,b)) -- Change color as needed
            end
        end)
    end

    monitorEsp()
end
local function unespmodel(name)--unEsp物品用
    local GD = workspace:GetDescendants()
    for _, esp in pairs(GD) do
        if esp.Name == name .. "Esp" then
            esp:Destroy()
        end
    end
end
local function createPlatform(name,sizeVector3,positionVector3)--创建平台-Vector3.new(x,y,z)
    if Platform then
        Platform:Destroy() --移除多余平台
    end
    Platform = Instance.new("Part")
    Platform.Name = name
    Platform.Size = sizeVector3
    Platform.Position = positionVector3
    Platform.Anchored = true
    Platform.Parent = workspace
    Platform.Transparency = 1
    Platform.CastShadow = false
end
local function teleportPlayerTo(player,toPosition)--传送玩家-Vector3.new(x,y,z)
    if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local toPosition = toPosition 
        playerPositions[player.UserId] = player.Character.HumanoidRootPart.CFrame
        player.Character.HumanoidRootPart.CFrame = CFrame.new(toPosition)
    end
end
local function teleportPlayerBack(player)--返回玩家
    if playerPositions[player.UserId] then
        player.Character.HumanoidRootPart.CFrame = playerPositions[player.UserId]
        playerPositions[player.UserId] = nil --清除坐标
    end
end
local function Animation(AnimationID)--动作播放
    local player = game:GetService("Players").LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")
    local animator = humanoid:WaitForChild("Animator")
    local kickAnimation = Instance.new("Animation")
    kickAnimation.AnimationId = AnimationID
    local kickAnimationTrack = animator:LoadAnimation(kickAnimation)
    kickAnimationTrack:Play()
end
--Function结束
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
Tab:AddToggle({
	Name = "轻松交互",
	Default = true,
    Flag = "ezuse"
})
Tab:AddButton({--自动交互
	Name = "自动交互电机/电缆",
    Callback = function()
        local GD = workspace:GetDescendants()
        for _, autoinstance in pairs(GD) do
            if autoinstance.Name == "EncounterGenerator" then
                autoinstance.ProxyPart.ProximityPrompt.MaxActivationDistance = 10000
                autoinstance.ProxyPart.ProximityPrompt.Exclusivity = 2
                for count = 0,20,1 do
                    autoinstance.ProxyPart.ProximityPrompt:InputHoldBegin()
                end
            end
            if autoinstance.Name == "BrokenCables" then
                autoinstance.ProxyPart.ProximityPrompt.MaxActivationDistance = 10000
                autoinstance.ProxyPart.ProximityPrompt.Exclusivity = 2
                for count = 0,20,1 do
                autoinstance.ProxyPart.ProximityPrompt:InputHoldBegin()
                end
            end
        end
    end
})
Tab:AddToggle({
	Name = "实体提醒",
	Default = true,
	Flag = "NotifyEntities",
	Save = true
})
Tab:AddToggle({
	Name = "自动躲避(待修复)",
	Default = false,
	Flag = "avoid",
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
    Name = "关闭大厅音乐",
    Callback = function()
        workspace.PlaylistSong.Volume = 0
        workspace.PlaylistSong.Looped = true
    end
})
Tab:AddButton({
    Name = "删除隐形墙",
    Callback = function()
        local GD = workspace:GetDescendants()
        for _, fs in pairs(GD) do
            if iw.Name == "InvisibleWalls" then
                iw:Destroy()
            end
        end
    end
})
Tab:AddBind({
	Name = "轻松交互(手动)",
	Default = Enum.KeyCode.Q,
	Hold = false,
	Callback = function()--交互-手动
        local GD = workspace:GetDescendants()
        for _, toezuse in pairs(GD) do
            if toezuse:IsA("ProximityPrompt") then
                toezuse.HoldDuration = "0"
                toezuse.RequiresLineOfSight = false
            end
        end
        Notification("轻松交互","已修改交互")
	end    
})
local Item = Window:MakeTab({
	Name = "物品",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})
Item:AddParagraph("提醒","复制物品需要背包内有物品本体,复制出的照明类工具电量等与本体相同")
Item:AddDropdown({
	Name = "功能",
	Default = "复制",
	Options = {"复制", "删除"},
	Flag = "cpyordel"    
})
Item:AddButton({
	Name = "钥匙卡",
	Callback = function()
		game.Players.LocalPlayer.PlayerFolder.Inventory.NormalKeyCard:Destroy()
            if OrionLib.Flags.cpyordel.Value == "复制" then
                copyitems("NormalKeyCard")
		        copyNotification("钥匙卡")
	        else
                delNotification("钥匙卡")
            end
        end
})
Item:AddButton({
	Name = "特殊钥匙卡",
	Callback = function()
		game.Players.LocalPlayer.PlayerFolder.Inventory.InnerKeyCard:Destroy()
            if OrionLib.Flags.cpyordel.Value == "复制" then
                copyitems("InnerKeyCard")
		        copyNotification("特殊钥匙卡")
	        else
                delNotification("特殊钥匙卡")
            end
        end    
})
Item:AddButton({
	Name = "闪光灯",
	Callback = function()
        if OrionLib.Flags.cpyordel.Value == "复制" then
            copyitems("FlashBeacon")
		    copyNotification("闪光灯")
	    else
            game.Players.LocalPlayer.PlayerFolder.Inventory.FlashBeacon:Destroy()
            delNotification("闪光灯")
        end
    end
})
Item:AddButton({
	Name = "黑光",
	Callback = function()
        if OrionLib.Flags.cpyordel.Value == "复制" then
            copyitems("Blacklight")
		    copyNotification("黑光")
	    else
            game.Players.LocalPlayer.PlayerFolder.Inventory.Blacklight:Destroy()
            delNotification("黑光")
        end
    end
})
Item:AddButton({
	Name = "手电筒",
	Callback = function()
        if OrionLib.Flags.cpyordel.Value == "复制" then
            copyitems("Flashlight")
		    copyNotification("手电筒")
	    else
            game.Players.LocalPlayer.PlayerFolder.Inventory.Flashlight:Destroy()
            delNotification("手电筒")
        end
    end    
})
Item:AddButton({
	Name = "灯笼",
	Callback = function()
        if OrionLib.Flags.cpyordel.Value == "复制" then
            copyitems("Lantern")
		    copyNotification("灯笼")
        else
            game.Players.LocalPlayer.PlayerFolder.Inventory.Lantern:Destroy()
            delNotification("灯笼")
        end
	end    
})
Item:AddButton({
	Name = "魔法书",
	Callback = function()
        if OrionLib.Flags.cpyordel.Value == "复制" then
            copyitems("Book")
		    copyNotification("魔法书")
	    else
            game.Players.LocalPlayer.PlayerFolder.Inventory.Book:Destroy()
            delNotification("魔法书")
        end
    end
})
Item:AddButton({
	Name = "软糖手电筒",
	Callback = function()
        if OrionLib.Flags.cpyordel.Value == "复制" then
            copyitems("Gummylight")
		    copyNotification("软糖手电筒")
        else
            game.Players.LocalPlayer.PlayerFolder.Inventory.Gummylight:Destroy()
            delNotification("软糖手电筒")
        end
	end
})
Item:AddButton({
	Name = "手摇手电筒",
	Callback = function()
        if OrionLib.Flags.cpyordel.Value == "复制" then
            copyitems("WindupLight")
		    copyNotification("手摇手电筒")
        else
            game.Players.LocalPlayer.PlayerFolder.Inventory.WindupLight:Destroy()
            delNotification("手摇手电筒")
        end
	end
})
local Del = Window:MakeTab({
	Name = "删除",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})
Del:AddButton({
	Name = "删除第一次boss关音乐",
	Callback = function()
		workspace.RegSearchlightsIntro:Destroy()
		workspace.RegSearchlightsLoop:Destroy()
        delNotification("boss关音乐")
	end
})
Del:AddButton({
	Name = "删除第二次boss关音乐",
	Callback = function()
		workspace.FinaleSong:Destroy()
        delNotification("boss关音乐")
	end
})
Del:AddButton({
	Name = "删除大炮滴滴声",
	Callback = function()
        local GD = workspace:GetDescendants()
        for _, fs in pairs(GD) do
            if fs.Name == "FinaleSignal" then
                fs:Destroy()
                delNotification("大炮滴滴声")
            end
        end
	end
})
Del:AddToggle({
	Name = "删除z317",
	Default = true,
	Flag = "noeyefestation",
	Save = true
})
Del:AddToggle({
	Name = "删除z367",
	Default = true,
	Flag = "nopandemonium",
	Save = true
})
Del:AddToggle({
	Name = "删除Searchlights(待修复)",
	Default = false,
	Flag = "nosearchlights",
	Save = true
})
Del:AddToggle({
	Name = "删除S-Q",
	Default = true,
	Flag = "nosq",
	Save = true
})
Del:AddToggle({
	Name = "删除自然伤害(大部分)",
	Default = true,
	Flag = "nodamage",
	Save = true
})
Del:AddToggle({
	Name = "删除炮台",
	Default = true,
	Flag = "noturret",
	Save = true
})
Del:AddToggle({
	Name = "删除假门(防触发)",
	Default = true,
	Flag = "noTrickster",
	Save = true
})
Del:AddToggle({
	Name = "删除假柜",
	Default = true,
	Flag = "noMonsterLocker",
	Save = true
})
Del:AddToggle({
	Name = "删除z432",
	Default = true,
	Flag = "noFriendPart",
	Save = true
})
Del:AddButton({
	Name = "手动删除Searchlights(第一次boss战)",
	Callback = function()
		local SLE_room = workspace.Rooms.SearchlightsEncounter
		SLE_room.Searchlights:Destroy()
		SLE_room.MainSearchlight:Destroy()
        delNotification("删除Searchlights")
	end
})
Del:AddButton({
	Name = "手动删除Searchlights(第二次boss战)",
	Callback = function()
		local SLE_room = workspace.Rooms.SearchlightsEnding.Interactables
		SLE_room.Searchlights:Destroy()
        SLE_room.Searchlights1:Destroy()
        SLE_room.Searchlights2:Destroy()
        SLE_room.Searchlights3:Destroy()
        SLE_room.SearchlightsCave:Destroy()
        delNotification("删除Searchlights")
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
        if state then
            espmodel("NormalDoor","门","0","1","0")
        else
            unespmodel("门")
        end
    end
})
Esp:AddToggle({--locker
    Name = "柜子ESP",
    Default = true,
    Callback = function(state)
        if state then
            espmodel("Locker","柜子","0","1","0")
        else

        end
    end
})
Esp:AddToggle({--keycard
    Name = "钥匙卡Esp",
    Default = true,
    Callback = function(state)
        if state then
            espmodel("NormalKeyCard","钥匙卡","0","0","1")
            espmodel("InnerKeyCard","特殊钥匙卡","1","0","0")
            espmodel("RidgeKeyCard","山脊钥匙卡","1","1","0")
        else
            unespmodel("钥匙卡")
            unespmodel("特殊钥匙卡")
            unespmodel("山脊钥匙卡")
        end
    end
})
Esp:AddToggle({--fake door
    Name = "假门Esp",
    Default = true,
    Callback = function(state)
        if state then
            espmodel("TricksterRoom","假门","1","0","0")
            espmodel("RidgeTricksterRoom","假门","1","0","0")
        else
            unespmodel("假门")
        end
    end
})
Esp:AddToggle({--fake locker
    Name = "假柜Esp",
    Default = true,
    Callback = function(state)
        if state then
            espmodel("MonsterLocker","假柜子","1","0","0")
        else
            unespmodel("假柜子")
        end
    end
})
Esp:AddToggle({--big door
    Name = "大门Esp",
    Default = true,
    Callback = function(state)
        if state then
            espmodel("BigRoomDoor","大门","0","1","0")
        else
            unespmodel("大门")
        end
    end
})
Esp:AddToggle({--Generator
    Name = "发电机Esp",
    Default = true,
    Callback = function(state)
        if state then
            espmodel("EncounterGenerator","未修复发电机","1","0","0")
        else
            unespmodel("未修复发电机")
        end
    end
})
Esp:AddToggle({--损坏线缆
    Name = "电缆Esp",
    Default = true,
    Callback = function(state)
        if state then
            espmodel("BrokenCables","未修复电缆","1","0","0")
        else
            unespmodel("未修复电缆")
        end
    end
})
Esp:AddToggle({--拉杆
    Name = "拉杆Esp",
    Default = true,
    Callback = function(state)
        if state then
            espmodel("Lever","拉杆","50","10","255")
            espmodel("Lever2","拉杆","50","10","255")
            espmodel("TriggerLever","大炮拉杆","0","1","0")
        else
            unespmodel("拉杆")
            unespmodel("大炮拉杆")
        end
    end
})
Esp:AddToggle({--物品
    Name = "物品Esp",
    Default = true,
    Callback = function(state)
        if state then
            espmodel("Flashlight","手电筒","25","25","25")
            espmodel("Lantern","灯笼","99","99","99")
            espmodel("FlashBeacon","闪光","1","1","1")
            espmodel("Blacklight","黑光","127","0","255")
            espmodel("Gummylight","软糖手电筒","15","230","100")
            espmodel("CodeBreacher","红卡","255","30","30")
            espmodel("DwellerPiece","墙居者肉块","50","10","25")
            espmodel("Medkit","医疗箱","80","51","235")
            espmodel("Splorglight","Splorglight","50","100","55")
            espmodel("WindupLight","手摇手电筒","85","100","66")
            espmodel("Book","魔法书","0","255","255")
        else
            unespmodel("手电筒")
            unespmodel("灯笼")
            unespmodel("闪光")
            unespmodel("黑光")
            unespmodel("软糖手电筒")
            unespmodel("红卡")
            unespmodel("墙居者肉块")
            unespmodel("医疗箱")
            unespmodel("Splorglight")
            unespmodel("手摇手电筒")
            unespmodel("魔法书")
        end
    end
})
Esp:AddToggle({--ItemLocker
    Name = "储物柜Esp",
    Default = false,
    Callback = function(state)
        if state then
            espmodel("ItemLocker","储物柜","50","10","255")
        else
            unespmodel("储物柜")
        end
    end
})
Esp:AddToggle({--钱
    Name = "研究(钱)Esp(>20)",
    Default = true,
    Callback = function(state)
        if state then
            espmodel("25Currency","25钱","1","1","0")
            espmodel("50Currency","50钱","1","0.5","0")
            espmodel("100Currency","100钱","1","0","1")
            espmodel("200Currency","200钱","0","1","1")
        else
            unespmodel("25钱")
            unespmodel("50钱")
            unespmodel("100钱")
            unespmodel("200钱")
        end
    end
})
Esp:AddToggle({
    Name = "研究(钱)Esp(<20)",
    Default = false,
    Callback = function(state)
        if state then
            espmodel("5Currency","5钱","1","1","1")
            espmodel("10Currency","10钱","1","1","1")
            espmodel("15Currency","15钱","0.5","0.5","0.5")
            espmodel("20Currency","20钱","1","1","1")
        else
            unespmodel("5钱")
            unespmodel("10钱")
            unespmodel("15钱")
            unespmodel("20钱")
        end
    end
})
Esp:AddToggle({--
    Name = "玩家Esp",
    Default = false,
    Callback = function(state)
        if state then
            _G.espInstances = {}
            local GP = game.Players:GetPlayers()
            for _, player in pairs(GP) do
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
local Player = Window:MakeTab({--main
	Name = "玩家",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})
local Section = Player:AddSection({
	Name = "相机"
})
Player:AddSlider({--视场角
	Name = "视场角",
	Min = 1,
	Max = 120,
	Default = 120,
	Increment = 1,
	ValueName = "fov",
	Callback = function(Value)
        game.Workspace.Camera.FieldOfView = Value
    end
})
local Section = Player:AddSection({
	Name = "身体"
})
Player:AddSlider({--速度
	Name = "速度",
	Min = 1,
	Max = 200,
	Default = 17,
	Increment = 1,
	ValueName = "speed",
	Callback = function(Value)
        humanoid.WalkSpeed = Value
    end
})
Player:AddSlider({--跳跃强度
	Name = "跳跃强度",
	Min = 1,
	Max = 200,
	Default = 50,
	Increment = 1,
	ValueName = "power",
	Callback = function(Value)
        humanoid.JumpPower = Value
    end
})
Player:AddTextbox({--腿部高度
	Name = "腿部高度",
    TextDisappear = false,
    Callback = function(Value)
        humanoid.HipHeight = Value
    end
})
Player:AddSlider({--斜坡角度
	Name = "最大斜坡角度",
	Min = 0,
	Max = 89,
	Default = 89,
	Increment = 1,
	ValueName = "度",
	Callback = function(Value)
        humanoid.MaxSlopeAngle = Value
    end
})
Player:AddSlider({
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
local Section = Player:AddSection({
	Name = "其他"
})
Player:AddToggle({--自动转向
	Name = "自动转向",
	Default = true,
    Callback = function(Value)
        if Value == true then
            humanoid.AutoRotate = true
        else
            humanoid.AutoRotate = false
        end
    end
})
Player:AddButton({
	Name = "坐",
    Callback = function()
    	local humanoid = game:GetService("Players").LocalPlayer.Character:FindFirstChild("Humanoid")
        humanoid.Sit = true
    end
})
Player:AddToggle({--自动转向
	Name = "直立",
	Default = false,
    Callback = function(Value)
        if Value == true then
            humanoid.PlatformStand = true
        else
            humanoid.PlatformStand = false
        end
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
        end
    end
})
Music:AddTextbox({
	Name = "音乐ID",
	TextDisappear = false,
	Callback = function(musicid)
		workspace.MusicBox.SoundId = "rbxassetid://" .. musicid
        workspace.MusicBox:Play()
        workspace.MusicBox.Looped = true
	end	  
})
Music:AddTextbox({
	Name = "音乐音量",
	TextDisappear = false,
	Callback = function(musicvolume)
		workspace.MusicBox.Volume = musicvolume
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
local Animator = Window:MakeTab({--others
	Name = "动画",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})
Animator:AddTextbox({
	Name = "动画ID",
	TextDisappear = true,
	Callback = function(Animationid)
		Animation("rbxassetid://" .. Animationid)
	end	  
})
Animator:AddLabel("以下名称对应动画效果")
Animator:AddButton({
    Name = "进柜",
    Callback = function()
        Animation("rbxassetid://12497909905")
    end
})
Animator:AddButton({
    Name = "摔倒",
    Callback = function()
        Animation("rbxassetid://13842248811")
    end
})
Animator:AddButton({
    Name = "假门攻击",
    Callback = function()
        Animation("rbxassetid://14783001346")
    end
})
Animator:AddButton({
    Name = "假柜-攻击",
    Callback = function()
        Animation("rbxassetid://14826175401")
    end
})
Animator:AddButton({
    Name = "假柜-被救",
    Callback = function()
        Animation("rbxassetid://15901315168")
    end
})
Animator:AddButton({
    Name = "假柜-救人",
    Callback = function()
        Animation("rbxassetid://15901325144")
    end
})
Animator:AddButton({
    Name = "z90攻击",
    Callback = function()
        Animation("rbxassetid://17374784439")
    end
})
Animator:AddButton({
    Name = "电机修复",
    Callback = function()
        Animation("rbxassetid://17557575607")
    end
})
Animator:AddButton({
    Name = "z13甩人",
    Callback = function()
        Animation("rbxassetid://18836343961")
    end
})
local others = Window:MakeTab({--others
	Name = "其他",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})
others:AddButton({
	Name = "加入随机大厅",
	Callback = function()
        Notification("加入游戏","尝试加入中")
		game:GetService("TeleportService"):Teleport(12411473842, game.Players.LocalPlayer)
	end    
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
others:AddButton({
	Name = "加入随机游戏",
	Callback = function()
        Notification("加入游戏","尝试加入中")
		game:GetService("TeleportService"):Teleport(12552538292, game.Players.LocalPlayer)
	end    
})
others:AddParagraph("原作者playvora", "https://scriptblox.com/script/Pressure-script-15848")
workspace.DescendantAdded:Connect(function(inst)--其他
    if inst:IsA("ProximityPrompt") and OrionLib.Flags.ezuse.Value then--交互
        task.wait(0.1)
        inst.HoldDuration = "0"
        inst.RequiresLineOfSight = false
    end
	if inst.Name == "Eyefestation" and OrionLib.Flags.noeyefestation.Value then
		task.wait(0.2)
		inst:Destroy()
        delNotification("Eyefestation")
	end
    if inst.Name == "EnragedEyefestation" and OrionLib.Flags.noeyefestation.Value then
		task.wait(0.2)
		inst:Destroy()
    end
    if inst.Name == "EyefestationGaze" and OrionLib.Flags.noeyefestation.Value then
		task.wait(0.2)
		inst:Destroy()
	end
    if inst.Name == "Searchlights" and OrionLib.Flags.nosearchlights.Value then--无Searchlights
        local GD = workspace:GetDescendants()
        for _, SLE in pairs(GD) do
            if SLE.Name == "SearchlightsEncounter" then
                task.wait(0.1)
                local SLE_room = workspace.Rooms.SearchlightsEncounter
                SLE_room.Searchlights:Destroy()
                SLE_room.MainSearchlight:Destroy()
                delNotification("Searchlights")
            elseif SLE.Name == "SearchlightsEnding" and OrionLib.Flags.nosearchlights.Value then
                task.wait(0.1)
                local SLE_room = workspace.Rooms.SearchlightsEnding.Interactables
                SLE_room.Searchlights1:Destroy()
                SLE_room.Searchlights2:Destroy()
                SLE_room.Searchlights3:Destroy()
                SLE_room.Searchlights:Destroy()
                delNotification("Searchlights")
	        end
        end
    end
	if inst.Name == "Steams" and OrionLib.Flags.nodamage.Value then--无环境伤害
		task.wait(0.1)
		inst:Destroy()
	end
    if inst.Name == "DamageParts" and OrionLib.Flags.nodamage.Value then
		task.wait(0.1)
		inst:Destroy()
	end
    if inst.Name == "DamagePart" and OrionLib.Flags.nodamage.Value then
		task.wait(0.1)
		inst:Destroy()
	end
    if inst.Name == "Electricity" and OrionLib.Flags.nodamage.Value then
		task.wait(0.1)
		inst:Destroy()
	end
    if inst.Name == "TurretSpawn" and OrionLib.Flags.noturret.Value then--炮台
        task.wait(0.1)
		inst:Destroy()
    end
    if inst.Name == "TurretSpawn1" and OrionLib.Flags.noturret.Value then
        task.wait(0.1)
		inst:Destroy()
    end
    if inst.Name == "TurretSpawn2" and OrionLib.Flags.noturret.Value then
        task.wait(0.1)
		inst:Destroy()
    end
    if inst.Name == "TurretSpawn3" and OrionLib.Flags.noturret.Value then
        task.wait(0.1)
		inst:Destroy()
    end
    if inst.Name == "MonsterLocker" and OrionLib.Flags.noMonsterLocker.Value then--假柜子
        task.wait(0.1)
		inst:Destroy()
    end
    if inst.Name == "Joint1" and OrionLib.Flags.nosq.Value then--S-Q
        task.wait(0.1)
		inst.Parent:Destroy()
    end
    if inst.Name == "FriendPart" and OrionLib.Flags.noFriendPart.Value then--z432
        task.wait(0.1)
		inst:Destroy()
        delNotification("z432")
    end
    if inst.Name == "Trickster" and OrionLib.Flags.noTrickster.Value then--假门
        task.wait(0.1)
		inst.RemoteEvent:Destroy()
    end
    if inst.Name == "WallDweller" and OrionLib.Flags.NotifyEntities.Value then--实体提醒-z90
        entityNotification("墙居者出现")
    end
end)
workspace.DescendantRemoving:Connect(function(inst)--实体提醒-z90
    if inst.Name == "WallDweller" and OrionLib.Flags.NotifyEntities.Value then
        entityNotification("墙居者消失")
    end
end)
workspace.ChildAdded:Connect(function(child)
    if table.find(entityNames, child.Name) and child:IsDescendantOf(workspace) and OrionLib.Flags.NotifyEntities.Value then--实体提醒
        if OrionLib.Flags.avoid.Value == true then
            createPlatform("AvoidPlatform",Vector3.new(3000, 1 , 3000),Vector3.new(5000, 10000 , 5000))
            teleportPlayerTo(game:GetService("Players").LocalPlayer,Platform.Position + Vector3.new(0, Platform.Size.Y / 2 + 5, 0))
            entityNotification(child.Name .. "出现,自动躲避中")
        else
            entityNotification(child.Name .. "出现")
        end
    end
    if child.Name == "Pandemonium" and child:IsDescendantOf(workspace) and OrionLib.Flags.nopandemonium.Value then--删除z367
        task.wait(0.2)
        child:Destroy()
        delNotification("Pandemonium(此提醒可能会出现多次)")
    end
end)
workspace.ChildRemoved:Connect(function(child)--实体提醒-消失
    if table.find(entityNames, child.Name) and OrionLib.Flags.NotifyEntities.Value then
        if OrionLib.Flags.avoid.Value == true then
            teleportPlayerBack(game:GetService("Players").LocalPlayer)
            entityNotification(child.Name .. "消失,已自动返回")
        else
            entityNotification(child.Name .. "消失")
        end
    end
    if child.Name == "EnragedEyefestation" and OrionLib.Flags.noeyefestation.Value then--其他
		task.wait(0.2)
		inst:Destroy()
	end
end)