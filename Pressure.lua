print("--------------------成功注入，正在加载中--------------------")
local OrionLib = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Orion/main/source'))()
print("--OrionLib已加载完成---------------------------加载Local中--")
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
local noautoinst = {"Locker", "MonsterLocker", "LockerUnderwater", "SpawnLocations", "Generator", "BrokenCable","EncounterGenerator"}
local noezuse = {"EncounterGenerator", "BrokenCables"}
local playerPositions = {} -- 存储玩家坐标
local Entitytoavoid = {} -- 自动躲避用-检测实体
local Platform -- 平台
local TeleportService = game:GetService("TeleportService") -- 传送服务
local Players = game:GetService("Players") -- 玩家服务
local Character = Players.LocalPlayer.Character -- 本地玩家Character
local humanoid = Character:FindFirstChild("Humanoid") -- 本地玩家humanoid
local Espboxes = Players.LocalPlayer.PlayerGui
-- 以下local为特殊用途
local autoInteract -- 自动交互
local ezuse -- 轻松交互
local ezfix -- 轻松修复
local delMusicBox -- 删除MusicBox
local maindooresp -- 主门esp
local instdooresp -- 其他门esp
local autoplay367 -- 自动过367小游戏
local autofov120 -- 保持广角
local playeresp -- 玩家esp
local Notififriend -- 好友提醒
print("--Local已加载完成---------------------------加载Function中--") -- local结束->Function设置
local function Notification(name,content,time) -- 信息
    if time == nil then
        time = 3
    end
    OrionLib:MakeNotification({
        Name =name,
        Content = content,
        Image = "rbxassetid://4483345998",
        Time = time
    })
end
local function copyNotification(copyitemname) -- 复制信息
    Notification(copyitemname, "已成功复制")
end
local function delNotification(delthings) -- 删除信息
    Notification(delthings, "已成功删除")
end
local function entityNotification(entityname) -- 实体提醒
    Notification("实体提醒", entityname)
end
local function copyitems(copyitem) -- 复制物品
    local create_NumberValue = Instance.new("NumberValue") -- copy items-type NumberValue
    create_NumberValue.Name = copyitem
    create_NumberValue.Parent = game.Players.LocalPlayer.PlayerFolder.Inventory
end
local function createespbox(theobject,name,color,playeresp) -- 创建esp箱
    for _, doespbox in pairs(theobject:GetChildren()) do
        if doespbox:IsA("BasePart") then
            local box = Instance.new("BoxHandleAdornment")
            if playeresp then
                box.Parent = Players.LocalPlayer.PlayerGui.Espboxes.PlayersEspboxes
            else
                box.Parent = Players.LocalPlayer.PlayerGui.Espboxes
            end
            box.Name =name .. "espbox"
            box.Size = doespbox.Size
            box.AlwaysOnTop = true
            box.ZIndex = 1
            box.Color3 =color
            box.Transparency = 0.7
            box.Adornee = doespbox
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

end
local function createBilltoesp(theobject,name,color,playeresp) -- 创建BillboardGui-颜色:Color3.new(r,g,b)
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
    txt.Text =name
    Instance.new("UIStroke", txt)
    createespbox(theobject,name,color, playeresp)
end
local function espmodel(modelname,name,r,g,b,Value) -- Esp物品(Model对象)用
    if Value then
        for _, themodel in pairs(workspace:GetDescendants()) do
            if themodel:IsA("Model") and themodel.Parent ~= Players and themodel.Name == modelname then
                createBilltoesp(themodel,name, Color3.new(r,g,b))
            end
        end
        workspace.DescendantAdded:Connect(function(themodel)
            if themodel:IsA("Model") and themodel.Parent ~= Players and themodel.Name == modelname then
                createBilltoesp(themodel,name, Color3.new(r,g,b))
            end
        end)
    end
end
local function unesp(name) -- unEsp物品用
    for _, esp in pairs(workspace:GetDescendants()) do
        if esp.Name ==name .. "esp" then
            esp:Destroy()
        end
    end
    for _, espbox in pairs(Players:GetDescendants()) do
        if espbox.Name ==name .. "espbox" then
            espbox:Destroy()
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
            playerPositions[player.UserId] = player.Character.HumanoidRootPart.CFrame
        end
        player.Character.HumanoidRootPart.CFrame = CFrame.new(toPositionVector3)
    end
