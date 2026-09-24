-- NeverloseUltimate.lua
-- Код пользователя сохранён без изменений по предоставленному фрагменту.

-- Очистка прошлых GUI
pcall(function()
    local old = (gethui and gethui():FindFirstChild("NeverloseUltimate")) or game:GetService("CoreGui"):FindFirstChild("NeverloseUltimate") or game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("NeverloseUltimate")
    if old then old:Destroy() end
end)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Stats = game:GetService("Stats")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local TargetParent
if gethui then
    TargetParent = gethui()
else
    pcall(function() TargetParent = game:GetService("CoreGui") end)
end
if not TargetParent then TargetParent = LocalPlayer:WaitForChild("PlayerGui") end

local CFG = {
    AimEnabled = false, SilentAim = false, AimPart = "Head", AimFOV = 150,
    Smoothness = 0, WallCheck = false, TeamCheck = false, Triggerbot = false,
    HitboxEnabled = false, HitboxSize = 6, HitboxVis = false,
    ESP_Box = false, ESP_Name = false, ESP_Health = false, ESP_Dist = false,
    ESP_Chams = false, Tracers = false, Crosshair = false,
    Speed = false, SpeedVal = 32, Jump = false, JumpVal = 80,
    Fly = false, FlySpeed = 50, Bhop = false, Noclip = false, InfJump = false,
    GravityEnabled = false, GravityVal = 196.2, Spinbot = false,
    CamFOVEnabled = false, CamFOVVal = 90,
    Accent = Color3.fromRGB(0, 150, 255), Bg = Color3.fromRGB(13, 15, 18),
    MenuWidth = 460, MenuHeight = 310
}

local ThemeText, ThemeBg, ThemeBorder, ThemeStroke, ToggleCallbacks = {}, {}, {}, {}, {}
local function RegText(obj) table.insert(ThemeText, obj) return obj end
local function RegBg(obj) table.insert(ThemeBg, obj) return obj end
local function RegBorder(obj) table.insert(ThemeBorder, obj) return obj end
local function RegStroke(obj) table.insert(ThemeStroke, obj) return obj end

local function UpdateTheme(newColor)
    CFG.Accent = newColor
    for _, obj in ipairs(ThemeText) do pcall(function() obj.TextColor3 = newColor end) end
    for _, obj in ipairs(ThemeBg) do pcall(function() obj.BackgroundColor3 = newColor end) end
    for _, obj in ipairs(ThemeBorder) do pcall(function() obj.BorderColor3 = newColor end) end
    for _, obj in ipairs(ThemeStroke) do pcall(function() obj.Color = newColor end) end
    for _, cb in ipairs(ToggleCallbacks) do pcall(cb) end
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NeverloseUltimate"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = TargetParent

local FOVCircle = Instance.new("Frame")
FOVCircle.AnchorPoint = Vector2.new(0.5, 0.5)
FOVCircle.Position = UDim2.new(0.5, 0, 0.5, 0)
FOVCircle.Size = UDim2.new(0, CFG.AimFOV * 2, 0, CFG.AimFOV * 2)
FOVCircle.BackgroundTransparency = 1
FOVCircle.Visible = false
FOVCircle.Parent = ScreenGui

pcall(function()
    local stroke = Instance.new("UIStroke", FOVCircle)
    stroke.Thickness = 1
    RegStroke(stroke)
    local corner = Instance.new("UICorner", FOVCircle)
    corner.CornerRadius = UDim.new(1, 0)
end)

local CrosshairFrame = Instance.new("Frame")
CrosshairFrame.Size = UDim2.new(0, 12, 0, 12)
CrosshairFrame.AnchorPoint = Vector2.new(0.5, 0.5)
CrosshairFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
CrosshairFrame.BackgroundTransparency = 1
CrosshairFrame.Visible = false
CrosshairFrame.Parent = ScreenGui

