<<<<<<< HEAD
local HttpService = game:GetService("HttpService")
local baseURL = "https://raw.githubusercontent.com/notpoiu/mspaint/main"

export type gameMapping = {
    exclusions: table?,
    main: string
}

if not getgenv().ExecutorSupport then
    loadstring(game:HttpGet(baseURL .. "/executorTest.lua"))()
end

if not getgenv().BloxstrapRPC then
    local BloxstrapRPC = {}

    export type RichPresence = {
        details:     string?,
        state:       string?,
        timeStart:   number?,
        timeEnd:     number?,
        smallImage:  RichPresenceImage?,
        largeImage:  RichPresenceImage?
    }

    export type RichPresenceImage = {
        assetId:    number?,
        hoverText:  string?,
        clear:      boolean?,
        reset:      boolean?
    }

    function BloxstrapRPC.SendMessage(command: string, data: any)
        local json = HttpService:JSONEncode({
            command = command, 
            data = data
        })
        
        print("[BloxstrapRPC] " .. json)
    end

    function BloxstrapRPC.SetRichPresence(data: RichPresence)
        if data.timeStart ~= nil then
            data.timeStart = math.round(data.timeStart)
        end
        
        if data.timeEnd ~= nil then
            data.timeEnd = math.round(data.timeEnd)
        end
        
        BloxstrapRPC.SendMessage("SetRichPresence", data)
    end 

    getgenv().BloxstrapRPC = BloxstrapRPC
end

local mapping: gameMapping = HttpService:JSONDecode(game:HttpGet(baseURL .. "/mappings/" .. game.GameId .. ".json"))
local scriptPath = mapping.main

if mapping.exclusions and mapping.exclusions[tostring(game.PlaceId)] then
    scriptPath = mapping.exclusions[tostring(game.PlaceId)]
end

loadstring(game:HttpGet(baseURL .. scriptPath))()
=======
if not ExecutorSupport then
    local Workspace = game:GetService("Workspace")

    local executorSupport = {}

    function test(name: string, func: () -> (), ...)
        local success, _ = pcall(func, ...)
        
        executorSupport[name] = success
        
        return success
    end

    test("require", require, game:GetService("ReplicatedStorage"):WaitForChild("ModuleScript"))
    test("hookmetamethod", function()
        local object = setmetatable({}, { __index = newcclosure(function() return false end), __metatable = "Locked!" })
        local ref = hookmetamethod(object, "__index", function() return true end)
        assert(object.test == true, "Failed to hook a metamethod and change the return value")
        assert(ref() == false, "Did not return the original function")

        local method
        local ref
        ref = hookmetamethod(game, "__namecall", function(...)
            if not method then
                method = getnamecallmethod()
            end
            return ref(...)
        end)
        game:GetService("Lighting")
        assert(method == "GetService", "Did not get the correct method (GetService)")
    end)
    test("firesignal", function()
        local event = Instance.new("BindableEvent")
        local fired = false

        event.Event:Once(function(value)
            fired = value
        end)

        firesignal(event.Event, true)

        task.wait()
        event:Destroy()

        assert(fired, "Failed to fire a BindableEvent")
    end)
    local canFirePrompt = test("fireproximityprompt", function()
        local prompt = Instance.new("ProximityPrompt", Instance.new("Part", Workspace))
        local triggered = false

        prompt.Triggered:Once(function()
            triggered = true
        end)

        fireproximityprompt(prompt)
        task.wait(0.1)

        prompt.Parent:Destroy()
        assert(triggered, "Failed to fire proximity prompt")
        print("finished this one")
    end)

    --// Fixes \\--

    if not canFirePrompt then
        getgenv().fireproximityprompt = function(prompt: ProximityPrompt, lookToPrompt: boolean)
            if not prompt:IsA("ProximityPrompt") then
                return error("ProximityPrompt expected, got " .. typeof(prompt))
            end

            local connection
            local promptPosition = prompt.Parent:GetPivot().Position
        
            local originalEnabled = prompt.Enabled
            local originalHold = prompt.HoldDuration
            local originalLineOfSight = prompt.RequiresLineOfSight
            local originalCamCFrame = workspace.CurrentCamera.CFrame
        
            prompt.Enabled = true
            prompt.HoldDuration = 0
            prompt.RequiresLineOfSight = false
            
            if lookToPrompt then
                workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, promptPosition)
                connection = workspace.CurrentCamera:GetPropertyChangedSignal("CFrame"):Connect(function()
                    workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, promptPosition)
                end)

                task.wait()
            end

            prompt:InputHoldEnd()
            prompt:InputHoldBegin()
            prompt:InputHoldEnd()

            if connection then connection:Disconnect() end

            prompt.Enabled = originalEnabled
            prompt.HoldDuration = originalHold
            prompt.RequiresLineOfSight = originalLineOfSight
            workspace.CurrentCamera.CFrame = originalCamCFrame
        end
    end

    if not isnetworkowner then
        getgenv().isnetworkowner = function(part: BasePart)
            if not part:IsA("BasePart") then
                return error("BasePart expected, got " .. typeof(part))
            end

            return part.ReceiveAge == 0
        end
    end

    --// Load \\--

    for name, result in pairs(executorSupport) do
        print(name .. ":", result)
    end

    getgenv().ExecutorSupport = executorSupport
end

loadstring(game:HttpGet("https://raw.githubusercontent.com/notpoiu/mspaint/main/places/" .. game.GameId .. ".lua"))()
>>>>>>> 9832e39905e871b54e6f2df05eb5d0c7d421b6eb
