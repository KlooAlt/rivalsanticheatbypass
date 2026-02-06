local Lib = {
    Icons = {
        Info = "rbxassetid://6034445513",
        Success = "rbxassetid://6031068433",
        Error = "rbxassetid://6031068428"
    },
    Colors = {
        Info = Color3.fromRGB(100, 160, 255),
        Success = Color3.fromRGB(110, 190, 140),
        Error = Color3.fromRGB(220, 90, 90)
    }
}

function Lib:Notify(text, type, duration)
    local ts = game:GetService("TweenService")
    local gui = (gethui and gethui()) or (syn and syn.protect_gui and game:GetService("CoreGui")) or game:GetService("CoreGui")
    
    local screen = gui:FindFirstChild("ExploitUI") or Instance.new("ScreenGui", gui)
    screen.Name = "ExploitUI"
    
    local container = screen:FindFirstChild("Holder") or Instance.new("Frame", screen)
    if not container:IsA("Frame") then
        container.Name = "Holder"
        container.BackgroundTransparency = 1
        container.Position = UDim2.new(0.5, -150, 0.1, 0)
        container.Size = UDim2.new(0, 300, 0.8, 0)
        local layout = Instance.new("UIListLayout", container)
        layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        layout.Padding = UDim.new(0, 6)
        layout.SortOrder = Enum.SortOrder.LayoutOrder
    end

    local main = Instance.new("Frame", container)
    main.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    main.BackgroundTransparency = 0.35
    main.BorderSizePixel = 0
    main.Size = UDim2.new(0.9, 0, 0, 45)
    
    local corner = Instance.new("UICorner", main)
    corner.CornerRadius = UDim.new(0, 4)

    local bar = Instance.new("Frame", main)
    bar.BackgroundColor3 = self.Colors[type or "Info"]
    bar.BorderSizePixel = 0
    bar.Position = UDim2.new(0, 5, 0.15, 0)
    bar.Size = UDim2.new(0, 2, 0.7, 0)

    local icon = Instance.new("ImageLabel", main)
    icon.BackgroundTransparency = 1
    icon.Position = UDim2.new(0, 15, 0.5, -11)
    icon.Size = UDim2.new(0, 22, 0, 22)
    icon.Image = self.Icons[type or "Info"]
    icon.ImageColor3 = Color3.new(1,1,1)

    local label = Instance.new("TextLabel", main)
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 48, 0, 0)
    label.Size = UDim2.new(1, -55, 1, 0)
    label.Font = Enum.Font.GothamMedium
    label.Text = text
    label.TextColor3 = Color3.new(1,1,1)
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left

    main.Position = UDim2.new(1.2, 0, 0, 0)
    ts:Create(main, TweenInfo.new(0.4, Enum.EasingStyle.Back), {Position = UDim2.new(0,0,0,0)}):Play()

    task.delay(duration or 3, function()
        local out = ts:Create(main, TweenInfo.new(0.4), {BackgroundTransparency = 1, Position = UDim2.new(-1.2, 0, 0, 0)})
        ts:Create(label, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
        ts:Create(icon, TweenInfo.new(0.3), {ImageTransparency = 1}):Play()
        ts:Create(bar, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
        out:Play()
        out.Completed:Wait()
        main:Destroy()
    end)
end

Lib:Notify("Loading script..", "Info")

if not game:IsLoaded() then game.Loaded:Wait() end

-- Updated Game Check (Da Hood Universe ID)
if game.GameId ~= 1001037305 and game.GameId ~= 6035872082 then 
    warn("Script not designed for this game. Continuing anyway.")
end 

local players = game:GetService("Players")
local rs = game:GetService("RunService")
local http = game:GetService("HttpService")
local rep = game:GetService("ReplicatedStorage")
local sg = game:GetService("StarterGui")
local sc = game:GetService("ScriptContext")
local plr = players.LocalPlayer
local mouse = plr:GetMouse()

local function get_env_service(name)
    local s = game:GetService(name)
    return (cloneref and cloneref(s)) or s
end

pcall(function()
    for _, v in pairs(getgc(true)) do
        if type(v) == "function" then
            local ok, src = pcall(function() return debug.info(v, "s") end)
            if ok and type(src) == "string" and src:find("AnalyticsPipelineController") then
                hookfunction(v, newcclosure(function()
                    return task.wait(9e9)
                end))
            end
        end
    end

    local analytics = rep:FindFirstChild("RemoteEvent", true)
    if analytics and analytics.Parent.Name == "AnalyticsPipeline" then
        for _, v in pairs(getconnections(analytics.OnClientEvent)) do
            if v.Function then
                hookfunction(v.Function, function() end)
            end
        end
    end

    for _, v in pairs(getconnections(sc.Error)) do 
        v:Disable() 
    end
    
    hookfunction(sc.Error.Connect, function() 
        return nil 
    end)

    local old_kick
    old_kick = hookfunction(plr.Kick, newcclosure(function(self, ...)
        if self == plr then return end
        return old_kick(self, ...)
    end))
end)

local blocked = {
    ["Analytics"] = true,
    ["CombatLog"] = true,
    ["Verify"] = true,
    ["Telemetry"] = true,
    ["InputUpdate"] = true
}

local old_nc
old_nc = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local name = tostring(self)

    if not checkcaller() then
        if method == "FireServer" then
            for k in pairs(blocked) do
                if name:find(k) then return nil end
            end
        end

        if method == "RequestAsync" or method == "PostAsync" or self == http then
            return nil
        end
    end

    return old_nc(self, ...)
end))

task.spawn(function()
    while true do
        task.wait(0.12)
        local settings = _G.BypasserSettings
        if settings and settings.TriggerBot then
            pcall(function()
                local t = mouse.Target
                if t and t.Parent:FindFirstChild("Humanoid") then
                    local target_plr = players:GetPlayerFromCharacter(t.Parent)
                    if target_plr and target_plr ~= plr then
                        if not (settings.TeamCheck and target_plr.Team == plr.Team) then
                            if mouse1click then mouse1click() end
                        end
                    end
                end
            end)
        end
    end
end)

game:GetService("CoreGui").ChildAdded:Connect(function(gui)
    if gui:IsA("ScreenGui") and not gui:FindFirstChild("Bypasser_Safe") then
        local val = Instance.new("BoolValue", gui)
        val.Name = "Bypasser_Safe"
        if gethui then 
            gui.Parent = gethui() 
        end
        gui.Name = "SystemUI_Protected"
    end
end)

if _G.BypasserSettings and writefile then
    pcall(function()
        writefile("Bypasser_Config.json", http:JSONEncode(_G.BypasserSettings))
    end)
end

Lib:Notify("Injected successfully! Enjoy.", "Success", 4)