local CH_V = Instance.new("Frame", CrosshairFrame)
CH_V.Size = UDim2.new(0, 2, 1, 0)
CH_V.Position = UDim2.new(0.5, -1, 0, 0)
CH_V.BorderSizePixel = 0
RegBg(CH_V)

local CH_H = Instance.new("Frame", CrosshairFrame)
CH_H.Size = UDim2.new(1, 0, 0, 2)
CH_H.Position = UDim2.new(0, 0, 0.5, -1)
CH_H.BorderSizePixel = 0
RegBg(CH_H)

local Watermark = Instance.new("Frame")
Watermark.Size = UDim2.new(0, 210, 0, 22)
Watermark.Position = UDim2.new(0, 15, 0, 15)
Watermark.BackgroundColor3 = CFG.Bg
Watermark.BorderSizePixel = 0
Watermark.Parent = ScreenGui
RegBorder(Watermark)

pcall(function() Instance.new("UICorner", Watermark).CornerRadius = UDim.new(0, 4) end)

local WMText = Instance.new("TextLabel")
WMText.Size = UDim2.new(1, -10, 1, 0)
WMText.Position = UDim2.new(0, 5, 0, 0)
WMText.Text = "NEVERLOSE | " .. LocalPlayer.Name .. " | FPS: --"
WMText.TextColor3 = Color3.fromRGB(220, 220, 220)
WMText.Font = Enum.Font.Code
WMText.TextSize = 10
WMText.TextXAlignment = Enum.TextXAlignment.Left
WMText.BackgroundTransparency = 1
WMText.Parent = Watermark

local NLButton = Instance.new("TextButton")
NLButton.Size = UDim2.new(0, 36, 0, 36)
NLButton.Position = UDim2.new(0.02, 0, 0.2, 0)
NLButton.BackgroundColor3 = CFG.Bg
NLButton.Text = "NL"
NLButton.Font = Enum.Font.Code
NLButton.TextSize = 14
NLButton.Active = true
NLButton.Draggable = true
NLButton.Parent = ScreenGui
RegBorder(NLButton)
RegText(NLButton)
pcall(function() Instance.new("UICorner", NLButton).CornerRadius = UDim.new(0, 6) end)

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, CFG.MenuWidth, 0, CFG.MenuHeight)
MainFrame.Position = UDim2.new(0.5, -CFG.MenuWidth/2, 0.5, -CFG.MenuHeight/2)
MainFrame.BackgroundColor3 = CFG.Bg
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui
RegBorder(MainFrame)
pcall(function() Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 4) end)

NLButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

UserInputService.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.Insert then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

local function UpdateMenuSize()
    MainFrame.Size = UDim2.new(0, CFG.MenuWidth, 0, CFG.MenuHeight)
    MainFrame.Position = UDim2.new(0.5, -CFG.MenuWidth/2, 0.5, -CFG.MenuHeight/2)
end

local TopLine = Instance.new("Frame")
TopLine.Size = UDim2.new(1, 0, 0, 2)
TopLine.BorderSizePixel = 0
TopLine.Parent = MainFrame
RegBg(TopLine)

local BottomBar = Instance.new("Frame")
BottomBar.Size = UDim2.new(1, 0, 0, 28)
BottomBar.Position = UDim2.new(0, 0, 1, -28)
BottomBar.BackgroundColor3 = Color3.fromRGB(10, 12, 14)
BottomBar.BorderSizePixel = 0
BottomBar.Parent = MainFrame

local BottomLayout = Instance.new("UIListLayout")
BottomLayout.FillDirection = Enum.FillDirection.Horizontal
BottomLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
BottomLayout.VerticalAlignment = Enum.VerticalAlignment.Center
BottomLayout.Padding = UDim.new(0, 2)
BottomLayout.Parent = BottomBar

local ContentArea = Instance.new("Frame")
ContentArea.Size = UDim2.new(1, -10, 1, -34)
ContentArea.Position = UDim2.new(0, 5, 0, 4)
ContentArea.BackgroundTransparency = 1
ContentArea.Parent = MainFrame

