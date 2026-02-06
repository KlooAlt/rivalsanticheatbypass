-- [[ DEATHBYTE v1.0 - IRON WALL BYPASS ]] --
-- Target: Rivals (GameID: 6035857208)

if not game:IsLoaded() then game.Loaded:Wait() end

-- Notification System
local function SendDeathByteNotify(title, msg)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = " [ DEATHBYTE ] ",
            Text = msg,
            Icon = "rbxassetid://6031068433", -- Red Alert Icon
            Duration = 5
        })
    end)
end

-- Core Bypass Logic
local bypass_success, err = pcall(function()
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local HttpService = game:GetService("HttpService")
    
    -- 1. ANALYTICS HANGING
    -- Finds the internal game controllers and freezes their reporting loops
    for _, v in pairs(getgc(true)) do
        if typeof(v) == "function" then
            local info = debug.info(v, "s")
            if info:find("AnalyticsPipelineController") or info:find("IronWall") then
                hookfunction(v, function(...)
                    return task.wait(9e9) -- Freeze the reporting function forever
                end)
            end
        end
    end

    -- 2. METAMETHOD PROTECTION
    -- Intercepts every message sent to the server and blocks "snitch" remotes
    local BlockList = {"Analytics", "Telemetry", "CombatLog", "Verify", "InputUpdate", "RemoteEvent"}
    local oldNamecall
    oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
        local method = getnamecallmethod()
        local name = tostring(self)

        if not checkcaller() and method == "FireServer" then
            for _, blocked in pairs(BlockList) do
                if name:find(blocked) then
                    return nil -- Drop the packet so the server never receives it
                end
            end
        end
        
        -- Block HttpService snitching
        if not checkcaller() and (method == "RequestAsync" or self == HttpService) then
            return nil
        end

        return oldNamecall(self, ...)
    end))

    -- 3. ANTI-KICK
    -- Stops the game from being able to force-close your connection
    local oldKick
    oldKick = hookfunction(LocalPlayer.Kick, newcclosure(function(self, ...)
        if self == LocalPlayer then
            print("[DEATHBYTE] Blocked an attempted kick.")
            return nil 
        end
        return oldKick(self, ...)
    end))

    -- 4. ERROR LOG SUPPRESSION
    -- Prevents the game from sending your script errors to the developers
    for _, conn in pairs(getconnections(game:GetService("LogService").MessageOut)) do
        conn:Disable()
    end
    for _, conn in pairs(getconnections(game:GetService("ScriptContext").Error)) do
        conn:Disable()
    end
end)

-- Execution Status
if bypass_success then
    print([[
    ______  _______ _______ _______ _     _ ______  驰 _______ _______ 
    |     \ |______ |_____|    |    |_____| |_____  | |______ |______ 
    |_____/ |______ |     |    |    |     | |_____  | |______ |______ 
    ]])
    SendDeathByteNotify("BYPASS ACTIVE", "Iron Wall bypassed successfully. You are now invisible.")
else
    warn("[DEATHBYTE] Critical Error during bypass: " .. tostring(err))
    SendDeathByteNotify("BYPASS FAILED", "Error: " .. tostring(err))
end
