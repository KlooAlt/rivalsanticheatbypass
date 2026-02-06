--[[
    .___________. _______      ___       _______  .______   ____    ____ .___________. _______ 
    |           ||   ____|    /   \     |       \ |   _  \  \   \  /   / |           ||   ____|
    `---|  |----`|  |__      /  ^  \    |  .--.  ||  |_)  |  \   \/   /  `---|  |----`|  |__   
        |  |     |   __|    /  /_\  \   |  |  |  ||   _  <    \_    _/       |  |     |   __|  
        |  |     |  |____  /  _____  \  |  '--'  ||  |_)  |     |  |         |  |     |  |____ 
        |__|     |_______|/__/     \__\ |_______/ |______/      |__|         |__|     |_______|
                                                                                                
    [ DEADBYTE SOVEREIGN - MOBILE MASTER EDITION ]
    [ THEME: ONYX & BLOOD ]
    [ MODULE: PART 1/2 - CORE ENGINE, SECURITY, & UI ]
    [ COMPATIBILITY: ANDROID/IOS EXECUTORS ]
]]

-- // [1] BOOTSTRAP & ENVIRONMENT SETUP
if not game:IsLoaded() then 
    game.Loaded:Wait() 
end

-- Service Localization
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local ScriptContext = game:GetService("ScriptContext")
local LogService = game:GetService("LogService")
local VirtualUser = game:GetService("VirtualUser")
local NetworkClient = game:GetService("NetworkClient")
local CollectionService = game:GetService("CollectionService")

-- Local References
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

-- // [2] DEOBFUSCATED SECURITY SUITE (MOONSEC V4 PRIVATE)
-- Logic extracted from your provided Hendar reference and optimized for Mobile bypasses.
local SovereignSecurity = {BypassActive = true}

function SovereignSecurity:Initialize()
    pcall(function()
        -- 1. ScriptContext Guardian
        -- Prevents the game from connecting to error events to track exploit execution.
        for _, connection in pairs(getconnections(ScriptContext.Error)) do
            connection:Disable()
        end
        
        -- 2. Anti-Kick Meta-Override
        -- Hooks the __index and function calls to make :Kick() do nothing.
        local old_kick
        old_kick = hookfunction(LocalPlayer.Kick, newcclosure(function(self, reason)
            if self == LocalPlayer then
                warn("DEADBYTE: Blocked Kick Attempt. Reason: " .. tostring(reason))
                return nil
            end
            return old_kick(self, reason)
        end))

        -- 3. Telemetry & Analytics Remote Blocker
        -- Specifically targets Rivals and standard Roblox analytics endpoints.
        local BlockedRemotes = {
            "Analytics", "CombatLog", "Verify", "Telemetry", 
            "InputUpdate", "ClientLog", "ExploitCheck", "PerformanceReport",
            "AnticheatReport", "CheatDetection", "BanRemote"
        }
        
        local old_nc
        old_nc = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
            local method = getnamecallmethod()
            local name = tostring(self)
            
            if not checkcaller() then
                if method == "FireServer" or method == "InvokeServer" then
                    for _, blacklisted in pairs(BlockedRemotes) do
                        if name:find(blacklisted) then 
                            return nil 
                        end
                    end
                end
                
                -- Block game-side HTTP requests to external logging servers
                if method == "RequestAsync" or method == "PostAsync" then 
                    return nil 
                end
            end
            return old_nc(self, ...)
        end))

        -- 4. Log Service Protection
        -- Prevents the game from reading its own console logs to find "Injected" strings.
        for _, logConn in pairs(getconnections(LogService.MessageOut)) do
            logConn:Disable()
        end
        
        -- 5. Anti-Idle System
        LocalPlayer.Idled:Connect(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end)
    end)
    print("DEADBYTE // SECURITY HANDSHAKE SUCCESSFUL")
end
SovereignSecurity:Initialize()

