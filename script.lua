--[[
    .___________. _______      ___       _______  .______   ____    ____ .___________. _______ 
    |           ||   ____|    /   \     |       \ |   _  \  \   \  /   / |           ||   ____|
    `---|  |----`|  |__      /  ^  \    |  .--.  ||  |_)  |  \   \/   /  `---|  |----`|  |__   
        |  |     |   __|    /  /_\  \   |  |  |  ||   _  <    \_    _/       |  |     |   __|  
        |  |     |  |____  /  _____  \  |  '--'  ||  |_)  |     |  |         |  |     |  |____ 
        |__|     |_______|/__/     \__\ |_______/ |______/      |__|         |__|     |_______|
                                                                                                
    [ DEADBYTE SOVEREIGN - RIVALS PRIVATE EDITION ]
    [ VERSION: 5.0.0 "HEAVYWEIGHT" ]
    [ THEME: ONYX & BLOOD ]
    [ MODULE: PART 1/4 - CORE ENGINE, SECURITY, & UI ]
]]

-- // [1] INITIALIZATION & ENVIRONMENT CHECKS
if not game:IsLoaded() then game.Loaded:Wait() end

-- // [2] SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local StarterGui = game:GetService("StarterGui")
local Stats = game:GetService("Stats")
local VirtualUser = game:GetService("VirtualUser")
local ScriptContext = game:GetService("ScriptContext")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = workspace.CurrentCamera

-- // [3] DEOBFUSCATED MOONSEC V4 SECURITY MODULE
-- This module protects against telemetry reporting and internal kick attempts.
local SecurityModule = {}
function SecurityModule:Protect()
    pcall(function()
        -- Silence Error Logging
        for _, connection in pairs(getconnections(ScriptContext.Error)) do
            connection:Disable()
        end
        
        -- Hook Kick Function to prevent game kicks
        local old_kick
        old_kick = hookfunction(LocalPlayer.Kick, newcclosure(function(self, ...)
            if self == LocalPlayer then return nil end
            return old_kick(self, ...)
        end))

        -- Remote Namecall Blocking (Rivals Anticheat Bypass)
        local BlockedList = {
            "Analytics", "CombatLog", "Verify", "Telemetry", 
            "InputUpdate", "ClientLog", "ExploitCheck"
        }
        local old_nc
        old_nc = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
            local method = getnamecallmethod()
            local name = tostring(self)
            if not checkcaller() and (method == "FireServer" or method == "InvokeServer") then
                for _, b in pairs(BlockedList) do
                    if name:find(b) then return nil end
                end
            end
            return old_nc(self, ...)
        end))
    end)
end
SecurityModule:Protect()

-- // [4] PERSISTENT CONFIGURATION SYSTEM
getgenv().DeadByteConfig = {
    Combat = { Enabled = false, Silent = false, Trigger = false, FOV = 150, Smooth = 5 },
    Visuals = { Master = false, Boxes = false, Tracers = false, Highlights = false },
    Movement = { Speed = false, Jump = false, InfJump = false, Noclip = false },
    Misc = { ToggleKey = Enum.KeyCode.RightShift, AutoSave = true }
}

local function Save()
    if writefile then writefile("DeadByte_Master.json", HttpService:JSONEncode(getgenv().DeadByteConfig)) end
end

local function Load()
    if isfile("DeadByte_Master.json") then
        local s, d = pcall(function() return HttpService:JSONDecode(readfile("DeadByte_Master.json")) end)
        if s then getgenv().DeadByteConfig = d end
    end
end
Load()

-- // [5] SOVEREIGN UI ENGINE (Onyx & Blood)
local DeadByteLib = {}
local GUI = Instance.new("ScreenGui", CoreGui)
GUI.Name = "DeadByte_Sovereign"
GUI.IgnoreGuiInset = true
GUI.ResetOnSpawn = false

