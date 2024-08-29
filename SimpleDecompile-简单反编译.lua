local Settings = {
    IncludeNils = false -- If true, functions that's names cannot be obtained (Most likely empty functions) will also be included in the decompiled code.
}
local HTTPs = game:GetService('HttpService');
function encode(a)
    return HTTPs:JSONEncode(a)
end
function decode(a)
    return HTTPs:JSONDecode(a)
end
if not isfolder("SimpleDecompile") then
    makefolder("SimpleDecompile")
    writefile("SimpleDecompile/config.json", encode(Settings))
elseif isfolder("SimpleDecompile") and isfile("SimpleDecompile/config.json") then
    Settings = decode(readfile("SimpleDecompile/config.json"))
end
function startswith(str, thing)
    if str:sub(1, #thing) == thing then
        return true
    else
        return false
    end
end
function pKey(key)
    if startswith(tostring(key), "__") then
        return tostring(key)
    end
    if type(key) == "number" then
        return "[" .. tostring(key) .. "]"
    else
        return '["' .. tostring(key) .. '"]'
    end
end
function pKey1(key, val)
 if type(key) == "number" then
  if typeof(val):lower() == "boolean" then
   return "bool_" .. tostring(key)
  else
   return typeof(val):lower() .. "_" .. tostring(key)
  end
 elseif type(key) == 'string' then
  return val
 end
end
function isStrFunc(str)
 for i, v in getrenv() do
  if tostring(i) == str and type(v) == "function" then return true end
 end
 return false
end
function gcsenv(Scr)
    local funcs = {}
    for i, v in next, getgc(true) do
        if (type(v) == "function" and islclosure(v) and getfenv(v).script == Scr) then
            table.insert(funcs, v)
        end
    end
    return funcs
end

function GetMetaMethods(regularTable)
    local meta = getmetatable(regularTable)
    if not meta then
        return {}
    end
    setreadonly(meta, false)
    local mms = {}
    for i, v in meta do
        if startswith(tostring(i), "__") then
            table.insert(mms, {Name = i, Value = v})
        end
    end
    return mms
end
function GetFullName(instance)
    local p = instance
    local lo = {}
    while (p ~= game and p.Parent ~= nil) do
        table.insert(lo, p)
        p = p.Parent
    end
    local fullName
    if #lo == 0 then
        return "nil -- Instance parented to nil"
    end
    if lo[#lo].ClassName ~= "Workspace" then
        fullName = 'game:GetService("' .. lo[#lo].ClassName .. '")'
    else
        fullName = "workspace"
    end
    for i = #lo - 1, 1, -1 do
        fullName = fullName .. ':FindFirstChild("' .. lo[i].Name .. '")'
    end
    return fullName
end
function processTableDescendants(tbl, indent, tblname)
    indent = indent or 0
    tblname = tblname or "{}"
    local metacount = 1
    local result = ""
    local count = 1
    for key, value in pairs(tbl) do
        if type(value) == "table" and not startswith(tostring(key), "__") then
            result = result .. string.rep("  ", indent) .. pKey(key) .. " = {"
            if #value == 0 then
                result = result .. "}"
            else
                result = result .. "\n" .. processTableDescendants(value, indent + 1)
                result = result .. string.rep("  ", indent) .. "}\n"
            end
            if getrawmetatable(value) ~= nil then
                result =
                    result ..
                    string.rep("  ", indent) ..
                        "local meta" .. tostring(metacount) .. " = setmetatable(" .. tostring(tblname) .. ", {})\n"
                metacount = metacount + 1
                for _, v in GetMetaMethods(value) do
                    result =
                        result ..
                        string.rep("  ", indent) .. "meta" .. tostring(metacount) .. "." .. tostring(v.Name) .. " = "
                    if typeof(v.Value) == "table" then
                        result =
                            result ..
                            string.rep("  ", indent) ..
                                "{" ..
                                    processTableDescendants(v.Value, indent + 1) ..
                                        "\n" .. string.rep("  ", indent) .. "}"
                    elseif typeof(v.Value) == "function" then
                        result = result .. string.rep("  ", indent) .. "function() --[[ Function Source ]] end"
                    else
                        result = result .. string.rep("  ", indent) .. tostring(v.Value)
                    end
                    result = result .. ";\n"
                end
            end
        elseif type(value) == "function" and not startswith(tostring(key), "__") then
            result =
                result ..
                string.rep("  ", indent) ..
                    pKey(key) .. " = function() --[[Function Source]] end" .. string.rep("  ", indent + 1)
        elseif typeof(value):lower() == "vector3" and not startswith(tostring(key), "__") then
            result =
                result ..
                string.rep("  ", indent) ..
                    pKey(key) ..
                        " = Vector3.new(" ..
                            tostring(value.X) .. ", " .. tostring(value.Y) .. ", " .. tostring(value.Z) .. ");\n"
        elseif typeof(value):lower() == "vector2" and not startswith(tostring(key), "__") then
            result =
                result ..
                string.rep("  ", indent) ..
                    pKey(key) .. " = Vector2.new(" .. tostring(value.X) .. ", " .. tostring(value.Y) .. ");\n"
        elseif typeof(value):lower() == "udim" and not startswith(tostring(key), "__") then
            result =
                result ..
                string.rep("  ", indent) ..
                    pKey(key) .. " = UDim.new(" .. tostring(value.Scale) .. ", " .. tostring(value.Offset) .. ");\n"
        elseif typeof(value):lower() == "udim2" and not startswith(tostring(key), "__") then
            result =
                result ..
                string.rep("  ", indent) ..
                    pKey(key) ..
                        " = UDim2.new(" ..
                            tostring(value.X.Scale) ..
                                ", " ..
                                    tostring(value.X.Offset) ..
                                        ", " .. tostring(value.Y.Scale) .. ", " .. tostring(value.Y.Offset) .. ");\n"
        elseif typeof(value):lower() == "instance" and not startswith(tostring(key), "__") then
            result = result .. string.rep("  ", indent) .. pKey(key) .. " = " .. GetFullName(value) .. ";\n"
        elseif typeof(value) == "string" and not startswith(tostring(key), "__") then
            result = result .. string.rep("  ", indent) .. pKey(key) .. ' = "' .. tostring(value) .. '";\n'
        elseif typeof(value) == "number" and not startswith(tostring(key), "__") then
            result = result .. string.rep("  ", indent) .. pKey(key) .. " = " .. tostring(value) .. ";\n"
        elseif typeof(value) == "nil" and not startswith(tostring(key), "__") then -- nil value
            result = result .. string.rep("  ", indent) .. pKey(key) .. " = " .. tostring(value) .. ";\n"
        elseif typeof(value):lower() == "cframe" and not startswith(tostring(key), "__") then -- Enum/Other value
            result = result .. string.rep("  ", indent) .. pKey(key) .. " = CFrame.new(" .. tostring(value) .. ");\n"
        elseif typeof(value):lower() == "color3" and not startswith(tostring(key), "__") then
            result =
                result ..
                string.rep("  ", indent) ..
                    pKey(key) ..
                        " = Color3.fromRGB(" ..
                            tostring(value.R * 255) ..
                                ", " .. tostring(value.G * 255) .. ", " .. tostring(value.B * 255) .. ");\n"
        end
    end
    if #tbl == 0 then
        return result
    else
        return "\n" .. result
    end
end
function DecompileFunction(func, excludename, indent, customname)
    if not indent then
        indent = 1
    end
    local metatablecount = 1
    local inf, String = debug.getinfo(func), "function " .. tostring(debug.getinfo(func).name) .. "("

    if excludename then
        String = "function("
    end
    if customname then
        String = "function " .. customname .. "("
    end
    if tostring(inf.is_vararg) == "1" then
        String = String .. "...\n"
    else
        local ab={"a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"}
        if inf.numparams > 0 then
            local paramcount = inf.numparams
            for i = 1, paramcount do
                String = String .. ab[i]
                if i < paramcount then
                    String = String .. ", "
                end
            end
            if paramcount > #ab then
                String = String .. ", ..."
            end
        end
        String = String .. ")"
        StringHolder = String
        String = ""
        UString = ""
        for i, v in getupvalues(func) do
        if typeof(v):lower() == "vector2" then
            UString = UString .. ("\n%s = Vector2.new(%d, %d)"):format(pKey1(i, v), v.X, v.Y)
        elseif typeof(v):lower() == "vector3" then
            UString = UString .. ("\n%s = Vector3.new(%d, %d, %d)"):format(pKey1(i, v), v.X, v.Y, v.Z)
        elseif typeof(v):lower() == "udim" then
            UString = UString .. ("\n%s = UDim.new(%d, %d)"):format(pKey1(i, v), v.Scale, v.Offset)
        elseif typeof(v):lower() == "udim2" then
            UString =
                UString ..
                ("\n%s = UDim2.new(%d, %d, %d, %d)"):format(
                    pKey1(i, v),
                    v.X.Scale,
                    v.X.Offset,
                    v.Y.Scale,
                    v.Y.Offset
                )
        elseif typeof(v):lower() == "number" then
            if os.time() - v < 1 then
                UString = UString .. ("\n%s = %s --[[ Possibly os.time() ]]"):format(pKey1(i, v), tostring(v))
            elseif tick() - v < 1 then
                UString = UString .. ("\n%s = %s -- [[ Possibly tick() ]]"):format(pKey1(i, v), tostring(v))
            else
                -- Reasons not to add userid checks: False alarms (Really rare, But why would they it in a modulescript or a localscript.)
                UString = UString .. ("\n%s = %s"):format(pKey1(i, v), tostring(v))
            end
        elseif typeof(v):lower() == "instance" then
            UString = UString .. ("\n%s = %s"):format(v.Name:gsub(" ", "_"),GetFullName(v))
        elseif typeof(v):lower() == "color3" then
            UString = UString .. ("\n%s = Color3.fromRGB(%d, %d, %d"):format(pKey1(i, v), v.R * 255, v.G * 255, v.B * 255)
        elseif typeof(v):lower() == "string" then
            UString = UString .. ('\n%s = "%s"'):format(pKey1(i, v), v)
        elseif typeof(v):lower() == "boolean" then
            UString = UString .. ("\n%s = %s"):format(pKey1(i, v), tostring(v))
        elseif typeof(v):lower() == "cframe" then
            UString = UString .. ("\n%s = CFrame.new(%s)"):format(pKey1(i, v), tostring(v))
        end
     end
    end
    if #getupvalues(func) == 0 then
        String = StringHolder
    else
        String = UString .. "\n" .. StringHolder or ''
    end
    local consts = string.rep("  ", indent) .. "--[[ Detected roblox functions list"
    local Aconsts = ""
    local UnknownProtos = 0
    for i, v in getconstants(func) do
     if isStrFunc(v) then
      consts = consts .. "\n" .. string.rep("  ", indent) ..v.."()"
     else
      Aconsts = Aconsts .. "\n" .. string.rep("  ", indent) .. "local c_" .. tostring(i) .. " = '" .. tostring(v) .. "'"
     end
    end
    consts = consts .. "\n" .. string.rep("  ", indent) .. "]]\n"
    for i, v in getprotos(func) do
        if debug.getinfo(v).name == nil then
            UnknownProtos = UnknownProtos + 1
            String =
                String ..
                ("\n%slocal %s\n"):format(
                    string.rep("  ", indent),
                    DecompileFunction(v, false, indent + 1, "nil" .. tostring(UnknownProtos))
                )
        else
            String = String .. ("\n%slocal %s\n"):format(string.rep("  ", indent), DecompileFunction(v, false, indent + 1))
        end
    end
    return String .. "\n" .. consts .. Aconsts .. "\n" .. string.rep(" ", indent) .. "end"
end

function DecompileScript(Script)
    local Decompiled = "--[[ DECOMPILED WITH SIMPLEDECOMPILE ]]\n"
    if typeof(Script) == "Instance" and Script.ClassName == "ModuleScript" then
        local s, e =
            pcall(
            function()
                for i, v in require(Script) do
                    if type(v) == "table" then
                        if #v == 0 then
                            if type(i) == "number" then
                                Decompiled = Decompiled .. ("\nlocal table_%d = {}; --[[ EMPTY TABLE ]]\n"):format(pKey1(i, v))
                            else
                                Decompiled = Decompiled .. ("\nlocal %s = {}; --[[ EMPTY TABLE ]]\n"):format(i)
                            end
                        else
                            if type(i) == "number" then
                                Decompiled =
                                    Decompiled ..
                                    ("local table_%d = {\n%s};\n"):format(
                                        pKey1(i, v),
                                        processTableDescendants(v, 0, "t_" .. tostring(i))
                                    )
                            else
                                Decompiled =
                                    Decompiled ..
                                    ("local %s = {\n%s};\n"):format(
                                        i,
                                        processTableDescendants(v, 0, "t_" .. tostring(i))
                                    )
                            end
                        end
                elseif type(v) == 'function' then
                 if type(i) == 'number' then
                    Decompiled = Decompiled .. ("\n%s"):format(DecompileFunction(v, false, 0, "f_"..tostring(i)))
                 else
                    Decompiled = Decompiled .. ("\n%s"):format(DecompileFunction(v, false, 0))
                 end
                end
             end
            end
        )
        if not s then
            return "-- Error occured when trying to iterate over ModuleScript, Message: " .. e
        end
        return Decompiled
    end
    local s, e =
        pcall(
        function()
            local uks = 1
            for i, v in getsenv(Script) do
                if type(v) == "table" then
                    if #v == 0 then
                        if type(i) == "number" then
                            Decompiled = Decompiled .. ("\nlocal table_%d = {}; --[[ EMPTY TABLE ]]\n"):format(pKey1(i, v))
                        else
                            Decompiled = Decompiled .. ("\nlocal %s = {}; --[[ EMPTY TABLE ]]\n"):format(i)
                        end
                    else
                        if type(i) == "number" then
                            Decompiled =
                                Decompiled ..
                                ("local table_%d = {\n%s};"):format(
                                    pKey1(i, v),
                                    processTableDescendants(v, 0, "t_" .. tostring(i))
                                )
                        else
                            Decompiled =
                                Decompiled ..
                                ("local %s = {\n%s};\n"):format(i, processTableDescendants(v, 0, "t_" .. tostring(i)))
                        end
                    end
                end
            end
            for i, v in gcsenv(Script) do -- garbage collection senv
                local name = debug.getinfo(v).name
                if name == nil and Settings.IncludeNils then
                    Decompiled = Decompiled .. ("\n%s"):format(DecompileFunction(v, false, 0, "nil" .. tostring(uks)))
                    uks = uks + 1
                elseif name ~= nil then
                    Decompiled = Decompiled .. ("\n%s"):format(DecompileFunction(v, false, 0))
                end
            end
        end
    )
    if not s then
        return " --An error occured while attempting to iterate over Script's enviroment!\nMessage: " .. e
    end
    return Decompiled
end

getgenv().decompile = DecompileScript
return DecompileScript