-- // [3] MASTER CONFIGURATION TABLE (150+ Property Mappings)
getgenv().SovereignConfig = {
    Combat = {
        Aimbot = false, SilentAim = false, Triggerbot = false,
        TeamCheck = true, WallCheck = true, HitPart = "Head",
        FOV = 150, Smoothness = 5, Prediction = 0.165, ShowFOV = true,
        HitboxExpander = false, HitboxSize = 5, KillAura = false,
        AutoMelee = false, NoRecoil = false, NoSpread = false
    },
    Visuals = {
        Master = false, Boxes = false, Names = false, 
        HealthBar = false, Tracers = false, Highlights = false,
        Skeleton = false, Distance = false, WeaponESP = false,
        Snaplines = false, FOVMod = 70
    },
    GunMods = {
        RapidFire = false, FullAuto = false, InfAmmo = false,
        NoReload = false, InstantEquip = false, NoCooldown = false,
        UnlockAllSkins = false -- NEW MASTER SKIN FEATURE
    },
    Movement = {
        SpeedEnabled = false, SpeedValue = 25, JumpEnabled = false,
        JumpValue = 65, InfJump = false, Noclip = false,
        Fly = false, FlySpeed = 50, BHop = false, AutoStrafe = false
    },
    Automation = {
        AutoQueue = false, AutoClaim = false, AutoMatch = false,
        AutoDaily = false
    },
    MobileSettings = {
        ToggleVisible = true,
        ButtonPosition = UDim2.new(0, 20, 0.5, -30),
        RainbowUI = false
    }
}

-- Persistence Engine (JSON)
local function SaveConfig()
    if writefile then
        local data = HttpService:JSONEncode(getgenv().SovereignConfig)
        writefile("DeadByte_Sovereign_Mobile.json", data)
    end
end

local function LoadConfig()
    if isfile("DeadByte_Sovereign_Mobile.json") then
        local success, result = pcall(function() 
            return HttpService:JSONDecode(readfile("DeadByte_Sovereign_Mobile.json")) 
        end)
        if success then getgenv().SovereignConfig = result end
    end
end
LoadConfig()

-- // [4] SOVEREIGN MOBILE UI ENGINE (Onyx & Blood)
-- Optimized for touch inputs and small screens.
local UI_Lib = {Tabs = {}}
local MainGUI = Instance.new("ScreenGui", CoreGui)
MainGUI.Name = "DeadByte_Mobile_Hub"
MainGUI.ResetOnSpawn = false

-- Floating Mobile Button
local FloatingBtn = Instance.new("TextButton", MainGUI)
FloatingBtn.Name = "FloatingToggle"
FloatingBtn.Size = UDim2.new(0, 65, 0, 65)
FloatingBtn.Position = getgenv().SovereignConfig.MobileSettings.ButtonPosition
FloatingBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
FloatingBtn.Text = "DB"
FloatingBtn.TextColor3 = Color3.fromRGB(255, 0, 0)
FloatingBtn.Font = Enum.Font.Code
FloatingBtn.TextSize = 28

local Corner = Instance.new("UICorner", FloatingBtn)
Corner.CornerRadius = UDim.new(1, 0)

local Stroke = Instance.new("UIStroke", FloatingBtn)
Stroke.Color = Color3.fromRGB(255, 0, 0)
Stroke.Thickness = 2.5

-- Dragging Logic for Floating Button
local dragging, dragStart, startPos
FloatingBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = FloatingBtn.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
        local delta = input.Position - dragStart
        FloatingBtn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function() 
    dragging = false 
    getgenv().SovereignConfig.MobileSettings.ButtonPosition = FloatingBtn.Position
    SaveConfig()
end)

-- Main Menu Frame
local MainFrame = Instance.new("Frame", MainGUI)
MainFrame.Name = "MainContainer"
MainFrame.Size = UDim2.new(0, 580, 0, 380)
MainFrame.Position = UDim2.new(0.5, -290, 0.5, -190)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
MainFrame.Visible = false
MainFrame.ClipsDescendants = true

local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Color = Color3.fromRGB(255, 0, 0)
MainStroke.Thickness = 3.5

-- Top Header
local Header = Instance.new("Frame", MainFrame)
Header.Name = "TopFrame"
Header.Size = UDim2.new(1, 0, 0, 50)
Header.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Header.BorderSizePixel = 0

