-- [[ ASCIDA v4.0 - RIVALS UNIFIED SCRIPT ]] --
-- Includes: Iron Wall Bypass, GUI Framework, Aimbot, and Triggerbot.

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- [[ 1. GLOBAL SETTINGS ]] --
_G.AscidaSettings = {
    AimbotEnabled = false,
    AimPart = "Head",
    Smoothing = 0.08,
    FOVRadius = 120,
    ShowFOV = true,
    TeamCheck = true,
    TriggerBot = false,
    WallCheck = true
}

-- [[ 2. ANTI-CHEAT BYPASS (IRON WALL) ]] --
-- Deobfuscated logic to prevent Rivals from detecting the cheat
task.spawn(function()
    if game.GameId ~= 6035857208 then return end
    
    local success, err = pcall(function()
        local RS = game:GetService("ReplicatedStorage")
        
        -- Hang the analytics pipeline
        for _, v in pairs(getgc(true)) do
            if typeof(v) == "function" and debug.info(v, "s"):find("AnalyticsPipelineController") then
                hookfunction(v, function() return task.wait(9e9) end)
            end
        end

        -- Block Reporting Remotes
        local oldNamecall
        oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
            local method = getnamecallmethod()
            local name = tostring(self)
            if method == "FireServer" and (name:find("Analytics") or name:find("Telemetry") or name:find("CombatLog")) then
                return nil
            end
            return oldNamecall(self, ...)
        end))
        
        -- Anti-Kick Hook
        local oldKick
        oldKick = hookfunction(LocalPlayer.Kick, newcclosure(function(self, ...)
            if self == LocalPlayer then return nil end
            return oldKick(self, ...)
        end))
    end)
    print(success and "Bypass Active" or "Bypass Failed: " .. tostring(err))
end)

-- [[ 3. AIMBOT LOGIC ]] --
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1
FOVCircle.Color = Color3.fromRGB(0, 150, 255)
FOVCircle.Filled = false
FOVCircle.Transparency = 0.5

local function IsVisible(part)
    if not _G.AscidaSettings.WallCheck then return true end
    local castPoints = {Camera.CFrame.Position, part.Position}
    local ignoreList = {LocalPlayer.Character, part.Parent}
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = ignoreList
    
    local result = workspace:Raycast(castPoints[1], castPoints[2] - castPoints[1], params)
    return result == nil
end

local function GetClosestPlayer()
    local target = nil
    local shortestDistance = _G.AscidaSettings.FOVRadius

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild(_G.AscidaSettings.AimPart) then
            if _G.AscidaSettings.TeamCheck and player.Team == LocalPlayer.Team then continue end
            
            local part = player.Character[_G.AscidaSettings.AimPart]
            local pos, onScreen = Camera:WorldToViewportPoint(part.Position)
            
            if onScreen and IsVisible(part) then
                local mousePos = UserInputService:GetMouseLocation()
                local distance = (Vector2.new(pos.X, pos.Y) - mousePos).Magnitude
                
                if distance < shortestDistance then
                    target = part
                    shortestDistance = distance
                end
            end
        end
    end
    return target
end

RunService.RenderStepped:Connect(function()
    FOVCircle.Radius = _G.AscidaSettings.FOVRadius
    FOVCircle.Visible = _G.AscidaSettings.ShowFOV
    FOVCircle.Position = UserInputService:GetMouseLocation()

    if _G.AscidaSettings.AimbotEnabled then
        local target = GetClosestPlayer()
        if target and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
            local targetPos = Camera:WorldToViewportPoint(target.Position)
            local mousePos = UserInputService:GetMouseLocation()
            
            -- Smooth Camera movement using lerp for natural feel
            local moveX = (targetPos.X - mousePos.X) * _G.AscidaSettings.Smoothing
            local moveY = (targetPos.Y - mousePos.Y) * _G.AscidaSettings.Smoothing
            
            if mousemoverel then
                mousemoverel(moveX, moveY)
            else
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Position)
            end
        end
    end
