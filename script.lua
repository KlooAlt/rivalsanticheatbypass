local ts = game:GetService("TweenService")
local cg = game:GetService("CoreGui")
local plrs = game:GetService("Players")
local rs = game:GetService("RunService")
local http = game:GetService("HttpService")
local rep = game:GetService("ReplicatedStorage")
local sc = game:GetService("ScriptContext")
local plr = plrs.LocalPlayer
local mouse = plr:GetMouse()

local Exploit = {
    Icons = {
        Info = "rbxassetid://6034445513",
        Error = "rbxassetid://6031068428",
        Success = "rbxassetid://6031068433",
        Warning = "rbxassetid://6034445533"
    },
    Colors = {
        Info = Color3.fromRGB(100, 150, 200),
        Error = Color3.fromRGB(200, 100, 100),
        Success = Color3.fromRGB(100, 200, 150),
        Warning = Color3.fromRGB(200, 180, 100)
    }
}

function Exploit:Notify(text, type, duration)
    type = type or "Info"
    duration = duration or 3
    
    local gui = (gethui and gethui()) or cg
    local screen = gui:FindFirstChild("NotifyUI") or Instance.new("ScreenGui", gui)
    screen.Name = "NotifyUI"
    
    local tray = screen:FindFirstChild("Tray") or Instance.new("Frame", screen)
    if not tray:IsA("Frame") then
        tray.Name = "Tray"
        tray.BackgroundTransparency = 1
        tray.Position = UDim2.new(0.5, -150, 0.1, 0)
        tray.Size = UDim2.new(0, 300, 0.8, 0)
        local layout = Instance.new("UIListLayout", tray)
        layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        layout.Padding = UDim.new(0, 5)
        layout.SortOrder = Enum.SortOrder.LayoutOrder
    end

    local frame = Instance.new("Frame", tray)
    frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    frame.BackgroundTransparency = 0.4
    frame.BorderSizePixel = 0
    frame.Size = UDim2.new(0.95, 0, 0, 45)
    frame.ClipsDescendants = true
    
    local corner = Instance.new("UICorner", frame)
    corner.CornerRadius = UDim.new(0, 8)

    local icon = Instance.new("ImageLabel", frame)
    icon.BackgroundTransparency = 1
    icon.Position = UDim2.new(0, 10, 0.5, -12)
    icon.Size = UDim2.new(0, 24, 0, 24)
    icon.Image = self.Icons[type]
    icon.ImageColor3 = Color3.new(1,1,1)

    local sep = Instance.new("Frame", frame)
    sep.BackgroundColor3 = Color3.new(1,1,1)
    sep.BackgroundTransparency = 0.5
    sep.Position = UDim2.new(0, 45, 0.2, 0)
    sep.Size = UDim2.new(0, 1, 0.6, 0)

    local lab = Instance.new("TextLabel", frame)
    lab.BackgroundTransparency = 1
    lab.Position = UDim2.new(0, 55, 0, 0)
    lab.Size = UDim2.new(1, -65, 1, 0)
    lab.Font = Enum.Font.GothamMedium
    lab.Text = text
    lab.TextColor3 = Color3.new(1,1,1)
    lab.TextSize = 14
    lab.TextXAlignment = Enum.TextXAlignment.Left

    frame.Position = UDim2.new(1.5, 0, 0, 0)
    ts:Create(frame, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(0,0,0,0)}):Play()

    task.delay(duration, function()
        local out = ts:Create(frame, TweenInfo.new(0.5), {BackgroundTransparency = 1, Position = UDim2.new(-1.5, 0, 0, 0)})
        ts:Create(lab, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
        ts:Create(icon, TweenInfo.new(0.3), {ImageTransparency = 1}):Play()
        ts:Create(sep, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
        out:Play()
        out.Completed:Wait()
        frame:Destroy()
    end)
end

Exploit:Notify("Loading script..", "Info")

if not game:IsLoaded() then 
    game.Loaded:Wait() 
end

if game.GameId ~= 6035872082 then 
    Exploit:Notify("Game ID mismatch!", "Error", 5)
    return 
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
                    local target_plr = plrs:GetPlayerFromCharacter(t.Parent)
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

cg.ChildAdded:Connect(function(gui)
    if gui:IsA("ScreenGui") and not gui:FindFirstChild("Bypasser_Safe") then
        local val = Instance.new("BoolValue", gui)
        val.Name = "Bypasser_Safe"
        if gethui then gui.Parent = gethui() end
        gui.Name = "SystemUI_Protected"
    end
end)

if _G.BypasserSettings and writefile then
    pcall(function()
        writefile("Bypasser_Config.json", http:JSONEncode(_G.BypasserSettings))
    end)
end

Exploit:Notify("Injected successfully! Enjoy.", "Success", 4)
