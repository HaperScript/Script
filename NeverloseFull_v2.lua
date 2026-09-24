-- NeverloseFull.lua
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

pcall(function()
    local old = (gethui and gethui():FindFirstChild("NeverloseFull"))
        or game:GetService("CoreGui"):FindFirstChild("NeverloseFull")
        or LocalPlayer.PlayerGui:FindFirstChild("NeverloseFull")
    if old then old:Destroy() end
end)

local TargetParent
if gethui then
    TargetParent = gethui()
else
    pcall(function() TargetParent = game:GetService("CoreGui") end)
end
if not TargetParent then TargetParent = LocalPlayer:WaitForChild("PlayerGui") end

local CFG = {
    AimEnabled=false, AimPart="Head", AimFOV=150,
    HitboxEnabled=false, HitboxSize=6, HitboxVis=false,
    ESP=false, Tracers=false,
    Speed=false, SpeedVal=32, Jump=false, JumpVal=80,
    Fly=false, FlySpeed=50, Bhop=false,
    Accent=Color3.fromRGB(0,150,255), Bg=Color3.fromRGB(13,15,18),
    MenuWidth=440, MenuHeight=280
}

local ThemeText,ThemeBg,ThemeBorder,ThemeStroke,ToggleCallbacks={},{},{},{},{}
local function RegText(o)table.insert(ThemeText,o)return o end
local function RegBg(o)table.insert(ThemeBg,o)return o end
local function RegBorder(o)table.insert(ThemeBorder,o)return o end
local function RegStroke(o)table.insert(ThemeStroke,o)return o end

local function UpdateTheme(c)
    CFG.Accent=c
    for _,o in ipairs(ThemeText)do pcall(function()o.TextColor3=c end)end
    for _,o in ipairs(ThemeBg)do pcall(function()o.BackgroundColor3=c end)end
    for _,o in ipairs(ThemeBorder)do pcall(function()o.BorderColor3=c end)end
    for _,o in ipairs(ThemeStroke)do pcall(function()o.Color=c end)end
    for _,cb in ipairs(ToggleCallbacks)do pcall(cb)end
end

local ScreenGui=Instance.new("ScreenGui")
ScreenGui.Name="NeverloseFull"
ScreenGui.ResetOnSpawn=false
ScreenGui.Parent=TargetParent

local FOVCircle=Instance.new("Frame")
FOVCircle.Name="FOVCircle"
FOVCircle.AnchorPoint=Vector2.new(.5,.5)
FOVCircle.Position=UDim2.new(.5,0,.5,0)
FOVCircle.Size=UDim2.new(0,CFG.AimFOV*2,0,CFG.AimFOV*2)
FOVCircle.BackgroundTransparency=1
FOVCircle.Visible=false
FOVCircle.Parent=ScreenGui
pcall(function()
    local s=Instance.new("UIStroke",FOVCircle);s.Thickness=1;RegStroke(s)
    local c=Instance.new("UICorner",FOVCircle);c.CornerRadius=UDim.new(1,0)
end)

local NLButton=Instance.new("TextButton")
NLButton.Size=UDim2.new(0,36,0,36)
NLButton.Position=UDim2.new(.02,0,.2,0)
NLButton.BackgroundColor3=CFG.Bg
NLButton.Text="NL"
NLButton.Font=Enum.Font.Code
NLButton.TextSize=14
NLButton.Active=true
NLButton.Draggable=true
NLButton.Parent=ScreenGui
RegBorder(NLButton);RegText(NLButton)
pcall(function()Instance.new("UICorner",NLButton).CornerRadius=UDim.new(0,6)end)

local MainFrame=Instance.new("Frame")
MainFrame.Size=UDim2.new(0,CFG.MenuWidth,0,CFG.MenuHeight)
MainFrame.Position=UDim2.new(.5,-CFG.MenuWidth/2,.5,-CFG.MenuHeight/2)
MainFrame.BackgroundColor3=CFG.Bg
MainFrame.Active=true
MainFrame.Draggable=true
MainFrame.Parent=ScreenGui
RegBorder(MainFrame)
pcall(function()Instance.new("UICorner",MainFrame).CornerRadius=UDim.new(0,4)end)