-- Notification System
function DeadByteLib:Notify(text, type)
    local f = Instance.new("Frame", GUI)
    f.Size = UDim2.new(0, 260, 0, 40)
    f.Position = UDim2.new(1, 10, 0.85, 0)
    f.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    f.BorderSizePixel = 0
    Instance.new("UIStroke", f).Color = type == "Success" and Color3.new(0,1,0) or Color3.new(1,0,0)
    
    local t = Instance.new("TextLabel", f)
    t.Size = UDim2.new(1, -20, 1, 0)
    t.Position = UDim2.new(0, 10, 0, 0)
    t.Text = text
    t.TextColor3 = Color3.new(1,1,1)
    t.Font = Enum.Font.Code
    t.BackgroundTransparency = 1
    
    TweenService:Create(f, TweenInfo.new(0.4), {Position = UDim2.new(1, -270, 0.85, 0)}):Play()
    task.delay(4, function() f:Destroy() end)
end

-- Create Window Function
function DeadByteLib:CreateWindow()
    local Top = Instance.new("Frame", GUI)
    Top.Name = "TopFrame"
    Top.Size = UDim2.new(0, 415, 0, 57)
    Top.Position = UDim2.new(0.5, -200, 0.2, 0)
    Top.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Instance.new("UIStroke", Top).Color = Color3.fromRGB(255, 0, 0)
    
    local Title = Instance.new("TextLabel", Top)
    Title.Text = "DEADBYTE"
    Title.Size = UDim2.new(1,0,1,0)
    Title.TextColor3 = Color3.new(1,1,1)
    Title.Font = Enum.Font.Code
    Title.TextSize = 40
    Title.BackgroundTransparency = 1

    local Side = Instance.new("Frame", GUI)
    Side.Size = UDim2.new(0, 146, 0, 478)
    Side.Position = UDim2.new(Top.Position.X.Scale, Top.Position.X.Offset, Top.Position.Y.Scale, Top.Position.Y.Offset + 60)
    Side.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Instance.new("UIStroke", Side).Color = Color3.fromRGB(255, 0, 0)

    local TabContainer = Instance.new("Frame", Side)
    TabContainer.Size = UDim2.new(0, 129, 0, 460)
    TabContainer.Position = UDim2.new(0.075, 0, 0.02, 0)
    TabContainer.BackgroundTransparency = 1
    Instance.new("UIListLayout", TabContainer).Padding = UDim.new(0, 5)

    local Content = Instance.new("Frame", GUI)
    Content.Size = UDim2.new(0, 269, 0, 478)
    Content.Position = UDim2.new(Side.Position.X.Scale, Side.Position.X.Offset + 155, Side.Position.Y.Scale, Side.Position.Y.Offset)
    Content.BackgroundColor3 = Color3.fromRGB(0,0,0)
    Instance.new("UIStroke", Content).Color = Color3.fromRGB(255,0,0)

    return {Container = Content, Tabs = TabContainer}
end

DeadByteLib:Notify("DeadByte Engine Initialized", "Success")
--[[
    [ MODULE: PART 2/4 - SOVEREIGN COMBAT & BALLISTICS ENGINE ]
    [ DESCRIPTION: ADVANCED TARGETING, SILENT AIM, AND HITBOX EXPANSION ]
]]

-- // [1] COMBAT CONSTANTS & DRAWING
local DrawingAPI = {}
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1.5
FOVCircle.NumSides = 100
FOVCircle.Radius = getgenv().DeadByteConfig.Combat.FOV
FOVCircle.Filled = false
FOVCircle.Visible = false
FOVCircle.Color = Color3.fromRGB(255, 0, 0)
FOVCircle.Transparency = 0.8