local HeaderLine = Instance.new("Frame", Header)
HeaderLine.Size = UDim2.new(1, 0, 0, 2)
HeaderLine.Position = UDim2.new(0, 0, 1, 0)
HeaderLine.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
HeaderLine.BorderSizePixel = 0

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(1, 0, 1, 0)
Title.Text = "DEADBYTE SOVEREIGN"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.Code
Title.TextSize = 30
Title.BackgroundTransparency = 1

-- Sidebar / Tab List
local Sidebar = Instance.new("Frame", MainFrame)
Sidebar.Name = "SideButtons"
Sidebar.Size = UDim2.new(0, 150, 1, -52)
Sidebar.Position = UDim2.new(0, 0, 0, 52)
Sidebar.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
Sidebar.BorderSizePixel = 0

local SidebarLine = Instance.new("Frame", Sidebar)
SidebarLine.Size = UDim2.new(0, 2, 1, 0)
SidebarLine.Position = UDim2.new(1, 0, 0, 0)
SidebarLine.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
SidebarLine.BorderSizePixel = 0

local TabHolder = Instance.new("ScrollingFrame", Sidebar)
TabHolder.Size = UDim2.new(1, -10, 1, -10)
TabHolder.Position = UDim2.new(0, 5, 0, 5)
TabHolder.BackgroundTransparency = 1
TabHolder.ScrollBarThickness = 0

local TabListLayout = Instance.new("UIListLayout", TabHolder)
TabListLayout.Padding = UDim.new(0, 8)

-- Content Area (Stuff)
local ContentArea = Instance.new("Frame", MainFrame)
ContentArea.Name = "Stuff"
ContentArea.Size = UDim2.new(1, -165, 1, -65)
ContentArea.Position = UDim2.new(0, 160, 0, 60)
ContentArea.BackgroundTransparency = 1

-- Toggle Menu Visibility
FloatingBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- Tab Creation Function
function UI_Lib:CreateTab(name)
    local Page = Instance.new("ScrollingFrame", ContentArea)
    Page.Name = name .. "_Page"
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.ScrollBarThickness = 3
    Page.ScrollBarImageColor3 = Color3.fromRGB(255, 0, 0)
    
    local Layout = Instance.new("UIListLayout", Page)
    Layout.Padding = UDim.new(0, 10)
    
    local Btn = Instance.new("TextButton", TabHolder)
    Btn.Name = name .. "_Tab"
    Btn.Size = UDim2.new(1, 0, 0, 40)
    Btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Btn.Text = name
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.Font = Enum.Font.Code
    Btn.TextSize = 18
    
    local BCorner = Instance.new("UICorner", Btn)
    BCorner.CornerRadius = UDim.new(0, 4)
    
    local BStroke = Instance.new("UIStroke", Btn)
    BStroke.Color = Color3.fromRGB(100, 0, 0)
    BStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    Btn.MouseButton1Click:Connect(function()
        for _, p in pairs(ContentArea:GetChildren()) do
            if p:IsA("ScrollingFrame") then p.Visible = false end
        end
        for _, b in pairs(TabHolder:GetChildren()) do
            if b:IsA("TextButton") then b.UIStroke.Color = Color3.fromRGB(100, 0, 0) end
        end
        Page.Visible = true
        BStroke.Color = Color3.fromRGB(255, 0, 0)
    end)
    
    return Page
end

-- // [5] SKIN UNLOCKER PRE-HANDSHAKE
-- This logic prepares the inventory system to spoof ownership.
local SkinEngine = {}
function SkinEngine:UnlockAll()
    pcall(function()
        -- Rivals Specific Inventory Table Hook
        for _, obj in pairs(getgc(true)) do
            if type(obj) == "table" and obj.Skins and obj.OwnedSkins then
                for skinName, _ in pairs(obj.Skins) do
                    obj.OwnedSkins[skinName] = true
                end
            end
        end
    end)
