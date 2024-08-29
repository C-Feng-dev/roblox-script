--[[
	WARNING: Heads up! This script has not been verified by ScriptBlox. Use at your own risk!
]]
local function testFunctionSupport()
    local function supportsHookMethod(methodName)
        return type(getgenv()[methodName]) == "function"
    end

    local function printResult(methodName, status)
        local emoji = ""
        if status == "works 🤑" then
            emoji = "\u{2705}" -- ✅
        elseif status == "half working" then
            emoji = "\u{2757}" -- ❗
        else
            emoji = "\u{274C}" -- ❌
        end
        print(emoji .. " " .. methodName .. " " .. status)
    end

    local function testHookFunction()
        if not supportsHookMethod("hookfunction") then
            return "dont work 🤞💔"
        end

        local originalFunction = function()
            return "original"
        end
        local function hookedFunction()
            return "hooked"
        end

        local hooked = false
        local success, result =
            pcall(
            function()
                return hookfunction(
                    originalFunction,
                    function()
                        hooked = true
                        return hookedFunction()
                    end
                )
            end
        )

        if success then
            local output = originalFunction()
            if hooked and output == "hooked" then
                return "works 🤑"
            else
                return "half working"
            end
        else
            return "dont work 🤞💔"
        end
    end

    local function testHookMetaMethod()
        if not supportsHookMethod("hookmetamethod") then
            return "dont work 🤞💔"
        end

        local metatable = {}
        local originalIndex = function(self, key)
            return "original"
        end

        setmetatable(
            metatable,
            {
                __index = originalIndex
            }
        )

        local success, _ =
            pcall(
            function()
                return hookmetamethod(
                    metatable,
                    "__index",
                    function(self, key)
                        return "hooked"
                    end
                )
            end
        )

        if success then
            local testResult = tostring(metatable["test"])
            if testResult == "hooked" then
                return "works 🤑"
            else
                return "half working 🤔"
            end
        else
            return "dont work 🤞💔"
        end
    end

    -- results
    local hookFunctionStatus = testHookFunction()
    local hookMetaMethodStatus = testHookMetaMethod()

    printResult("hookfunction", hookFunctionStatus)
    printResult("hookmetamethod", hookMetaMethodStatus)
end

testFunctionSupport()