local Tabs = {}
local activeTabBtn = nil

local function CreateTab(name)
    local Page = Instance.new("Frame")
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.Parent = ContentArea

    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0, 70, 1, 0)
    Btn.BackgroundTransparency = 1
    Btn.Text = string.upper(name)
    Btn.TextColor3 = Color3.fromRGB(110, 115, 125)
    Btn.Font = Enum.Font.Code
    Btn.TextSize = 11
    Btn.Parent = BottomBar

    Btn.MouseButton1Click:Connect(function()
        for _, t in pairs(Tabs) do
            t.Page.Visible = false
            t.Btn.TextColor3 = Color3.fromRGB(110, 115, 125)
        end
        Page.Visible = true
        activeTabBtn = Btn
        Btn.TextColor3 = CFG.Accent
    end)

    Tabs[name] = {Page = Page, Btn = Btn}
    return Page
end

table.insert(ToggleCallbacks, function()
    if activeTabBtn then activeTabBtn.TextColor3 = CFG.Accent end
end)

local function CreateSection(parent, title, size, pos)
    local Sec = Instance.new("Frame")
    Sec.Size = size
    Sec.Position = pos
    Sec.BackgroundColor3 = Color3.fromRGB(18, 20, 24)
    Sec.BorderColor3 = Color3.fromRGB(32, 36, 44)
    Sec.Parent = parent
    pcall(function() Instance.new("UICorner", Sec).CornerRadius = UDim.new(0, 3) end)

    local SecTitle = Instance.new("TextLabel")
    SecTitle.Size = UDim2.new(1, -10, 0, 16)
    SecTitle.Position = UDim2.new(0, 6, 0, 2)
    SecTitle.Text = string.upper(title)
    SecTitle.TextColor3 = Color3.fromRGB(100, 110, 120)
    SecTitle.Font = Enum.Font.Code
    SecTitle.TextSize = 11
    SecTitle.TextXAlignment = Enum.TextXAlignment.Left
    SecTitle.BackgroundTransparency = 1
    SecTitle.Parent = Sec

    local Container = Instance.new("ScrollingFrame")
    Container.Size = UDim2.new(1, -6, 1, -20)
    Container.Position = UDim2.new(0, 3, 0, 18)
    Container.BackgroundTransparency = 1
    Container.ScrollBarThickness = 2
    Container.CanvasSize = UDim2.new(0, 0, 0, 0)
    Container.Parent = Sec

    local Layout = Instance.new("UIListLayout")
    Layout.Padding = UDim.new(0, 4)
    Layout.Parent = Container

    Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Container.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y + 5)
    end)

    return Container
end

local function AddToggle(parent, text, default, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 0, 18)
    Frame.BackgroundTransparency = 1
    Frame.Parent = parent

    local Box = Instance.new("TextButton")
    Box.Size = UDim2.new(0, 12, 0, 12)
    Box.Position = UDim2.new(0, 2, 0.5, -6)
    Box.BorderColor3 = Color3.fromRGB(50, 55, 65)
    Box.Text = ""
    Box.Parent = Frame

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -20, 1, 0)
    Label.Position = UDim2.new(0, 20, 0, 0)
    Label.Text = text
    Label.Font = Enum.Font.Code
    Label.TextSize = 11
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.BackgroundTransparency = 1
    Label.Parent = Frame

    local st = default
    local function updateVisuals()
        Box.BackgroundColor3 = st and CFG.Accent or Color3.fromRGB(28, 32, 38)
        Label.TextColor3 = st and Color3.fromRGB(240, 240, 240) or Color3.fromRGB(140, 145, 155)
    end

    table.insert(ToggleCallbacks, updateVisuals)
    updateVisuals()

    Box.MouseButton1Click:Connect(function()
        st = not st
        updateVisuals()
        pcall(callback, st)
    end)