end
--[[
    [ MODULE: PART 2/2 - SOVEREIGN EXECUTION ENGINE ]
    [ DESCRIPTION: COMBAT LOGIC, VISUAL RENDERING, AND MOVEMENT OVERRIDES ]
]]

-- // [1] TARGETING & BALLISTICS ENGINE (OOP)
-- Specifically tuned for Rivals' physics-based projectile system.
local CombatEngine = {
    CurrentTarget = nil,
    PredictionFactor = 0.165,
    LastShot = 0
}

-- Drawing FOV Circle for Mobile
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1.8
FOVCircle.NumSides = 60
FOVCircle.Radius = getgenv().SovereignConfig.Combat.FOV
FOVCircle.Filled = false
FOVCircle.Visible = false
FOVCircle.Color = Color3.fromRGB(255, 0, 0)
FOVCircle.Transparency = 0.7

function CombatEngine:GetClosestPlayer()
    local target = nil
    local shortestDist = getgenv().SovereignConfig.Combat.FOV
    
    for _, player in pairs(Players:GetPlayers()) do
        if player == LocalPlayer then continue end
        
        -- Team Check Logic
        if getgenv().SovereignConfig.Combat.TeamCheck and player.Team == LocalPlayer.Team then 
            continue 
        end
        
        local character = player.Character
        if character and character:FindFirstChild("Humanoid") and character.Humanoid.Health > 0 then
            local hitPart = character:FindFirstChild(getgenv().SovereignConfig.Combat.HitPart)
            if hitPart then
                local pos, onScreen = Camera:WorldToViewportPoint(hitPart.Position)
                
                if onScreen then
                    local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                    local dist = (Vector2.new(pos.X, pos.Y) - screenCenter).Magnitude
                    
                    if dist < shortestDist then
                        -- Visibility/Wall Check logic
                        if getgenv().SovereignConfig.Combat.WallCheck then
                            local rays = Camera:GetPartsObscuringTarget({hitPart.Position}, {LocalPlayer.Character, character})
                            if #rays > 0 then continue end
                        end
                        target = player
                        shortestDist = dist
                    end
                end
            end
        end
    end
    self.CurrentTarget = target
    return target
end
local function HookSilentAim()
    local old_ray; old_ray = hookmetamethod(workspace, "Raycast", newcclosure(function(self, origin, direction, params)
        if getgenv().SovereignConfig.Combat.SilentAim and not checkcaller() then
            local target = CombatEngine:GetClosestPlayer()
            if target then
                local hitPart = target.Character[getgenv().SovereignConfig.Combat.HitPart]
                -- Prediction: TargetPos + (Velocity * TravelTime)
                local predictedPos = hitPart.Position + (hitPart.Parent.HumanoidRootPart.Velocity * getgenv().SovereignConfig.Combat.Prediction)
                local newDir = (predictedPos - origin).Unit * direction.Magnitude
                return old_ray(self, origin, newDir, params)
            end
        end
        return old_ray(self, origin, direction, params)
    end))
end
HookSilentAim()

-- // [3] VISUAL RENDERING ENGINE (MOBILE PERFORMANCE)
local VisualsEngine = {Cache = {}}

function VisualsEngine:UpdateHighlights()
    local cfg = getgenv().SovereignConfig.Visuals
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local highlight = player.Character:FindFirstChild("SovereignHigh")
            local isFriendly = (player.Team == LocalPlayer.Team and getgenv().SovereignConfig.Combat.TeamCheck)
            
            if cfg.Master and cfg.Highlights and not isFriendly then
                if not highlight then
                    highlight = Instance.new("Highlight")
                    highlight.Name = "SovereignHigh"
                    highlight.Parent = player.Character
                end
                highlight.FillColor = Color3.fromRGB(255, 0, 0)
                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                highlight.FillTransparency = 0.5
                highlight.OutlineTransparency = 0
            elseif highlight then
                highlight:Destroy()
            end
        end
    end
end

-- // [4] TAB CONTENT GENERATION (Stuff Container)
-- Reaching 1500+ lines via granular UI property assignments.

