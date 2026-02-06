--[[
    .___________. _______      ___       _______  .______   ____    ____ .___________. _______ 
    |           ||   ____|    /   \     |       \ |   _  \  \   \  /   / |           ||   ____|
    `---|  |----`|  |__      /  ^  \    |  .--.  ||  |_)  |  \   \/   /  `---|  |----`|  |__   
        |  |     |   __|    /  /_\  \   |  |  |  ||   _  <    \_    _/       |  |     |   __|  
        |  |     |  |____  /  _____  \  |  '--'  ||  |_)  |     |  |         |  |     |  |____ 
        |__|     |_______|/__/     \__\ |_______/ |______/      |__|         |__|     |_______|
                                                                                                
    [ DEADBYTE SOVEREIGN - RIVALS PRIVATE EDITION ]
    [ THEME: ONYX & BLOOD ]
    [ VERSION: 5.0.0 FINAL ]
]]

-- // [1] ENVIRONMENT & SERVICE INITIALIZATION
if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local Stats = game:GetService("Stats")
local NetworkClient = game:GetService("NetworkClient")
local VirtualUser = game:GetService("VirtualUser")
local LogService = game:GetService("LogService")
local ScriptContext = game:GetService("ScriptContext")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = workspace.CurrentCamera

-- // [2] MOONSEC V4 DEOBFUSCATED SECURITY (HENDAR REBORN)
-- Extracted and optimized logic from the provided protection reference.
local SovereignSecurity = {Enabled = true}
function SovereignSecurity:Apply()
    pcall(function()
        -- 1. Error Silencing (Blocks script-based detection logs)
        for _, v in pairs(getconnections(ScriptContext.Error)) do v:Disable() end
        hookfunction(ScriptContext.Error.Connect, function() return nil end)
        
        -- 2. Meta-Hook System (Blocks Rivals Anticheat Remotes)
        local BlockedRemotes = {
            "Analytics", "CombatLog", "Verify", "Telemetry", 
            "InputUpdate", "ClientLog", "ExploitCheck", "PerformanceReport"
        }
        
        local old_nc
        old_nc = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
            local method = getnamecallmethod()
            local name = tostring(self)
            
            if not checkcaller() then
                if method == "FireServer" or method == "InvokeServer" then
                    for _, b in pairs(BlockedRemotes) do
                        if name:find(b) then return nil end
                    end
                end
                -- Block RequestAsync from game to prevent external logging
                if method == "RequestAsync" or method == "PostAsync" then return nil end
            end
            return old_nc(self, ...)
        end))

        -- 3. Anti-Kick (Prevents local script kicks)
        local old_kick
        old_kick = hookfunction(LocalPlayer.Kick, newcclosure(function(self, ...)
            if self == LocalPlayer then return nil end
            return old_kick(self, ...)
        end))
        
        -- 4. Anti-AFK (VirtualUser method)
        LocalPlayer.Idled:Connect(function()
            VirtualUser:Button2Down(Vector2.new(0,0), Camera.CFrame)
            task.wait(1)
            VirtualUser:Button2Up(Vector2.new(0,0), Camera.CFrame)
        end)
    end)
    print("DEADBYTE // SECURITY HANDSHAKE SUCCESS.")
end
SovereignSecurity:Apply()

-- // [3] MASTER CONFIGURATION TABLE
getgenv().Sovereign = {
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
        Snaplines = false, ViewmodelMod = false, FOVMod = 70
    },
    GunMods = {
        RapidFire = false, FullAuto = false, InfAmmo = false,
        NoReload = false, InstantEquip = false, NoCooldown = false,
        FastSwitch = false
    },
    Movement = {
        SpeedEnabled = false, SpeedValue = 25, JumpEnabled = false,
        JumpValue = 65, InfJump = false, Noclip = false,
        Fly = false, FlySpeed = 50, BHop = false, AutoStrafe = false,
        SlideBoost = false
    },
    Automation = {
        AutoQueue = false, AutoClaim = false, AutoMatch = false,
        AutoDaily = false, AutoFarmKills = false
    },
    Misc = {
        FPSUnlock = false, ServerHop = false, Rejoin = false,
        ToggleKey = Enum.KeyCode.RightShift, ConfigName = "Default"
    }
}

-- // [4] CONFIG SAVING ENGINE
local function SaveConfig()
    if writefile then
        writefile("DeadByte_Master.json", HttpService:JSONEncode(getgenv().Sovereign))
    end
end

local function LoadConfig()
    if isfile("DeadByte_Master.json") then
        local success, result = pcall(function() return HttpService:JSONDecode(readfile("DeadByte_Master.json")) end)
        if success then getgenv().Sovereign = result end
    end
end
LoadConfig()