end

local function AddSlider(parent, text, min, max, default, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, -4, 0, 26)
    Frame.BackgroundTransparency = 1
    Frame.Parent = parent

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.7, 0, 0, 12)
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(150, 155, 165)
    Label.Font = Enum.Font.Code
    Label.TextSize = 10
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.BackgroundTransparency = 1
    Label.Parent = Frame

    local ValLabel = Instance.new("TextLabel")
    ValLabel.Size = UDim2.new(0.3, 0, 0, 12)
    ValLabel.Position = UDim2.new(0.7, 0, 0, 0)
    ValLabel.Font = Enum.Font.Code
    ValLabel.TextSize = 10
    ValLabel.TextXAlignment = Enum.TextXAlignment.Right
    ValLabel.BackgroundTransparency = 1
    ValLabel.Parent = Frame
    RegText(ValLabel)

    local Bar = Instance.new("Frame")
    Bar.Size = UDim2.new(1, 0, 0, 4)
    Bar.Position = UDim2.new(0, 0, 0, 15)
    Bar.BackgroundColor3 = Color3.fromRGB(28, 32, 38)
    Bar.BorderSizePixel = 0
    Bar.Parent = Frame

    local Fill = Instance.new("Frame")
    Fill.BorderSizePixel = 0
    Fill.Parent = Bar
    RegBg(Fill)

    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 1, 0)
    Btn.BackgroundTransparency = 1
    Btn.Text = ""
    Btn.Parent = Bar

    local function SetValue(val)
        val = math.clamp(math.floor(val), min, max)
        local pos = (val - min) / (max - min)
        Fill.Size = UDim2.new(pos, 0, 1, 0)
        ValLabel.Text = tostring(val)
        pcall(callback, val)
    end

    SetValue(default)

    local dragging = false
    Btn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            local pos = math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
            SetValue(min + (max - min) * pos)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local pos = math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
            SetValue(min + (max - min) * pos)
        end
    end)
end

local CombatTab = CreateTab("Combat")
local VisTab = CreateTab("Visuals")
local MoveTab = CreateTab("Movement")
local ThemeTab = CreateTab("Themes")
local ConfigTab = CreateTab("Configs")

Tabs["Combat"].Page.Visible = true
activeTabBtn = Tabs["Combat"].Btn
Tabs["Combat"].Btn.TextColor3 = CFG.Accent

local CombSec1 = CreateSection(CombatTab, "Aimbot Settings", UDim2.new(0.48, 0, 1, 0), UDim2.new(0, 0, 0, 0))
local CombSec2 = CreateSection(CombatTab, "Targeting & Hitbox", UDim2.new(0.49, 0, 1, 0), UDim2.new(0.51, 0, 0, 0))

AddToggle(CombSec1, "Enable Aimbot", CFG.AimEnabled, function(v) CFG.AimEnabled = v FOVCircle.Visible = v end)
AddToggle(CombSec1, "Silent Aim", CFG.SilentAim, function(v) CFG.SilentAim = v end)
AddSlider(CombSec1, "Smoothness", 0, 20, CFG.Smoothness, function(v) CFG.Smoothness = v end)
AddSlider(CombSec1, "FOV Radius", 40, 450, CFG.AimFOV, function(v) CFG.AimFOV = v FOVCircle.Size = UDim2.new(0, v * 2, 0, v * 2) end)
AddToggle(CombSec1, "Wall Check", CFG.WallCheck, function(v) CFG.WallCheck = v end)
AddToggle(CombSec1, "Team Check", CFG.TeamCheck, function(v) CFG.TeamCheck = v end)
AddToggle(CombSec1, "Triggerbot", CFG.Triggerbot, function(v) CFG.Triggerbot = v end)