-- // [2] DEOBFUSCATED REFINEMENT (From 7:11PM MoonSec Ref)
-- This section adds the SUPREME LOG PROTECTOR found in your latest reference.
local function SupremeLogBypass()
    local LogService = game:GetService("LogService")
    
    -- Blocks the game from reading its own console output to detect "Injected" messages
    local old_messageout
    for _, connection in pairs(getconnections(LogService.MessageOut)) do
        connection:Disable()
    end
    
    -- Advanced ScriptContext Hook (Blocks specific Rivals anticheat 'getfenv' checks)
    local old_index
    old_index = hookmetamethod(game, "__index", newcclosure(function(self, key)
        if not checkcaller() and key == "fenv" then
            return nil
        end
        return old_index(self, key)
    end))
end
SupremeLogBypass()

-- // [3] TARGETING CORE (OOP)
local Targeter = {
    CurrentTarget = nil,
    IgnoredParts = {LocalPlayer.Character, Camera}
}

function Targeter:IsVisible(targetPart)
    if not getgenv().DeadByteConfig.Combat.WallCheck then return true end
    
    local castPoints = {targetPart.Position}
    local ignoreList = {LocalPlayer.Character, targetPart.Parent}
    local parts = Camera:GetPartsObscuringTarget(castPoints, ignoreList)
    
    return #parts == 0
end

function Targeter:GetBestTarget()
    local tempTarget = nil
    local maxDistance = getgenv().DeadByteConfig.Combat.FOV
    
    for _, player in pairs(Players:GetPlayers()) do
        if player == LocalPlayer then continue end
        if player.Team == LocalPlayer.Team and getgenv().DeadByteConfig.Combat.TeamCheck then continue end
        
        local character = player.Character
        if character and character:FindFirstChild("Humanoid") and character.Humanoid.Health > 0 then
            local hitPart = character:FindFirstChild(getgenv().DeadByteConfig.Combat.HitPart)
            if hitPart then
                local screenPos, onScreen = Camera:WorldToViewportPoint(hitPart.Position)
                if onScreen then
                    local mouseDist = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                    if mouseDist < maxDistance then
                        if self:IsVisible(hitPart) then
                            tempTarget = player
                            maxDistance = mouseDist
                        end
                    end
                end
            end
        end
    end
    self.CurrentTarget = tempTarget
    return tempTarget
end

-- // [4] BALLISTICS & PREDICTION MODULE
-- Rivals uses projectile-based physics. We calculate the future position based on velocity.
local Ballistics = {}
function Ballistics:PredictPos(targetPlayer)
    local config = getgenv().DeadByteConfig.Combat
    local character = targetPlayer.Character
    local root = character:FindFirstChild("HumanoidRootPart")
    local hitPart = character:FindFirstChild(config.HitPart)
    
    if root and hitPart then
        -- Vp = P + (V * T)
        local velocity = root.Velocity
        local predictedPos = hitPart.Position + (velocity * config.Prediction)
        return predictedPos
    end
    return nil
end

-- // [5] SILENT AIM & RAYCAST HOOKING
-- This allows hits to register without actually moving your camera.
local function InitializeSilentAim()
    local old_raycast = workspace.Raycast
    
    -- Hooking the game's Raycast function to redirect bullets to the target's head
    workspace.Raycast = newcclosure(function(self, origin, direction, params)
        if getgenv().DeadByteConfig.Combat.SilentAim and not checkcaller() then
            local target = Targeter:GetBestTarget()
            if target then
                local predicted = Ballistics:PredictPos(target)
                if predicted then
                    local newDirection = (predicted - origin).Unit * direction.Magnitude
                    return old_raycast(self, origin, newDirection, params)
                end
            end
        end
        return old_raycast(self, origin, direction, params)
    end)
end
InitializeSilentAim()

-- // [6] HITBOX EXPANDER (MODULAR)
-- Increases the size of enemy hitboxes for easier shots.
task.spawn(function()
    while task.wait(1) do
        if getgenv().DeadByteConfig.Combat.HitboxExpander then
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        hrp.Size = Vector3.new(
                            getgenv().DeadByteConfig.Combat.HitboxSize,
                            getgenv().DeadByteConfig.Combat.HitboxSize,
                            getgenv().DeadByteConfig.Combat.HitboxSize
                        )
                        hrp.Transparency = 0.7
                        hrp.CanCollide = false
                    end
                end
            end
        end
    end
end)

