local oldGame = game
local fakeGame = newproxy(true)
local fakeGameMt = getmetatable(fakeGame)
fakeGameMt.__type = "Instance"
fakeGameMt.__index = function(self, k, v)
    if tostring(k) == "HttpGet" or tostring(k) == "HttpGetAsync" then
        return function(s, ...)
            return senv.httpget(...)
        end
    end
    if tostring(k) == "GetObjects" then
        return function(s, ...)
            return senv.getobjects(...)
        end
    end
    local e = oldGame[k]
    if type(e) == "function" then
        return function(s, ...)
            return e(oldGame, ...)
        end
    end
    return e
end
fakeGameMt.__newindex = function(self, k, v)
    oldGame[k] = v
end
fakeGameMt.__call = function(self, k, ...)
    return oldGame[k](oldGame, ...)
end
fakeGameMt.__tostring = function(self)
    return oldGame.Name
end
fakeGameMt.__len = function(self)
    return error('attempt to get length of a userdata value')
end
fakeGameMt.__metatable = "The metatable is locked"
rawset(getfenv(0), "game", fakeGame)
rawset(getfenv(1), "game", fakeGame)
rawset(getfenv(0), "Game", fakeGame)
rawset(getfenv(1), "Game", fakeGame)
rawset(senv, "game", fakeGame)
rawset(senv, "Game", fakeGame)

loadstring(game:HttpGet('https://raw.githubusercontent.com/catter-y/cat-hub/main/main'))()