end
local function teleportPlayerBack(player) -- 返回玩家 
    if playerPositions[player.UserId] then
        player.Character.HumanoidRootPart.CFrame = playerPositions[player.UserId]
        if playerPositions[player.UserId] then
            playerPositions[player.UserId] = nil -- 清除坐标
        end
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
    local animator = humanoid:WaitForChild("Animator")
    local DoAnimation = Instance.new("Animation")
    DoAnimation.AnimationId = AnimationID
    local AnimationTrack = animator:LoadAnimation(DoAnimation)
    AnimationTrack:Play()
end
local function loadfinish() -- 加载完成后向控制台发送
    print("------------------------其他加载完成------------------------")
    print("--PressureScript已加载完成")
    print("--欢迎使用!" .. game.Players.LocalPlayer.Name)
    print("--此服务器游戏ID为:" .. game.GameId)
    print("--此服务器位置ID为:" .. game.PlaceId)
    print("--此服务器UUID为:" .. game.JobId)
    print("--此服务器上的游戏版本为:version_" .. game.PlaceVersion)
    print("------------------------所有加载完成------------------------")
end
print("--Function已加载完成------------------------加载其他命令中--") -- Function结束->其他命令
for _, Espboxes in pairs(Players.LocalPlayer.PlayerGui:GetChildren()) do -- 删除多余espboxex
    if Espboxes.Name == "Espboxes" and Espboxes:IsA("Folder") then
        Espboxes:Destroy()
    end
end
for _, MusicBox in pairs(workspace:GetChildren()) do -- 删除多余MusicBox
    if MusicBox.Name == "MusicBox" and MusicBox:IsA("Sound") then
        MusicBox:Destroy()
    end
end
Instance.new("Folder", Players.LocalPlayer.PlayerGui).Name = "Espboxes" -- 创建espboxes
Instance.new("Folder", Players.LocalPlayer.PlayerGui.Espboxes).Name = "PlayersEspboxes" -- 创建espboxex/PlayersEspboxes
Instance.new("Sound", workspace).Name = "MusicBox" -- 创建MusicBox
loadfinish()-- 其他命令结束
local Tab = Window:MakeTab({ -- main
    Name = "主界面",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})