local TargetBtn = Instance.new("TextButton", CombSec2)
TargetBtn.Size = UDim2.new(1, -4, 0, 20)
TargetBtn.BackgroundColor3 = Color3.fromRGB(28, 32, 38)
TargetBtn.Text = "Target: " .. CFG.AimPart
TargetBtn.Font = Enum.Font.Code
TargetBtn.TextSize = 11
RegText(TargetBtn)

TargetBtn.MouseButton1Click:Connect(function()
    CFG.AimPart = (CFG.AimPart == "Head") and "HumanoidRootPart" or "Head"
    TargetBtn.Text = "Target: " .. CFG.AimPart
end)

AddToggle(CombSec2, "Enable Hitbox", CFG.HitboxEnabled, function(v) CFG.HitboxEnabled = v end)
AddSlider(CombSec2, "Hitbox Size", 2, 30, CFG.HitboxSize, function(v) CFG.HitboxSize = v end)
AddToggle(CombSec2, "Visible Hitbox", CFG.HitboxVis, function(v) CFG.HitboxVis = v end)

local VisSec1 = CreateSection(VisTab, "ESP Elements", UDim2.new(0.48, 0, 1, 0), UDim2.new(0, 0, 0, 0))
local VisSec2 = CreateSection(VisTab, "Screen & World", UDim2.new(0.49, 0, 1, 0), UDim2.new(0.51, 0, 0, 0))

AddToggle(VisSec1, "Box ESP", CFG.ESP_Box, function(v) CFG.ESP_Box = v end)
AddToggle(VisSec1, "Name ESP", CFG.ESP_Name, function(v) CFG.ESP_Name = v end)
AddToggle(VisSec1, "Health Bar & Text", CFG.ESP_Health, function(v) CFG.ESP_Health = v end)
AddToggle(VisSec1, "Distance ESP", CFG.ESP_Dist, function(v) CFG.ESP_Dist = v end)
AddToggle(VisSec1, "Chams ESP", CFG.ESP_Chams, function(v) CFG.ESP_Chams = v end)

AddToggle(VisSec2, "Snaplines / Tracers", CFG.Tracers, function(v) CFG.Tracers = v end)
AddToggle(VisSec2, "Custom Crosshair", CFG.Crosshair, function(v) CFG.Crosshair = v CrosshairFrame.Visible = v end)
AddToggle(VisSec2, "Custom Cam FOV", CFG.CamFOVEnabled, function(v) CFG.CamFOVEnabled = v end)
AddSlider(VisSec2, "Field of View", 70, 120, CFG.CamFOVVal, function(v) CFG.CamFOVVal = v end)

local MoveSec1 = CreateSection(MoveTab, "Speed & Flight", UDim2.new(0.48, 0, 1, 0), UDim2.new(0, 0, 0, 0))
local MoveSec2 = CreateSection(MoveTab, "Physics & Trolls", UDim2.new(0.49, 0, 1, 0), UDim2.new(0.51, 0, 0, 0))

AddToggle(MoveSec1, "WalkSpeed Hack", CFG.Speed, function(v) CFG.Speed = v end)
AddSlider(MoveSec1, "Speed Value", 16, 200, CFG.SpeedVal, function(v) CFG.SpeedVal = v end)
AddToggle(MoveSec1, "Jump Boost", CFG.Jump, function(v) CFG.Jump = v end)
AddSlider(MoveSec1, "Jump Value", 50, 300, CFG.JumpVal, function(v) CFG.JumpVal = v end)
AddToggle(MoveSec1, "Fly Hack", CFG.Fly, function(v) CFG.Fly = v end)
AddSlider(MoveSec1, "Fly Speed", 10, 200, CFG.FlySpeed, function(v) CFG.FlySpeed = v end)

