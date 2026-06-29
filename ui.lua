-- ==================== UI FRAMEWORK ====================
local UI = {}
local Players       = game:GetService("Players")
local RunService    = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService  = game:GetService("TweenService")
local lp            = Players.LocalPlayer
local mouse         = lp:GetMouse()

-- Couleurs par défaut (modifiables dans Settings)
UI.Theme = {
    Background    = Color3.fromRGB(15, 15, 20),
    TopBar        = Color3.fromRGB(20, 20, 30),
    Accent        = Color3.fromRGB(100, 60, 255),
    AccentHover   = Color3.fromRGB(120, 80, 255),
    Text          = Color3.fromRGB(240, 240, 240),
    SubText       = Color3.fromRGB(160, 160, 180),
    Toggle_On     = Color3.fromRGB(100, 60, 255),
    Toggle_Off    = Color3.fromRGB(50, 50, 65),
    Button        = Color3.fromRGB(30, 30, 42),
    ButtonHover   = Color3.fromRGB(45, 45, 60),
    Section       = Color3.fromRGB(22, 22, 32),
    Slider_BG     = Color3.fromRGB(35, 35, 50),
    Slider_Fill   = Color3.fromRGB(100, 60, 255),
    Border        = Color3.fromRGB(55, 55, 75),
    Separator     = Color3.fromRGB(40, 40, 55),
    Notification  = Color3.fromRGB(25, 25, 38),
}

-- ScreenGui root
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RivalsCheat"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = gethui and gethui() or game:GetService("CoreGui")

-- Fenêtre principale
local MainFrame = Instance.new("Frame")
MainFrame.Name = "Main"
MainFrame.Size = UDim2.new(0, 620, 0, 420)
MainFrame.Position = UDim2.new(0.5, -310, 0.5, -210)
MainFrame.BackgroundColor3 = UI.Theme.Background
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 4)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = UI.Theme.Border
MainStroke.Thickness = 1
MainStroke.Parent = MainFrame

-- Topbar
local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 36)
TopBar.BackgroundColor3 = UI.Theme.TopBar
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 4)
TopCorner.Parent = TopBar

-- Fix coin bas du topbar
local TopFix = Instance.new("Frame")
TopFix.Size = UDim2.new(1, 0, 0, 8)
TopFix.Position = UDim2.new(0, 0, 1, -8)
TopFix.BackgroundColor3 = UI.Theme.TopBar
TopFix.BorderSizePixel = 0
TopFix.Parent = TopBar

-- Titre
local Title = Instance.new("TextLabel")
Title.Text = "RIVALS  ·  CHEAT"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 13
Title.TextColor3 = UI.Theme.Text
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1, -80, 1, 0)
Title.Position = UDim2.new(0, 14, 0, 0)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

-- Accent line sous titre
local AccentLine = Instance.new("Frame")
AccentLine.Size = UDim2.new(0, 3, 0, 16)
AccentLine.Position = UDim2.new(0, 6, 0.5, -8)
AccentLine.BackgroundColor3 = UI.Theme.Accent
AccentLine.BorderSizePixel = 0
AccentLine.Parent = TopBar

-- Bouton fermer
local CloseBtn = Instance.new("TextButton")
CloseBtn.Text = "✕"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 12
CloseBtn.TextColor3 = UI.Theme.SubText
CloseBtn.BackgroundTransparency = 1
CloseBtn.Size = UDim2.new(0, 36, 1, 0)
CloseBtn.Position = UDim2.new(1, -36, 0, 0)
CloseBtn.Parent = TopBar

CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- Bouton minimize
local MinBtn = Instance.new("TextButton")
MinBtn.Text = "—"
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 12
MinBtn.TextColor3 = UI.Theme.SubText
MinBtn.BackgroundTransparency = 1
MinBtn.Size = UDim2.new(0, 36, 1, 0)
MinBtn.Position = UDim2.new(1, -72, 0, 0)
MinBtn.Parent = TopBar

-- Drag
local dragging, dragStart, startPos = false, nil, nil
TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
end)

