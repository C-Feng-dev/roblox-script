print("--------------------成功注入，正在加载中--------------------")
local loadsuc, OrionLib = pcall(function()
    return loadstring(game:HttpGet('https://raw.githubusercontent.com/C-Feng-dev/Orion/refs/heads/main/source'))()
end)
if loadsuc ~= true then
    warn("OrionLib加载错误,原因:" .. OrionLib)
    return
end
local Ver = "Alpha 0.0.3"
print("--OrionLib已加载完成--------------------------------加载中--")
OrionLib:MakeNotification({
    Name = "加载中...",
    Content = "可能会有短暂卡顿",
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
-- local设置
local entityNames = {"Angler", "RidgeAngler", "Blitz", "RidgeBlitz", "Pinkie", "RidgePinkie", "Froger", "RidgeFroger","Chainsmoker", "Pandemonium", "Eyefestation", "A60", "Mirage"} -- 实体
local noautoinst = {"Locker", "MonsterLocker", "LockerUnderwater", "Generator", "BrokenCable","EncounterGenerator","Saboterousrusrer","Toilet"}
local playerPositions = {} -- 存储玩家坐标
local Entitytoavoid = {} -- 自动躲避用-检测自动躲避的实体
local EspConnects = {}
local TeleportService = game:GetService("TeleportService") -- 传送服务
local Players = game:GetService("Players") -- 玩家服务
local Character = Players.LocalPlayer.Character -- 本地玩家Character
local humanoid = Character:FindFirstChild("Humanoid") -- 本地玩家humanoid
local Espboxes = Players.LocalPlayer.PlayerGui
local RemoteFolder = game:GetService('ReplicatedStorage').Events -- Remote Event储存区之一
--local结束->Function设置
local function Notify(name,content,time,usesound,sound) -- 信息
    OrionLib:MakeNotification({
        Name = name,
        Content = content,
        Image = "rbxassetid://4483345998",
        Time = time or "3",
        sound = sound,
        useSound = usesound
    })
end
local function copyNotifi(copyitemname) -- 复制信息
    Notify(copyitemname, "已成功复制")
end
local function delNotifi(delthings) -- 删除信息
    Notify(delthings, "已成功删除")
end
local function entityNotifi(entityname) -- 实体提醒
    Notify("实体提醒", entityname)
end
local function copyitems(copyitem) -- 复制物品
    local create_NumberValue = Instance.new("NumberValue") -- copy items-type NumberValue
    create_NumberValue.Name = copyitem
    create_NumberValue.Parent = game.Players.LocalPlayer.PlayerFolder.Inventory
end
local function createBilltoesp(theobject,name,color,hlset) -- 创建BillboardGui-颜色:Color3.new(r,g,b)
    local bill = Instance.new("BillboardGui", theobject) -- 创建BillboardGui
    bill.AlwaysOnTop = true
    bill.Size = UDim2.new(0, 100, 0, 50)
    bill.Adornee = theobject
    bill.MaxDistance = 2000
    bill.Name = name .. "esp"
    local mid = Instance.new("Frame", bill) -- 创建Frame-圆形
    mid.AnchorPoint = Vector2.new(0.5, 0.5)
    mid.BackgroundColor3 = color
    mid.Size = UDim2.new(0, 8, 0, 8)
    mid.Position = UDim2.new(0.5, 0, 0.5, 0)
    Instance.new("UICorner", mid).CornerRadius = UDim.new(1, 0)
    Instance.new("UIStroke", mid)
    local txt = Instance.new("TextLabel", bill) -- 创建TextLabel-显示
    txt.AnchorPoint = Vector2.new(0.5, 0.5)
    txt.BackgroundTransparency = 1
    txt.TextColor3 =color
    txt.Size = UDim2.new(1, 0, 0, 20)
    txt.Position = UDim2.new(0.5, 0, 0.7, 0)
    txt.Text = name
    Instance.new("UIStroke", txt)
    if hlset then
        local hl = Instance.new("Highlight",bill)
        hl.Name = name .. "Esp Highlight"
        hl.Parent = Players.LocalPlayer.PlayerGui
        hl.Adornee = theobject
        hl.DepthMode = "AlwaysOnTop"
        hl.FillColor = color
        hl.FillTransparency = "0.5"
    end
    task.spawn(function()
        while hl do
            if hl.Adornee == nil or not hl.Adornee:IsDescendantOf(workspace) then
                hl:Destroy()
            end
            task.wait()
        end
    end)
end
local function espmodel(modelname,name,r,g,b,hlset) -- Esp物品(Model对象)用
    for _, themodel in pairs(workspace:GetDescendants()) do
        if themodel:IsA("Model") and themodel.Parent ~= Players and themodel.Name == modelname then
            createBilltoesp(themodel,name, Color3.new(r,g,b),hlset)
        end
    end
    local esp = workspace.DescendantAdded:Connect(function(themodel)
        if themodel:IsA("Model") and themodel.Parent ~= Players and themodel.Name == modelname then
            createBilltoesp(themodel,name, Color3.new(r,g,b),hlset)
        end
    end)
    table.insert(EspConnects,esp)
end
local function unesp(name) -- unEsp物品用
    for _, esp in pairs(workspace:GetDescendants()) do
        if esp.Name == name .. "Esp Highlight" then
            esp:Destroy()
        end
    end
    for _, hl in pairs(workspace:GetDescendants()) do
        if hl.Name == name .. "Esp Highlight" then
            hl:Destroy()
        end
    end
end
local function teleportPlayerTo(player,toPositionVector3,saveposition) -- 传送玩家-Vector3.new(x,y,z)
    if player.Character:FindFirstChild("HumanoidRootPart") then
        if saveposition then
            playerPositions[player.UserId] = player.Character.HumanoidRootPart.CFrame
        end
        player.Character.HumanoidRootPart.CFrame = CFrame.new(toPositionVector3)
    end
end
local function teleportPlayerBack(player) -- 返回玩家 
    if playerPositions[player.UserId] then
        player.Character.HumanoidRootPart.CFrame = playerPositions[player.UserId]
        playerPositions[player.UserId] = nil -- 清除坐标
    else
        warn("返回失败!存储玩家原坐标的数值无法用于返回")
    end
end
local function chatMessage(chat) -- 发送信息
    game:GetService("TextChatService").TextChannels.RBXGeneral:SendAsync(tostring(chat))
end
local function loadfinish() -- 加载完成后向控制台发送
    print("--------------------------加载完成--------------------------")
    print("--Pressure Script已加载完成")
    print("--欢迎使用!" .. game.Players.LocalPlayer.Name)
    print("--此服务器游戏ID为:" .. game.GameId)
    print("--此服务器位置ID为:" .. game.PlaceId)
    print("--此服务器UUID为:" .. game.JobId)
    print("--此服务器上的游戏版本为:version_" .. game.PlaceVersion)
    print("--------------------------欢迎使用--------------------------")
end
--Function结束-其他
task.spawn(function()--关闭esp的Connect
	while (OrionLib:IsRunning()) do
		task.wait()
	end
	for _, Connection in pairs(EspConnects) do
		Connection:Disconnect()
	end
end)
loadfinish()--其他结束->加载完成信息
Notify("加载完成", "已成功加载")
--Tab界面
local Tab = Window:MakeTab({
    Name = "主界面",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})
local Item = Window:MakeTab({
    Name = "物品",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})
local Del = Window:MakeTab({
    Name = "删除",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})
local Esp = Window:MakeTab({
    Name = "透视",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})
local others = Window:MakeTab({
    Name = "其他",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})
--子界面
local Section = Tab:AddSection({
    Name = "实体"
})
Tab:AddToggle({
    Name = "实体提醒",
    Default = true,
    Flag = "NotifyEntities",
    Save = true
})
Tab:AddToggle({
    Name = "实体播报",
    Default = false,
    Flag = "chatNotifyEntities",
    Save = true
})
Tab:AddToggle({
    Name = "自动躲避",
    Default = false,
    Flag = "avoid",
    Save = true
})
Tab:AddButton({ -- 手动返回
    Name = "手动返回",
    Callback = function()
        if playerPositions[player.UserId] then
            teleportPlayerBack(Players.LocalPlayer)
        else
            Notify("返回失败","存储玩家原坐标的数值无法用于返回")
        end
    end
})
local Section = Tab:AddSection({
    Name = "交互"
})
Tab:AddToggle({ -- 轻松交互
    Name = "轻松交互",
    Default = true,
    Callback = function(Value)
        if Value then
            ezinst = true
            task.spawn(function()
                while ezinst do
                    for _, toezInteract in pairs(workspace:GetDescendants()) do
                        if toezInteract:IsA("ProximityPrompt") then
                            toezInteract.HoldDuration = "0.01"
                            toezInteract.RequiresLineOfSight = false
                            toezInteract.MaxActivationDistance = "11.5"
                        end
                    end
                    task.wait(0.1)
                end
            end)
        else
            ezinst = false
        end
    end
})
Tab:AddToggle({ -- 轻松交互
    Name = "轻松修复",
    Default = true,
    Callback = function(Value)
        if Value then
            ezfix = true
            task.spawn(function()
                while ezfix do
                    local FixGame = game.Players.LocalPlayer.PlayerGui.Main.FixMinigame.Background.Frame.Middle
                    FixGame.Circle.Rotation = FixGame.Pointer.Rotation - 20
                    task.wait()
                end
            end)
        else
            ezfix = false
        end
    end
})
Tab:AddToggle({ -- 轻松交互
    Name = "自动过367小游戏",
    Default = true,
    Callback = function(Value)
        if Value then
            auto367game = true
            task.spawn(function()
                while PandemoniumGame.circle.Position ~= UDim2.new(0, 0, 0, 20) and auto367game do
                    local PandemoniumGame = game.Players.LocalPlayer.PlayerGui.Main.PandemoniumMiniGame.Background.Frame
                    PandemoniumGame.circle.Position = UDim2.new(0, 0, 0, 20)
                    task.wait()
                end
            end)
        else
            auto367game = false
        end
    end
})
Tab:AddToggle({ -- 轻松交互
    Name = "自动交互",
    Default = false,
    Callback = function(Value)
        if Value then
            autoinst = true
            task.spawn(function()
                while autoinst do -- 交互-循环
                    for _, descendant in pairs(workspace:GetDescendants()) do
                        local parentModel = descendant:FindFirstAncestorOfClass("Model")
                        if descendant:IsA("ProximityPrompt") and not table.find(noautoinst, parentModel.Name) then
                            descendant:InputHoldBegin()
                        end
                    end
                    task.wait(0.05)
                end
            end)
        else
            autoinst = false
        end
    end
})
local Section = Tab:AddSection({
    Name = "相机"
})
Tab:AddToggle({ -- 保持广角
    Name = "保持广角",
    Default = true,
    Callback = function(Value)
        if Value then
            keep120fov = true
            task.spawn(function()
                while game.Workspace.Camera.FieldOfView ~= "120" and keep120fov do
                    game.Workspace.Camera.FieldOfView = "120"
                    task.wait()
                end
            end)
        else
            keep120fov = false
        end
    end
})
Tab:AddToggle({ -- 高亮
    Name = "高亮(低质量)",
    Default = true,
    Callback = function(Value)
        local Light = game:GetService("Lighting")
        if Value then
            FullBrightLite = true
            task.spawn(function()
                while FullBrightLite do
                    Light.Ambient = Color3.new(1, 1, 1)
                    Light.ColorShift_Bottom = Color3.new(1, 1, 1)
                    Light.ColorShift_Top = Color3.new(1, 1, 1)
                    task.wait()
                end
            end)
        else
            FullBrightLite = false
            Light.Ambient = Color3.new(0, 0, 0)
            Light.ColorShift_Bottom = Color3.new(0, 0, 0)
            Light.ColorShift_Top = Color3.new(0, 0, 0)
        end
    end
})
--[[Tab:AddToggle({--第三人称
    Name = "第三人称(测试)",
    Default = false,
    Callback = function(Value)
        if Value then
            thirdperson = true
            task.spawn(function()
                while thirdperson do
                    workspace.Camera.CFrame = game:GetService("Players").LocalPlayer.Character.UpperTorso.CFrame * CFrame.new(1.5, 0.5, 6.5)                    
                    task.wait()
                end
            end)
        else
            thirdperson = false
        end
    end})]]
local Section = Tab:AddSection({
    Name = "其他"
})
Tab:AddButton({
    Name = "再来一局",
    Callback = function()
        Notify("再来一局","请稍等...")
        RemoteFolder.PlayAgain:FireServer()
    end
})
Tab:AddSlider({
    Name = "玩家透明度",
    Min = 0,
    Max = 1,
    Default = 0,
    Increment = 0.05,
    Callback = function(Value)
        for _, humanpart in pairs(Character:GetChildren()) do
            if humanpart:IsA("MeshPart") then
                humanpart.Transparency = Value
            end
        end
    end
})
Tab:AddToggle({ -- 玩家提醒
    Name = "玩家提醒",
    Default = true,
    Flag = "PlayerNotifications"
})
Tab:AddToggle({ -- 自动跳关
    Name = "自动跳关",
    Default = false,
    Callback = function(Value)
        if Value then
            autogame = true
            task.spawn(function()
                while autogame do
                    for _, notopendoor in pairs(workspace:GetDescendants()) do
                        if notopendoor.Name == "NormalDoor" and notopendoor.Parent.Name == "Entrances" and notopendoor.OpenValue.Value == false then
                            teleportPlayerTo(Players.LocalPlayer,notopendoor.Root.Position,false)
                        end
                    end
                    task.wait(0.1)
                end
            end)
        else
        autogame = false
        end
    end
})
Tab:AddButton({
    Name = "删除已修复装置的透视",
    Default = true,
    Callback = function()
        for _, FixedThings in pairs(workspace:GetDescendants()) do
            if FixedThings.Name == "EncounterGenerator" and FixedThings.Fixed.Value == 100 then
                FixedThings:FindFirstChildOfClass("BillboardGui"):Destroy()
            end
            if FixedThings.Name == "BrokenCables" and FixedThings.Fixed.Value == 100 then
                FixedThings:FindFirstChildOfClass("BillboardGui"):Destroy()
            end
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
    Name = "重启大厅音乐",
    Callback = function()
        workspace.PlaylistSong:Destroy()
    end
})
Tab:AddButton({
    Name = "删除隐形墙",
    Callback = function()
        for _, iw in pairs(workspace:GetDescendants()) do
            if iw.Name == "InvisibleWalls" then
                iw:Destroy()
            end
        end
    end
})
Item:AddParagraph("提醒", "复制物品需要背包内有物品本体,复制出的工具行为与本体相同")
Item:AddDropdown({
    Name = "功能",
    Default = "复制",
    Options = {"复制", "删除"},
    Flag = "cpyordel"
})
Item:AddButton({
    Name = "闪光灯",
    Callback = function()
        if OrionLib.Flags.cpyordel.Value == "复制" then
            copyitems("FlashBeacon")
            copyNotifi("闪光灯")
        else
            game.Players.LocalPlayer.PlayerFolder.Inventory.FlashBeacon:Destroy()
            delNotifi("闪光灯")
        end
    end
})
Item:AddButton({
    Name = "黑光",
    Callback = function()
        if OrionLib.Flags.cpyordel.Value == "复制" then
            copyitems("Blacklight")
            copyNotifi("黑光")
        else
            game.Players.LocalPlayer.PlayerFolder.Inventory.Blacklight:Destroy()
            delNotifi("黑光")
        end
    end
})
Item:AddButton({
    Name = "手摇手电筒",
    Callback = function()
        if OrionLib.Flags.cpyordel.Value == "复制" then
            copyitems("WindupLight")
            copyNotifi("手摇手电筒")
        else
            game.Players.LocalPlayer.PlayerFolder.Inventory.WindupLight:Destroy()
            delNotifi("手摇手电筒")
        end
    end
})
Item:AddButton({
    Name = "手电筒",
    Callback = function()
        if OrionLib.Flags.cpyordel.Value == "复制" then
            copyitems("Flashlight")
            copyNotifi("手电筒")
        else
            game.Players.LocalPlayer.PlayerFolder.Inventory.Flashlight:Destroy()
            delNotifi("手电筒")
        end
    end
})
Item:AddButton({
    Name = "灯笼",
    Callback = function()
        if OrionLib.Flags.cpyordel.Value == "复制" then
            copyitems("Lantern")
            copyNotifi("灯笼")
        else
            game.Players.LocalPlayer.PlayerFolder.Inventory.Lantern:Destroy()
            delNotifi("灯笼")
        end
    end
})
Item:AddButton({
    Name = "魔法书",
    Callback = function()
        if OrionLib.Flags.cpyordel.Value == "复制" then
            copyitems("Book")
            copyNotifi("魔法书")
        else
            game.Players.LocalPlayer.PlayerFolder.Inventory.Book:Destroy()
            delNotifi("魔法书")
        end
    end
})
Item:AddButton({
    Name = "软糖手电筒",
    Callback = function()
        if OrionLib.Flags.cpyordel.Value == "复制" then
            copyitems("Gummylight")
            copyNotifi("软糖手电筒")
        else
            game.Players.LocalPlayer.PlayerFolder.Inventory.Gummylight:Destroy()
            delNotifi("软糖手电筒")
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
    Name = "删除Searchlights(待增强)",
    Default = true,
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
    Name = "删除炮台",
    Default = true,
    Flag = "noturret",
    Save = true
})
Del:AddToggle({
    Name = "删除自然伤害(大部分)",
    Default = true,
    Flag = "nodamage",
    Save = true
})
Del:AddToggle({
    Name = "删除z432",
    Default = true,
    Flag = "noFriendPart",
    Save = true
})
Del:AddToggle({
    Name = "删除水区",
    Default = true,
    Flag = "nowatertoswim",
    Save = true
})
Del:AddToggle({
    Name = "删除假柜",
    Default = true,
    Flag = "noMonsterLocker",
    Save = true
})
Esp:AddToggle({ -- door
    Name = "门透视",
    Default = true,
    Callback = function(Value)
        if Value then
            espmodel("NormalDoor","门","0","1","0",true)
            espmodel("BigRoomDoor", "大门", "0", "1", "0",true)
        else
            unesp("门")
            unesp("大门")
        end
    end
})
--[[Esp:AddToggle({ -- door
    Name = "主门透视",
    Default = true,
    Callback = function(Value)
        maindooresp = Value
        if maindooresp then
            if maindooresp then
                for _, NormalDoor in pairs(workspace:GetDescendants()) do
                    if NormalDoor:IsA("Model") and NormalDoor.Parent == "Entrances" then
                        createBilltoesp("NormalDoor", "主门", Color3.new(0, 1, 0))
                    end
                end
                workspace.DescendantAdded:Connect(function(NormalDoor)
                    if NormalDoor:IsA("Model") and NormalDoor.Parent == "Entrances" then
                        createBilltoesp(NormalDoor, "主门", Color3.new(0, 1, 0))
                    end
                end)
            end
        else
            maindooresp = false
            unesp("主门")
            for _, unmaindooresp in pairs(Players.LocalPlayer.PlayerGui:GetDescendants()) do
                if unmaindooresp.Name == "主门espbox" then
                    unmaindooresp:Destroy()
                end
            end
        end
    end
})]]
Esp:AddToggle({ -- locker
    Name = "柜子透视",
    Default = true,
    Callback = function(Value)
        if Value then
            espmodel("Locker", "柜子", "0", "1", "0",false)
        else
            unesp("柜子")
        end
    end
})
Esp:AddToggle({ -- keycard
    Name = "钥匙卡透视",
    Default = true,
    Callback = function(Value)
        if Value then
            espmodel("NormalKeyCard", "钥匙卡", "0", "0", "1",true)
            espmodel("InnerKeyCard", "特殊钥匙卡", "1", "0", "0",true)
            espmodel("RidgeKeyCard", "山脊钥匙卡", "1", "1", "0",true)
        else
            unesp("钥匙卡")
            unesp("特殊钥匙卡")
            unesp("山脊钥匙卡")
        end
    end
})
Esp:AddToggle({ -- fake door
    Name = "假门透视",
    Default = true,
    Callback = function(Value)
        if Value then
            espmodel("TricksterRoom", "假门", "1", "0", "0",true)
            espmodel("ServerTrickster", "假门", "1", "0", "0",true)
            espmodel("RidgeTricksterRoom", "假门", "1", "0", "0",true)
        else
            unesp("假门")
        end
    end
})
Esp:AddToggle({ -- fake locker
    Name = "假柜透视",
    Default = true,
    Callback = function(Value)
        if Value then
            espmodel("MonsterLocker", "假柜子", "1", "0", "0",true)
        else
            unesp("假柜子")
        end
    end
})
Esp:AddToggle({ -- 发电机
    Name = "修复设备透视",
    Default = true,
    Callback = function(Value)
        if Value then
            espmodel("EncounterGenerator", "未修复发电机", "1", "0", "0",false)
            espmodel("BrokenCables", "未修复电缆", "1", "0", "0",false)
        else
            unesp("未修复发电机")
            unesp("未修复电缆")
        end
    end
})
Esp:AddToggle({ -- 拉杆
    Name = "拉杆透视",
    Default = true,
    Callback = function(Value)
        if Value then
            espmodel("Lever", "拉杆", "50", "10", "255",false)
            espmodel("Lever2", "拉杆", "50", "10", "255",false)
            espmodel("TurretControls", "炮台拉杆", "0", "1", "0",false)
            espmodel("TriggerLever", "大炮拉杆", "0", "1", "0",false)
        else
            unesp("拉杆")
            unesp("炮台拉杆")
            unesp("大炮拉杆")
        end
    end
})
Esp:AddToggle({ -- 物品
    Name = "物品透视",
    Default = true,
    Callback = function(Value)
        if Value then
            espmodel("DefaultBattery1", "电池", "1", "1", "1",false)
            espmodel("Flashlight", "手电筒", "25", "25", "25",false)
            espmodel("Lantern", "灯笼", "99", "99", "99",false)
            espmodel("FlashBeacon", "闪光", "1", "1", "1",false)
            espmodel("Blacklight", "黑光", "127", "0", "255",false)
            espmodel("Gummylight", "软糖手电筒", "15", "230", "100",false)
            espmodel("CodeBreacher", "红卡", "255", "30", "30",false)
            espmodel("DwellerPiece", "墙居者肉块", "50", "10", "25",false)
            espmodel("Medkit", "医疗箱", "80", "51", "235",false)
            espmodel("WindupLight", "手摇手电筒", "85", "100", "66",false)
            espmodel("Book", "魔法书", "0", "255", "255",true)
        else
            espmodel("电池")
            unesp("手电筒")
            unesp("灯笼")
            unesp("闪光")
            unesp("黑光")
            unesp("软糖手电筒")
            unesp("红卡")
            unesp("墙居者肉块")
            unesp("医疗箱")
            unesp("手摇手电筒")
            unesp("魔法书")
        end
    end
})
Esp:AddToggle({ -- 钱
    Name = "研究(钱)透视",
    Default = true,
    Callback = function(Value)
        if Value then
            espmodel("5Currency", "5钱", "1", "1", "1",false)
            espmodel("10Currency", "10钱", "1", "1", "1",false)
            espmodel("15Currency", "15钱", "0.5", "0.5", "0.5",false)
            espmodel("20Currency", "20钱", "1", "1", "1",false)
            espmodel("25Currency", "25钱", "1", "1", "0",false)
            espmodel("50Currency", "50钱", "1", "0.5", "0",true)
            espmodel("100Currency", "100钱", "1", "0", "1",true)
            espmodel("200Currency", "200钱", "0", "1", "1",true)
            espmodel("Relic", "500钱", "0", "1", "1",true)
        else
            unesp("5钱")
            unesp("10钱")
            unesp("15钱")
            unesp("20钱")
            unesp("25钱")
            unesp("50钱")
            unesp("100钱")
            unesp("200钱")
            unesp("500钱")
        end
    end
})
Esp:AddToggle({ -- 实体
    Name = "实体透视",
    Default = true,
    Flag = "EntityEsp"
})
Esp:AddToggle({ -- 玩家
    Name = "玩家透视",
    Default = false,
    Callback = function(Value)
        for _, player in pairs(game.Players:GetPlayers()) do
            if Value then
                if player ~= game.Players.LocalPlayer then
                    createBilltoesp(player.Character, player.Name, Color3.new(238, 201, 0),false)
                end
            else
                if player.Character:FindFirstChildOfClass("BillboardGui") then
                    player.Character:FindFirstChildOfClass("BillboardGui"):Destroy()
                end
            end
        end
    end
})
local Section = others:AddSection({
    Name = "注入"
})
others:AddButton({
    Name = "注入Infinity Yield",
    Callback = function()
        Notify("注入Infinity Yield", "尝试注入中")
        loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
        Notify("注入Infinity Yield", "注入完成(如果没有加载则重试)")
    end
})
others:AddButton({
    Name = "注入Dex v2 white(会卡顿)",
    Callback = function()
        Notify("注入Dex v2 white", "尝试注入中")
        loadstring(game:HttpGet('https://raw.githubusercontent.com/MariyaFurmanova/Library/main/dex2.0'))()
        Notify("注入Dex v2 white", "注入完成(如果没有加载则重试)")
    end
})
local Section = others:AddSection({
    Name = "删除(窗口)"
})
others:AddButton({
    Name = "删除此窗口",
    Callback = function()
        workspaceDA:Disconnect()
        workspaceDR:Disconnect()
        workspaceCA:Disconnect()
        workspaceCR:Disconnect()
        for _, Connection in pairs(EspConnects) do
            Connection:Disconnect()
        end
        OrionLib:Destroy()
    end
})
local Section = others:AddSection({
    Name = "加入"
})
others:AddButton({
    Name = "加入随机大厅",
    Callback = function()
        Notify("加入游戏", "尝试加入中")
        TeleportService:Teleport(12411473842)
    end
})
others:AddTextbox({
    Name = "使用UUID加入游戏",
    Callback = function(jobId)
        local function failtp()
            Notify("加入失败", "若UUID正确则可能对应的服务器为预留服务器")
            warn("加入游戏失败!")
        end
        Notify("加入游戏", "尝试加入中")
        TeleportService:TeleportToPlaceInstance(12552538292, jobId, Players.LocalPlayer)
        TeleportService.TeleportInitFailed:Connect(failtp)
    end
})
local Section = others:AddSection({
    Name = "关于"
})
others:AddLabel("此服务器上的游戏ID为:" .. game.GameId)
others:AddLabel("此服务器上的游戏版本为:version_" .. game.PlaceVersion)
others:AddLabel("此服务器位置ID为:" .. game.PlaceId)
others:AddParagraph("此服务器UUID为:", game.JobId)
others:AddLabel("版本:" .. Ver)
workspaceDA = workspace.DescendantAdded:Connect(function(inst) -- 其他
    if inst.Name == "Eyefestation" and OrionLib.Flags.noeyefestation.Value then
        inst:Destroy()
        delNotifi("Eyefestation")
    end
    if inst.Name == "EnragedEyefestation" and OrionLib.Flags.noeyefestation.Value then
        inst:Destroy()
    end
    if inst.Name == "EyefestationGaze" and OrionLib.Flags.noeyefestation.Value then
        inst:Destroy()
    end
    if inst.Name == "EnragedEyefestation" and OrionLib.Flags.noeyefestation.Value then -- 其他
        task.wait(0.2)
        inst:Destroy()
    end
    if inst.Name == "Searchlights" and OrionLib.Flags.nosearchlights.Value then -- 无Searchlights
        for _, SLE in pairs(workspace:GetDescendants()) do
            if SLE.Name == "SearchlightsEncounter" then
                task.wait(0.1)
                local SLE_room = workspace.Rooms.SearchlightsEncounter
                SLE_room.Searchlights:Destroy()
                SLE_room.MainSearchlight:Destroy()
            elseif SLE.Name == "SearchlightsEnding" and OrionLib.Flags.nosearchlights.Value then
                task.wait(0.1)
                local SLE_room = workspace.Rooms.SearchlightsEnding.Interactables
                SLE_room.Searchlights1:Destroy()
                SLE_room.Searchlights2:Destroy()
                SLE_room.Searchlights3:Destroy()
                SLE_room.Searchlights:Destroy()
            end
        end
        delNotifi("Searchlights")
    end
    if inst.Name == "Steams" and OrionLib.Flags.nodamage.Value then -- 无环境伤害
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
    if inst.Name == "TurretSpawn" and OrionLib.Flags.noturret.Value then -- 炮台
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
    if inst.Name == "MonsterLocker" and OrionLib.Flags.noMonsterLocker.Value then -- 假柜子
        task.wait(0.1)
        inst:Destroy()
    end
    if inst.Name == "Joint1" and OrionLib.Flags.nosq.Value then -- S-Q
        task.wait(0.1)
        inst.Parent:Destroy()
    end
    if inst.Name == "FriendPart" and OrionLib.Flags.noFriendPart.Value then -- z432nowatertoswim
        task.wait(0.1)
        inst:Destroy()
        delNotifi("z432")
    end
    if inst.Name == "WaterPart" and inst:FindFirstAncestorOfClass("Folder").Name == "Rooms" and OrionLib.Flags.nowatertoswim.Value then -- 水区
        task.wait(0.1)
        inst:Destroy()
    end
    if inst.Name == "Trickster" and inst:FindFirstAncestorOfClass("Model").Name == "Trickster" and OrionLib.Flags.noTrickster.Value then -- 假门
        Notify("检测假门", "尝试删除")
        inst.Trickster:Destroy()
    end
    if inst.Name == "WallDweller" and OrionLib.Flags.NotifyEntities.Value then -- 实体提醒-z90
        entityNotifi("墙居者出现")
        if OrionLib.Flags.chatNotifyEntities.Value then
            chatMessage("墙居者出现")
        end
    end
    if inst.Name == "RottenWallDweller" and OrionLib.Flags.NotifyEntities.Value then
        entityNotifi("墙居者出现")
        if OrionLib.Flags.chatNotifyEntities.Value then
            chatMessage("墙居者出现")
        end
    end
end)
workspaceDR = workspace.DescendantRemoving:Connect(function(inst) -- 实体提醒-z90
    if inst.Name == "WallDweller" and OrionLib.Flags.NotifyEntities.Value then
        entityNotifi("墙居者消失")
        if OrionLib.Flags.chatNotifyEntities.Value then
            chatMessage("墙居者消失")
        end
    end
    if inst.Name == "RottenWallDweller" and OrionLib.Flags.NotifyEntities.Value then
        entityNotifi("墙居者消失")
        if OrionLib.Flags.chatNotifyEntities.Value then
            chatMessage("墙居者消失")
        end
    end
end)
workspaceCA = workspace.ChildAdded:Connect(function(child) -- 关于实体
    if table.find(entityNames, child.Name) and child:IsDescendantOf(workspace) then
        if OrionLib.Flags.NotifyEntities.Value and OrionLib.Flags.avoid.Value == false then -- 实体提醒
            entityNotifi(child.Name .. "出现")
        end
        if OrionLib.Flags.avoid.Value and child.Name ~= "Mirage" then -- 自动躲避            
            teleportPlayerTo(Players.LocalPlayer,Vector3.new(1000,6000,1000),true)
            Character:FindFirstChild("HumanoidRootPart").Anchored = true
            Entitytoavoid[child] = true
            entityNotifi(child.Name .. "出现,自动躲避中")
        end
        if OrionLib.Flags.chatNotifyEntities.Value then -- 实体播报
            chatMessage(child.Name .. "出现")
        end
        if OrionLib.Flags.EntityEsp.Value then -- 实体esp
            createBilltoesp(child, child.Name, Color3.new(1, 0, 0), true)
        end
        if OrionLib.Flags.nopandemonium.Value and child.Name == "Pandemonium" and child:IsDescendantOf(workspace) then -- 删除z367
            task.wait(0.1)
            child:Destroy()
            delNotifi("Pandemonium")
        end
    end
end)
workspaceCR = workspace.ChildRemoved:Connect(function(child) -- 关于实体
    if table.find(entityNames, child.Name) then
        if OrionLib.Flags.avoid.Value and Entitytoavoid[child] then -- 自动躲避
            Character:FindFirstChild("HumanoidRootPart").Anchored = false
            teleportPlayerBack(Players.LocalPlayer)
            Entitytoavoid[child] = nil
        end
        if OrionLib.Flags.NotifyEntities.Value and OrionLib.Flags.avoid.Value == false then -- 实体提醒
            entityNotifi(child.Name .. "消失")
        end
        if OrionLib.Flags.chatNotifyEntities.Value then -- 实体播报
            chatMessage(child.Name .. "消失")
        end
    end 
    if child.Name == "Mirage" then -- Mirage
        if OrionLib.Flags.NotifyEntities.Value then
            entityNotifi("Mirage消失")
        end
        if OrionLib.Flags.chatNotifyEntities.Value then
            chatMessage(child.Name .. "消失")
        end
    end
end)
Players.PlayerAdded:Connect(function(player)
    if OrionLib.Flags.PlayerNotifications.Value then
        if player:IsFriendsWith(Players.LocalPlayer.UserId) then
            Notififriend = "(好友)"
        else
            Notififriend = ""
        end
        Notify("玩家提醒", player.Name .. Notififriend .. "已加入", 2,false)
    end
    if OrionLib.Flags.playeresp.Value and player ~= Players.LocalPlayer then
        createBilltoesp(player.Character, player.Name, Color3.new(238, 201, 0))
    end
end)
Players.PlayerRemoving:Connect(function(player)
    if OrionLib.Flags.PlayerNotifications.Value then
        if player:IsFriendsWith(Players.LocalPlayer.UserId) then
            Notififriend = "(好友)"
        else
            Notififriend = ""
        end
        Notify("玩家提醒", player.Name .. Notififriend .. "已退出", 2,false)
    end
end)
