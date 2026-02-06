--[[
    .______    _______      ___       _______  .______   ____    ____ .___________. _______ 
    |   _  \  |   ____|    /   \     |       \ |   _  \  \   \  /   / |           ||   ____|
    |  |_)  | |  |__      /  ^  \    |  .--.  ||  |_)  |  \   \/   /  `---|  |----`|  |__   
    |   _  <  |   __|    /  /_\  \   |  |  |  ||   _  <    \_    _/       |  |     |   __|  
    |  |_)  | |  |____  /  _____  \  |  '--'  ||  |_)  |     |  |         |  |     |  |____ 
    |______/  |_______|/__/     \__\ |_______/ |______/      |__|         |__|     |_______|
                                                                                                
    [ DEADBYTE SOVEREIGN - RIVALS PRIVATE ]
    [ DEVELOPER: DEADBYTE TEAM ]
    [ THEME: ONYX & BLOOD ]
]]

-- // [1] ENVIRONMENT INITIALIZATION
if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local StarterGui = game:GetService("StarterGui")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = workspace.CurrentCamera

-- // [2] DEOBFUSCATED SECURITY SUITE (MoonSec Ref)
local Security = {}
function Security:Initalize()
    local sc = game:GetService("ScriptContext")
    
    -- Anti-Error Tracing
    for _, v in pairs(getconnections(sc.Error)) do v:Disable() end
    
    -- Anti-Kick Hook
    local old_kick
    old_kick = hookfunction(LocalPlayer.Kick, newcclosure(function(self, ...)
        if self == LocalPlayer then 
            print("DeadByte: Blocked a kick attempt.")
            return nil 
        end
        return old_kick(self, ...)
    end))

    -- Remote Blocking (Rivals Anticheat Bypasses)
    local BlockedRemotes = {"Analytics", "CombatLog", "Verify", "Telemetry", "InputUpdate"}
    local old_nc
    old_nc = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
        local method = getnamecallmethod()
        local name = tostring(self)
        if not checkcaller() and (method == "FireServer" or method == "InvokeServer") then
            for _, blocked in pairs(BlockedRemotes) do
                if name:find(blocked) then return nil end
            end
        end
        return old_nc(self, ...)
    end))
end
Security:Initalize()

-- // [3] CONFIGURATION SYSTEM
getgenv().DeadByteConfig = {
    Combat = {
        AimbotEnabled = false,
        SilentAim = false,
        TeamCheck = true,
        WallCheck = true,
        HitPart = "Head",
        FOV = 150,
        Smoothing = 4,
        Prediction = 0.165,
        VisibleFOV = true
    },
    Visuals = {
        ESP_Enabled = false,
        Boxes = false,
        Names = false,
        Health = false,
        Tracers = false,
        Highlights = false,
        HighlightColor = Color3.fromRGB(255, 0, 0)
    },
    Movement = {
        Speed = 16,
        Jump = 50,
        InfJump = false,
        Noclip = false
    },
    Customization = {
        Accent = Color3.fromRGB(255, 0, 0),
        Main = Color3.fromRGB(12, 12, 12),
        Outline = Color3.fromRGB(50, 0, 0)
    }
}

local function SaveSettings()
    if writefile then
        writefile("DeadByte_Master.json", HttpService:JSONEncode(getgenv().DeadByteConfig))
    end
end

local function LoadSettings()
    if isfile("DeadByte_Master.json") then
        local data = HttpService:JSONDecode(readfile("DeadByte_Master.json"))
        getgenv().DeadByteConfig = data
    end
end

-- // [4] SOVEREIGN UI ENGINE (Onyx & Blood)
local UI = {Active = true, Tabs = {}}

function UI:Notify(text, type)
    local notifyFrame = Instance.new("Frame", CoreGui:FindFirstChild("DeadByte_UI") or Instance.new("ScreenGui", CoreGui))
    notifyFrame.Size = UDim2.new(0, 250, 0, 40)
    notifyFrame.Position = UDim2.new(1, 10, 0.85, 0)
    notifyFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    notifyFrame.BorderSizePixel = 0
    
    local stroke = Instance.new("UIStroke", notifyFrame)
    stroke.Color = type == "Success" and Color3.new(0,1,0) or Color3.new(1,0,0)
    
    local label = Instance.new("TextLabel", notifyFrame)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.Text = text
    label.TextColor3 = Color3.new(1,1,1)
    label.Font = Enum.Font.Code
    label.BackgroundTransparency = 1

    TweenService:Create(notifyFrame, TweenInfo.new(0.4), {Position = UDim2.new(1, -260, 0.85, 0)}):Play()
    task.delay(3, function() notifyFrame:Destroy() end)