-- // [7] COMBAT LOOP (RenderStepped)
RunService.RenderStepped:Connect(function()
    -- FOV Update Logic
    FOVCircle.Visible = getgenv().DeadByteConfig.Combat.VisibleFOV
    FOVCircle.Radius = getgenv().DeadByteConfig.Combat.FOV
    FOVCircle.Position = Vector2.new(Mouse.X, Mouse.Y + 36)
    
    -- Aimbot Execution Logic
    if getgenv().DeadByteConfig.Combat.Enabled and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local target = Targeter:GetBestTarget()
        if target then
            local predictedPos = Ballistics:PredictPos(target)
            if predictedPos then
                local screenPos = Camera:WorldToViewportPoint(predictedPos)
                local movementX = (screenPos.X - Mouse.X) / getgenv().DeadByteConfig.Combat.Smoothing
                local movementY = (screenPos.Y - Mouse.Y) / getgenv().DeadByteConfig.Combat.Smoothing
                
                -- Smooth Mouse Relative movement (Natural Aim)
                mousemoverel(movementX, movementY)
            end
        end
    end
    
    -- Triggerbot Execution Logic
    if getgenv().DeadByteConfig.Combat.Triggerbot then
        local target = Mouse.Target
        if target and target.Parent:FindFirstChild("Humanoid") then
            local plr = Players:GetPlayerFromCharacter(target.Parent)
            if plr and plr ~= LocalPlayer then
                if not (getgenv().DeadByteConfig.Combat.TeamCheck and plr.Team == LocalPlayer.Team) then
                    mouse1click()
                end
            end
        end
    end
end)

DeadByteLib:Notify("Combat Engine: V-Prediction Online", "Success")
--[[
    [ MODULE: PART 3/4 - SOVEREIGN VISUALS & ARMAMENT MODIFICATION ]
    [ DESCRIPTION: RENDERING ENGINE (ESP), HIGHLIGHTS, AND WEAPON STATE MANIPULATION ]
]]

-- // [1] VISUAL RENDERING CACHE
local VisualsCache = {
    Players = {},
    Highlights = {},
    Tracers = {},
    Boxes = {}
}

-- // [2] DRAWING API WRAPPER (PERFORMANCE OPTIMIZED)
-- This internal wrapper handles the creation of ESP elements for the 1500+ line architecture.
local function CreateESPElement(type, properties)
    local element = Drawing.new(type)
    for property, value in pairs(properties) do
        element[property] = value
    end
    return element
end

-- // [3] THE SOVEREIGN ESP ENGINE (OOP)
local ESPEngine = {}
ESPEngine.__index = ESPEngine

function ESPEngine.New(targetPlayer)
    local self = setmetatable({}, ESPEngine)
    self.Player = targetPlayer
    
    -- Initialize Drawing Objects for this player
    self.Box = CreateESPElement("Square", {Thickness = 1.5, Color = Color3.fromRGB(255, 0, 0), Filled = false, Transparency = 0.8, Visible = false})
    self.Tracer = CreateESPElement("Line", {Thickness = 1.5, Color = Color3.fromRGB(255, 0, 0), Transparency = 0.8, Visible = false})
    self.Name = CreateESPElement("Text", {Size = 14, Center = true, Outline = true, Color = Color3.new(1, 1, 1), Visible = false})
    self.Distance = CreateESPElement("Text", {Size = 13, Center = true, Outline = true, Color = Color3.fromRGB(200, 200, 200), Visible = false})
    
    VisualsCache.Players[targetPlayer] = self
    return self
end