-- Minimize logic
local minimized = false
MinBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        TweenService:Create(MainFrame, TweenInfo.new(0.2), {Size = UDim2.new(0, 620, 0, 36)}):Play()
    else
        TweenService:Create(MainFrame, TweenInfo.new(0.2), {Size = UDim2.new(0, 620, 0, 420)}):Play()
    end
end)

-- Toggle avec INSERT
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.Insert then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

-- ========== TABS ==========
local TabBar = Instance.new("Frame")
TabBar.Name = "TabBar"
TabBar.Size = UDim2.new(0, 115, 1, -36)
TabBar.Position = UDim2.new(0, 0, 0, 36)
TabBar.BackgroundColor3 = UI.Theme.TopBar
TabBar.BorderSizePixel = 0
TabBar.Parent = MainFrame

local TabList = Instance.new("UIListLayout")
TabList.Padding = UDim.new(0, 2)
TabList.Parent = TabBar

local TabPadding = Instance.new("UIPadding")
TabPadding.PaddingTop = UDim.new(0, 8)
TabPadding.PaddingLeft = UDim.new(0, 6)
TabPadding.PaddingRight = UDim.new(0, 6)
TabPadding.Parent = TabBar

-- Séparateur
local Sep = Instance.new("Frame")
Sep.Size = UDim2.new(0, 1, 1, -36)
Sep.Position = UDim2.new(0, 115, 0, 36)
Sep.BackgroundColor3 = UI.Theme.Border
Sep.BorderSizePixel = 0
Sep.Parent = MainFrame

-- Contenu
local ContentArea = Instance.new("Frame")
ContentArea.Name = "Content"
ContentArea.Size = UDim2.new(1, -116, 1, -36)
ContentArea.Position = UDim2.new(0, 116, 0, 36)
ContentArea.BackgroundTransparency = 1
ContentArea.BorderSizePixel = 0
ContentArea.Parent = MainFrame

-- ========== CRÉER UN ONGLET ==========
UI.Tabs = {}
UI.ActiveTab = nil

function UI:CreateTab(name, icon)
    local TabBtn = Instance.new("TextButton")
    TabBtn.Name = name
    TabBtn.Text = (icon or "") .. "  " .. name
    TabBtn.Font = Enum.Font.Gotham
    TabBtn.TextSize = 11
    TabBtn.TextColor3 = UI.Theme.SubText
    TabBtn.TextXAlignment = Enum.TextXAlignment.Left
    TabBtn.BackgroundColor3 = Color3.fromRGB(0,0,0)
    TabBtn.BackgroundTransparency = 1
    TabBtn.Size = UDim2.new(1, 0, 0, 30)
    TabBtn.BorderSizePixel = 0
    TabBtn.Parent = TabBar

    local TabCorner = Instance.new("UICorner")
    TabCorner.CornerRadius = UDim.new(0, 4)
    TabCorner.Parent = TabBtn

    local ActiveBar = Instance.new("Frame")
    ActiveBar.Size = UDim2.new(0, 3, 0, 18)
    ActiveBar.Position = UDim2.new(0, -2, 0.5, -9)
    ActiveBar.BackgroundColor3 = UI.Theme.Accent
    ActiveBar.BorderSizePixel = 0
    ActiveBar.Visible = false
    Instance.new("UICorner", ActiveBar).CornerRadius = UDim.new(0, 2)
    ActiveBar.Parent = TabBtn

    -- ScrollFrame pour contenu
    local ScrollFrame = Instance.new("ScrollingFrame")
    ScrollFrame.Name = name .. "_Content"
    ScrollFrame.Size = UDim2.new(1, 0, 1, 0)
    ScrollFrame.BackgroundTransparency = 1
    ScrollFrame.BorderSizePixel = 0
    ScrollFrame.ScrollBarThickness = 3
    ScrollFrame.ScrollBarImageColor3 = UI.Theme.Accent
    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    ScrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    ScrollFrame.Visible = false
    ScrollFrame.Parent = ContentArea

    local ListLayout = Instance.new("UIListLayout")
    ListLayout.Padding = UDim.new(0, 6)
    ListLayout.Parent = ScrollFrame

    local Padding = Instance.new("UIPadding")
    Padding.PaddingTop = UDim.new(0, 10)
    Padding.PaddingLeft = UDim.new(0, 10)
    Padding.PaddingRight = UDim.new(0, 10)
    Padding.Parent = ScrollFrame

    local Tab = {
        Button = TabBtn,
        Content = ScrollFrame,
        ActiveBar = ActiveBar,
    }

    TabBtn.MouseButton1Click:Connect(function()
        UI:SelectTab(name)
    end)

    UI.Tabs[name] = Tab
    if not UI.ActiveTab then UI:SelectTab(name) end
    return Tab