end

function UI:CreateWindow()
    local Screen = Instance.new("ScreenGui", CoreGui)
    Screen.Name = "DeadByte_UI"
    
    local Main = Instance.new("Frame", Screen)
    Main.Size = UDim2.new(0, 680, 0, 450)
    Main.Position = UDim2.new(0.5, -340, 0.5, -225)
    Main.BackgroundColor3 = getgenv().DeadByteConfig.Customization.Main
    Main.BorderSizePixel = 0
    
    local Stroke = Instance.new("UIStroke", Main)
    Stroke.Color = getgenv().DeadByteConfig.Customization.Outline
    Stroke.Thickness = 2
    
    local Sidebar = Instance.new("Frame", Main)
    Sidebar.Size = UDim2.new(0, 180, 1, 0)
    Sidebar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    Sidebar.BorderSizePixel = 0
    
    local Logo = Instance.new("TextLabel", Sidebar)
    Logo.Size = UDim2.new(1, 0, 0, 60)
    Logo.Text = "DEADBYTE"
    Logo.Font = Enum.Font.Code
    Logo.TextSize = 25
    Logo.TextColor3 = Color3.fromRGB(255, 0, 0)
    
    local TabContainer = Instance.new("ScrollingFrame", Sidebar)
    TabContainer.Position = UDim2.new(0, 0, 0, 70)
    TabContainer.Size = UDim2.new(1, 0, 1, -80)
    TabContainer.BackgroundTransparency = 1
    TabContainer.ScrollBarThickness = 0
    local Layout = Instance.new("UIListLayout", TabContainer)
    Layout.Padding = UDim.new(0, 5)

    local PageContainer = Instance.new("Frame", Main)
    PageContainer.Position = UDim2.new(0, 190, 0, 10)
    PageContainer.Size = UDim2.new(1, -200, 1, -20)
    PageContainer.BackgroundTransparency = 1

    -- Dragging Logic
    local dragStart, startPos, dragging
    Main.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; dragStart = input.Position; startPos = Main.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)

    return {Container = PageContainer, TabHolder = TabContainer, Main = Main}
end

-- // [5] COMBAT & VISUALS ENGINES
local FOV = Drawing.new("Circle")
FOV.Color = Color3.new(1, 0, 0)
FOV.Thickness = 1
FOV.NumSides = 100

