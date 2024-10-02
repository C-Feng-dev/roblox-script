print("--------------------成功注入，正在加载中--------------------")
local Librepo = "https://raw.githubusercontent.com/mstudio45/LinoriaLib/main/"
local Library = loadstring(game:HttpGet(Librepo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(Librepo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(Librepo .. "addons/SaveManager.lua"))()
print("--Lib已加载------------------------------------加载Local中--")
if game.PlaceId ~= 12552538292 then
    Library:Notify("请在游戏内注入",3, 4590657391)
    Instance.new("Folder",game.Players.LocalPlayer).Name = "PlayerFolder"
    Instance.new("Folder",game.Players.LocalPlayer.PlayerFolder).Name = "Inventory"
end
-- local设置
local entityNames = {"Angler", "RidgeAngler", "Blitz", "RidgeBlitz", "Pinkie", "RidgePinkie", "Froger", "RidgeFroger","Chainsmoker", "Pandemonium", "Eyefestation", "A60", "Mirage"} -- 实体
local noautoinst = {"Locker", "MonsterLocker", "LockerUnderwater", "ShopSpawn", "Generator", "BrokenCable","EncounterGenerator"}
local noezuse = {"EncounterGenerator", "BrokenCables"}
local playerPositions = {} -- 存储玩家坐标
local Entitytoavoid = {} -- 自动躲避用-检测实体
local Platform -- 平台
local TeleportService = game:GetService("TeleportService") -- 传送服务
local Players = game:GetService("Players") -- 玩家服务
local Character = Players.LocalPlayer.Character -- 本地玩家Character
local humanoid = Character:FindFirstChild("Humanoid") -- 本地玩家humanoid
local Espboxes = Players.LocalPlayer.PlayerGui--本地玩家playerGui
local Inventory = game.Players.LocalPlayer.PlayerFolder.Inventory--本地玩家Inventory
local RemoteFolder = game:GetService('ReplicatedStorage').Events--Remote Event储存区之一
local Options = getgenv().Linoria.Options--GUI选项
local Toggles = getgenv().Linoria.Toggles
local FrameTimer = tick()--设置信息local
local FrameCounter = 0;--设置信息local
local FPS = 60;--设置信息local
-- 以下local为特殊用途
local AutoInteract -- 自动交互
local ezInteract -- 轻松交互
local delMusicBox -- 删除MusicBox
local maindooresp -- 主门esp
local instdooresp -- 其他门esp
local autoplay367 -- 自动过367小游戏
local keepfov120 -- 保持广角
local playeresp -- 玩家esp
local Notififriend -- 好友提醒
print("--Local已加载-------------------------------加载Function中--") -- local结束->Function设置
local function Notify(content,time,sound) -- 信息
    if time == nil then
        time = 5
    end
    if sound ~= false then
        sound = "4590657391"
    end
    Library:Notify(content, time, sound)
end
local function delNotification(content)
    Notify(content .. " 已成功删除")
end
local function copyitems(copyitem,copyitemname) -- 复制物品
    for _, thecopyitem in pairs(Inventory:GetChildren()) do
        if thecopyitem.Name == copyitem then
            local create_NumberValue = Instance.new("NumberValue") -- copy items-type NumberValue
            create_NumberValue.Name = copyitem
            create_NumberValue.Parent = Inventory
            Notify(copyitemname .. " 已成功复制")
        end
    end
end
local function createBilltoesp(theobject,name,color,espbox,playeresp) -- 创建BillboardGui-颜色:Color3.new(r,g,b)
    local bill = Instance.new("BillboardGui", theobject) -- 创建BillboardGui
    bill.AlwaysOnTop = true
    bill.Size = UDim2.new(0, 100, 0, 50)
    bill.Adornee = theobject
    bill.MaxDistance = 2000
    bill.Name =name .. "esp"
    local mid = Instance.new("Frame", bill) -- 创建Frame-圆形
    mid.AnchorPoint = Vector2.new(0.5, 0.5)
    mid.BackgroundColor3 =color
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
    local box = Instance.new("BoxHandleAdornment")
    if playeresp then
        box.Parent = Players.LocalPlayer.PlayerGui.Espboxes.PlayersEspboxes
    else
        box.Parent = Players.LocalPlayer.PlayerGui.Espboxes
    end
    box.Name = espbox.name .. "espbox"
    box.Size = espbox.Size
    box.AlwaysOnTop = true
    box.ZIndex = 1
    box.Color3 =color
    box.Transparency = 0.7
    box.Adornee = espbox
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
local function esp(modelname,name,r,g,b,set)
    local setting = "_G." .. set
    for _, theEsp in pairs(workspace:GetDescendants()) do
        if theEsp:IsA("Model") and theEsp.Parent ~= Character and theEsp.Name == modelname then
            createBilltoesp(theEsp,name, Color3.new(r,g,b))
        end
    end
    local EspAdded = workspace.DescendantAdded:Connect(function(theEsp)
        if theEsp:IsA("Model") and theEsp.Parent ~= Character and theEsp.Name == modelname and setting then
            createBilltoesp(theEsp,name, Color3.new(r,g,b))
        end
    end)
    if setting == true then
        EspAdded:DisConnect()
        for _, checkEsp in pairs(workspace:GetDescendants()) do
            if checkEsp:IsA("BillboardGui") and checkEsp.Name == modelname .. "esp" then
                checkEsp:Destroy()
            end
        end
    end
end
local function createPlatform(name, sizeVector3,positionVector3) -- 创建平台-Vector3.new(x,y,z)
    if Platform then
        Platform:Destroy() -- 移除多余平台
    end
    Platform = Instance.new("Part")
    Platform.Name =name
    Platform.Size = sizeVector3
    Platform.Position = positionVector3
    Platform.Anchored = true
    Platform.Parent = workspace
    Platform.Transparency = 1
    Platform.CastShadow = false
end
local function teleportPlayerTo(player,toPositionVector3,saveposition) -- 传送玩家-Vector3.new(x,y,z)
    if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        if saveposition then
            if playerPositions[player.UserId] then
                Notify("提醒","坐标已被其他功能存储")
            else
                playerPositions[player.UserId] = player.Character.HumanoidRootPart.CFrame
            end
        end
        player.Character.HumanoidRootPart.CFrame = CFrame.new(toPositionVector3)
    end
end
local function teleportPlayerBack(player) -- 返回玩家 
    if playerPositions[player.UserId] then
        player.Character.HumanoidRootPart.CFrame = playerPositions[player.UserId]
        playerPositions[player.UserId] = nil -- 清除坐标
    end
end
local function chatMessage(chat) -- 发送信息
    local str = tostring(chat)
    local TextChatService = cloneref(game:GetService("TextChatService"))
    if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
        TextChatService.TextChannels.RBXGeneral:SendAsync(str)
    else
        ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(str, "All")
    end
end
local function Animation(AnimationID) -- 动作播放
    local Animator = humanoid:WaitForChild("Animator")
    local DoAnimation = Instance.new("Animation")
    DoAnimation.AnimationId = AnimationID
    local AnimationTrack = Animator:LoadAnimation(DoAnimation)
    AnimationTrack:Play()
end
local function loadfinish() -- 加载完成后向控制台发送
    print("------------------------其他加载完成------------------------")
    print("--PressureScript已成功加载")
    print("--欢迎使用!" .. game.Players.LocalPlayer.Name)
    print("--此服务器游戏ID为:" .. game.GameId)
    print("--此服务器位置ID为:" .. game.PlaceId)
    print("--此服务器JobId为:" .. game.JobId)
    print("--此服务器上的游戏版本为:version_" .. game.PlaceVersion)
    print("------------------------所有加载完成------------------------")
end
local function UnloadUI()--关闭UI等
    Players.LocalPlayer.PlayerGui.Espboxes:Destroy()
    Workspace.MusicBox:Destroy()
    warn('已关闭GUI')
    Library:Unload()    
end
print("--Function已加载----------------------------加载其他命令中--") -- Function结束->其他命令
Library:SetWatermarkVisibility(true)--显示信息
local WatermarkConnection = game:GetService('RunService').RenderStepped:Connect(function()--加载信息
    FrameCounter += 1;
    if (tick() - FrameTimer) >= 1 then
        FPS = FrameCounter;
        FrameTimer = tick();
        FrameCounter = 0;
    end;
    Library:SetWatermark(('Pressure | %s fps | %s ms'):format(
        math.floor(FPS),
        math.floor(game:GetService('Stats').Network.ServerStatsItem['Data Ping']:GetValue())
    ));
end);
for _, Espboxes in pairs(Players.LocalPlayer.PlayerGui:GetChildren()) do -- 删除多余espboxex
    if Espboxes.Name == "Espboxes" and Espboxes:IsA("Folder") then
        Espboxes:Destroy()
    end
end
for _, MusicBox in pairs(Workspace:GetChildren()) do -- 删除多余MusicBox
    if MusicBox.Name == "MusicBox" and MusicBox:IsA("Sound") then
        MusicBox:Destroy()
    end
end
Instance.new("Folder", Players.LocalPlayer.PlayerGui).Name = "Espboxes" -- 创建espboxes
Instance.new("Folder", Players.LocalPlayer.PlayerGui.Espboxes).Name = "PlayersEspboxes" -- 创建espboxex/PlayersEspboxes
Instance.new("Sound", workspace).Name = "MusicBox" -- 创建MusicBox
loadfinish()-- 其他命令结束
local Window = Library:CreateWindow({--窗口
    Title = "Pressure",
    Center = false,
    AutoShow = true,
    Resizable = true,
    ShowCustomCursor = true,
    TabPadding = 8,
    MenuFadeTime = 0.1
})
local Tabs = {--Tabs
    Tab = Window:AddTab("主界面"),
    Item = Window:AddTab("物品"),
    Del = Window:AddTab("删除"),
    Esp = Window:AddTab("透视"),
    Player = Window:AddTab("玩家"),
    Music = Window:AddTab("音乐盒(客户端)"),
    Animator = Window:AddTab("动画"),
    Others = Window:AddTab("其他"),
    ['UI Settings'] = Window:AddTab('UI设置'),
}
local MainGroup = Tabs.Tab:AddLeftGroupbox("实体")
MainGroup:AddToggle('NotifyEntities',{
    Text = "实体提醒",
    Default = true,
    Tooltip = '当实体出现时提醒',
})
MainGroup:AddToggle('chatNotifyEntities',{
    Text = "实体播报",
    Default = false,
    Tooltip = '当实体出现时播报',
})
MainGroup:AddToggle('avoidEntities',{
    Text = "自动躲避",
    Default = false,
    Tooltip = '当实体出现时自动躲避',
})
MainGroup:AddButton({ -- 手动返回
    Text = "手动返回",
    DoubleClick = true,
    Tooltip = '手动返回记录的坐标点',
    Func = function()
        teleportPlayerBack(Players.LocalPlayer)
    end
})
local InteractGroup = Tabs.Tab:AddRightGroupbox("交互")
InteractGroup:AddToggle('ezInteract',{ -- 轻松交互
    Text = "轻松交互",
    Default = true,
    Callback = function(Value)
        ezInteract = Value
        if ezInteract then
            task.spawn(function()
                while ezInteract do
                    for _, toezInteract in pairs(workspace:GetDescendants()) do
                        if toezInteract:IsA("ProximityPrompt") and ezInteract and not InteractGrouple.find(noezInteract, toezInteract:FindFirstAncestorOfClass("Model").Name) then
                            toezInteract.HoldDuration = "0"
                            toezInteract.RequiresLineOfSight = false
                            toezInteract.MaxActivationDistance = "12"
                        end
                    end
                    task.wait(0.1)
                end
            end)
        end
    end
})
InteractGroup:AddToggle('ezfix',{ -- 轻松交互
    Text = "轻松修复",
    Default = true,
    Tooltip = '使判定区跟随指针',
    Callback = function(Value)
        task.spawn(function()
            while Value do
                local FixGame = game.Players.LocalPlayer.PlayerGui.Main.FixMinigame.Background.Frame.Middle
                FixGame.Circle.Rotation = FixGame.Pointer.Rotation - 20
                task.wait()
            end
        end)
    end
})
InteractGroup:AddToggle('autoplay367',{ -- 自动过367小游戏
    Text = "自动过367小游戏",
    Default = true,
    Tooltip = '固定367小游戏圆圈',
    Callback = function(Value)
        autoplay367 = Value
        if autoplay367 then
            task.spawn(function()
                while autoplay367 do
                    local PandemoniumGame = game.Players.LocalPlayer.PlayerGui.Main.PandemoniumMiniGame.Background.Frame
                    PandemoniumGame.circle.Position = UDim2.new(0, 0, 0, 20)
                    task.wait()
                end
            end)
        else
            autoplay367 = false
        end
    end
})
InteractGroup:AddToggle('AutoInteract',{ -- 自动交互
    Text = "自动交互",
    Default = false,
    Callback = function(Value)
        autoInteract = Value
        if autoInteract then
            task.spawn(function()
                Options.AutoInteract:OnClick(function()
                    while autoInteract or Toggles.AutoInteractKey.Value do -- 交互-循环
                        for _, toautoInteract in pairs(workspace:GetDescendants()) do
                            local parentModel = toautoInteract:FindFirstAncestorOfClass("Model")
                            if toautoInteract:IsA("ProximityPrompt") and parentModel then
                                if not table.find(noautoinst, parentModel.Name) then
                                    toautoInteract:InputHoldBegin()
                                end
                            end
                        end
                        task.wait(0.02)
                    end
                end)
            end)
        end
    end
}):AddKeyPicker("AutoInteractKey", {
    Mode = Library.IsMobile and "Toggle" or "Hold",
    Default = "R",
    Text = "自动交互",
    SyncToggleState = Library.IsMobile
})

	print('Keybind clicked!', Options.KeyPicker:GetState())

InteractGroup:AddButton("远程交互电机/电缆(多点几下)",function() -- 交互电机/电缆
    for _, Autointeract in pairs(workspace:GetDescendants()) do
        if Autointeract.Name == "EncounterGenerator" then
            Autointeract.ProxyPart.ProximityPrompt.MaxActivationDistance = 100000
            Autointeract.ProxyPart.ProximityPrompt.Exclusivity = 2
            Autointeract.ProxyPart.ProximityPrompt.RequiresLineOfSight = false
            Autointeract.ProxyPart.ProximityPrompt:InputHoldBegin()
        elseif Autointeract.Name == "BrokenCables" then
            Autointeract.ProxyPart.ProximityPrompt.MaxActivationDistance = 100000
            Autointeract.ProxyPart.ProximityPrompt.Exclusivity = 2
            Autointeract.ProxyPart.ProximityPrompt.RequiresLineOfSight = false
            Autointeract.ProxyPart.ProximityPrompt:InputHoldBegin()
        end
    end
end)
local OtherInInteract = Tabs.Tab:AddLeftGroupbox("其他") do
OtherInInteract:AddToggle('keepfov120',{ -- 保持广角
    Text = "保持广角",
    Default = true,
    Callback = function(Value)
        keepfov120 = Value
        if keepfov120 then
            task.spawn(function()
                while keepfov120 do
                    game.Workspace.Camera.FieldOfView = "120"
                    task.wait()
                end
            end)
        end
    end
})
OtherInInteract:AddToggle('FullBrightLite',{ -- 高亮
    Text = "高亮(低质量)",
    Default = false,
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
OtherInInteract:AddToggle('PlayerNotifications',{ -- 玩家提醒
    Text = "玩家提醒",
    Default = false,
})
--[[OtherInInteract:AddToggle('autoplay',{ -- 自动跳关
    Text = "自动跳关",
    Default = false,
    Func = function(Value)
        autoplay = Value
        if autoplay then
            task.spawn(function()
                for _,notopendoor in pairs(workspace:GetDescendants()) do
                    if notopendoor.Name == "NormalDoor" and notopendoor.Parent == "Entrances" and notopendoor.OpenValue.Value == false then
                        notopendoor.Root.Position = 111
                    end
                end
            end)
        end
    end
})]]
OtherInInteract:AddButton("删除已修复装置的Esp",function(Value)
    for _, FixedThings in pairs(workspace:GetDescendants()) do
        if FixedThings.Name == "EncounterGenerator" and FixedThings.Fixed.Value == 100 then
            FixedThings:FindFirstChildOfClass("BillboardGui"):Destroy()
        end
        if FixedThings.Name == "BrokenCables" and FixedThings.Fixed.Value == 100 then
            FixedThings:FindFirstChildOfClass("BillboardGui"):Destroy()
        end
    end
end)
OtherInInteract:AddButton("删除隐形墙", function()
    for _, iw in pairs(workspace:GetDescendants()) do
        if iw.Name == "InvisibleWalls" then
            iw:Destroy()
        end
    end
end)
OtherInInteract:AddButton("关闭大厅音乐", function()
    workspace.PlaylistSong.Volume = 0
    workspace.PlaylistSong.Looped = true
end)
OtherInInteract:AddButton("重启大厅音乐", function()
    workspace.PlaylistSong:Destroy()
end)
OtherInInteract:AddButton({
    Text = "再来一局",
    DoubleClick = true,
    Func = function()
        Notify("请稍等...")
        RemoteFolder.PlayAgain:FireServer()
    end
})
local ItemGroup = Tabs.Item:AddLeftGroupbox("可用物品")
local ItemGroupSet = Tabs.Item:AddRightGroupbox("其他")
ItemGroupSet:AddLabel('提醒:复制物品需要背包内有物品本体\n复制出的工具行为与本体相同')
ItemGroupSet:AddDivider()
ItemGroupSet:AddDropdown('ItemSetting',{
    Default = 1,
    Values = {"复制", "删除"},
    Text = '功能'
})
ItemGroup:AddButton("闪光灯",function()
        if Options.ItemSetting.Value == "复制" then
            copyitems("FlashBeacon","闪光灯")
        else
            Inventory.FlashBeacon:Destroy()
            delNotification("闪光灯")
        end
    end
)
ItemGroup:AddButton("黑光",function()
        if Options.ItemSetting.Value == "复制" then
            copyitems("Blacklight","黑光")
        else
            Inventory.Blacklight:Destroy()
            delNotification("黑光")
        end
    end
)
ItemGroup:AddButton("手摇手电筒",function()
        if Options.ItemSetting.Value == "复制" then
            copyitems("WindupLight","手摇手电筒")
        else
            Inventory.WindupLight:Destroy()
            delNotification("手摇手电筒")
        end
    end
)
ItemGroup:AddButton("手电筒",function()
        if Options.ItemSetting.Value == "复制" then
            copyitems("Flashlight","手电筒")
        else
            Inventory.Flashlight:Destroy()
            delNotification("手电筒")
        end
    end
)
ItemGroup:AddButton("灯笼",function()
        if Options.ItemSetting.Value == "复制" then
            copyitems("Lantern","灯笼")
        else
            Inventory.Lantern:Destroy()
            delNotification("灯笼")
        end
    end
)
ItemGroup:AddButton("魔法书",function()
        if Options.ItemSetting.Value == "复制" then
            copyitems("Book","魔法书")
        else
            Inventory.Book:Destroy()
            delNotification("魔法书")
        end
    end
)
ItemGroup:AddButton("软糖手电筒",function()
        if Options.ItemSetting.Value == "复制" then
            copyitems("Gummylight","软糖手电筒")
        else
            Inventory.Gummylight:Destroy()
            delNotification("软糖手电筒")
        end
    end
)
local DelGroup = Tabs.Del:AddLeftGroupbox("删除")
local OnceDelGroup = Tabs.Del:AddRightGroupbox("删除(一次性)")
DelGroup:AddToggle("noeyefestation",{
    Text = "删除z317",
    Default = true,
})
DelGroup:AddToggle("nopandemonium",{
    Text = "删除z367",
    Default = true,
})
DelGroup:AddToggle("nosearchlights",{
    Text = "删除Searchlights(待增强)",
    Default = true,
})
DelGroup:AddToggle("nosq",{
    Text = "删除S-Q",
    Default = true,
})
DelGroup:AddToggle("noturret",{
    Text = "删除炮台",
    Default = true,
})
DelGroup:AddToggle("nodamage",{
    Text = "删除自然伤害(大部分)",
    Default = true,
})
DelGroup:AddToggle("noFriendPart",{
    Text = "删除z432",
    Default = true,
})
DelGroup:AddToggle("nowatertoswim",{
    Text = "删除水区",
    Default = true,
})
DelGroup:AddToggle("noMonsterLocker",{
    Text = "删除假柜",
    Default = true,
})
DelGroup:AddToggle("noFriendPart",{
    Text = "删除z432",
    Default = true,
})
OnceDelGroup:AddButton({
    Text = "删除第一次boss关音乐",
    Func = function()
        workspace.RegSearchlightsIntro:Destroy()
        workspace.RegSearchlightsLoop:Destroy()
        delNotification("boss关音乐")
    end
})
OnceDelGroup:AddButton({
    Text = "删除第二次boss关音乐",
    Func = function()
        workspace.FinaleSong:Destroy()
        delNotification("boss关音乐")
    end
})
OnceDelGroup:AddButton({
    Text = "关闭大炮滴滴声",
    Func = function()
        workspace.Rooms.SearchlightsEnding.TriggerLever.Box.FinaleSignal.Playing = false
        workspace.Rooms.SearchlightsEnding.Parts.CaveLight.Part.FinaleSignal.Playing = false
    end
})
OnceDelGroup:AddButton({
    Text = "手动删除Searchlights(第一次boss战)",
    Func = function()
        local SLE_room = workspace.Rooms.SearchlightsEncounter
        SLE_room.Searchlights:Destroy()
        SLE_room.MainSearchlight:Destroy()
        delNotification("删除Searchlights")
    end
})
OnceDelGroup:AddButton({
    Text = "手动删除Searchlights(第二次boss战)",
    Func = function()
        local SLE_room = workspace.Rooms.SearchlightsEnding.Interactables
        SLE_room.Searchlights:Destroy()
        SLE_room.Searchlights1:Destroy()
        SLE_room.Searchlights2:Destroy()
        SLE_room.Searchlights3:Destroy()
        SLE_room.SearchlightsCave:Destroy()
        delNotification("删除Searchlights")
    end
})
local EspGroup = Tabs.Esp:AddLeftGroupbox('Esp')
--local EspGroupSet = Tabs.Esp:AddRightGroupbox('Esp设置')
EspGroup:AddToggle('DoorsEsp',{ -- door
    Text = "门Esp",
    Default = true,
    Callback = function(Value)
        esp("NormalDoor","门","0","1","0",Value)
    end
})
--[[EspGroup:AddToggle({ -- door
    Text = "主门Esp",
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
            for _, unmaindooresp in pairs(Players.LocalPlayer.PlayerGui:GetDescendants()) do
                if unmaindooresp.Name == "主门espbox" then
                    unmaindooresp:Destroy()
                end
            end
        end
    end
})
EspGroup:AddToggle({ -- door
    Text = "其他可互动门Esp",
    Default = false,
    Callback = function(Value)
        instdooresp = Value
        if instdooresp then
            if instdooresp then
                for _, InstDoor in pairs(workspace:GetDescendants()) do
                    if InstDoor:IsA("Model") and InstDoor.Parent ~= Players and InstDoor.Parent == "Interactables" then
                        createBilltoesp("InstDoor", "其他门", Color3.new(0, 1, 0))
                    end
                end
                workspace.DescendantAdded:Connect(function(InstDoor)
                    if InstDoor:IsA("Model") and InstDoor.Parent ~= Players and InstDoor.Parent == "Interactables" then
                        createBilltoesp(InstDoor, "其他门", Color3.new(0, 1, 0))
                    end
                end)
            end
        else
            instdooresp = false
            for _, uninstdooresp in pairs(Players.LocalPlayer.PlayerGui:GetDescendants()) do
                if uninstdooresp.Name == "其他门espbox" then
                    uninstdooresp:Destroy()
                end
            end
        end
    end
})]]
EspGroup:AddToggle('BigDoorsEsp',{ -- big door
    Text = "大门Esp",
    Default = true,
    Callback = function(Value)
        if Value then
            esp("BigRoomDoor", "大门", "0", "1", "0", Value)
        end
    end
})
EspGroup:AddToggle('LockersEsp',{ -- locker
    Text = "柜子ESP",
    Default = true,
    Callback = function(Value)
        if Value then
            esp("Locker", "柜子", "0", "1", "0", Value)
        end
    end
})
EspGroup:AddToggle('FakeLockersEsp',{ -- fake locker
    Text = "假柜Esp",
    Default = true,
    Callback = function(Value)
        if Value then
            esp("MonsterLocker", "假柜子", "1", "0", "0", Value)
        end
    end
})
EspGroup:AddToggle('FakeDoorsEsp',{ -- fake door
    Text = "假门Esp",
    Default = true,
    Callback = function(Value)
        if Value then
            esp("TricksterRoom", "假门", "1", "0", "0", Value)
            esp("ServerTrickster", "假门", "1", "0", "0", Value)
            esp("RidgeTricksterRoom", "假门", "1", "0", "0", Value)
        end
    end
})
EspGroup:AddToggle('KeyCardsEsp',{ -- keycard
    Text = "钥匙卡Esp",
    Default = true,
    Callback = function(Value)
        if Value then
            esp("NormalKeyCard", "钥匙卡", "0", "0", "1", Value)
            esp("InnerKeyCard", "特殊钥匙卡", "1", "0", "0", Value)
            esp("RidgeKeyCard", "山脊钥匙卡", "1", "1", "0", Value)
        end
    end
})
EspGroup:AddToggle('GeneratorsEsp',{ -- 发电机
    Text = "发电机Esp",
    Default = true,
    Callback = function(Value)
        if Value then
            esp("EncounterGenerator", "未修复发电机", "1", "0", "0", Value)
        end
    end
})
EspGroup:AddToggle('CablesEsp',{ -- 损坏线缆
    Text = "电缆Esp",
    Default = true,
    Callback = function(Value)
        if Value then
            esp("BrokenCables", "未修复电缆", "1", "0", "0", Value)
        end
    end
})
EspGroup:AddToggle('LeversEsp',{ -- 拉杆
    Text = "拉杆Esp",
    Default = true,
    Callback = function(Value)
        if Value then
            esp("Lever", "拉杆", "50", "10", "255", Value)
            esp("Lever2", "拉杆", "50", "10", "255", Value)
            esp("TurretControls", "炮台拉杆", "0", "1", "0", Value)
            esp("TriggerLever", "大炮拉杆", "0", "1", "0", Value)
        end
    end
})
EspGroup:AddToggle('ItemsEsp',{ -- 物品
    Text = "物品Esp",
    Default = true,
    Callback = function(Value)
        if Value then
            esp("DefaultBattery1", "电池", "1", "1", "1", Value)
            esp("Flashlight", "手电筒", "25", "25", "25", Value)
            esp("Lantern", "灯笼", "99", "99", "99", Value)
            esp("FlashBeacon", "闪光", "1", "1", "1", Value)
            esp("Blacklight", "黑光", "127", "0", "255", Value)
            esp("Gummylight", "软糖手电筒", "15", "230", "100", Value)
            esp("CodeBreacher", "红卡", "255", "30", "30", Value)
            esp("DwellerPiece", "墙居者肉块", "50", "10", "25", Value)
            esp("Medkit", "医疗箱", "80", "51", "235", Value)
            esp("WindupLight", "手摇手电筒", "85", "100", "66", Value)
            esp("Book", "魔法书", "0", "255", "255", Value)
        end
    end
})
EspGroup:AddToggle('ItemLockersEsp',{ -- ItemLocker
    Text = "储物柜Esp",
    Default = false,
    Callback = function(Value)
        if Value then
            esp("ItemLocker", "储物柜", "50", "10", "255", Value)
        end
    end
})
EspGroup:AddToggle('SmallCurrencyEsp',{ -- 钱
    Text = "研究(钱)Esp(>20)",
    Default = true,
    Callback = function(Value)
        if Value then
            esp("25Currency", "25钱", "1", "1", "0", Value)
            esp("50Currency", "50钱", "1", "0.5", "0", Value)
            esp("100Currency", "100钱", "1", "0", "1", Value)
            esp("200Currency", "200钱", "0", "1", "1", Value)
            esp("Relic", "500钱", "0", "1", "1", Value)
        end
    end
})
EspGroup:AddToggle('BigCurrencyEsp',{
    Text = "研究(钱)Esp(<20)",
    Default = false,
    Callback = function(Value)
        if Value then
            esp("5Currency", "5钱", "1", "1", "1", Value)
            esp("10Currency", "10钱", "1", "1", "1", Value)
            esp("15Currency", "15钱", "0.5", "0.5", "0.5", Value)
            esp("20Currency", "20钱", "1", "1", "1", Value)
        end
    end
})
EspGroup:AddToggle('EntitiesEsp',{ -- 实体
    Text = "实体Esp",
    Default = true,
    Flag = "EntityEsp"
})
EspGroup:AddToggle('PlayersEsp',{ -- 玩家
    Text = "玩家Esp",
    Default = false,
    Callback = function(Value)
        for _, player in pairs(game.Players:GetPlayers()) do
            if player ~= game.Players.LocalPlayer then
                if Value then
                    createBilltoesp(player.Character, player.Name, Color3.new(238, 201, 0),nil,true)
                else
                    if player.Character:FindFirstChildOfClass("BillboardGui") then
                        player.Character:FindFirstChildOfClass("BillboardGui"):Destroy()
                    end
                    if Players.LocalPlayer.PlayerGui.Espboxes.PlayersEspboxes then
                        for _, playersespboxes in pairs(
                            Players.LocalPlayer.PlayerGui.Espboxes.PlayersEspboxes:GetChildren()) do
                            playersespboxes:Destroy()
                        end
                    end
                end
            end
        end
    end
})
local PlayerCameraGroup = Tabs.Player:AddLeftGroupbox('相机')
local PlayerBodyGroup = Tabs.Player:AddRightGroupbox('身体')
local PlayerOtherGroup = Tabs.Player:AddLeftGroupbox('其他')
PlayerCameraGroup:AddSlider('Fov', {-- 视场角
	Text = "视场角",
    Tooltip = "若'保持广角'功能已启动此功能将失效",
	Default = 120,
	Min = 1,
    Max = 120,
	Rounding = 1,
	HideMax = true,
	Callback = function(Value)
		game.Workspace.Camera.FieldOfView = Value
	end
})
PlayerBodyGroup:AddSlider('Speed',{ -- 速度
    Text = "速度",
    Min = 1,
    Max = 200,
    Default = 17,
    Rounding = 1,
    HideMax = true,
    Callback = function(Value)
        humanoid.WalkSpeed = Value
    end
})
PlayerBodyGroup:AddSlider('JumpPower',{ -- 跳跃强度
    Text = "跳跃强度",
    Min = 1,
    Max = 200,
    Default = 50,
    Rounding = 1,
    HideMax = true,
    Callback = function(Value)
        humanoid.JumpPower = Value
    end
})
PlayerBodyGroup:AddSlider('Transparency',{--人物透明度
    Text = "透明度",
    Min = 0,
    Max = 1,
    Default = 0,
    Rounding = 1,
    HideMax = true,
    Callback = function(Value)
        for _, humanpart in pairs(Character:GetChildren()) do
            if humanpart:IsA("MeshPart") then
                humanpart.Transparency = Value
            end
        end
    end
})
PlayerBodyGroup:AddInput('HipHeight',{ -- 腿部高度
    Text = "腿部高度",
    Numeric = true,
    Finished = true,
    Callback = function(Value)
        humanoid.HipHeight = Value
    end
})
PlayerBodyGroup:AddSlider('MaxSlopeAngle',{ -- 斜坡角度
    Text = "最大斜坡角度",
    Min = 0,
    Max = 89,
    Default = 89,
    Rounding = 1,
    HideMax = true,
    Callback = function(Value)
        humanoid.MaxSlopeAngle = Value
    end
})
PlayerBodyGroup:AddSlider('Gravity',{
    Text = "重力",
    Min = 1,
    Max = 500,
    Default = 200,
    Rounding = 1,
    HideMax = true,
    Callback = function(Value)
        game.Workspace.Gravity = Value
    end
})
PlayerOtherGroup:AddToggle('AutoRotate',{ -- 自动转向
    Text = "自动转向",
    Default = true,
    Callback = function(Value)
        if Value then
            humanoid.AutoRotate = true
        else
            humanoid.AutoRotate = false
        end
    end
})
PlayerOtherGroup:AddButton({
    Text = "坐",
    Func = function()
        humanoid.Sit = true
    end
})
PlayerOtherGroup:AddToggle('PlatformStand',{ -- 人物直立
    Text = "人物直立",
    Default = false,
    Callback = function(Value)
        if Value then
            humanoid.PlatformStand = true
        else
            humanoid.PlatformStand = false
        end
    end
})
local MusicBoxGroup = Tabs.Music:AddLeftGroupbox('音乐盒')
local MusicBoxGroupSet = Tabs.Music:AddRightGroupbox('音乐盒设置')
MusicBoxGroup:AddToggle('MusicBoxSwitch',{
    Text = "音乐盒开关",
    Default = true,
    Callback = function(Value)
        if Value then
            workspace.MusicBox.Playing = true
        else
            workspace.MusicBox:Pause()
        end
    end
})
MusicBoxGroup:AddInput('MusicBoxID',{
    Text = "音乐ID",
    Numeric = true,
	Finished = true,
	ClearTextOnFocus = false,
    Callback = function(musicid)
        workspace.MusicBox.SoundId = "rbxassetid://" .. musicid
        workspace.MusicBox:Play()
        workspace.MusicBox.Looped = true
    end
})
MusicBoxGroupSet:AddInput('MusicBoxSound',{
    Text = "音乐音量",
    Numeric = true,
	Finished = true,
	ClearTextOnFocus = false,
    Callback = function(musicvolume)
        workspace.MusicBox.Volume = musicvolume
    end
})
MusicBoxGroupSet:AddInput('MusicBoxTimePosition',{
    Text = "音乐进度",
    Numeric = true,
	Finished = true,
	ClearTextOnFocus = false,
    Callback = function(musicTimePosition)
        workspace.MusicBox.TimePosition = musicTimePosition
    end
})
MusicBoxGroupSet:AddToggle('MusicBoxLoop',{
    Text = "音乐循环",
    Default = true,
    Callback = function(Value)
        if Value then
            workspace.MusicBox.Looped = true
        else
            workspace.MusicBox.Looped = false
        end
    end
})
local AnimatorGroup = Tabs.Animator:AddLeftGroupbox('动画')-- 动画
AnimatorGroup:AddInput('AnimatorGroupID',{
    Text = "动画ID",
    TextDisappear = true,
    Callback = function(Animationid)
        Animation("rbxassetid://" .. Animationid)
    end
})
AnimatorGroup:AddDivider()
AnimatorGroup:AddLabel('部分动画')
AnimatorGroup:AddButton({
    Text = "进柜",
    Func = function()
        Animation("rbxassetid://12497909905")
    end
})
AnimatorGroup:AddButton({
    Text = "摔倒",
    Func = function()
        Animation("rbxassetid://13842248811")
    end
})
AnimatorGroup:AddButton({
    Text = "假门攻击",
    Func = function()
        Animation("rbxassetid://14783001346")
    end
})
AnimatorGroup:AddButton({
    Text = "假柜-攻击",
    Func = function()
        Animation("rbxassetid://14826175401")
    end
})
AnimatorGroup:AddButton({
    Text = "假柜-被救",
    Func = function()
        Animation("rbxassetid://15901315168")
    end
})
AnimatorGroup:AddButton({
    Text = "假柜-救人",
    Func = function()
        Animation("rbxassetid://15901325144")
    end
})
AnimatorGroup:AddButton({
    Text = "z90攻击",
    Func = function()
        Animation("rbxassetid://17374784439")
    end
})
AnimatorGroup:AddButton({
    Text = "电机修复",
    Func = function()
        Animation("rbxassetid://17557575607")
    end
})
AnimatorGroup:AddButton({
    Text = "z13甩人",
    Func = function()
        Animation("rbxassetid://18836343961")
    end
})
local InjectGroupBox = Tabs.Others:AddLeftGroupbox('注入')--其他
local JoinGroupBox = Tabs.Others:AddRightGroupbox('加入')
local AboutGroupBox = Tabs.Others:AddLeftGroupbox('关于')
local MiscGroupBox = Tabs.Others:AddRightGroupbox('杂项')
InjectGroupBox:AddButton({
    Text = "注入Infinity Yield",
    Func = function()
        Notify("尝试注入Infinity Yield")
        loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
        Notify("注入完成(如果没有加载请重试)")
    end
})
InjectGroupBox:AddButton({
    Text = "注入Dex v2 white(会卡顿)",
    Func = function()
        Notify("尝试注入Dex v2 white")
        loadstring(game:HttpGet('https://raw.githubusercontent.com/MariyaFurmanova/Library/main/dex2.0'))()
        Notify("注入完成(如果没有加载请重试)")
    end
})
InjectGroupBox:AddButton({
    Text = "注入Dex v4 Beta(会卡顿)",
    Func = function()
        Notify("尝试注入Dex v4 Beta")
        local RepositoryName = "Dex"
        local File = "out.lua"
        local link = "https://raw.githubusercontent.com/luau/" .. RepositoryName .. "/master/" .. File
        loadstring(game:HttpGet(link, true), "Dex")(link)
        Notify("注入完成(如果没有加载请重试)")
    end
})
InjectGroupBox:AddButton({
    Text = "注入UNC Test(英文)",
    Func = function()
        Notify("尝试注入UNC Test")
        loadstring(game:HttpGet('https://raw.githubusercontent.com/unified-naming-convention/NamingStandard/main/UNCCheckEnv.lua'))()
        Notify("注入完成(如果没有加载请重试)")
    end
})
JoinGroupBox:AddButton({
    Text = "加入随机大厅",
    Func = function()
        Notify("尝试加入中")
        TeleportService:Teleport(12411473842)
    end
})
JoinGroupBox:AddButton({
    Text = "加入随机游戏",
    Func = function()
        Notify("尝试加入中")
        TeleportService:Teleport(12552538292)
    end
})
JoinGroupBox:AddInput('JobIdToJoin',{
    Text = "使用JobId加入游戏",
    Callback = function(jobId)
        local function failtp()
            Notify("加入失败,若JobId正确则可能对应的服务器为预留服务器")
            warn("加入失败!")
        end
        Notify("尝试加入中")
        TeleportService:TeleportToPlaceInstance(12552538292, jobId, Players.LocalPlayer)
        TeleportService.TeleportInitFailed:Connect(failtp)
    end
})
MiscGroupBox:AddButton({
    Text = "删除Dex",
    Func = function()   
        game.CoreGui.Dex:Destroy()
        Notify("Dex", "已关闭")
    end
})
AboutGroupBox:AddLabel("此服务器上的游戏ID为:" .. game.GameId)
AboutGroupBox:AddLabel("此服务器上的游戏版本为:version_" .. game.PlaceVersion)
AboutGroupBox:AddLabel("此服务器位置ID为:" .. game.PlaceId)
local MenuGroup = Tabs["UI Settings"]:AddLeftGroupbox("菜单")
MenuGroup:AddToggle("KeybindMenuOpen", { Default = false, Text = "打开键位显示", Callback = function(value) Library.KeybindFrame.Visible = value end})
MenuGroup:AddToggle("ShowCustomCursor", {Text = "LinoriaLib鼠标", Default = true, Callback = function(Value) Library.ShowCustomCursor = Value end})
MenuGroup:AddDivider()
MenuGroup:AddLabel("菜单键位"):AddKeyPicker("MenuKeybind", { Default = "RightShift", NoUI = true, Text = "Menu keybind" })
MenuGroup:AddButton("关闭", function() WatermarkConnection:Disconnect() print('已关闭GUI') Library:Unload() end)
Library.ToggleKeybind = Options.MenuKeybind
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
ThemeManager:SetFolder("script")
SaveManager:SetFolder("script/pressure")
SaveManager:BuildConfigSection(Tabs["UI Settings"])
ThemeManager:ApplyToTab(Tabs["UI Settings"])
workspace.DescendantAdded:Connect(function(inst) -- 其他
    if inst.Name == "Eyefestation" and Toggles.noeyefestation.Value then
        inst:Destroy()
        delNotification("Eyefestation")
    end
    if inst.Name == "EnragedEyefestation" and Toggles.noeyefestation.Value then
        inst:Destroy()
    end
    if inst.Name == "EyefestationGaze" and Toggles.noeyefestation.Value then
        inst:Destroy()
    end
    if inst.Name == "EnragedEyefestation" and Toggles.noeyefestation.Value then -- 其他
        task.wait(0.2)
        inst:Destroy()
    end
    if inst.Name == "Searchlights" and Toggles.nosearchlights.Value then -- 无Searchlights
        for _, SLE in pairs(workspace:GetDescendants()) do
            if SLE.Name == "SearchlightsEncounter" then
                task.wait(0.1)
                local SLE_room = workspace.Rooms.SearchlightsEncounter
                SLE_room.Searchlights:Destroy()
                SLE_room.MainSearchlight:Destroy()
            elseif SLE.Name == "SearchlightsEnding" and Toggles.nosearchlights.Value then
                task.wait(0.1)
                local SLE_room = workspace.Rooms.SearchlightsEnding.Interactables
                SLE_room.Searchlights1:Destroy()
                SLE_room.Searchlights2:Destroy()
                SLE_room.Searchlights3:Destroy()
                SLE_room.Searchlights:Destroy()
            end
        end
        delNotification("Searchlights")
    end
    if inst.Name == "Steams" and Toggles.nodamage.Value then -- 无环境伤害
        task.wait(0.1)
        inst:Destroy()
    end
    if inst.Name == "Steam" and Toggles.nodamage.Value then -- 无环境伤害
        task.wait(0.1)
        inst:Destroy()
    end
    if inst.Name == "DamageParts" and Toggles.nodamage.Value then
        task.wait(0.1)
        inst:Destroy()
    end
    if inst.Name == "DamagePart" and Toggles.nodamage.Value then
        task.wait(0.1)
        inst:Destroy()
    end
    if inst.Name == "Electricity" and Toggles.nodamage.Value then
        task.wait(0.1)
        inst:Destroy()
    end
    if inst.Name == "TurretSpawn" and Toggles.noturret.Value then -- 炮台
        task.wait(0.1)
        inst:Destroy()
    end
    if inst.Name == "TurretSpawn1" and Toggles.noturret.Value then
        task.wait(0.1)
        inst:Destroy()
    end
    if inst.Name == "TurretSpawn2" and Toggles.noturret.Value then
        task.wait(0.1)
        inst:Destroy()
    end
    if inst.Name == "TurretSpawn3" and Toggles.noturret.Value then
        task.wait(0.1)
        inst:Destroy()
    end
    if inst.Name == "MonsterLocker" and Toggles.noMonsterLocker.Value then -- 假柜子
        task.wait(0.1)
        inst:Destroy()
    end
    if inst.Name == "Joint1" and Toggles.nosq.Value then -- S-Q
        task.wait(0.1)
        inst.Parent:Destroy()
    end
    if inst.Name == "FriendPart" and Toggles.noFriendPart.Value then -- z432nowatertoswim
        task.wait(0.1)
        inst:Destroy()
        delNotification("z432")
    end
    if inst.Name == "WaterPart" and inst:FindFirstAncestorOfClass("Folder").Name == "Rooms" and
        Toggles.nowatertoswim.Value then -- 水区
        task.wait(0.1)
        inst:Destroy()
    end
    if inst.Name == "Trickster" and inst:FindFirstAncestorOfClass("Model").Name == "Trickster" and
        Toggles.noTrickster.Value then -- 假门
        Notify("检测假门", "尝试删除")
        inst.Trickster:Destroy()
    end
    if inst.Name == "WallDweller" and Toggles.NotifyEntities.Value then -- 实体提醒-z90
        Notify("墙居者出现")
        if Toggles.chatNotifyEntities.Value then
            chatMessage("墙居者出现")
        end
    end
    if inst.Name == "RottenWallDweller" and Toggles.NotifyEntities.Value then
        Notify("墙居者出现")
        if Toggles.chatNotifyEntities.Value then
            chatMessage("墙居者出现")
        end
    end
end)
workspace.DescendantRemoving:Connect(function(inst) -- 实体提醒-z90
    if inst.Name == "WallDweller" and Toggles.NotifyEntities.Value then
        Notify("墙居者消失")
        if Toggles.chatNotifyEntities.Value then
            chatMessage("墙居者消失")
        end
    end
    if inst.Name == "RottenWallDweller" and Toggles.NotifyEntities.Value then
        Notify("墙居者消失")
        if Toggles.chatNotifyEntities.Value then
            chatMessage("墙居者消失")
        end
    end
end)
workspace.ChildAdded:Connect(function(child) -- 关于实体
    if table.find(entityNames, child.Name) and child:IsDescendantOf(workspace) then
        if Toggles.NotifyEntities.Value and Toggles.avoid.Value ~= false then -- 实体提醒
            Notify(child.Name .. "出现")
        end
        if Toggles.avoidEntities.Value and child.Name ~= "Mirage" and workspace.r100Intro.Playing ~= true and workspace.r100Intro.r100IntroFadeout.Playing ~= true then -- 自动躲避
            createPlatform("AvoidPlatform", Vector3.new(3000, 1, 3000), Vector3.new(5000, 10000, 5000))
            teleportPlayerTo(Players.LocalPlayer, Platform.Position + Vector3.new(0, Platform.Size.Y / 2 + 5, 0),true)
            Entitytoavoid[child] = true
            Notify(child.Name .. "出现,自动躲避中")
        end
        if Toggles.chatNotifyEntities.Value then -- 实体播报
            chatMessage(child.Name .. "出现")
        end
        if Toggles.EntityEsp.Value then -- 实体esp(待修)
            createespbox(child, child.Name, Color3.new(1, 0, 0))
        end
        if Toggles.nopandemonium.Value and child.Name == "Pandemonium" and child:IsDescendantOf(workspace) then -- 删除z367
            task.wait(0.1)
            child:Destroy()
            delNotification("Pandemonium")
        end
    end
end)
workspace.ChildRemoved:Connect(function(child) -- 关于实体
    if table.find(entityNames, child.Name) then
        if workspace.r100Intro.Playing == false and workspace.r100Intro.r100IntroFadeout.Playing == false then
            if Toggles.avoidEntities.Value then -- 自动躲避
                teleportPlayerBack(Players.LocalPlayer)
                Notify(child.Name .. "消失,已自动返回")
                if Entitytoavoid[child] then
                    Entitytoavoid[child] = nil
                end
            end
            if Toggles.NotifyEntities.Value and Toggles.avoidEntities.Value == false then -- 实体提醒
                Notify(child.Name .. "消失")
            end
            if Toggles.chatNotifyEntities.Value then -- 实体播报
                chatMessage(child.Name .. "消失")
            end
        end
    end
    if child.Name == "Mirage" then -- Mirage
        if Toggles.NotifyEntities.Value then
            Notify("Mirage消失")
        end
        if Toggles.chatNotifyEntities.Value then
            chatMessage(child.Name .. "消失")
        end
    end
end)
Players.PlayerAdded:Connect(function(player)
    if Toggles.PlayerNotifications.Value then
        if player:IsFriendsWith(Players.LocalPlayer.UserId) then
            Notififriend = "(好友)"
        else
            Notififriend = ""
        end
        Notify(player.Name .. Notififriend .. "已加入", 2)
    end
    if Toggles.playeresp.Value and player ~= Players.LocalPlayer then
        print(player .. player.Character ..  player.Name)
        createBilltoesp(player.Character, player.Name, Color3.new(238, 201, 0), true)
    end
end)
Players.PlayerRemoving:Connect(function(player)
    if Toggles.PlayerNotifications.Value then
        if player:IsFriendsWith(Players.LocalPlayer.UserId) then
            Notififriend = "(好友)"
        else
            Notififriend = ""
        end
        Notify(player.Name .. Notififriend .. "已退出", 2)
    end
end)
SaveManager:LoadAutoloadConfig()--自动加载配置
end