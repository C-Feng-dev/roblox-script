local OrionLib = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Orion/main/source'))()
local Window = OrionLib:MakeWindow({
	IntroText = "MusicBox",
	Name = "音乐盒",
	HidePremium = false,
	SaveConfig = true,
	ConfigFolder = "MusicBox"
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