local function GetTarget()
    local target = nil
    local dist = getgenv().DeadByteConfig.Combat.FOV
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") then
            if getgenv().DeadByteConfig.Combat.TeamCheck and player.Team == LocalPlayer.Team then continue end
            local pos, screen = Camera:WorldToViewportPoint(player.Character[getgenv().DeadByteConfig.Combat.HitPart].Position)
            if screen then
                local mag = (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                if mag < dist then
                    if getgenv().DeadByteConfig.Combat.WallCheck then
                        local parts = Camera:GetPartsObscuringTarget({player.Character[getgenv().DeadByteConfig.Combat.HitPart].Position}, {LocalPlayer.Character, player.Character})
                        if #parts > 0 then continue end
                    end
                    target = player
                    dist = mag
                end
            end
        end
    end
    return target
end

-- // [6] INITIALIZING THE MASTER SUITE
LoadSettings()
local Window = UI:CreateWindow()

function UI:CreateTab(name)
    local Page = Instance.new("ScrollingFrame", Window.Container)
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.ScrollBarThickness = 2
    Page.ScrollBarImageColor3 = Color3.fromRGB(255, 0, 0)
    Instance.new("UIListLayout", Page).Padding = UDim.new(0, 10)

    local Btn = Instance.new("TextButton", Window.TabHolder)
    Btn.Size = UDim2.new(1, -10, 0, 35)
    Btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Btn.Text = name
    Btn.TextColor3 = Color3.fromRGB(150, 150, 150)
    Btn.Font = Enum.Font.Code
    Btn.BorderSizePixel = 0
    
    Btn.MouseButton1Click:Connect(function()
        for _, v in pairs(Window.Container:GetChildren()) do v.Visible = false end
        Page.Visible = true
        for _, v in pairs(Window.TabHolder:GetChildren()) do if v:IsA("TextButton") then v.TextColor3 = Color3.fromRGB(150, 150, 150) end end
        Btn.TextColor3 = Color3.fromRGB(255, 0, 0)
    end)
    return Page
end

-- Tabs
local CombatTab = UI:CreateTab("Combat")
local VisualsTab = UI:CreateTab("Visuals")
local MovementTab = UI:CreateTab("Movement")
local MiscTab = UI:CreateTab("Miscellaneous")
local SettingsTab = UI:CreateTab("Configuration")

-- // Feature Building (Repeat these patterns to reach 1500+ lines)
local function NewToggle(parent, text, cfg, key)
    local frame = Instance.new("TextButton", parent)
    frame.Size = UDim2.new(1, -10, 0, 40)
    frame.BackgroundColor3 = Color3.fromRGB(15, 10, 10)
    frame.Text = "  " .. text .. ": " .. (cfg[key] and "ON" or "OFF")
    frame.TextColor3 = Color3.new(1,1,1)
    frame.TextXAlignment = Enum.TextXAlignment.Left
    frame.Font = Enum.Font.Code
    
    frame.MouseButton1Click:Connect(function()
        cfg[key] = not cfg[key]
        frame.Text = "  " .. text .. ": " .. (cfg[key] and "ON" or "OFF")
        SaveSettings()
    end)
end

-- COMBAT FEATURES (Add 20+ more to expand)
NewToggle(CombatTab, "Aimbot Enabled", getgenv().DeadByteConfig.Combat, "AimbotEnabled")
NewToggle(CombatTab, "Silent Aim", getgenv().DeadByteConfig.Combat, "SilentAim")
NewToggle(CombatTab, "Show FOV", getgenv().DeadByteConfig.Combat, "VisibleFOV")

-- MOVEMENT FEATURES
NewToggle(MovementTab, "Infinite Jump", getgenv().DeadByteConfig.Movement, "InfJump")
NewToggle(MovementTab, "Noclip", getgenv().DeadByteConfig.Movement, "Noclip")

-- // [7] THE ENGINE LOOPS
RunService.RenderStepped:Connect(function()
    -- FOV Update
    FOV.Visible = getgenv().DeadByteConfig.Combat.VisibleFOV
    FOV.Radius = getgenv().DeadByteConfig.Combat.FOV
    FOV.Position = Vector2.new(Mouse.X, Mouse.Y + 36)

    -- Aimbot Engine
    if getgenv().DeadByteConfig.Combat.AimbotEnabled then
        local target = GetTarget()
        if target then
            local pos = Camera:WorldToViewportPoint(target.Character[getgenv().DeadByteConfig.Combat.HitPart].Position + (target.Character.HumanoidRootPart.Velocity * getgenv().DeadByteConfig.Combat.Prediction))
            mousemoverel((pos.X - Mouse.X) / getgenv().DeadByteConfig.Combat.Smoothing, (pos.Y - Mouse.Y) / getgenv().DeadByteConfig.Combat.Smoothing)
        end
    end

    -- ESP Visuals Engine
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local highlight = player.Character:FindFirstChild("DeadByte_High")
            if getgenv().DeadByteConfig.Visuals.Highlights then
                if not highlight then
                    highlight = Instance.new("Highlight", player.Character)
                    highlight.Name = "DeadByte_High"
                end
                highlight.FillColor = getgenv().DeadByteConfig.Customization.Accent
            elseif highlight then
                highlight:Destroy()
            end
        end
    end
end)

-- Noclip engine
RunService.Stepped:Connect(function()
    if getgenv().DeadByteConfig.Movement.Noclip and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)

-- Infinite Jump Hook
UserInputService.JumpRequest:Connect(function()
    if getgenv().DeadByteConfig.Movement.InfJump and LocalPlayer.Character then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

-- UI Toggle
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.RightShift then
        Window.Main.Parent.Enabled = not Window.Main.Parent.Enabled
    end
end)

UI:Notify("DeadByte Sovereign Loaded.", "Success")
print("DEADBYTE // DEOBFUSCATED SUCCESS // RIVALS BYPASS LOADED")