NLButton.MouseButton1Click:Connect(function()MainFrame.Visible=not MainFrame.Visible end)

local function UpdateMenuSize()
    MainFrame.Size=UDim2.new(0,CFG.MenuWidth,0,CFG.MenuHeight)
    MainFrame.Position=UDim2.new(.5,-CFG.MenuWidth/2,.5,-CFG.MenuHeight/2)
end

local TopLine=Instance.new("Frame",MainFrame)
TopLine.Size=UDim2.new(1,0,0,2)
TopLine.BorderSizePixel=0
RegBg(TopLine)

local BottomBar=Instance.new("Frame",MainFrame)
BottomBar.Size=UDim2.new(1,0,0,28)
BottomBar.Position=UDim2.new(0,0,1,-28)
BottomBar.BackgroundColor3=Color3.fromRGB(10,12,14)
BottomBar.BorderSizePixel=0

local BottomLayout=Instance.new("UIListLayout",BottomBar)
BottomLayout.FillDirection=Enum.FillDirection.Horizontal
BottomLayout.HorizontalAlignment=Enum.HorizontalAlignment.Center
BottomLayout.VerticalAlignment=Enum.VerticalAlignment.Center
BottomLayout.Padding=UDim.new(0,2)

local ContentArea=Instance.new("Frame",MainFrame)
ContentArea.Size=UDim2.new(1,-10,1,-34)
ContentArea.Position=UDim2.new(0,5,0,4)
ContentArea.BackgroundTransparency=1

local Tabs,activeTabBtn={},nil
local function CreateTab(name)
    local Page=Instance.new("Frame",ContentArea)
    Page.Size=UDim2.new(1,0,1,0)
    Page.BackgroundTransparency=1
    Page.Visible=false

    local Btn=Instance.new("TextButton",BottomBar)
    Btn.Size=UDim2.new(0,75,1,0)
    Btn.BackgroundTransparency=1
    Btn.Text=string.upper(name)
    Btn.TextColor3=Color3.fromRGB(110,115,125)
    Btn.Font=Enum.Font.Code
    Btn.TextSize=11
    Btn.MouseButton1Click:Connect(function()
        for _,t in pairs(Tabs)do t.Page.Visible=false;t.Btn.TextColor3=Color3.fromRGB(110,115,125)end
        Page.Visible=true;activeTabBtn=Btn;Btn.TextColor3=CFG.Accent
    end)
    Tabs[name]={Page=Page,Btn=Btn}
    return Page
end
table.insert(ToggleCallbacks,function()if activeTabBtn then activeTabBtn.TextColor3=CFG.Accent end end)

local function CreateSection(parent,title,size,pos)
    local Sec=Instance.new("Frame",parent)
    Sec.Size=size;Sec.Position=pos
    Sec.BackgroundColor3=Color3.fromRGB(18,20,24)
    Sec.BorderColor3=Color3.fromRGB(32,36,44)
    pcall(function()Instance.new("UICorner",Sec).CornerRadius=UDim.new(0,3)end)

    local Title=Instance.new("TextLabel",Sec)
    Title.Size=UDim2.new(1,-10,0,16);Title.Position=UDim2.new(0,6,0,2)
    Title.Text=string.upper(title);Title.TextColor3=Color3.fromRGB(100,110,120)
    Title.Font=Enum.Font.Code;Title.TextSize=11;Title.TextXAlignment=Enum.TextXAlignment.Left
    Title.BackgroundTransparency=1

    local Container=Instance.new("ScrollingFrame",Sec)
    Container.Size=UDim2.new(1,-6,1,-20);Container.Position=UDim2.new(0,3,0,18)
    Container.BackgroundTransparency=1;Container.ScrollBarThickness=2
    Container.CanvasSize=UDim2.new(0,0,0,0)

    local Layout=Instance.new("UIListLayout",Container)
    Layout.Padding=UDim.new(0,4)
    Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Container.CanvasSize=UDim2.new(0,0,0,Layout.AbsoluteContentSize.Y+5)
    end)
    return Container
end