end

function UI:SelectTab(name)
    for tname, tab in pairs(UI.Tabs) do
        local active = (tname == name)
        tab.Content.Visible = active
        tab.ActiveBar.Visible = active
        tab.Button.TextColor3 = active and UI.Theme.Text or UI.Theme.SubText
        tab.Button.BackgroundTransparency = active and 0.85 or 1
        tab.Button.BackgroundColor3 = active and UI.Theme.Accent or Color3.fromRGB(0,0,0)
    end
    UI.ActiveTab = name
end

-- ========== COMPOSANTS ==========

-- Section header
function UI:AddSection(tab, text)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 0, 22)
    Frame.BackgroundTransparency = 1
    Frame.BorderSizePixel = 0
    Frame.Parent = tab.Content

    local Line = Instance.new("Frame")
    Line.Size = UDim2.new(1, 0, 0, 1)
    Line.Position = UDim2.new(0, 0, 1, -1)
    Line.BackgroundColor3 = UI.Theme.Separator
    Line.BorderSizePixel = 0
    Line.Parent = Frame

    local Label = Instance.new("TextLabel")
    Label.Text = text:upper()
    Label.Font = Enum.Font.GothamBold
    Label.TextSize = 9
    Label.TextColor3 = UI.Theme.Accent
    Label.BackgroundTransparency = 1
    Label.Size = UDim2.new(1, 0, 1, 0)
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Frame
    return Frame
end

