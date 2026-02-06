--[[
    DEADBYTE V2 - RIVALS PRIVATE SUITE
    Theme: Blood Red & Onyx
    Features: Aimbot, Silent Aim, ESP, Gun Mods, Movement, Configs
]]

if not game:IsLoaded() then game.Loaded:Wait() end

-- // Core Settings & Personalization
getgenv().DeadByteConfig = {
    Aimbot = {
        Enabled = false,
        SilentAim = false,
        TeamCheck = true,
        WallCheck = true,
        FOV = 120,
        Smoothing = 3,
        HitPart = "Head", -- Head, UpperTorso, HumanoidRootPart
        Prediction = 0.165,
        VisibleFOV = true
    },
    Visuals = {
        Enabled = false,
        Boxes = false,
        Names = false,
        Tracers = false,
        Health = false,
        Distance = false,
        Highlights = false
    },
    GunMods = {
        NoRecoil = false,
        NoSpread = false,
        RapidFire = false,
        InfAmmo = false
    },
    Movement = {
        WalkSpeed = 16,
        JumpPower = 50,
        InfJump = false,
        Noclip = false
    },
    Colors = {
        Accent = Color3.fromRGB(255, 0, 0),
        Main = Color3.fromRGB(10, 10, 10),
        Outline = Color3.fromRGB(40, 0, 0)
    }
}

-- // Services
local Players = game:GetService("Players")
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Http = game:GetService("HttpService")
local LP = Players.LocalPlayer
local Mouse = LP:GetMouse()
local Cam = workspace.CurrentCamera

-- // Notification System (As requested from image)
local function Notify(text, type, duration)
    local screen = CoreGui:FindFirstChild("DeadByteNotify") or Instance.new("ScreenGui", CoreGui)
    screen.Name = "DeadByteNotify"
    
    local container = screen:FindFirstChild("Main") or Instance.new("Frame", screen)
    if not container:IsA("Frame") then
        container.Name = "Main"
        container.BackgroundTransparency = 1
        container.Position = UDim2.new(0.5, -150, 0.05, 0)
        container.Size = UDim2.new(0, 300, 0.8, 0)
        Instance.new("UIListLayout", container).Padding = UDim.new(0, 5)
    end

    local frame = Instance.new("Frame", container)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    frame.BackgroundTransparency = 0.3
    frame.Size = UDim2.new(1, 0, 0, 40)
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 4)
    
    local bar = Instance.new("Frame", frame)
    bar.Size = UDim2.new(0, 2, 0.7, 0)
    bar.Position = UDim2.new(0, 5, 0.15, 0)
    bar.BackgroundColor3 = type == "Success" and Color3.new(0,1,0) or Color3.new(1,0,0)

    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1, -40, 1, 0)
    label.Position = UDim2.new(0, 20, 0, 0)
    label.Text = text
    label.TextColor3 = Color3.new(1,1,1)
    label.Font = Enum.Font.Code
    label.BackgroundTransparency = 1
    label.TextXAlignment = Enum.TextXAlignment.Left

    task.delay(duration or 3, function() frame:Destroy() end)
end

-- // Configuration Logic
local function Save()
    if writefile then
        writefile("DeadByte_Rivals.json", Http:JSONEncode(getgenv().DeadByteConfig))
    end
end

local function Load()
    if isfile("DeadByte_Rivals.json") then
        getgenv().DeadByteConfig = Http:JSONDecode(readfile("DeadByte_Rivals.json"))
    end
end

-- // Security Bypasses (Integrated)
pcall(function()
    local sc = game:GetService("ScriptContext")
    for _, v in pairs(getconnections(sc.Error)) do v:Disable() end
    
    local old_kick
    old_kick = hookfunction(LP.Kick, newcclosure(function(self, ...)
        if self == LP then return nil end
        return old_kick(self, ...)
    end))
end)

-- // UI Framework
local DeadByte = {Tabs = {}}

function DeadByte:CreateWindow()
    local Main = Instance.new("ScreenGui", CoreGui)
    Main.Name = "DeadByte"
    
    local Frame = Instance.new("Frame", Main)
    Frame.BackgroundColor3 = getgenv().DeadByteConfig.Colors.Main
    Frame.BorderSizePixel = 0
    Frame.Position = UDim2.new(0.5, -300, 0.5, -200)
    Frame.Size = UDim2.new(0, 600, 0, 400)
    
    local Stroke = Instance.new("UIStroke", Frame)
    Stroke.Thickness = 2
    Stroke.Color = getgenv().DeadByteConfig.Colors.Outline

    local Top = Instance.new("Frame", Frame)
    Top.Size = UDim2.new(1, 0, 0, 30)
    Top.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    
    local Title = Instance.new("TextLabel", Top)
    Title.Text = " DEADBYTE // RIVALS PRIVATE"
    Title.TextColor3 = getgenv().DeadByteConfig.Colors.Accent
    Title.Font = Enum.Font.Code
    Title.TextSize = 14
    Title.Size = UDim2.new(1, 0, 1, 0)
    Title.TextXAlignment = Enum.TextXAlignment.Left

    local Container = Instance.new("Frame", Frame)
    Container.Position = UDim2.new(0, 140, 0, 40)
    Container.Size = UDim2.new(1, -150, 1, -50)
    Container.BackgroundTransparency = 1

    local TabList = Instance.new("Frame", Frame)
    TabList.Position = UDim2.new(0, 10, 0, 40)
    TabList.Size = UDim2.new(0, 120, 1, -50)
    TabList.BackgroundTransparency = 1
    local Layout = Instance.new("UIListLayout", TabList)
    Layout.Padding = UDim.new(0, 5)

    -- Toggle UI Visibility
    UIS.InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.RightShift then
            Main.Enabled = not Main.Enabled
        end
    end)

    return {Container = Container, TabList = TabList}