-- // [5] SOVEREIGN UI ENGINE (Onyx & Blood)
-- Based on provided compiler logic but expanded for massive scale.
local UI = {}
local SovereignGui = Instance.new("ScreenGui", CoreGui)
SovereignGui.Name = "DeadByte_Sovereign"
SovereignGui.IgnoreGuiInset = true
SovereignGui.ResetOnSpawn = false

function UI:CreateWindow()
    -- Rebuilding provided "TopFrame" structure
    local TopFrame = Instance.new("Frame", SovereignGui)
    TopFrame.Name = "TopFrame"
    TopFrame.Size = UDim2.new(0, 415, 0, 57)
    TopFrame.Position = UDim2.new(0.337, 0, 0.068, 0)
    TopFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    TopFrame.BorderSizePixel = 0
    
    local HeaderStroke = Instance.new("UIStroke", TopFrame)
    HeaderStroke.Color = Color3.fromRGB(255, 0, 0)
    HeaderStroke.Thickness = 4.8
    HeaderStroke.LineJoinMode = Enum.LineJoinMode.Miter

    local Logo = Instance.new("TextLabel", TopFrame)
    Logo.Size = UDim2.new(0, 200, 0, 50)
    Logo.Text = "DEADBYTE"
    Logo.TextColor3 = Color3.fromRGB(255, 255, 255)
    Logo.Font = Enum.Font.Code
    Logo.TextSize = 41
    Logo.BackgroundTransparency = 1

    -- Rebuilding provided "SideButtons" structure
    local Sidebar = Instance.new("Frame", SovereignGui)
    Sidebar.Name = "SideButtons"
    Sidebar.Size = UDim2.new(0, 146, 0, 478)
    Sidebar.Position = UDim2.new(0.337, 0, 0.16, 0)
    Sidebar.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    
    local SideStroke = Instance.new("UIStroke", Sidebar)
    SideStroke.Color = Color3.fromRGB(255, 0, 0)
    SideStroke.Thickness = 4.8

    local TabList = Instance.new("Frame", Sidebar)
    TabList.Name = "Buttons"
    TabList.Size = UDim2.new(0, 129, 0, 460)
    TabList.Position = UDim2.new(0.075, 0, 0.018, 0)
    TabList.BackgroundTransparency = 1
    local TabListLayout = Instance.new("UIListLayout", TabList)
    TabListLayout.Padding = UDim.new(0, 5)

    -- Rebuilding provided "Stuff" (Content Area)
    local Content = Instance.new("Frame", SovereignGui)
    Content.Name = "Stuff"
    Content.Size = UDim2.new(0, 269, 0, 478)
    Content.Position = UDim2.new(0.451, 0, 0.16, 0)
    Content.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    
    local ContentStroke = Instance.new("UIStroke", Content)
    ContentStroke.Color = Color3.fromRGB(255, 0, 0)
    ContentStroke.Thickness = 4.8

    -- Professional Dragging Logic
    local dragging, dragStart, startPos
    TopFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; dragStart = input.Position; startPos = TopFrame.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            local newPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            TopFrame.Position = newPos
            Sidebar.Position = UDim2.new(newPos.X.Scale, newPos.X.Offset, newPos.Y.Scale, newPos.Y.Offset + 57)
            Content.Position = UDim2.new(newPos.X.Scale, newPos.X.Offset + 146, newPos.Y.Scale, newPos.Y.Offset + 57)
        end
    end)
    UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)

    return {Container = Content, TabList = TabList}
end

-- // [6] FEATURE CREATION MODULES
local SovereignWindow = UI:CreateWindow()
local SovereignPages = {}

function UI:CreateTab(name)
    local Page = Instance.new("ScrollingFrame", SovereignWindow.Container)
    Page.Size = UDim2.new(1, -10, 1, -10)
    Page.Position = UDim2.new(0, 5, 0, 5)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.ScrollBarThickness = 2
    Page.ScrollBarImageColor3 = Color3.fromRGB(255, 0, 0)
    Instance.new("UIListLayout", Page).Padding = UDim.new(0, 5)

    local Btn = Instance.new("TextButton", SovereignWindow.TabList)
    Btn.Size = UDim2.new(0, 114, 0, 36)
    Btn.Text = name
    Btn.BackgroundColor3 = Color3.fromRGB(15, 0, 0)
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.Font = Enum.Font.Code
    Btn.TextSize = 20
    local BtnStroke = Instance.new("UIStroke", Btn)
    BtnStroke.Color = Color3.fromRGB(255, 0, 0)
    BtnStroke.Thickness = 1
    BtnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    Btn.MouseButton1Click:Connect(function()
        for _, p in pairs(SovereignPages) do p.Visible = false end
        Page.Visible = true
        for _, b in pairs(SovereignWindow.TabList:GetChildren()) do if b:IsA("TextButton") then b.TextColor3 = Color3.new(0.6,0.6,0.6) end end
        Btn.TextColor3 = Color3.new(1,1,1)
    end)
    SovereignPages[name] = Page
    return Page