local function AddToggle(parent,text,default,callback)
    local Frame=Instance.new("Frame",parent)
    Frame.Size=UDim2.new(1,0,0,18);Frame.BackgroundTransparency=1

    local Box=Instance.new("TextButton",Frame)
    Box.Size=UDim2.new(0,12,0,12);Box.Position=UDim2.new(0,2,.5,-6)
    Box.BorderColor3=Color3.fromRGB(50,55,65);Box.Text=""

    local Label=Instance.new("TextLabel",Frame)
    Label.Size=UDim2.new(1,-20,1,0);Label.Position=UDim2.new(0,20,0,0)
    Label.Text=text;Label.Font=Enum.Font.Code;Label.TextSize=11
    Label.TextXAlignment=Enum.TextXAlignment.Left;Label.BackgroundTransparency=1

    local st=default
    local function Update()
        Box.BackgroundColor3=st and CFG.Accent or Color3.fromRGB(28,32,38)
        Label.TextColor3=st and Color3.fromRGB(240,240,240) or Color3.fromRGB(140,145,155)
    end
    table.insert(ToggleCallbacks,Update);Update()
    Box.MouseButton1Click:Connect(function()st=not st;Update();pcall(callback,st)end)
end

local function AddSlider(parent,text,min,max,default,callback)
    local Frame=Instance.new("Frame",parent)
    Frame.Size=UDim2.new(1,-4,0,26);Frame.BackgroundTransparency=1

    local Label=Instance.new("TextLabel",Frame)
    Label.Size=UDim2.new(.7,0,0,12);Label.Text=text
    Label.TextColor3=Color3.fromRGB(150,155,165);Label.Font=Enum.Font.Code
    Label.TextSize=10;Label.TextXAlignment=Enum.TextXAlignment.Left;Label.BackgroundTransparency=1

    local ValLabel=Instance.new("TextLabel",Frame)
    ValLabel.Size=UDim2.new(.3,0,0,12);ValLabel.Position=UDim2.new(.7,0,0,0)
    ValLabel.Font=Enum.Font.Code;ValLabel.TextSize=10;ValLabel.TextXAlignment=Enum.TextXAlignment.Right
    ValLabel.BackgroundTransparency=1;RegText(ValLabel)

    local Bar=Instance.new("Frame",Frame)
    Bar.Size=UDim2.new(1,0,0,4);Bar.Position=UDim2.new(0,0,0,15)
    Bar.BackgroundColor3=Color3.fromRGB(28,32,38);Bar.BorderSizePixel=0

    local Fill=Instance.new("Frame",Bar);Fill.BorderSizePixel=0;RegBg(Fill)
    local Btn=Instance.new("TextButton",Bar);Btn.Size=UDim2.new(1,0,1,0);Btn.BackgroundTransparency=1;Btn.Text=""

    local function SetValue(val)
        val=math.clamp(math.floor(val),min,max)
        Fill.Size=UDim2.new((val-min)/(max-min),0,1,0)
        ValLabel.Text=tostring(val);pcall(callback,val)
    end
    SetValue(default)

    local dragging=false
    Btn.InputBegan:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
            dragging=true
            SetValue(min+(max-min)*math.clamp((input.Position.X-Bar.AbsolutePosition.X)/Bar.AbsoluteSize.X,0,1))
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then dragging=false end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and(input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch)then
            SetValue(min+(max-min)*math.clamp((input.Position.X-Bar.AbsolutePosition.X)/Bar.AbsoluteSize.X,0,1))
        end
    end)
end

local CombatTab=CreateTab("Combat")
local VisTab=CreateTab("Visuals")
local MoveTab=CreateTab("Movement")
local ThemeTab=CreateTab("Themes")
local ConfigTab=CreateTab("Configs")
Tabs.Combat.Page.Visible=true;activeTabBtn=Tabs.Combat.Btn;activeTabBtn.TextColor3=CFG.Accent

local CombSec1=CreateSection(CombatTab,"Hard Aimbot",UDim2.new(.48,0,1,0),UDim2.new(0,0,0,0))
local CombSec2=CreateSection(CombatTab,"Hitbox Expansion",UDim2.new(.49,0,1,0),UDim2.new(.51,0,0,0))