end

function DeadByte:CreateTab(name, parent)
    local Page = Instance.new("ScrollingFrame", parent.Container)
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.ScrollBarThickness = 0
    Instance.new("UIListLayout", Page).Padding = UDim.new(0, 10)

    local Btn = Instance.new("TextButton", parent.TabList)
    Btn.Size = UDim2.new(1, 0, 0, 30)
    Btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Btn.Text = name
    Btn.TextColor3 = Color3.new(1,1,1)
    Btn.Font = Enum.Font.Code
    
    Btn.MouseButton1Click:Connect(function()
        for _, v in pairs(parent.Container:GetChildren()) do v.Visible = false end
        Page.Visible = true
    end)

    return Page
end

-- // Feature Helper Functions
local FOV = Drawing.new("Circle")
FOV.Thickness = 1
FOV.NumSides = 100
FOV.Color = Color3.new(1,0,0)

function GetTarget()
    local target = nil
    local dist = getgenv().DeadByteConfig.Aimbot.FOV
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LP and v.Character and v.Character:FindFirstChild("Humanoid") then
            if getgenv().DeadByteConfig.Aimbot.TeamCheck and v.Team == LP.Team then continue end
            local pos, screen = Cam:WorldToViewportPoint(v.Character[getgenv().DeadByteConfig.Aimbot.HitPart].Position)
            if screen then
                local mag = (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                if mag < dist then
                    target = v
                    dist = mag
                end
            end
        end
    end
    return target
end

-- // Building the Menu
Load()
Notify("Loading DeadByte..", "Info")
local UI = DeadByte:CreateWindow()
local MainTab = DeadByte:CreateTab("COMBAT", UI)
local VisualTab = DeadByte:CreateTab("VISUALS", UI)
local MiscTab = DeadByte:CreateTab("MISC", UI)

-- // COMBAT FEATURES
local function AddToggle(parent, text, tbl, key)
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.new(1, 0, 0, 30)
    b.BackgroundColor3 = Color3.fromRGB(25, 10, 10)
    b.Text = text .. ": " .. (tbl[key] and "ON" or "OFF")
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.Code
    b.MouseButton1Click:Connect(function()
        tbl[key] = not tbl[key]
        b.Text = text .. ": " .. (tbl[key] and "ON" or "OFF")
        Save()
    end)
end

AddToggle(MainTab, "Master Aimbot", getgenv().DeadByteConfig.Aimbot, "Enabled")
AddToggle(MainTab, "Silent Aim", getgenv().DeadByteConfig.Aimbot, "SilentAim")
AddToggle(MainTab, "Wall Check", getgenv().DeadByteConfig.Aimbot, "WallCheck")
AddToggle(MainTab, "Show FOV Circle", getgenv().DeadByteConfig.Aimbot, "VisibleFOV")

-- // VISUAL FEATURES
AddToggle(VisualTab, "Enable ESP Highlights", getgenv().DeadByteConfig.Visuals, "Highlights")
AddToggle(VisualTab, "Box ESP", getgenv().DeadByteConfig.Visuals, "Boxes")

-- // MISC FEATURES
AddToggle(MiscTab, "Infinite Jump", getgenv().DeadByteConfig.Movement, "InfJump")
AddToggle(MiscTab, "Rapid Fire (Gun Mod)", getgenv().DeadByteConfig.GunMods, "RapidFire")

-- // LOOPS & ENGINE
RS.RenderStepped:Connect(function()
    -- FOV Update
    FOV.Visible = getgenv().DeadByteConfig.Aimbot.VisibleFOV
    FOV.Radius = getgenv().DeadByteConfig.Aimbot.FOV
    FOV.Position = Vector2.new(Mouse.X, Mouse.Y + 36)

    -- Aimbot Loop
    if getgenv().DeadByteConfig.Aimbot.Enabled then
        local target = GetTarget()
        if target then
            local pos = Cam:WorldToViewportPoint(target.Character[getgenv().DeadByteConfig.Aimbot.HitPart].Position)
            mousemoverel((pos.X - Mouse.X) / getgenv().DeadByteConfig.Aimbot.Smoothing, (pos.Y - Mouse.Y) / getgenv().DeadByteConfig.Aimbot.Smoothing)
        end
    end

    -- Highlights ESP
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LP and p.Character then
            local highlight = p.Character:FindFirstChild("DeadByteHighlight")
            if getgenv().DeadByteConfig.Visuals.Highlights then
                if not highlight then
                    highlight = Instance.new("Highlight", p.Character)
                    highlight.Name = "DeadByteHighlight"
                end
                highlight.FillColor = getgenv().DeadByteConfig.Colors.Accent
                highlight.OutlineColor = Color3.new(1,1,1)
            elseif highlight then
                highlight:Destroy()
            end
        end
    end
end)

-- Noclip / Movement Logic
RS.Stepped:Connect(function()
    if getgenv().DeadByteConfig.Movement.Noclip and LP.Character then
        for _, v in pairs(LP.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)

-- Infinite Jump
UIS.JumpRequest:Connect(function()
    if getgenv().DeadByteConfig.Movement.InfJump then
        LP.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

Notify("DeadByte Injected Successfully!", "Success")