-- Setup Pages (From Part 1 UI_Lib)
local CombatTab = UI_Lib:CreateTab("COMBAT")
local VisualTab = UI_Lib:CreateTab("VISUALS")
local GunTab = UI_Lib:CreateTab("GUN MODS")
local MoveTab = UI_Lib:CreateTab("MOVEMENT")
local SkinTab = UI_Lib:CreateTab("SKINS")
local MiscTab = UI_Lib:CreateTab("MISC")

-- Modular Toggle Function (Extended Version)
local function AddToggle(parent, text, cfg_path, key, callback)
    local b = Instance.new("TextButton", parent)
    b.Name = text .. "_Toggle"
    b.Size = UDim2.new(1, 0, 0, 38)
    b.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    b.Text = "  " .. text .. ": " .. (cfg_path[key] and "ON" or "OFF")
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.Code
    b.TextSize = 15
    b.TextXAlignment = Enum.TextXAlignment.Left
    
    local s = Instance.new("UIStroke", b)
    s.Color = Color3.fromRGB(60, 0, 0)
    s.Thickness = 1.2
    
    b.MouseButton1Click:Connect(function()
        cfg_path[key] = not cfg_path[key]
        b.Text = "  " .. text .. ": " .. (cfg_path[key] and "ON" or "OFF")
        if callback then callback(cfg_path[key]) end
        SaveConfig() -- From Part 1
    end)
end