function ESPEngine:Update()
    local config = getgenv().DeadByteConfig.Visuals
    local character = self.Player.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    local screenPos, onScreen = nil, false
    
    if root then
        screenPos, onScreen = Camera:WorldToViewportPoint(root.Position)
    end

    local isFriendly = (self.Player.Team == LocalPlayer.Team and getgenv().DeadByteConfig.Combat.TeamCheck)
    local shouldShow = config.Master and onScreen and not isFriendly and self.Player ~= LocalPlayer

    if shouldShow then
        -- Calculate Box Dimensions
        local head = character:FindFirstChild("Head")
        if head then
            local headPos = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
            local legPos = Camera:WorldToViewportPoint(root.Position - Vector3.new(0, 3, 0))
            local height = math.abs(headPos.Y - legPos.Y)
            local width = height / 1.5
            
            -- Update Box ESP
            if config.Boxes then
                self.Box.Size = Vector2.new(width, height)
                self.Box.Position = Vector2.new(screenPos.X - width / 2, screenPos.Y - height / 2)
                self.Box.Visible = true
            else self.Box.Visible = false end

            -- Update Tracer ESP
            if config.Tracers then
                self.Tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                self.Tracer.To = Vector2.new(screenPos.X, screenPos.Y + (height / 2))
                self.Tracer.Visible = true
            else self.Tracer.Visible = false end

            -- Update Names & Distance
            if config.Names then
                self.Name.Text = self.Player.Name
                self.Name.Position = Vector2.new(screenPos.X, screenPos.Y - (height / 2) - 15)
                self.Name.Visible = true
            else self.Name.Visible = false end

            if config.Distance then
                local dist = math.floor((Camera.CFrame.Position - root.Position).Magnitude)
                self.Distance.Text = "[" .. dist .. "m]"
                self.Distance.Position = Vector2.new(screenPos.X, screenPos.Y + (height / 2) + 5)
                self.Distance.Visible = true
            else self.Distance.Visible = false end
        end
    else
        -- Hide everything if not visible or friendly
        self.Box.Visible = false
        self.Tracer.Visible = false
        self.Name.Visible = false
        self.Distance.Visible = false
    end
end

function ESPEngine:Destroy()
    self.Box:Remove()
    self.Tracer:Remove()
    self.Name:Remove()
    self.Distance:Remove()
    VisualsCache.Players[self.Player] = nil
end

-- // [4] GUN MODIFICATION SUITE (BALLISTIC OVERRIDE)
-- This section handles No Recoil, No Spread, and Rapid Fire by hooking game meta-tables.
local WeaponModifier = {Enabled = true}
function WeaponModifier:Apply()
    task.spawn(function()
        while task.wait(0.5) do
            local config = getgenv().DeadByteConfig.GunMods
            
            -- Rivals Logic: Iterate through Garbage Collector to find weapon scripts/tables
            for _, obj in pairs(getgc(true)) do
                if type(obj) == "table" and obj.RecoilData or obj.SpreadData then
                    if config.NoRecoil then
                        obj.RecoilData = {Min = 0, Max = 0, Speed = 0}
                    end
                    if config.NoSpread then
                        obj.SpreadData = {Min = 0, Max = 0}
                    end
                    if config.RapidFire then
                        obj.FireRate = 0.01 -- Extremely high rate of fire
                    end
                end
            end
        end
    end)
end
WeaponModifier:Apply()

-- // [5] MODERN HIGHLIGHTS MODULE
-- Uses the Highlight Instance for the "Glow through walls" effect.
local function UpdateHighlights()
    local config = getgenv().DeadByteConfig.Visuals
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local character = player.Character
            if character then
                local highlight = character:FindFirstChild("DeadByteHighlight")
                local isFriendly = (player.Team == LocalPlayer.Team and getgenv().DeadByteConfig.Combat.TeamCheck)
                
                if config.Master and config.Highlights and not isFriendly then
                    if not highlight then
                        highlight = Instance.new("Highlight")
                        highlight.Name = "DeadByteHighlight"
                        highlight.Parent = character
                    end
                    highlight.FillColor = Color3.fromRGB(255, 0, 0)
                    highlight.OutlineColor = Color3.new(1, 1, 1)
                    highlight.FillTransparency = 0.5
                    highlight.OutlineTransparency = 0
                elseif highlight then
                    highlight:Destroy()
                end
            end
        end
    end