end)

-- [[ 4. ASCIDA GUI FRAMEWORK ]] --
local ScreenGui = Instance.new("ScreenGui", (gethui and gethui()) or game:GetService("CoreGui"))
ScreenGui.Name = "Ascida_Unified"

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 550, 0, 380)
MainFrame.Position = UDim2.new(0.5, -275, 0.5, -190)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", MainFrame).Color = Color3.fromRGB(50, 50, 70)

-- Sidebar
local Sidebar = Instance.new("Frame", MainFrame)
Sidebar.Size = UDim2.new(0, 140, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 8)

local TabContainer = Instance.new("Frame", MainFrame)
TabContainer.Position = UDim2.new(0, 150, 0, 10)
TabContainer.Size = UDim2.new(1, -160, 1, -20)
TabContainer.BackgroundTransparency = 1

local Pages = {}
local function CreateTab(name)
    local Page = Instance.new("ScrollingFrame", TabContainer)
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.ScrollBarThickness = 0
    Instance.new("UIListLayout", Page).Padding = UDim.new(0, 10)
    
    local TabBtn = Instance.new("TextButton", Sidebar)
    TabBtn.Size = UDim2.new(1, -20, 0, 35)
    TabBtn.Position = UDim2.new(0, 10, 0, #Sidebar:GetChildren() * 40)
    TabBtn.Text = name
    TabBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    TabBtn.Font = Enum.Font.GothamMedium
    Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 4)

    TabBtn.MouseButton1Click:Connect(function()
        for _, p in pairs(Pages) do p.Visible = false end
        Page.Visible = true
    end)
    
    Pages[name] = Page
    return Page
end

local function CreateToggle(parent, text, default, callback)
    local Toggle = Instance.new("TextButton", parent)
    Toggle.Size = UDim2.new(1, -10, 0, 30)
    Toggle.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
    Toggle.Text = "  " .. text
    Toggle.TextColor3 = Color3.fromRGB(200, 200, 200)
    Toggle.TextXAlignment = Enum.TextXAlignment.Left
    Toggle.Font = Enum.Font.Gotham
    Instance.new("UICorner", Toggle).CornerRadius = UDim.new(0, 4)
    
    local Box = Instance.new("Frame", Toggle)
    Box.Size = UDim2.new(0, 18, 0, 18)
    Box.Position = UDim2.new(1, -25, 0.5, -9)
    Box.BackgroundColor3 = default and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(60, 60, 80)
    Instance.new("UICorner", Box).CornerRadius = UDim.new(0, 4)

    local state = default
    Toggle.MouseButton1Click:Connect(function()
        state = not state
        Box.BackgroundColor3 = state and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(60, 60, 80)
        callback(state)
    end)
end

-- [[ 5. BUILD MENU TABS ]] --
local CombatTab = CreateTab("Combat")
local VisualTab = CreateTab("Visuals")

-- Combat Section
CreateToggle(CombatTab, "Enable Aimbot", false, function(v) _G.AscidaSettings.AimbotEnabled = v end)
CreateToggle(CombatTab, "TriggerBot", false, function(v) _G.AscidaSettings.TriggerBot = v end)
CreateToggle(CombatTab, "Wall Check", true, function(v) _G.AscidaSettings.WallCheck = v end)
CreateToggle(CombatTab, "Team Check", true, function(v) _G.AscidaSettings.TeamCheck = v end)

-- Visual Section
CreateToggle(VisualTab, "Show FOV Circle", true, function(v) _G.AscidaSettings.ShowFOV = v end)

-- Default View
Pages["Combat"].Visible = true

-- Dragging System
local dragStart, startPos, dragging
MainFrame.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true dragStart = i.Position startPos = MainFrame.Position end end)
UserInputService.InputChanged:Connect(function(i) if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then local delta = i.Position - dragStart MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) end end)
UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)

print("Ascida Unified v4.0 Loaded.")