Notification("加载完成", "已成功加载")
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
        teleportPlayerBack(Players.LocalPlayer)
    end
})
local Section = Tab:AddSection({
    Name = "交互"
})
Tab:AddToggle({ -- 轻松交互
    Name = "轻松交互",
    Default = true,
    Callback = function(Value)
        ezuse = Value
        if ezuse then
            task.spawn(function()
                while ezuse do
                    for _, toezuse in pairs(workspace:GetDescendants()) do
                        if toezuse:IsA("ProximityPrompt") and ezuse and not table.find(noezuse, toezuse:FindFirstAncestorOfClass("Model").Name) then
                            toezuse.HoldDuration = "0"
                            toezuse.RequiresLineOfSight = false
                            toezuse.MaxActivationDistance = "10"
                        end
                    end
                    task.wait(0.1)
                end
            end)
        end
    end
})
Tab:AddToggle({ -- 轻松交互
    Name = "轻松修复",
    Default = true,
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
Tab:AddToggle({ -- 轻松交互
    Name = "自动过367小游戏",
    Default = true,
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
Tab:AddToggle({ -- 轻松交互
    Name = "自动交互",
    Default = false,
    Callback = function(Value)
        autoInteract = Value
        if autoInteract then
            task.spawn(function()
                while autoInteract do -- 交互-循环
                    for _, descendant in pairs(workspace:GetDescendants()) do
                        local parentModel = descendant:FindFirstAncestorOfClass("Model")
                        if descendant:IsA("ProximityPrompt") and parentModel then
                            if not table.find(noautoinst, parentModel.Name) then
                                descendant:InputHoldBegin()
                            end
                        end
                    end
                    task.wait(0.02)
                end
            end)
        end
    end
})
Tab:AddButton({ -- 交互电机/电缆
    Name = "交互电机/电缆(多点几下)",
    Callback = function()
        for _, Autointeract in pairs(workspace:GetDescendants()) do
            if Autointeract.Name == "EncounterGenerator" then
                Autointeract.ProxyPart.ProximityPrompt.MaxActivationDistance = 100000
                Autointeract.ProxyPart.ProximityPrompt.Exclusivity = 2
                Autointeract.ProxyPart.ProximityPrompt.RequiresLineOfSight = false
                Autointeract.ProxyPart.ProximityPrompt:InputHoldBegin()
            end
            if Autointeract.Name == "BrokenCables" then
                Autointeract.ProxyPart.ProximityPrompt.MaxActivationDistance = 100000
                Autointeract.ProxyPart.ProximityPrompt.Exclusivity = 2
                Autointeract.ProxyPart.ProximityPrompt.RequiresLineOfSight = false
                Autointeract.ProxyPart.ProximityPrompt:InputHoldBegin()
            end
        end
    end
})
local Section = Tab:AddSection({
    Name = "其他"
})
Tab:AddToggle({ -- 保持广角
    Name = "保持广角",
    Default = true,
    Callback = function(Value)
        autofov120 = Value
        if autofov120 then
            task.spawn(function()
                while autofov120 do
                    game.Workspace.Camera.FieldOfView = "120"
                    task.wait()
                end
            end)
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
--[[Tab:AddToggle({ -- 自动跳关
    Name = "自动跳关",
    Default = false,
    Callback = function(Value)
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
Tab:AddButton({
    Name = "删除已修复装置的Esp",
    Default = true,
    Callback = function(Value)
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
    Name = "删除隐形墙",
    Callback = function()
        for _, iw in pairs(workspace:GetDescendants()) do
            if iw.Name == "InvisibleWalls" then
                iw:Destroy()
            end
        end
    end
})
Tab:AddButton({
    Name = "重启大厅音乐",
    Callback = function()
        workspace.PlaylistSong:Destroy()
    end
})
Tab:AddTextbox({ -- 腿部高度
    Name = "玩家腿部高度",
    TextDisappear = false,
    Callback = function(Value)
        humanoid.HipHeight = Value
    end
})
Tab:AddSlider({
    Name = "玩家重力",
    Min = 1,
    Max = 500,
    Default = 200,
    Increment = 1,
    ValueName = "Gravity",
    Callback = function(Value)
        game.Workspace.Gravity = Value
    end
})
local Item = Window:MakeTab({
    Name = "物品",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})
Item:AddParagraph("提醒", "复制物品需要背包内有物品本体,复制出的工具行为与本体相同")
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
    Name = "关闭大炮滴滴声",
    Callback = function()
        workspace.Rooms.SearchlightsEnding.TriggerLever.Box.FinaleSignal.Playing = false
        workspace.Rooms.SearchlightsEnding.Parts.CaveLight.Part.FinaleSignal.Playing = false
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
local Esp = Window:MakeTab({ -- Esp
    Name = "Esp",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})
Esp:AddToggle({ -- door
    Name = "门Esp",
    Default = true,
    Callback = function(Value)
        espmodel("NormalDoor","门","0","1","0",Value)
    end
})
--[[Esp:AddToggle({ -- door
    Name = "主门Esp",
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
})
Esp:AddToggle({ -- door
    Name = "其他可互动门Esp",
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
            unesp("其他门")
            for _, uninstdooresp in pairs(Players.LocalPlayer.PlayerGui:GetDescendants()) do
                if uninstdooresp.Name == "其他门espbox" then
                    uninstdooresp:Destroy()
                end
            end
        end
    end
})]]
Esp:AddToggle({ -- locker
    Name = "柜子ESP",
    Default = true,
    Callback = function(Value)
        if Value then
            espmodel("Locker", "柜子", "0", "1", "0", Value)
        else
            unesp("柜子")
        end
    end
})
Esp:AddToggle({ -- keycard
    Name = "钥匙卡Esp",
    Default = true,
    Callback = function(Value)
        if Value then
            espmodel("NormalKeyCard", "钥匙卡", "0", "0", "1", Value)
            espmodel("InnerKeyCard", "特殊钥匙卡", "1", "0", "0", Value)
            espmodel("RidgeKeyCard", "山脊钥匙卡", "1", "1", "0", Value)
        else
            unesp("钥匙卡")
            unesp("特殊钥匙卡")
            unesp("山脊钥匙卡")
        end
    end
})
Esp:AddToggle({ -- fake door
    Name = "假门Esp",
    Default = true,
    Callback = function(Value)
        if Value then
            espmodel("TricksterRoom", "假门", "1", "0", "0", Value)
            espmodel("ServerTrickster", "假门", "1", "0", "0", Value)
            espmodel("RidgeTricksterRoom", "假门", "1", "0", "0", Value)
        else
            unesp("假门")
        end
    end
})
Esp:AddToggle({ -- fake locker
    Name = "假柜Esp",
    Default = true,
    Callback = function(Value)
        if Value then
            espmodel("MonsterLocker", "假柜子", "1", "0", "0", Value)
        else
            unesp("假柜子")
        end
    end
})
Esp:AddToggle({ -- big door
    Name = "大门Esp",
    Default = true,
    Callback = function(Value)
        if Value then
            espmodel("BigRoomDoor", "大门", "0", "1", "0", Value)
        else
            unesp("大门")
        end
    end
})
Esp:AddToggle({ -- 发电机
    Name = "发电机Esp",
    Default = true,
    Callback = function(Value)
        if Value then
            espmodel("EncounterGenerator", "未修复发电机", "1", "0", "0", Value)
        else
            unesp("未修复发电机")
        end
    end
})
Esp:AddToggle({ -- 损坏线缆
    Name = "电缆Esp",
    Default = true,
    Callback = function(Value)
        if Value then
            espmodel("BrokenCables", "未修复电缆", "1", "0", "0", Value)
        else
            unesp("未修复电缆")
        end
    end
})
Esp:AddToggle({ -- 拉杆
    Name = "拉杆Esp",
    Default = true,
    Callback = function(Value)
        if Value then
            espmodel("Lever", "拉杆", "50", "10", "255", Value)
            espmodel("Lever2", "拉杆", "50", "10", "255", Value)
            espmodel("TurretControls", "炮台拉杆", "0", "1", "0", Value)
            espmodel("TriggerLever", "大炮拉杆", "0", "1", "0", Value)
        else
            unesp("拉杆")
            unesp("炮台拉杆")
            unesp("大炮拉杆")
        end
    end
})
Esp:AddToggle({ -- 物品
    Name = "物品Esp",
    Default = true,
    Callback = function(Value)
        if Value then
            espmodel("DefaultBattery1", "电池", "1", "1", "1", Value)
            espmodel("Flashlight", "手电筒", "25", "25", "25", Value)
            espmodel("Lantern", "灯笼", "99", "99", "99", Value)
            espmodel("FlashBeacon", "闪光", "1", "1", "1", Value)
            espmodel("Blacklight", "黑光", "127", "0", "255", Value)
            espmodel("Gummylight", "软糖手电筒", "15", "230", "100", Value)
            espmodel("CodeBreacher", "红卡", "255", "30", "30", Value)
            espmodel("DwellerPiece", "墙居者肉块", "50", "10", "25", Value)
            espmodel("Medkit", "医疗箱", "80", "51", "235", Value)
            espmodel("WindupLight", "手摇手电筒", "85", "100", "66", Value)
            espmodel("Book", "魔法书", "0", "255", "255", Value)
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
Esp:AddToggle({ -- ItemLocker
    Name = "储物柜Esp",
    Default = false,
    Callback = function(Value)
        if Value then
            espmodel("ItemLocker", "储物柜", "50", "10", "255", Value)
        else
            unesp("储物柜")
        end
    end
})
Esp:AddToggle({ -- 钱
    Name = "研究(钱)Esp(>20)",
    Default = true,
    Callback = function(Value)
        if Value then
            espmodel("25Currency", "25钱", "1", "1", "0", Value)
            espmodel("50Currency", "50钱", "1", "0.5", "0", Value)
            espmodel("100Currency", "100钱", "1", "0", "1", Value)
            espmodel("200Currency", "200钱", "0", "1", "1", Value)
            espmodel("Relic", "500钱", "0", "1", "1", Value)
        else
            unesp("25钱")
            unesp("50钱")
            unesp("100钱")
            unesp("200钱")
            unesp("500钱")
        end
    end
})
Esp:AddToggle({
    Name = "研究(钱)Esp(<20)",
    Default = false,
    Callback = function(Value)
        if Value then
            espmodel("5Currency", "5钱", "1", "1", "1", Value)
            espmodel("10Currency", "10钱", "1", "1", "1", Value)
            espmodel("15Currency", "15钱", "0.5", "0.5", "0.5", Value)
            espmodel("20Currency", "20钱", "1", "1", "1", Value)
        else
            unesp("5钱")
            unesp("10钱")
            unesp("15钱")
            unesp("20钱")
        end
    end
})
Esp:AddToggle({ -- 实体
    Name = "实体Esp",
    Default = true,
    Flag = "EntityEsp"
})
Esp:AddToggle({ -- 玩家
    Name = "玩家Esp",
    Default = false,
    Callback = function(Value)
        for _, player in pairs(game.Players:GetPlayers()) do
            if player ~= game.Players.LocalPlayer then
                if Value then
                    playeresp = Value
                    createBilltoesp(player.Character, player.Name, Color3.new(238, 201, 0), Value)
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
local Music = Window:MakeTab({ -- main
    Name = "音乐盒(客户端)",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})
Music:AddToggle({
    Name = "音乐盒开关",
    Default = true,
    Callback = function(Value)
        if Value then
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
        if Value then
            workspace.MusicBox.Looped = true
        else
            workspace.MusicBox.Looped = false
        end
    end
})
local Animator = Window:MakeTab({ -- others
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
local Section = Animator:AddSection({
    Name = "部分动画"
})
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
local others = Window:MakeTab({ -- others
    Name = "其他",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})
local Section = others:AddSection({
    Name = "注入"
})
others:AddButton({
    Name = "注入Infinity Yield",
    Callback = function()
        Notification("注入Infinity Yield", "尝试注入中")
        loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
        Notification("注入Infinity Yield", "注入完成(如果没有加载则重试)")
    end
})
others:AddButton({
    Name = "注入Dex v2 white(会卡顿)",
    Callback = function()
        Notification("注入Dex v2 white", "尝试注入中")
        loadstring(game:HttpGet('https://raw.githubusercontent.com/MariyaFurmanova/Library/main/dex2.0'))()
        Notification("注入Dex v2 white", "注入完成(如果没有加载则重试)")
    end
})
others:AddButton({
    Name = "注入Dex v4 Beta(会卡顿)",
    Callback = function()
        Notification("注入Dex v4 Beta", "尝试注入中")
        local RepositoryName = "Dex"
        local File = "out.lua"
        local link = "https://raw.githubusercontent.com/luau/" .. RepositoryName .. "/master/" .. File
        loadstring(game:HttpGet(link, true), "Dex")(link)
        Notification("注入Dex v4 Beta", "注入完成(如果没有加载则重试)")
    end
})
others:AddButton({
    Name = "注入UNC Test(英文)",
    Callback = function()
        Notification("注入UNC Test", "尝试注入中")
        loadstring(game:HttpGet(
            'https://raw.githubusercontent.com/unified-naming-convention/NamingStandard/main/UNCCheckEnv.lua'))()
        Notification("注入UNC Test", "注入完成(如果没有加载则重试)")
    end
})
local Section = others:AddSection({
    Name = "删除(窗口)"
})
others:AddButton({
    Name = "删除此窗口",
    Callback = function()
        OrionLib:Destroy()
    end
})
others:AddButton({
    Name = "删除Dex",
    Callback = function()
        game.CoreGui.Dex:Destroy()
        Notification("Dex", "已关闭")
    end
})
local Section = others:AddSection({
    Name = "加入"
})
others:AddButton({
    Name = "加入随机大厅",
    Callback = function()
        Notification("加入游戏", "尝试加入中")
        TeleportService:Teleport(12411473842)
    end
})
others:AddButton({
    Name = "加入随机游戏",
    Callback = function()
        Notification("加入游戏", "尝试加入中")
        TeleportService:Teleport(12552538292)
    end
})
others:AddTextbox({
    Name = "使用UUID加入游戏",
    Callback = function(jobId)
        local function failtp()
            Notification("加入失败", "若UUID正确则可能对应的服务器为预留服务器")
            warn("加入游戏失败!")
        end
        Notification("加入游戏", "尝试加入中")
        TeleportService:TeleportToPlaceInstance(12552538292, jobId, Players.LocalPlayer)
        TeleportService.TeleportInitFailed:Connect(failtp)
    end
})
local Section = others:AddSection({
    Name = "关于"
})
others:AddParagraph("原作者playvora", "https://scriptblox.com/script/Pressure-script-15848")
others:AddLabel("此服务器上的游戏ID为:" .. game.GameId)
others:AddLabel("此服务器上的游戏版本为:version_" .. game.PlaceVersion)
others:AddLabel("此服务器位置ID为:" .. game.PlaceId)
others:AddParagraph("此服务器UUID为:", game.JobId)
workspace.DescendantAdded:Connect(function(inst) -- 其他
    if inst.Name == "Eyefestation" and OrionLib.Flags.noeyefestation.Value then
        inst:Destroy()
        delNotification("Eyefestation")
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
        delNotification("Searchlights")
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
        delNotification("z432")
    end
    if inst.Name == "WaterPart" and inst:FindFirstAncestorOfClass("Folder").Name == "Rooms" and
        OrionLib.Flags.nowatertoswim.Value then -- 水区
        task.wait(0.1)
        inst:Destroy()
    end
    if inst.Name == "Trickster" and inst:FindFirstAncestorOfClass("Model").Name == "Trickster" and
        OrionLib.Flags.noTrickster.Value then -- 假门
        Notification("检测假门", "尝试删除")
        inst.Trickster:Destroy()
    end
    if inst.Name == "WallDweller" and OrionLib.Flags.NotifyEntities.Value then -- 实体提醒-z90
        entityNotification("墙居者出现")
        if OrionLib.Flags.chatNotifyEntities.Value then
            chatMessage("墙居者出现")
        end
    end
    if inst.Name == "RottenWallDweller" and OrionLib.Flags.NotifyEntities.Value then
        entityNotification("墙居者出现")
        if OrionLib.Flags.chatNotifyEntities.Value then
            chatMessage("墙居者出现")
        end
    end
end)
workspace.DescendantRemoving:Connect(function(inst) -- 实体提醒-z90
    if inst.Name == "WallDweller" and OrionLib.Flags.NotifyEntities.Value then
        entityNotification("墙居者消失")
        if OrionLib.Flags.chatNotifyEntities.Value then
            chatMessage("墙居者消失")
        end
    end
    if inst.Name == "RottenWallDweller" and OrionLib.Flags.NotifyEntities.Value then
        entityNotification("墙居者消失")
        if OrionLib.Flags.chatNotifyEntities.Value then
            chatMessage("墙居者消失")
        end
    end
end)
workspace.ChildAdded:Connect(function(child) -- 关于实体
    if table.find(entityNames, child.Name) and child:IsDescendantOf(workspace) then
        if OrionLib.Flags.NotifyEntities.Value and OrionLib.Flags.avoid.Value == false then -- 实体提醒
            entityNotification(child.Name .. "出现")
        end
        if OrionLib.Flags.avoid.Value and child.Name ~= "Mirage" and workspace.r100Intro.Playing == false and
            workspace.r100Intro.r100IntroFadeout.Playing == false then -- 自动躲避
            createPlatform("AvoidPlatform", Vector3.new(3000, 1, 3000), Vector3.new(5000, 10000, 5000))
            teleportPlayerTo(Players.LocalPlayer, Platform.Position + Vector3.new(0, Platform.Size.Y / 2 + 5, 0),true)
            Entitytoavoid[child] = true
            entityNotification(child.Name .. "出现,自动躲避中")
        end
        if OrionLib.Flags.chatNotifyEntities.Value then -- 实体播报
            chatMessage(child.Name .. "出现")
        end
        if OrionLib.Flags.EntityEsp.Value then -- 实体esp(待修)
            createespbox(child, child.Name, Color3.new(1, 0, 0))
        end
        if OrionLib.Flags.nopandemonium.Value and child.Name == "Pandemonium" and child:IsDescendantOf(workspace) then -- 删除z367
            task.wait(0.1)
            child:Destroy()
            delNotification("Pandemonium")
        end
    end
end)
workspace.ChildRemoved:Connect(function(child) -- 关于实体
    if table.find(entityNames, child.Name) then
        if workspace.r100Intro.Playing == false and workspace.r100Intro.r100IntroFadeout.Playing == false then
            if OrionLib.Flags.avoid.Value then -- 自动躲避
                teleportPlayerBack(Players.LocalPlayer)
                entityNotification(child.Name .. "消失,已自动返回")
                if Entitytoavoid[child] then
                    Entitytoavoid[child] = nil
                end
            end
            if OrionLib.Flags.NotifyEntities.Value and OrionLib.Flags.avoid.Value == false then -- 实体提醒
                entityNotification(child.Name .. "消失")
            end
            if OrionLib.Flags.chatNotifyEntities.Value then -- 实体播报
                chatMessage(child.Name .. "消失")
            end
        end
    end
    if child.Name == "Mirage" then -- Mirage
        if OrionLib.Flags.NotifyEntities.Value then
            entityNotification("Mirage消失")
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
        Notification("玩家提醒", player.Name .. Notififriend .. "已加入", 2)
    end
    if OrionLib.Flags.playeresp.Value and player ~= Players.LocalPlayer then
        print(player .. player.Character ..  player.Name)
        createBilltoesp(player.Character, player.Name, Color3.new(238, 201, 0), true)
    end
end)
Players.PlayerRemoving:Connect(function(player)
    if OrionLib.Flags.PlayerNotifications.Value then
        if player:IsFriendsWith(Players.LocalPlayer.UserId) then
            Notififriend = "(好友)"
        else
            Notififriend = ""
        end
        Notification("玩家提醒", player.Name .. Notififriend .. "已退出", 2)
    end
end)