AddToggle(CombSec1,"Enable Aimbot",CFG.AimEnabled,function(v)CFG.AimEnabled=v;FOVCircle.Visible=v end)

local TargetBtn=Instance.new("TextButton",CombSec1)
TargetBtn.Size=UDim2.new(1,-4,0,20);TargetBtn.BackgroundColor3=Color3.fromRGB(28,32,38)
TargetBtn.Text="Target Part: "..CFG.AimPart;TargetBtn.Font=Enum.Font.Code;TargetBtn.TextSize=11
RegText(TargetBtn)
TargetBtn.MouseButton1Click:Connect(function()
    CFG.AimPart=CFG.AimPart=="Head" and "HumanoidRootPart" or "Head"
    TargetBtn.Text="Target Part: "..CFG.AimPart
end)

AddSlider(CombSec1,"FOV Size",40,450,CFG.AimFOV,function(v)CFG.AimFOV=v;FOVCircle.Size=UDim2.new(0,v*2,0,v*2)end)
AddToggle(CombSec2,"Enable Hitbox",CFG.HitboxEnabled,function(v)CFG.HitboxEnabled=v end)
AddSlider(CombSec2,"Hitbox Size",2,30,CFG.HitboxSize,function(v)CFG.HitboxSize=v end)
AddToggle(CombSec2,"Visible Hitbox",CFG.HitboxVis,function(v)CFG.HitboxVis=v end)

local VisSec1=CreateSection(VisTab,"Visual Options",UDim2.new(.98,0,1,0),UDim2.new(0,0,0,0))
AddToggle(VisSec1,"Chams ESP",CFG.ESP,function(v)CFG.ESP=v end)

local MoveSec1=CreateSection(MoveTab,"Speed & Jump",UDim2.new(.48,0,1,0),UDim2.new(0,0,0,0))
local MoveSec2=CreateSection(MoveTab,"Fly & Bhop",UDim2.new(.49,0,1,0),UDim2.new(.51,0,0,0))
AddToggle(MoveSec1,"Speedhack",CFG.Speed,function(v)CFG.Speed=v end)
AddSlider(MoveSec1,"WalkSpeed",16,200,CFG.SpeedVal,function(v)CFG.SpeedVal=v end)
AddToggle(MoveSec1,"Jump Boost",CFG.Jump,function(v)CFG.Jump=v end)
AddSlider(MoveSec1,"JumpPower",50,300,CFG.JumpVal,function(v)CFG.JumpVal=v end)
AddToggle(MoveSec2,"Fly Hack",CFG.Fly,function(v)CFG.Fly=v end)
AddSlider(MoveSec2,"Fly Speed",10,200,CFG.FlySpeed,function(v)CFG.FlySpeed=v end)
AddToggle(MoveSec2,"Auto Bhop",CFG.Bhop,function(v)CFG.Bhop=v end)

local ThemeSec=CreateSection(ThemeTab,"Customization & UI Size",UDim2.new(.98,0,1,0),UDim2.new(0,0,0,0))
local PresetBtn=Instance.new("TextButton",ThemeSec)
PresetBtn.Size=UDim2.new(1,-4,0,22);PresetBtn.BackgroundColor3=Color3.fromRGB(25,28,35)
PresetBtn.Text="Preset: Neverlose Blue";PresetBtn.Font=Enum.Font.Code;PresetBtn.TextSize=11;RegText(PresetBtn)

local presets={
    {name="Neverlose Blue",color=Color3.fromRGB(0,150,255)},
    {name="Crimson Red",color=Color3.fromRGB(255,40,60)},
    {name="Neon Green",color=Color3.fromRGB(0,230,120)},
    {name="Purple Glow",color=Color3.fromRGB(170,60,255)},
    {name="Pink Style",color=Color3.fromRGB(255,105,180)}
}
local pIdx=1
PresetBtn.MouseButton1Click:Connect(function()
    pIdx=pIdx%#presets+1
    local p=presets[pIdx];PresetBtn.Text="Preset: "..p.name;UpdateTheme(p.color)
end)