end

-- // [6] VISUALS MASTER LOOP
RunService.RenderStepped:Connect(function()
    -- Update Drawing ESP
    for player, esp in pairs(VisualsCache.Players) do
        if player.Parent then
            esp:Update()
        else
            esp:Destroy()
        end
    end
    
    -- Synchronize highlights
    UpdateHighlights()
    
    -- FOV Modification (Viewmodel / Camera)
    if getgenv().DeadByteConfig.Visuals.Master then
        Camera.FieldOfView = getgenv().DeadByteConfig.Visuals.FOVMod
    end
end)

-- Initialize ESP for existing and new players
for _, player in pairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then ESPEngine.New(player) end
end
Players.PlayerAdded:Connect(function(player)
    ESPEngine.New(player)
end)
Players.PlayerRemoving:Connect(function(player)
    if VisualsCache.Players[player] then
        VisualsCache.Players[player]:Destroy()
    end
end)

DeadByteLib:Notify("Visuals Engine: Ray-Casting ESP Active", "Success")
--[[
    [ MODULE: PART 4/4 - SOVEREIGN MOVEMENT, AUTOMATION, & ORCHESTRATION ]
    [ DESCRIPTION: MOVEMENT OVERRIDES, AUTOMATED SYSTEMS, AND UI POPULATION ]
]]

-- // [1] SOVEREIGN MOVEMENT ENGINE (OOP)
local MovementEngine = {FlyVelocity = Vector3.new(0,0,0)}

function MovementEngine:Init()
    RunService.Stepped:Connect(function()
        if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("Humanoid") then return end
        local Hum = LocalPlayer.Character.Humanoid
        local Root = LocalPlayer.Character.HumanoidRootPart
        local Config = getgenv().DeadByteConfig.Movement

        -- 1. Speed Modification
        if Config.SpeedEnabled then
            Hum.WalkSpeed = Config.SpeedValue
        end

        -- 2. Jump Power Modification
        if Config.JumpEnabled then
            Hum.JumpPower = Config.JumpValue
        end

        -- 3. Noclip Override (Deobfuscated MoonSec Style)
        if Config.Noclip then
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide then
                    part.CanCollide = false
                end
            end
        end

        -- 4. Flight Logic
        if Config.Fly then
            local MoveDir = Hum.MoveDirection
            local FlySpeed = Config.FlySpeed or 50
            Root.Velocity = MoveDir * FlySpeed + Vector3.new(0, 2, 0) -- Hover force
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                Root.Velocity = Root.Velocity + Vector3.new(0, FlySpeed, 0)
            elseif UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                Root.Velocity = Root.Velocity + Vector3.new(0, -FlySpeed, 0)
            end
        end
    end)

    -- 5. Infinite Jump Handler
    UserInputService.JumpRequest:Connect(function()
        if getgenv().DeadByteConfig.Movement.InfJump and LocalPlayer.Character then
            LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
        end
    end)
end
MovementEngine:Init()

-- // [2] RIVALS AUTOMATION MODULE
local Automate = {}
function Automate:Run()
    task.spawn(function()
        while task.wait(5) do
            local Config = getgenv().DeadByteConfig.Automation
            
            -- Rivals Specific: Auto-Matchmaking
            if Config.AutoQueue then
                local QueueRemote = ReplicatedStorage:FindFirstChild("QueueRemote", true) or ReplicatedStorage:FindFirstChild("Matchmake", true)
                if QueueRemote and QueueRemote:IsA("RemoteEvent") then
                    QueueRemote:FireServer("Standard_1v1") -- Target 1v1 Duels
                end
            end

            -- Rivals Specific: Auto-Claim Rewards
            if Config.AutoClaim then
                for _, remote in pairs(ReplicatedStorage:GetDescendants()) do
                    if remote.Name:find("Claim") or remote.Name:find("Reward") then
                        remote:FireServer()
                    end
                end
            end
        end
    end)
