local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("GngWilshy's rooms GUI! v1.0 ", "Synapse")

-- local player
local Tab = Window:NewTab("Local Player")
local PlayerSection = Tab:NewSection("Local Player")

PlayerSection:NewButton("Noclip (Warning:Can't Disable Noclip!)", "noclip forever, use with speed", function()
    local StealthMode = true 
 
local Indicator
 
if not StealthMode then
    local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
    print("NOCLIP: Press Q to Activate")
    Indicator = Instance.new("TextLabel", ScreenGui)
    Indicator.AnchorPoint = Vector2.new(0, 1)
    Indicator.Position = UDim2.new(0, 0, 1, 0)
    Indicator.Size = UDim2.new(0, 200, 0, 50)
    Indicator.BackgroundTransparency = 1
    Indicator.TextScaled = true
    Indicator.TextStrokeTransparency = 0
    Indicator.TextColor3 = Color3.new(0, 0, 0)
    Indicator.TextStrokeColor3 = Color3.new(1, 1, 1)
    Indicator.Text = "Noclip: Enabled"
end
 
local noclip = true
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
 
local mouse = player:GetMouse()
 
mouse.KeyDown:Connect(function(key)
    if key == "q" then
        noclip = not noclip
 
        if not StealthMode then
            Indicator.Text = "Noclip: " .. (noclip and "Enabled" or "Disabled")
        end
    end
end)
 
while true do
    player = game.Players.LocalPlayer
    character = player.Character
 
    if noclip then
        for _, v in pairs(character:GetDescendants()) do
            pcall(function()
                if v:IsA("BasePart") then
                    v.CanCollide = false
                end
            end)
        end
    end
 
    game:GetService("RunService").Stepped:wait()
end

end)

PlayerSection:NewButton("Fly (when button pressed - use f to enable/disable", "Doesn't trigger anticheat", function()
    loadstring(game:HttpGet('https://pastebin.com/raw/u46FXhxK'))()
end)

PlayerSection:NewToggle("Speed 21 (buggy)", "may be buggy but ur sonic", function(state)
    if state then
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 21
    else
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16
    end
end)

-- utilities
local Tab = Window:NewTab("Utilities")
local ToolSection = Tab:NewSection("tools")

ToolSection:NewButton("Full Bright (FOREVER)", "fullbright forever", function()
    loadstring(game:HttpGet('https://pastebin.com/raw/7S3aQsQF', true))()
end)

ToolSection:NewButton("a-90 bypasser!", "bypasses a-90", function()
    game.Players.LocalPlayer.PlayerGui.MainUI.Initiator.Main_Game.RemoteListener.Modules.A90:Destroy()
end)

ToolSection:NewButton("Entity Notifyer (forever)", "tells you when a-60 or a-120 comes", function()
    loadstring(game:HttpGet('https://pastebin.com/raw/ELmcEmje', true))()
end)

ToolSection:NewButton("Autowalk", "Automatically completes rooms for you", function()
    loadstring(game:HttpGet("https://" .. "raw.githubusercontent.com/DaRealGeo/roblox/master/rooms-autowalk"))()
end)

--misc
local Tab = Window:NewTab("Misc")
local MiscSection = Tab:NewSection("Fun stuf! (more soon)")

MiscSection:NewButton("Scanner!", "gives you a scanner", function()
    _G.OnShop = true

loadstring(game:HttpGet('https://raw.githubusercontent.com/DeividComSono/Scripts/main/Scanner.lua'))()
end)

MiscSection:NewButton("Figure Plushy", "has sound!", function()
    loadstring(game:HttpGet('https://pastebin.com/raw/PzfDRbAH'))()
end)

MiscSection:NewButton("SEEK PLUSHY!", "has sound!", function()
    loadstring(game:HttpGet('https://pastebin.com/raw/8mazJ8eZ'))()
end)



local OtherSection = Tab:NewSection("Other Scripts")

OtherSection:NewButton("Inf Yield", "ADMIN!!!!@!@!", function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
end)

local MorphsrSection = Tab:NewSection("COMMING SOON!!!")

-- credits

local Tab = Window:NewTab("CREDITS")
local CreditsSection = Tab:NewSection("Gui created by Gngwilshy")
local CreditsSection = Tab:NewSection("Many cool scripts - Deivid, and lolcat")
local CreditsSection = Tab:NewSection("Gngwilshy's discord Gngwilshy#7113")
local CreditsSection = Tab:NewSection("My other account, XlvbIngjIlfbx")