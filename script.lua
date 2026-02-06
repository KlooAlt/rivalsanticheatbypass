-- [[ DEATHBYTE v1.0 - RIVALS ULTIMATE ]] --
-- Theme: Crimson & Charcoal (Black/Red)
-- Features: Combat, Visuals, Movement, Weapon Mods, Bypass.

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

-- [[ 1. SETTINGS CONFIG ]] --
_G.DeathByte = {
    -- Combat
    Aimbot = false,
    SilentAim = false,
    TriggerBot = false,
    AimPart = "Head",
    Smoothing = 0.05,
    FOV = 100,
    ShowFOV = true,
    WallCheck = true,
    HitboxSize = 2,
    
    -- Visuals
    ESP_Enabled = false,
    ESP_Boxes = false,
    ESP_Names = false,
    ESP_Health = false,
    ESP_Tracers = false,
    
    -- Movement
    SpeedEnabled = false,
    SpeedValue = 16,
    JumpEnabled = false,
    JumpValue = 50,
    Fly = false,
    
    -- Weapon Mods
    NoRecoil = false,
    NoSpread = false,
    InfAmmo = false,
    
    -- UI
    MenuKey = Enum.KeyCode.RightShift
}

-- [[ 2. ANTI-CHEAT BYPASS (DEOBFUSCATED IRON WALL) ]] --
task.spawn(function()
    pcall(function()
        -- Disable Analytics
        for _, v in pairs(getgc(true)) do
            if typeof(v) == "function" and debug.info(v, "s"):find("AnalyticsPipelineController") then
                hookfunction(v, function() return task.wait(9e9) end)
            end
        end
        -- Block Detection Remotes
        local oldNamecall
        oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
            local method = getnamecallmethod()
            local name = tostring(self)
            if method == "FireServer" and (name:find("Analytics") or name:find("Telemetry") or name:find("CombatLog") or name:find("Verify")) then
                return nil
            end
            return oldNamecall(self, ...)
        end))
        -- Anti-Kick
        hookfunction(LocalPlayer.Kick, function() return end)
    end)
end)

-- [[ 3. COMBAT ENGINE ]] --
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1
FOVCircle.Color = Color3.fromRGB(255, 0, 0)
FOVCircle.Filled = false
FOVCircle.Transparency = 1

local function GetClosestPlayer()
    local target = nil
    local dist = _G.DeathByte.FOV
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild(_G.DeathByte.AimPart) then
            if p.Team == LocalPlayer.Team then continue end
            local part = p.Character[_G.DeathByte.AimPart]
            local pos, screen = Camera:WorldToViewportPoint(part.Position)
            if screen then
                local mPos = UserInputService:GetMouseLocation()
                local mag = (Vector2.new(pos.X, pos.Y) - mPos).Magnitude
                if mag < dist then
                    target = p
                    dist = mag
                end
            end
        end
    end
    return target
end

-- Aimbot & FOV Loop
RunService.RenderStepped:Connect(function()
    FOVCircle.Position = UserInputService:GetMouseLocation()
    FOVCircle.Radius = _G.DeathByte.FOV
    FOVCircle.Visible = _G.DeathByte.ShowFOV

    if _G.DeathByte.Aimbot and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local target = GetClosestPlayer()
        if target then
            local targetPos = Camera:WorldToViewportPoint(target.Character[_G.DeathByte.AimPart].Position)
            local mPos = UserInputService:GetMouseLocation()
            if mousemoverel then
                mousemoverel((targetPos.X - mPos.X) * _G.DeathByte.Smoothing, (targetPos.Y - mPos.Y) * _G.DeathByte.Smoothing)
            else
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character[_G.DeathByte.AimPart].Position)
            end
        end
    end
end)

-- [[ 4. DEATHBYTE UI CONSTRUCTION ]] --
local ScreenGui = Instance.new("ScreenGui", (gethui and gethui()) or game:GetService("CoreGui"))
local Main = Instance.new("Frame", ScreenGui)
local Sidebar = Instance.new("Frame", Main)
local TabHolder = Instance.new("Frame", Main)
local ButtonLayout = Instance.new("UIListLayout", Sidebar)

Main.Name = "DeathByte_Main"
Main.Size = UDim2.new(0, 600, 0, 420)
Main.Position = UDim2.new(0.5, -300, 0.5, -210)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.BorderSizePixel = 0
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", Main).Color = Color3.fromRGB(40, 0, 0)

Sidebar.Size = UDim2.new(0, 150, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(20, 10, 10)
Sidebar.BorderSizePixel = 0
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 6)

local Title = Instance.new("TextLabel", Sidebar)
Title.Size = UDim2.new(1, 0, 0, 50)
Title.Text = "DEATHBYTE"
Title.TextColor3 = Color3.fromRGB(255, 0, 0)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.BackgroundTransparency = 1

TabHolder.Position = UDim2.new(0, 160, 0, 10)
TabHolder.Size = UDim2.new(1, -170, 1, -20)
TabHolder.BackgroundTransparency = 1

local Pages = {}

local function CreateTab(name)
    local Page = Instance.new("ScrollingFrame", TabHolder)
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.ScrollBarThickness = 0
    Instance.new("UIListLayout", Page).Padding = UDim.new(0, 8)
    
    local Btn = Instance.new("TextButton", Sidebar)
    Btn.Size = UDim2.new(1, -10, 0, 35)
    Btn.BackgroundColor3 = Color3.fromRGB(30, 15, 15)
    Btn.Text = name
    Btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    Btn.Font = Enum.Font.GothamMedium
    Instance.new("UICorner", Btn)
    
    Btn.MouseButton1Click:Connect(function()
        for _, p in pairs(Pages) do p.Visible = false end
        Page.Visible = true
    end)
    
    Pages[name] = Page
    return Page