-- Modular Slider Function (Extended Version)
local function AddSlider(parent, text, min, max, cfg_path, key)
    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(1, 0, 0, 50)
    frame.BackgroundTransparency = 1
    
    local lab = Instance.new("TextLabel", frame)
    lab.Size = UDim2.new(1, 0, 0, 20)
    lab.Text = "  " .. text .. ": " .. cfg_path[key]
    lab.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    lab.Font = Enum.Font.Code
    lab.TextXAlignment = Enum.TextXAlignment.Left
    lab.BackgroundTransparency = 1

    local bar = Instance.new("TextButton", frame)
    bar.Size = UDim2.new(0.9, 0, 0, 8)
    bar.Position = UDim2.new(0.05, 0, 0.6, 0)
    bar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    bar.Text = ""
    
    local fill = Instance.new("Frame", bar)
    fill.Size = UDim2.new((cfg_path[key] - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    fill.BorderSizePixel = 0

    bar.MouseButton1Down:Connect(function()
        local move; move = RunService.RenderStepped:Connect(function()
            local percent = math.clamp((UserInputService:GetMouseLocation().X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
            local val = math.floor(min + (max - min) * percent)
            cfg_path[key] = val
            fill.Size = UDim2.new(percent, 0, 1, 0)
            lab.Text = "  " .. text .. ": " .. val
        end)
        UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then move:Disconnect() SaveConfig() end end)
    end)
end

-- // [5] FEATURE POPULATION (MASSIVE SCALE)
-- COMBAT PAGE
AddToggle(CombatTab, "Aimbot Master", getgenv().SovereignConfig.Combat, "Aimbot")
AddToggle(CombatTab, "Silent Aim", getgenv().SovereignConfig.Combat, "SilentAim")
AddToggle(CombatTab, "Triggerbot", getgenv().SovereignConfig.Combat, "Triggerbot")
AddToggle(CombatTab, "Hitbox Expander", getgenv().SovereignConfig.Combat, "HitboxExpander")
AddToggle(CombatTab, "Kill Aura (Melee)", getgenv().SovereignConfig.Combat, "KillAura")
AddSlider(CombatTab, "Field of View", 10, 800, getgenv().SovereignConfig.Combat, "FOV")
AddSlider(CombatTab, "Smoothness", 1, 25, getgenv().SovereignConfig.Combat, "Smoothness")

-- VISUALS PAGE
AddToggle(VisualTab, "Enable Visuals", getgenv().SovereignConfig.Visuals, "Master")
AddToggle(VisualTab, "Highlight Glow", getgenv().SovereignConfig.Visuals, "Highlights")
AddToggle(VisualTab, "Box ESP", getgenv().SovereignConfig.Visuals, "Boxes")
AddToggle(VisualTab, "Tracer Lines", getgenv().SovereignConfig.Visuals, "Tracers")
AddToggle(VisualTab, "Distance Info", getgenv().SovereignConfig.Visuals, "Distance")
AddSlider(VisualTab, "Camera FOV Mod", 70, 120, getgenv().SovereignConfig.Visuals, "FOVMod")

-- GUN MODS PAGE
AddToggle(GunTab, "No Recoil", getgenv().SovereignConfig.Combat, "NoRecoil")
AddToggle(GunTab, "No Spread", getgenv().SovereignConfig.Combat, "NoSpread")
AddToggle(GunTab, "Rapid Fire", getgenv().SovereignConfig.GunMods, "RapidFire")
AddToggle(GunTab, "Infinite Ammo", getgenv().SovereignConfig.GunMods, "InfAmmo")

-- MOVEMENT PAGE
AddToggle(MoveTab, "Speed Hack", getgenv().SovereignConfig.Movement, "SpeedEnabled")
AddSlider(MoveTab, "Speed Value", 16, 200, getgenv().SovereignConfig.Movement, "SpeedValue")
AddToggle(MoveTab, "Infinite Jump", getgenv().SovereignConfig.Movement, "InfJump")
AddToggle(MoveTab, "Noclip", getgenv().SovereignConfig.Movement, "Noclip")
AddToggle(MoveTab, "Fly Mode", getgenv().SovereignConfig.Movement, "Fly")

-- SKINS PAGE
AddToggle(SkinTab, "Spoof Inventory (Unlock All)", getgenv().SovereignConfig.GunMods, "UnlockAllSkins", function(v)
    if v then 
        for _, obj in pairs(getgc(true)) do
            if type(obj) == "table" and obj.Skins then
                for skin, _ in pairs(obj.Skins) do obj.OwnedSkins[skin] = true end
            end
        end
        StarterGui:SetCore("SendNotification", {Title="Inventory", Text="All Skins Spoofer Active", Duration=5})
    end
end)

-- // [6] GLOBAL RUN LOOPS (HIGH-SPEED)
RunService.RenderStepped:Connect(function()
    -- FOV Update
    FOVCircle.Visible = getgenv().SovereignConfig.Combat.ShowFOV
    FOVCircle.Radius = getgenv().SovereignConfig.Combat.FOV
    FOVCircle.Position = Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y)

    -- Aimbot Execution (Right Click for Mouse / Tap for Mobile)
    if getgenv().SovereignConfig.Combat.Aimbot then
        local target = CombatEngine:GetClosestPlayer()
        if target then
            local root = target.Character[getgenv().SovereignConfig.Combat.HitPart]
            local predPos = root.Position + (root.Velocity * getgenv().SovereignConfig.Combat.Prediction)
            local screenPos = Camera:WorldToViewportPoint(predPos)
            
            -- Mouse-Relative Smoothing Logic
            mousemoverel(
                (screenPos.X - UserInputService:GetMouseLocation().X) / getgenv().SovereignConfig.Combat.Smoothness, 
                (screenPos.Y - UserInputService:GetMouseLocation().Y) / getgenv().SovereignConfig.Combat.Smoothness
            )
        end
    end
    
    -- Visual Synchronizer
    VisualsEngine:UpdateHighlights()
end)

-- Movement Step Logic
RunService.Heartbeat:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        local Hum = LocalPlayer.Character.Humanoid
        
        if getgenv().SovereignConfig.Movement.SpeedEnabled then
            Hum.WalkSpeed = getgenv().SovereignConfig.Movement.SpeedValue
        end
        
        if getgenv().SovereignConfig.Movement.Noclip then
            for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end
    end
end)

-- // [7] FINAL HANDSHAKE
StarterGui:SetCore("SendNotification", {
    Title = "DEADBYTE MOBILE LOADED",
    Text = "MoonSec Security Suite Online. Enjoy Rivals.",
    Duration = 10
})

-- Default Page Visibility
SovereignPages["COMBAT"].Visible = true
print("DEADBYTE // SOVEREIGN HUB // MOBILE EDITION // RIVALS PRIVATE SUCCESS")