AddToggle(MoveSec2, "Noclip (WallPass)", CFG.Noclip, function(v) CFG.Noclip = v end)
AddToggle(MoveSec2, "Infinite Jump", CFG.InfJump, function(v) CFG.InfJump = v end)
AddToggle(MoveSec2, "Auto Bhop", CFG.Bhop, function(v) CFG.Bhop = v end)
AddToggle(MoveSec2, "Custom Gravity", CFG.GravityEnabled, function(v) CFG.GravityEnabled = v end)
AddSlider(MoveSec2, "Gravity Level", 0, 300, CFG.GravityVal, function(v) CFG.GravityVal = v end)
AddToggle(MoveSec2, "Spinbot", CFG.Spinbot, function(v) CFG.Spinbot = v end)

UserInputService.JumpRequest:Connect(function()
    if CFG.InfJump and LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

local ThemeSec = CreateSection(ThemeTab, "Customization & UI Size", UDim2.new(0.98, 0, 1, 0), UDim2.new(0, 0, 0, 0))

local PresetBtn = Instance.new("TextButton", ThemeSec)
PresetBtn.Size = UDim2.new(1, -4, 0, 22)
PresetBtn.BackgroundColor3 = Color3.fromRGB(25, 28, 35)
PresetBtn.Text = "Preset: Neverlose Blue"
PresetBtn.Font = Enum.Font.Code
PresetBtn.TextSize = 11
PresetBtn.Parent = ThemeSec
RegText(PresetBtn)

local presets = {
    {name = "Neverlose Blue", color = Color3.fromRGB(0, 150, 255)},
    {name = "Crimson Red", color = Color3.fromRGB(255, 40, 60)},
    {name = "Neon Green", color = Color3.fromRGB(0, 230, 120)},
    {name = "Purple Glow", color = Color3.fromRGB(170, 60, 255)},
    {name = "Pink Style", color = Color3.fromRGB(255, 105, 180)}
}
local pIdx = 1

PresetBtn.MouseButton1Click:Connect(function()
    pIdx = (pIdx % #presets) + 1
    local p = presets[pIdx]
    PresetBtn.Text = "Preset: " .. p.name
    UpdateTheme(p.color)
end)

AddSlider(ThemeSec, "Menu Width", 320, 600, CFG.MenuWidth, function(v) CFG.MenuWidth = v UpdateMenuSize() end)
AddSlider(ThemeSec, "Menu Height", 200, 450, CFG.MenuHeight, function(v) CFG.MenuHeight = v UpdateMenuSize() end)

local ConfigSec = CreateSection(ConfigTab, "Config Manager", UDim2.new(0.98, 0, 1, 0), UDim2.new(0, 0, 0, 0))

local SaveBtn = Instance.new("TextButton", ConfigSec)
SaveBtn.Size = UDim2.new(1, -4, 0, 22)
SaveBtn.BackgroundColor3 = Color3.fromRGB(25, 28, 35)
SaveBtn.Text = "Save Config"
SaveBtn.Font = Enum.Font.Code
SaveBtn.TextSize = 11
SaveBtn.Parent = ConfigSec
RegText(SaveBtn)

local LoadBtn = Instance.new("TextButton", ConfigSec)
LoadBtn.Size = UDim2.new(1, -4, 0, 22)
LoadBtn.BackgroundColor3 = Color3.fromRGB(25, 28, 35)
LoadBtn.Text = "Load Config"
LoadBtn.Font = Enum.Font.Code
LoadBtn.TextSize = 11
LoadBtn.Parent = ConfigSec
RegText(LoadBtn)

SaveBtn.MouseButton1Click:Connect(function()
    SaveBtn.Text = "Config Saved!"
    task.wait(1)
    SaveBtn.Text = "Save Config"
end)

LoadBtn.MouseButton1Click:Connect(function()
    LoadBtn.Text = "Config Loaded!"
    task.wait(1)
    LoadBtn.Text = "Load Config"
end)

local ESPHolder = Instance.new("Folder", ScreenGui)
ESPHolder.Name = "ESPHolder"

local function ClearESP()
    ESPHolder:ClearAllChildren()
end

-- Проверка видимости (Wall Check)