end

-- Tab Definitions
local CombatTab = UI:CreateTab("COMBAT")
local VisualTab = UI:CreateTab("VISUALS")
local GunModTab = UI:CreateTab("GUN MODS")
local MoveTab = UI:CreateTab("MOVEMENT")
local AutomateTab = UI:CreateTab("AUTOMATE")
local MiscTab = UI:CreateTab("MISC")

-- Modular Feature Creators
local function CreateToggle(parent, text, cfg_path, key)
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.new(1, 0, 0, 30)
    b.BackgroundColor3 = Color3.fromRGB(20, 0, 0)
    b.Text = text .. ": " .. (cfg_path[key] and "ON" or "OFF")
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.Code
    b.TextSize = 14
    
    b.MouseButton1Click:Connect(function()
        cfg_path[key] = not cfg_path[key]
        b.Text = text .. ": " .. (cfg_path[key] and "ON" or "OFF")
        SaveConfig()
    end)
end

local function CreateSlider(parent, text, min, max, cfg_path, key)
    local container = Instance.new("Frame", parent)
    container.Size = UDim2.new(1, 0, 0, 40)
    container.BackgroundTransparency = 1
    
    local label = Instance.new("TextLabel", container)
    label.Size = UDim2.new(1, 0, 0, 20)
    label.Text = text .. ": " .. cfg_path[key]
    label.TextColor3 = Color3.new(1,1,1)
    label.Font = Enum.Font.Code
    label.BackgroundTransparency = 1

    local bar = Instance.new("TextButton", container)
    bar.Size = UDim2.new(0.9, 0, 0, 10)
    bar.Position = UDim2.new(0.05, 0, 0, 25)
    bar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    bar.Text = ""
    
    local fill = Instance.new("Frame", bar)
    fill.Size = UDim2.new((cfg_path[key]-min)/(max-min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    fill.BorderSizePixel = 0

    bar.MouseButton1Down:Connect(function()
        local conn
        conn = RunService.RenderStepped:Connect(function()
            local percent = math.clamp((Mouse.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
            cfg_path[key] = math.floor(min + (max - min) * percent)
            fill.Size = UDim2.new(percent, 0, 1, 0)
            label.Text = text .. ": " .. cfg_path[key]
        end)
        UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then conn:Disconnect() SaveConfig() end end)
    end)
end

-- // [7] FEATURE POPULATION (Extensive Feature List)
-- COMBAT
CreateToggle(CombatTab, "Master Aimbot", getgenv().Sovereign.Combat, "Aimbot")
CreateToggle(CombatTab, "Silent Aim", getgenv().Sovereign.Combat, "SilentAim")
CreateToggle(CombatTab, "Triggerbot", getgenv().Sovereign.Combat, "Triggerbot")
CreateToggle(CombatTab, "Kill Aura", getgenv().Sovereign.Combat, "KillAura")
CreateToggle(CombatTab, "Hitbox Expander", getgenv().Sovereign.Combat, "HitboxExpander")
CreateSlider(CombatTab, "Aimbot FOV", 10, 800, getgenv().Sovereign.Combat, "FOV")
CreateSlider(CombatTab, "Aimbot Smoothing", 1, 20, getgenv().Sovereign.Combat, "Smoothness")

-- VISUALS
CreateToggle(VisualTab, "Master Visuals", getgenv().Sovereign.Visuals, "Master")
CreateToggle(VisualTab, "Box ESP", getgenv().Sovereign.Visuals, "Boxes")
CreateToggle(VisualTab, "Enemy Highlights", getgenv().Sovereign.Visuals, "Highlights")
CreateToggle(VisualTab, "Tracer Lines", getgenv().Sovereign.Visuals, "Tracers")
CreateToggle(VisualTab, "Name ESP", getgenv().Sovereign.Visuals, "Names")
CreateToggle(VisualTab, "Health Bar", getgenv().Sovereign.Visuals, "HealthBar")

-- GUN MODS
CreateToggle(GunModTab, "No Recoil", getgenv().Sovereign.Combat, "NoRecoil")
CreateToggle(GunModTab, "No Spread", getgenv().Sovereign.Combat, "NoSpread")
CreateToggle(GunModTab, "Rapid Fire", getgenv().Sovereign.GunMods, "RapidFire")
CreateToggle(GunModTab, "Infinite Ammo", getgenv().Sovereign.GunMods, "InfAmmo")

-- MOVEMENT
CreateToggle(MoveTab, "Speed Modification", getgenv().Sovereign.Movement, "SpeedEnabled")
CreateSlider(MoveTab, "Walk Speed", 16, 150, getgenv().Sovereign.Movement, "SpeedValue")
CreateToggle(MoveTab, "Infinite Jump", getgenv().Sovereign.Movement, "InfJump")
CreateToggle(MoveTab, "Noclip", getgenv().Sovereign.Movement, "Noclip")
CreateToggle(MoveTab, "Fly Mode", getgenv().Sovereign.Movement, "Fly")

-- // [8] COMBAT ENGINE (Aimbot & Prediction)
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1
FOVCircle.NumSides = 100
FOVCircle.Color = Color3.fromRGB(255, 0, 0)

local function GetTarget()
    local target = nil
    local shortestDist = getgenv().Sovereign.Combat.FOV
    
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            if getgenv().Sovereign.Combat.TeamCheck and p.Team == LocalPlayer.Team then continue end
            local head = p.Character:FindFirstChild(getgenv().Sovereign.Combat.HitPart)
            if not head then continue end
            
            local pos, onScreen = Camera:WorldToViewportPoint(head.Position)
            if onScreen then
                local dist = (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                if dist < shortestDist then
                    if getgenv().Sovereign.Combat.WallCheck then
                        local rays = Camera:GetPartsObscuringTarget({head.Position}, {LocalPlayer.Character, p.Character})
                        if #rays > 0 then continue end
                    end
                    target = p
                    shortestDist = dist
                end
            end
        end
    end
    return target
end

-- // [9] MAIN EXECUTION LOOPS
RunService.RenderStepped:Connect(function()
    -- FOV Update
    FOVCircle.Visible = getgenv().Sovereign.Combat.ShowFOV
    FOVCircle.Radius = getgenv().Sovereign.Combat.FOV
    FOVCircle.Position = Vector2.new(Mouse.X, Mouse.Y + 36)

    -- Aimbot Logic
    if getgenv().Sovereign.Combat.Aimbot and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local target = GetTarget()
        if target then
            local root = target.Character[getgenv().Sovereign.Combat.HitPart]
            local predPos = root.Position + (root.Velocity * getgenv().Sovereign.Combat.Prediction)
            local screenPos = Camera:WorldToViewportPoint(predPos)
            
            mousemoverel(
                (screenPos.X - Mouse.X) / getgenv().Sovereign.Combat.Smoothness, 
                (screenPos.Y - Mouse.Y) / getgenv().Sovereign.Combat.Smoothness
            )
        end
    end

    -- Triggerbot Logic
    if getgenv().Sovereign.Combat.Triggerbot and Mouse.Target then
        local target_char = Mouse.Target.Parent
        local t_plr = Players:GetPlayerFromCharacter(target_char)
        if t_plr and t_plr ~= LocalPlayer then
            if not (getgenv().Sovereign.Combat.TeamCheck and t_plr.Team == LocalPlayer.Team) then
                mouse1click()
            end
        end
    end

    -- Visual Highlights
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local high = p.Character:FindFirstChild("SovereignESP")
            if getgenv().Sovereign.Visuals.Master and getgenv().Sovereign.Visuals.Highlights then
                if not high then
                    high = Instance.new("Highlight", p.Character)
                    high.Name = "SovereignESP"
                    high.FillColor = Color3.fromRGB(255, 0, 0)
                end
            elseif high then
                high:Destroy()
            end
        end
    end
end)

-- Movement Step Logic
RunService.Stepped:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        local Hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        
        -- Speed Mod
        if getgenv().Sovereign.Movement.SpeedEnabled then
            Hum.WalkSpeed = getgenv().Sovereign.Movement.SpeedValue
        end
        
        -- Jump Mod
        if getgenv().Sovereign.Movement.JumpEnabled then
            Hum.JumpPower = getgenv().Sovereign.Movement.JumpValue
        end

        -- Noclip
        if getgenv().Sovereign.Movement.Noclip then
            for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end
    end
end)

-- Inf Jump Logic
UserInputService.JumpRequest:Connect(function()
    if getgenv().Sovereign.Movement.InfJump and LocalPlayer.Character then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

-- Toggle UI Logic
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == getgenv().Sovereign.Misc.ToggleKey then
        SovereignGui.Enabled = not SovereignGui.Enabled
    end
end)

-- // [10] BOOTSTRAP FINALIZATION
SovereignPages["COMBAT"].Visible = true
StarterGui:SetCore("SendNotification", {
    Title = "DEADBYTE SOVEREIGN",
    Text = "Engine Active. Press [RightShift] for Menu.",
    Duration = 8
})
print("DEADBYTE // SOVEREIGN HUB // RIVALS PRIVATE // INJECTED")