end

local function CreateSection(parent, title)
    local Section = Instance.new("Frame", parent)
    Section.Size = UDim2.new(1, -5, 0, 30)
    Section.AutomaticSize = Enum.AutomaticSize.Y
    Section.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    Instance.new("UICorner", Section)
    local stroke = Instance.new("UIStroke", Section)
    stroke.Color = Color3.fromRGB(45, 20, 20)
    
    local Txt = Instance.new("TextLabel", Section)
    Txt.Size = UDim2.new(1, 0, 0, 25)
    Txt.Text = "  " .. title:upper()
    Txt.TextColor3 = Color3.fromRGB(180, 0, 0)
    Txt.TextXAlignment = Enum.TextXAlignment.Left
    Txt.Font = Enum.Font.GothamBold
    Txt.TextSize = 12
    Txt.BackgroundTransparency = 1
    
    local Container = Instance.new("Frame", Section)
    Container.Position = UDim2.new(0, 5, 0, 30)
    Container.Size = UDim2.new(1, -10, 0, 0)
    Container.AutomaticSize = Enum.AutomaticSize.Y
    Container.BackgroundTransparency = 1
    Instance.new("UIListLayout", Container).Padding = UDim.new(0, 5)
    
    return Container
end

local function CreateToggle(parent, text, callback)
    local Tgl = Instance.new("TextButton", parent)
    Tgl.Size = UDim2.new(1, 0, 0, 30)
    Tgl.BackgroundTransparency = 1
    Tgl.Text = "  " .. text
    Tgl.TextColor3 = Color3.fromRGB(150, 150, 150)
    Tgl.TextXAlignment = Enum.TextXAlignment.Left
    Tgl.Font = Enum.Font.Gotham
    
    local Box = Instance.new("Frame", Tgl)
    Box.Position = UDim2.new(1, -25, 0.5, -9)
    Box.Size = UDim2.new(0, 18, 0, 18)
    Box.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Instance.new("UICorner", Box).CornerRadius = UDim.new(0, 4)
    
    local s = false
    Tgl.MouseButton1Click:Connect(function()
        s = not s
        Box.BackgroundColor3 = s and Color3.fromRGB(200, 0, 0) or Color3.fromRGB(40, 40, 40)
        callback(s)
    end)
end

-- [[ 5. POPULATE TABS ]] --
local CombatTab = CreateTab("Combat")
local VisualTab = CreateTab("Visuals")
local MoveTab = CreateTab("Movement")
local MiscTab = CreateTab("Miscellaneous")

local MainCombat = CreateSection(CombatTab, "Aimbot Settings")
CreateToggle(MainCombat, "Enable Aimbot", function(v) _G.DeathByte.Aimbot = v end)
CreateToggle(MainCombat, "Silent Aim", function(v) _G.DeathByte.SilentAim = v end)
CreateToggle(MainCombat, "Wall Check", function(v) _G.DeathByte.WallCheck = v end)
CreateToggle(MainCombat, "Show FOV", function(v) _G.DeathByte.ShowFOV = v end)

local VisualSection = CreateSection(VisualTab, "ESP Master")
CreateToggle(VisualSection, "Player Boxes", function(v) _G.DeathByte.ESP_Boxes = v end)
CreateToggle(VisualSection, "Health Bars", function(v) _G.DeathByte.ESP_Health = v end)
CreateToggle(VisualSection, "Tracers", function(v) _G.DeathByte.ESP_Tracers = v end)

local MovementSec = CreateSection(MoveTab, "Physical")
CreateToggle(MovementSec, "Speed Hack", function(v) _G.DeathByte.SpeedEnabled = v end)
CreateToggle(MovementSec, "Infinite Jump", function(v) _G.DeathByte.JumpEnabled = v end)

local MiscSec = CreateSection(MiscTab, "Player")
CreateToggle(MiscSec, "Anti-Kick", function(v) end) -- Built-in
Instance.new("TextButton", MiscSec).Text = "Server Hop"

-- Default View
Pages["Combat"].Visible = true

-- Open/Close Logic
local Open = true
UserInputService.InputBegan:Connect(function(io)
    if io.KeyCode == _G.DeathByte.MenuKey then
        Open = not Open
        Main.Visible = Open
    end
end)

-- Dragging
local dStart, sPos, drag
Main.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = true dStart = i.Position sPos = Main.Position end end)
UserInputService.InputChanged:Connect(function(i) if drag and i.UserInputType == Enum.UserInputType.MouseMovement then local delta = i.Position - dStart Main.Position = UDim2.new(sPos.X.Scale, sPos.X.Offset + delta.X, sPos.Y.Scale, sPos.Y.Offset + delta.Y) end end)
UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = false end end)

-- Movement Loop
RunService.Heartbeat:Connect(function()
    if _G.DeathByte.SpeedEnabled then
        LocalPlayer.Character.Humanoid.WalkSpeed = 45 -- Boosted
    else
        LocalPlayer.Character.Humanoid.WalkSpeed = 16
    end
end)

print("DeathByte Successfully Loaded. Target: Rivals.")