AddSlider(ThemeSec,"Menu Width",320,600,CFG.MenuWidth,function(v)CFG.MenuWidth=v;UpdateMenuSize()end)
AddSlider(ThemeSec,"Menu Height",200,450,CFG.MenuHeight,function(v)CFG.MenuHeight=v;UpdateMenuSize()end)

local ConfigSec=CreateSection(ConfigTab,"Config Manager",UDim2.new(.98,0,1,0),UDim2.new(0,0,0,0))
local SaveBtn=Instance.new("TextButton",ConfigSec)
SaveBtn.Size=UDim2.new(1,-4,0,22);SaveBtn.BackgroundColor3=Color3.fromRGB(25,28,35)
SaveBtn.Text="Save Config";SaveBtn.Font=Enum.Font.Code;SaveBtn.TextSize=11;RegText(SaveBtn)
SaveBtn.MouseButton1Click:Connect(function()SaveBtn.Text="Config Saved!";task.wait(1);SaveBtn.Text="Save Config"end)

RunService.RenderStepped:Connect(function()
    pcall(function()
        local Char=LocalPlayer.Character;if not Char then return end
        local Hum=Char:FindFirstChildOfClass("Humanoid")
        local HRP=Char:FindFirstChild("HumanoidRootPart")
        if Hum then
            if CFG.Speed then Hum.WalkSpeed=CFG.SpeedVal end
            if CFG.Jump then Hum.UseJumpPower=true;Hum.JumpPower=CFG.JumpVal end
            if CFG.Bhop and Hum.FloorMaterial~=Enum.Material.Air then Hum:ChangeState(Enum.HumanoidStateType.Jumping)end
        end
        if CFG.Fly and HRP then
            HRP.AssemblyLinearVelocity=Vector3.zero
            HRP.CFrame=HRP.CFrame+((Hum and Hum.MoveDirection or Vector3.zero)*(CFG.FlySpeed/10))
        end
        if CFG.AimEnabled then
            local closestTarget,minMouseDist=nil,CFG.AimFOV
            local centerPos=Vector2.new(Camera.ViewportSize.X/2,Camera.ViewportSize.Y/2)
            for _,plr in pairs(Players:GetPlayers())do
                if plr~=LocalPlayer and plr.Character then
                    local targetPart=plr.Character:FindFirstChild(CFG.AimPart)or plr.Character:FindFirstChild("Head")
                    local hum=plr.Character:FindFirstChildOfClass("Humanoid")
                    if targetPart and hum and hum.Health>0 then
                        local screenPos,onScreen=Camera:WorldToViewportPoint(targetPart.Position)
                        if onScreen then
                            local mouseDist=(Vector2.new(screenPos.X,screenPos.Y)-centerPos).Magnitude
                            if mouseDist<minMouseDist then minMouseDist=mouseDist;closestTarget=targetPart end
                        end
                    end
                end
            end
            if closestTarget then Camera.CFrame=CFrame.new(Camera.CFrame.Position,closestTarget.Position)end
        end
        for _,plr in pairs(Players:GetPlayers())do
            if plr~=LocalPlayer and plr.Character then
                local tHRP=plr.Character:FindFirstChild("HumanoidRootPart")
                local tHum=plr.Character:FindFirstChildOfClass("Humanoid")
                if tHRP then
                    if CFG.HitboxEnabled then
                        tHRP.Size=Vector3.new(CFG.HitboxSize,CFG.HitboxSize,CFG.HitboxSize)
                        tHRP.Transparency=CFG.HitboxVis and .5 or 1
                        tHRP.Color=CFG.Accent;tHRP.CanCollide=false
                    end
                    local hl=plr.Character:FindFirstChild("NL_ESP")
                    if CFG.ESP and tHum and tHum.Health>0 then
                        if not hl then
                            hl=Instance.new("Highlight");hl.Name="NL_ESP"
                            hl.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop;hl.Parent=plr.Character
                        end
                        hl.FillColor=CFG.Accent;hl.OutlineColor=CFG.Accent
                        hl.FillTransparency=.5;hl.OutlineTransparency=0;hl.Enabled=true
                    elseif hl then hl:Destroy()end
                end
            end
        end
    end)
end)