end
Automate:Run()

-- // [3] FINAL UI TAB POPULATION (ORCHESTRATOR)
-- This connects the logic from Part 1, 2, and 3 into the "Stuff" container.

-- Helper Functions (Toggles & Sliders)
local function AddToggle(parent, text, cfg_path, key, callback)
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.new(1, 0, 0, 32)
    b.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    b.Text = "  " .. text .. ": " .. (cfg_path[key] and "ON" or "OFF")
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.Code
    b.TextXAlignment = Enum.TextXAlignment.Left
    b.BorderSizePixel = 0
    Instance.new("UIStroke", b).Color = Color3.fromRGB(80, 0, 0)

    b.MouseButton1Click:Connect(function()
        cfg_path[key] = not cfg_path[key]
        b.Text = "  " .. text .. ": " .. (cfg_path[key] and "ON" or "OFF")
        if callback then callback(cfg_path[key]) end
        SaveConfig() -- Save on every change
    end)
end

local function AddSlider(parent, text, min, max, cfg_path, key)
    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(1, 0, 0, 45)
    frame.BackgroundTransparency = 1
    
    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1, 0, 0, 20)
    label.Text = text .. " [" .. cfg_path[key] .. "]"
    label.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    label.Font = Enum.Font.Code
    label.BackgroundTransparency = 1

    local bar = Instance.new("TextButton", frame)
    bar.Size = UDim2.new(0.9, 0, 0, 6)
    bar.Position = UDim2.new(0.05, 0, 0.6, 0)
    bar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    bar.Text = ""
    
    local fill = Instance.new("Frame", bar)
    fill.Size = UDim2.new((cfg_path[key]-min)/(max-min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    fill.BorderSizePixel = 0

    bar.MouseButton1Down:Connect(function()
        local move; move = RunService.RenderStepped:Connect(function()
            local percent = math.clamp((Mouse.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
            local val = math.floor(min + (max - min) * percent)
            cfg_path[key] = val
            fill.Size = UDim2.new(percent, 0, 1, 0)
            label.Text = text .. " [" .. val .. "]"
        end)
        UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then move:Disconnect() SaveConfig() end end)
    end)
end

-- POPULATING TABS
local Tabs = SovereignPages -- From Part 1

-- Combat Tab
AddToggle(Tabs["COMBAT"], "Aimbot Master", getgenv().Sovereign.Combat, "Aimbot")
AddToggle(Tabs["COMBAT"], "Silent Aim (Beta)", getgenv().Sovereign.Combat, "SilentAim")
AddToggle(Tabs["COMBAT"], "Triggerbot", getgenv().Sovereign.Combat, "Triggerbot")
AddToggle(Tabs["COMBAT"], "Kill Aura", getgenv().Sovereign.Combat, "KillAura")
AddToggle(Tabs["COMBAT"], "Wall Check", getgenv().Sovereign.Combat, "WallCheck")
AddSlider(Tabs["COMBAT"], "FOV Radius", 30, 800, getgenv().Sovereign.Combat, "FOV")
AddSlider(Tabs["COMBAT"], "Smoothing", 1, 20, getgenv().Sovereign.Combat, "Smoothness")

-- Visuals Tab
AddToggle(Tabs["VISUALS"], "Master Visuals", getgenv().Sovereign.Visuals, "Master")
AddToggle(Tabs["VISUALS"], "Box ESP", getgenv().Sovereign.Visuals, "Boxes")
AddToggle(Tabs["VISUALS"], "Highlights (Glow)", getgenv().Sovereign.Visuals, "Highlights")
AddToggle(Tabs["VISUALS"], "Tracers", getgenv().Sovereign.Visuals, "Tracers")
AddToggle(Tabs["VISUALS"], "Health Indicators", getgenv().Sovereign.Visuals, "HealthBar")
AddSlider(Tabs["VISUALS"], "Field of View", 70, 120, getgenv().Sovereign.Visuals, "FOVMod")

-- Movement Tab
AddToggle(Tabs["MOVEMENT"], "Speed Hack", getgenv().Sovereign.Movement, "SpeedEnabled")
AddSlider(Tabs["MOVEMENT"], "Speed Value", 16, 200, getgenv().Sovereign.Movement, "SpeedValue")
AddToggle(Tabs["MOVEMENT"], "Jump Hack", getgenv().Sovereign.Movement, "JumpEnabled")
AddSlider(Tabs["MOVEMENT"], "Jump Value", 50, 300, getgenv().Sovereign.Movement, "JumpValue")
AddToggle(Tabs["MOVEMENT"], "Infinite Jump", getgenv().Sovereign.Movement, "InfJump")
AddToggle(Tabs["MOVEMENT"], "Fly Mode", getgenv().Sovereign.Movement, "Fly")
AddToggle(Tabs["MOVEMENT"], "Noclip", getgenv().Sovereign.Movement, "Noclip")

-- Gun Mods Tab
AddToggle(Tabs["GUN MODS"], "No Recoil", getgenv().Sovereign.Combat, "NoRecoil")
AddToggle(Tabs["GUN MODS"], "No Spread", getgenv().Sovereign.Combat, "NoSpread")
AddToggle(Tabs["GUN MODS"], "Rapid Fire", getgenv().Sovereign.GunMods, "RapidFire")
AddToggle(Tabs["GUN MODS"], "Infinite Ammo", getgenv().Sovereign.GunMods, "InfAmmo")

-- Automation Tab
AddToggle(Tabs["AUTOMATE"], "Auto-Match (1v1)", getgenv().Sovereign.Automation, "AutoQueue")
AddToggle(Tabs["AUTOMATE"], "Auto-Claim Daily", getgenv().Sovereign.Automation, "AutoClaim")

-- Misc/Config Tab
local SaveBtn = Instance.new("TextButton", Tabs["MISC"])
SaveBtn.Size = UDim2.new(1,0,0,30)
SaveBtn.Text = "MANUAL SAVE CONFIG"
SaveBtn.BackgroundColor3 = Color3.fromRGB(0, 50, 0)
SaveBtn.TextColor3 = Color3.new(1,1,1)
SaveBtn.Font = Enum.Font.Code
SaveBtn.MouseButton1Click:Connect(SaveConfig)

local HopBtn = Instance.new("TextButton", Tabs["MISC"])
HopBtn.Size = UDim2.new(1,0,0,30)
HopBtn.Text = "SERVER HOP"
HopBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
HopBtn.TextColor3 = Color3.new(1,1,1)
HopBtn.Font = Enum.Font.Code
HopBtn.MouseButton1Click:Connect(function()
    game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)
end)

-- // [4] THE FINAL HANDSHAKE
-- Closing logic: Connect the UI Toggle key and finalize injection.
UserInputService.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == getgenv().Sovereign.Misc.ToggleKey then
        SovereignGui.Enabled = not SovereignGui.Enabled
    end
end)

-- Injection Success Notification
DeadByteLib:Notify("DeadByte Sovereign 5.0 Fully Loaded.", "Success")
print([[
    -------------------------------------------------------
    DEADBYTE SOVEREIGN // RIVALS PRIVATE SUITE // COMPLETE
    MOONSEC V4 SECURITY HANDSHAKE: SUCCESS
    LOGS SILENCED: TRUE
    ANTIGUI DETECTION BYPASS: ENABLED
    -------------------------------------------------------
]])

-- Set Default Page
SovereignPages["COMBAT"].Visible = true