-- Toggle
function UI:AddToggle(tab, text, default, callback)
    local val = default or false

    local Row = Instance.new("Frame")
    Row.Size = UDim2.new(1, 0, 0, 28)
    Row.BackgroundColor3 = UI.Theme.Section
    Row.BorderSizePixel = 0
    Row.Parent = tab.Content
    Instance.new("UICorner", Row).CornerRadius = UDim.new(0, 4)

    local Label = Instance.new("TextLabel")
    Label.Text = text
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 11
    Label.TextColor3 = UI.Theme.Text
    Label.BackgroundTransparency = 1
    Label.Size = UDim2.new(1, -50, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Row

    local ToggleBG = Instance.new("Frame")
    ToggleBG.Size = UDim2.new(0, 32, 0, 16)
    ToggleBG.Position = UDim2.new(1, -42, 0.5, -8)
    ToggleBG.BackgroundColor3 = val and UI.Theme.Toggle_On or UI.Theme.Toggle_Off
    ToggleBG.BorderSizePixel = 0
    ToggleBG.Parent = Row
    Instance.new("UICorner", ToggleBG).CornerRadius = UDim.new(1, 0)

    local Knob = Instance.new("Frame")
    Knob.Size = UDim2.new(0, 12, 0, 12)
    Knob.Position = val and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
    Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Knob.BorderSizePixel = 0
    Knob.Parent = ToggleBG
    Instance.new("UICorner", Knob).CornerRadius = UDim.new(1, 0)

    local Btn = Instance.new("TextButton")
    Btn.Text = ""
    Btn.BackgroundTransparency = 1
    Btn.Size = UDim2.new(1, 0, 1, 0)
    Btn.Parent = Row

    local toggle = {Value = val}

    local function updateVisual()
        TweenService:Create(ToggleBG, TweenInfo.new(0.15), {
            BackgroundColor3 = toggle.Value and UI.Theme.Toggle_On or UI.Theme.Toggle_Off
        }):Play()
        TweenService:Create(Knob, TweenInfo.new(0.15), {
            Position = toggle.Value and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
        }):Play()
    end

    Btn.MouseButton1Click:Connect(function()
        toggle.Value = not toggle.Value
        updateVisual()
        if callback then callback(toggle.Value) end
    end)

    updateVisual()
    return toggle
end

-- Slider
function UI:AddSlider(tab, text, min, max, default, suffix, callback)
    local val = default or min

    local Container = Instance.new("Frame")
    Container.Size = UDim2.new(1, 0, 0, 42)
    Container.BackgroundColor3 = UI.Theme.Section
    Container.BorderSizePixel = 0
    Container.Parent = tab.Content
    Instance.new("UICorner", Container).CornerRadius = UDim.new(0, 4)

    local Label = Instance.new("TextLabel")
    Label.Text = text
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 11
    Label.TextColor3 = UI.Theme.Text
    Label.BackgroundTransparency = 1
    Label.Size = UDim2.new(1, -60, 0, 20)
    Label.Position = UDim2.new(0, 10, 0, 4)
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Container

    local ValLabel = Instance.new("TextLabel")
    ValLabel.Text = tostring(val) .. (suffix or "")
    ValLabel.Font = Enum.Font.GothamBold
    ValLabel.TextSize = 10
    ValLabel.TextColor3 = UI.Theme.Accent
    ValLabel.BackgroundTransparency = 1
    ValLabel.Size = UDim2.new(0, 55, 0, 20)
    ValLabel.Position = UDim2.new(1, -65, 0, 4)
    ValLabel.TextXAlignment = Enum.TextXAlignment.Right
    ValLabel.Parent = Container

    local Track = Instance.new("Frame")
    Track.Size = UDim2.new(1, -20, 0, 4)
    Track.Position = UDim2.new(0, 10, 0, 30)
    Track.BackgroundColor3 = UI.Theme.Slider_BG
    Track.BorderSizePixel = 0
    Track.Parent = Container
    Instance.new("UICorner", Track).CornerRadius = UDim.new(1, 0)

    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new((val - min) / (max - min), 0, 1, 0)
    Fill.BackgroundColor3 = UI.Theme.Slider_Fill
    Fill.BorderSizePixel = 0
    Fill.Parent = Track
    Instance.new("UICorner", Fill).CornerRadius = UDim.new(1, 0)

    local Thumb = Instance.new("Frame")
    Thumb.Size = UDim2.new(0, 10, 0, 10)
    Thumb.Position = UDim2.new((val - min) / (max - min), -5, 0.5, -5)
    Thumb.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Thumb.BorderSizePixel = 0
    Thumb.Parent = Track
    Instance.new("UICorner", Thumb).CornerRadius = UDim.new(1, 0)

    local SliderBtn = Instance.new("TextButton")
    SliderBtn.Text = ""
    SliderBtn.BackgroundTransparency = 1
    SliderBtn.Size = UDim2.new(1, 0, 0, 20)
    SliderBtn.Position = UDim2.new(0, 0, 0, 22)
    SliderBtn.Parent = Container

    local slider = {Value = val}
    local sliding = false

    local function update(inputX)
        local trackPos = Track.AbsolutePosition.X
        local trackSize = Track.AbsoluteSize.X
        local rel = math.clamp((inputX - trackPos) / trackSize, 0, 1)
        local newVal = math.floor(min + rel * (max - min))
        slider.Value = newVal
        ValLabel.Text = tostring(newVal) .. (suffix or "")
        Fill.Size = UDim2.new(rel, 0, 1, 0)
        Thumb.Position = UDim2.new(rel, -5, 0.5, -5)
        if callback then callback(newVal) end
    end

    SliderBtn.MouseButton1Down:Connect(function()
        sliding = true
        update(mouse.X)
    end)

    UserInputService.InputChanged:Connect(function(input)
        if sliding and input.UserInputType == Enum.UserInputType.MouseMovement then
            update(input.Position.X)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then sliding = false end
    end)

    return slider
end

-- Dropdown
function UI:AddDropdown(tab, text, options, default, callback)
    local selected = default or options[1]
    local open = false

    local Container = Instance.new("Frame")
    Container.Size = UDim2.new(1, 0, 0, 28)
    Container.BackgroundColor3 = UI.Theme.Section
    Container.BorderSizePixel = 0
    Container.ClipsDescendants = false
    Container.Parent = tab.Content
    Instance.new("UICorner", Container).CornerRadius = UDim.new(0, 4)
    Container.ZIndex = 10

    local Label = Instance.new("TextLabel")
    Label.Text = text
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 11
    Label.TextColor3 = UI.Theme.Text
    Label.BackgroundTransparency = 1
    Label.Size = UDim2.new(0.5, 0, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.ZIndex = 11
    Label.Parent = Container

    local DropBtn = Instance.new("TextButton")
    DropBtn.Text = selected .. "  ▾"
    DropBtn.Font = Enum.Font.Gotham
    DropBtn.TextSize = 10
    DropBtn.TextColor3 = UI.Theme.SubText
    DropBtn.BackgroundColor3 = UI.Theme.Button
    DropBtn.BorderSizePixel = 0
    DropBtn.Size = UDim2.new(0, 120, 0, 20)
    DropBtn.Position = UDim2.new(1, -130, 0.5, -10)
    DropBtn.ZIndex = 11
    DropBtn.Parent = Container
    Instance.new("UICorner", DropBtn).CornerRadius = UDim.new(0, 4)

    local DropList = Instance.new("Frame")
    DropList.Size = UDim2.new(0, 120, 0, #options * 24 + 4)
    DropList.Position = UDim2.new(1, -130, 1, 2)
    DropList.BackgroundColor3 = UI.Theme.Button
    DropList.BorderSizePixel = 0
    DropList.Visible = false
    DropList.ZIndex = 50
    DropList.Parent = Container
    Instance.new("UICorner", DropList).CornerRadius = UDim.new(0, 4)
    Instance.new("UIListLayout", DropList).Padding = UDim.new(0, 2)

    local dd = {Value = selected}

    for _, opt in ipairs(options) do
        local OptBtn = Instance.new("TextButton")
        OptBtn.Text = opt
        OptBtn.Font = Enum.Font.Gotham
        OptBtn.TextSize = 10
        OptBtn.TextColor3 = UI.Theme.Text
        OptBtn.BackgroundTransparency = 1
        OptBtn.Size = UDim2.new(1, 0, 0, 22)
        OptBtn.ZIndex = 51
        OptBtn.Parent = DropList
        OptBtn.MouseButton1Click:Connect(function()
            dd.Value = opt
            DropBtn.Text = opt .. "  ▾"
            DropList.Visible = false
            open = false
            if callback then callback(opt) end
        end)
    end

    DropBtn.MouseButton1Click:Connect(function()
        open = not open
        DropList.Visible = open
    end)

    return dd
end

-- Bouton simple
function UI:AddButton(tab, text, callback)
    local Btn = Instance.new("TextButton")
    Btn.Text = text
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 11
    Btn.TextColor3 = UI.Theme.Text
    Btn.BackgroundColor3 = UI.Theme.Button
    Btn.BorderSizePixel = 0
    Btn.Size = UDim2.new(1, 0, 0, 28)
    Btn.Parent = tab.Content
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 4)

    Btn.MouseEnter:Connect(function()
        TweenService:Create(Btn, TweenInfo.new(0.1), {BackgroundColor3 = UI.Theme.ButtonHover}):Play()
    end)
    Btn.MouseLeave:Connect(function()
        TweenService:Create(Btn, TweenInfo.new(0.1), {BackgroundColor3 = UI.Theme.Button}):Play()
    end)
    Btn.MouseButton1Click:Connect(function()
        if callback then callback() end
    end)
    return Btn
end

-- Color Picker (simple RGB sliders)
function UI:AddColorPicker(tab, text, default, callback)
    local col = default or Color3.fromRGB(255, 255, 255)
    local r, g, b = math.floor(col.R * 255), math.floor(col.G * 255), math.floor(col.B * 255)

    local Container = Instance.new("Frame")
    Container.Size = UDim2.new(1, 0, 0, 110)
    Container.BackgroundColor3 = UI.Theme.Section
    Container.BorderSizePixel = 0
    Container.Parent = tab.Content
    Instance.new("UICorner", Container).CornerRadius = UDim.new(0, 4)
    Instance.new("UIListLayout", Container).Padding = UDim.new(0, 2)

    local Header = Instance.new("Frame")
    Header.Size = UDim2.new(1, 0, 0, 26)
    Header.BackgroundTransparency = 1
    Header.Parent = Container

    local HLabel = Instance.new("TextLabel")
    HLabel.Text = text
    HLabel.Font = Enum.Font.Gotham
    HLabel.TextSize = 11
    HLabel.TextColor3 = UI.Theme.Text
    HLabel.BackgroundTransparency = 1
    HLabel.Size = UDim2.new(1, -40, 1, 0)
    HLabel.Position = UDim2.new(0, 10, 0, 0)
    HLabel.TextXAlignment = Enum.TextXAlignment.Left
    HLabel.Parent = Header

    local Preview = Instance.new("Frame")
    Preview.Size = UDim2.new(0, 24, 0, 14)
    Preview.Position = UDim2.new(1, -34, 0.5, -7)
    Preview.BackgroundColor3 = col
    Preview.BorderSizePixel = 0
    Preview.Parent = Header
    Instance.new("UICorner", Preview).CornerRadius = UDim.new(0, 3)

    local cp = {Value = col}

    local function update()
        cp.Value = Color3.fromRGB(r, g, b)
        Preview.BackgroundColor3 = cp.Value
        if callback then callback(cp.Value) end
    end

    local function addChan(parent, name, getVal, setVal)
        local F = Instance.new("Frame")
        F.Size = UDim2.new(1, 0, 0, 22)
        F.BackgroundTransparency = 1
        F.Parent = parent

        local L = Instance.new("TextLabel")
        L.Text = name
        L.Font = Enum.Font.Gotham
        L.TextSize = 9
        L.TextColor3 = UI.Theme.SubText
        L.BackgroundTransparency = 1
        L.Size = UDim2.new(0, 16, 1, 0)
        L.Position = UDim2.new(0, 10, 0, 0)
        L.TextXAlignment = Enum.TextXAlignment.Left
        L.Parent = F

        local Track = Instance.new("Frame")
        Track.Size = UDim2.new(1, -60, 0, 4)
        Track.Position = UDim2.new(0, 28, 0.5, -2)
        Track.BackgroundColor3 = UI.Theme.Slider_BG
        Track.BorderSizePixel = 0
        Track.Parent = F
        Instance.new("UICorner", Track).CornerRadius = UDim.new(1, 0)

        local Fill = Instance.new("Frame")
        Fill.Size = UDim2.new(getVal() / 255, 0, 1, 0)
        Fill.BackgroundColor3 = UI.Theme.Accent
        Fill.BorderSizePixel = 0
        Fill.Parent = Track
        Instance.new("UICorner", Fill).CornerRadius = UDim.new(1, 0)

        local VL = Instance.new("TextLabel")
        VL.Text = tostring(getVal())
        VL.Font = Enum.Font.Gotham
        VL.TextSize = 9
        VL.TextColor3 = UI.Theme.Accent
        VL.BackgroundTransparency = 1
        VL.Size = UDim2.new(0, 28, 1, 0)
        VL.Position = UDim2.new(1, -30, 0, 0)
        VL.TextXAlignment = Enum.TextXAlignment.Right
        VL.Parent = F

        local sliding = false
        local Btn = Instance.new("TextButton")
        Btn.Text = ""
        Btn.BackgroundTransparency = 1
        Btn.Size = UDim2.new(1, 0, 1, 0)
        Btn.Parent = F

        Btn.MouseButton1Down:Connect(function()
            sliding = true
            local rel = math.clamp((mouse.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
            setVal(math.floor(rel * 255))
            Fill.Size = UDim2.new(rel, 0, 1, 0)
            VL.Text = tostring(getVal())
            update()
        end)

        UserInputService.InputChanged:Connect(function(input)
            if sliding and input.UserInputType == Enum.UserInputType.MouseMovement then
                local rel = math.clamp((input.Position.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
                setVal(math.floor(rel * 255))
                Fill.Size = UDim2.new(rel, 0, 1, 0)
                VL.Text = tostring(getVal())
                update()
            end
        end)

        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then sliding = false end
        end)
    end

    addChan(Container, "R", function() return r end, function(v) r = v end)
    addChan(Container, "G", function() return g end, function(v) g = v end)
    addChan(Container, "B", function() return b end, function(v) b = v end)

    return cp
end

-- Keybind picker
function UI:AddKeybind(tab, text, default, callback)
    local key = default or Enum.KeyCode.Unknown
    local listening = false

    local Row = Instance.new("Frame")
    Row.Size = UDim2.new(1, 0, 0, 28)
    Row.BackgroundColor3 = UI.Theme.Section
    Row.BorderSizePixel = 0
    Row.Parent = tab.Content
    Instance.new("UICorner", Row).CornerRadius = UDim.new(0, 4)

    local Label = Instance.new("TextLabel")
    Label.Text = text
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 11
    Label.TextColor3 = UI.Theme.Text
    Label.BackgroundTransparency = 1
    Label.Size = UDim2.new(1, -80, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Row

    local KeyBtn = Instance.new("TextButton")
    KeyBtn.Text = key.Name
    KeyBtn.Font = Enum.Font.GothamBold
    KeyBtn.TextSize = 10
    KeyBtn.TextColor3 = UI.Theme.Accent
    KeyBtn.BackgroundColor3 = UI.Theme.Button
    KeyBtn.BorderSizePixel = 0
    KeyBtn.Size = UDim2.new(0, 65, 0, 18)
    KeyBtn.Position = UDim2.new(1, -75, 0.5, -9)
    KeyBtn.Parent = Row
    Instance.new("UICorner", KeyBtn).CornerRadius = UDim.new(0, 3)

    local kb = {Value = key}

    KeyBtn.MouseButton1Click:Connect(function()
        listening = true
        KeyBtn.Text = "..."
        KeyBtn.TextColor3 = Color3.fromRGB(255, 200, 50)
    end)

    UserInputService.InputBegan:Connect(function(input, gpe)
        if listening and input.UserInputType == Enum.UserInputType.Keyboard then
            listening = false
            kb.Value = input.KeyCode
            KeyBtn.Text = input.KeyCode.Name
            KeyBtn.TextColor3 = UI.Theme.Accent
            if callback then callback(input.KeyCode) end
        end
    end)

    return kb
end

-- Notification système
function UI:Notify(title, desc, duration)
    duration = duration or 3
    local NFrame = Instance.new("Frame")
    NFrame.Size = UDim2.new(0, 240, 0, 60)
    NFrame.Position = UDim2.new(1, -250, 1, -70)
    NFrame.BackgroundColor3 = UI.Theme.Notification
    NFrame.BorderSizePixel = 0
    NFrame.Parent = ScreenGui
    Instance.new("UICorner", NFrame).CornerRadius = UDim.new(0, 4)

    local Stroke = Instance.new("UIStroke")
    Stroke.Color = UI.Theme.Accent
    Stroke.Thickness = 1
    Stroke.Parent = NFrame

    local T = Instance.new("TextLabel")
    T.Text = title
    T.Font = Enum.Font.GothamBold
    T.TextSize = 11
    T.TextColor3 = UI.Theme.Text
    T.BackgroundTransparency = 1
    T.Size = UDim2.new(1, -10, 0, 20)
    T.Position = UDim2.new(0, 8, 0, 6)
    T.TextXAlignment = Enum.TextXAlignment.Left
    T.Parent = NFrame

    local D = Instance.new("TextLabel")
    D.Text = desc
    D.Font = Enum.Font.Gotham
    D.TextSize = 10
    D.TextColor3 = UI.Theme.SubText
    D.BackgroundTransparency = 1
    D.Size = UDim2.new(1, -10, 0, 30)
    D.Position = UDim2.new(0, 8, 0, 24)
    D.TextXAlignment = Enum.TextXAlignment.Left
    D.TextWrapped = true
    D.Parent = NFrame

    TweenService:Create(NFrame, TweenInfo.new(0.3), {Position = UDim2.new(1, -250, 1, -80)}):Play()
    task.delay(duration, function()
        TweenService:Create(NFrame, TweenInfo.new(0.3), {Position = UDim2.new(1, 260, 1, -80)}):Play()
        task.delay(0.4, function() NFrame:Destroy() end)
    end)
end

return UI
