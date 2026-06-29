-- ==================== UwU - Rivals UI ====================
local UI = {}
local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService     = game:GetService("TweenService")
local lp               = Players.LocalPlayer
local mouse            = lp:GetMouse()

UI.Theme = {
    BG        = Color3.fromRGB(10, 10, 11),
    BG2       = Color3.fromRGB(14, 14, 15),
    BG3       = Color3.fromRGB(18, 18, 20),
    Border    = Color3.fromRGB(35, 35, 38),
    Accent    = Color3.fromRGB(200, 20, 20),
    AccentDim = Color3.fromRGB(120, 10, 10),
    Text      = Color3.fromRGB(230, 230, 230),
    TextDim   = Color3.fromRGB(140, 140, 140),
    TextOff   = Color3.fromRGB(90, 90, 90),
    SliderFill= Color3.fromRGB(200, 20, 20),
    CheckOn   = Color3.fromRGB(200, 20, 20),
    CheckOff  = Color3.fromRGB(18, 18, 20),
    Section   = Color3.fromRGB(200, 20, 20),
}

-- Root GUI
local gui = Instance.new("ScreenGui")
gui.Name = "UwU_Rivals"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
local ok = pcall(function() gui.Parent = game:GetService("CoreGui") end)
if not ok then gui.Parent = lp:WaitForChild("PlayerGui") end

-- Main window
local WIN_W, WIN_H = 700, 500
local Win = Instance.new("Frame")
Win.Name = "Window"
Win.Size = UDim2.new(0, WIN_W, 0, WIN_H)
Win.Position = UDim2.new(0.5, -WIN_W/2, 0.5, -WIN_H/2)
Win.BackgroundColor3 = UI.Theme.BG
Win.BorderSizePixel = 1
Win.BorderColor3 = UI.Theme.Accent
Win.ClipsDescendants = false
Win.Parent = gui

-- Left accent bar
local LeftBar = Instance.new("Frame")
LeftBar.Size = UDim2.new(0, 3, 1, 0)
LeftBar.BackgroundColor3 = UI.Theme.Accent
LeftBar.BorderSizePixel = 0
LeftBar.Parent = Win

-- Title bar
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 30)
TitleBar.BackgroundColor3 = UI.Theme.BG2
TitleBar.BorderSizePixel = 0
TitleBar.Parent = Win

local TitleSep = Instance.new("Frame")
TitleSep.Size = UDim2.new(1, 0, 0, 1)
TitleSep.Position = UDim2.new(0, 0, 1, -1)
TitleSep.BackgroundColor3 = UI.Theme.Accent
TitleSep.BorderSizePixel = 0
TitleSep.Parent = TitleBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Text = "UwU - Rivals"
TitleLabel.Font = Enum.Font.Code
TitleLabel.TextSize = 13
TitleLabel.TextColor3 = UI.Theme.Text
TitleLabel.BackgroundTransparency = 1
TitleLabel.Size = UDim2.new(1, -60, 1, 0)
TitleLabel.Position = UDim2.new(0, 10, 0, 0)
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TitleBar

-- Red X dot accent
local AccentDot = Instance.new("TextLabel")
AccentDot.Text = "-X"
AccentDot.Font = Enum.Font.Code
AccentDot.TextSize = 13
AccentDot.TextColor3 = UI.Theme.Accent
AccentDot.BackgroundTransparency = 1
AccentDot.Size = UDim2.new(0, 30, 1, 0)
AccentDot.Position = UDim2.new(0, 74, 0, 0)
AccentDot.TextXAlignment = Enum.TextXAlignment.Left
AccentDot.Parent = TitleBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Text = "✕"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 11
CloseBtn.TextColor3 = UI.Theme.Accent
CloseBtn.BackgroundTransparency = 1
CloseBtn.Size = UDim2.new(0, 30, 1, 0)
CloseBtn.Position = UDim2.new(1, -30, 0, 0)
CloseBtn.Parent = TitleBar
CloseBtn.MouseButton1Click:Connect(function() Win.Visible = false end)

-- Drag
local dragging, dragStart, startPos = false, nil, nil
TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true; dragStart = input.Position; startPos = Win.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local d = input.Position - dragStart
        Win.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
end)

-- INSERT toggle
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.Insert then Win.Visible = not Win.Visible end
end)

-- Tab bar
local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(1, 0, 0, 26)
TabBar.Position = UDim2.new(0, 0, 0, 30)
TabBar.BackgroundColor3 = UI.Theme.BG2
TabBar.BorderSizePixel = 0
TabBar.Parent = Win

local TabBarSep = Instance.new("Frame")
TabBarSep.Size = UDim2.new(1, 0, 0, 1)
TabBarSep.Position = UDim2.new(0, 0, 1, 0)
TabBarSep.BackgroundColor3 = UI.Theme.Border
TabBarSep.BorderSizePixel = 0
TabBarSep.Parent = TabBar

local TabLayout = Instance.new("UIListLayout")
TabLayout.FillDirection = Enum.FillDirection.Horizontal
TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabLayout.Parent = TabBar

-- Content area
local ContentArea = Instance.new("Frame")
ContentArea.Size = UDim2.new(1, 0, 1, -57)
ContentArea.Position = UDim2.new(0, 0, 0, 57)
ContentArea.BackgroundTransparency = 1
ContentArea.ClipsDescendants = true
ContentArea.Parent = Win

-- Footer
local Footer = Instance.new("Frame")
Footer.Size = UDim2.new(1, 0, 0, 1)
Footer.Position = UDim2.new(0, 0, 1, -1)
Footer.BackgroundColor3 = UI.Theme.Accent
Footer.BorderSizePixel = 0
Footer.Parent = Win

-- ===== TAB SYSTEM =====
UI.Tabs = {}
UI.ActiveTab = nil

function UI:CreateTab(name)
    local TabBtn = Instance.new("TextButton")
    TabBtn.Text = name
    TabBtn.Font = Enum.Font.Code
    TabBtn.TextSize = 10
    TabBtn.TextColor3 = UI.Theme.TextOff
    TabBtn.BackgroundTransparency = 1
    TabBtn.Size = UDim2.new(0, 0, 1, 0)
    TabBtn.AutomaticSize = Enum.AutomaticSize.X
    TabBtn.BorderSizePixel = 0
    TabBtn.Parent = TabBar

    local TabPad = Instance.new("UIPadding")
    TabPad.PaddingLeft = UDim.new(0, 12)
    TabPad.PaddingRight = UDim.new(0, 12)
    TabPad.Parent = TabBtn

    local ActiveLine = Instance.new("Frame")
    ActiveLine.Size = UDim2.new(1, 0, 0, 2)
    ActiveLine.Position = UDim2.new(0, 0, 1, -2)
    ActiveLine.BackgroundColor3 = UI.Theme.Accent
    ActiveLine.BorderSizePixel = 0
    ActiveLine.Visible = false
    ActiveLine.Parent = TabBtn

    -- Two-column scroll content
    local Page = Instance.new("Frame")
    Page.Name = "Page_" .. name
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.Parent = ContentArea

    local ColLeft = Instance.new("ScrollingFrame")
    ColLeft.Name = "Left"
    ColLeft.Size = UDim2.new(0.5, -2, 1, 0)
    ColLeft.Position = UDim2.new(0, 0, 0, 0)
    ColLeft.BackgroundTransparency = 1
    ColLeft.BorderSizePixel = 0
    ColLeft.ScrollBarThickness = 2
    ColLeft.ScrollBarImageColor3 = UI.Theme.Accent
    ColLeft.CanvasSize = UDim2.new(0, 0, 0, 0)
    ColLeft.AutomaticCanvasSize = Enum.AutomaticSize.Y
    ColLeft.Parent = Page

    local LL = Instance.new("UIListLayout")
    LL.Padding = UDim.new(0, 0)
    LL.Parent = ColLeft

    local ColRight = Instance.new("ScrollingFrame")
    ColRight.Name = "Right"
    ColRight.Size = UDim2.new(0.5, -2, 1, 0)
    ColRight.Position = UDim2.new(0.5, 2, 0, 0)
    ColRight.BackgroundTransparency = 1
    ColRight.BorderSizePixel = 0
    ColRight.ScrollBarThickness = 2
    ColRight.ScrollBarImageColor3 = UI.Theme.Accent
    ColRight.CanvasSize = UDim2.new(0, 0, 0, 0)
    ColRight.AutomaticCanvasSize = Enum.AutomaticSize.Y
    ColRight.Parent = Page

    local RL = Instance.new("UIListLayout")
    RL.Padding = UDim.new(0, 0)
    RL.Parent = ColRight

    local tab = {
        Button = TabBtn,
        Page = Page,
        Left = ColLeft,
        Right = ColRight,
        ActiveLine = ActiveLine,
    }

    TabBtn.MouseButton1Click:Connect(function() UI:SelectTab(name) end)

    UI.Tabs[name] = tab
    if not UI.ActiveTab then UI:SelectTab(name) end
    return tab
end

function UI:SelectTab(name)
    for tname, tab in pairs(UI.Tabs) do
        local active = (tname == name)
        tab.Page.Visible = active
        tab.ActiveLine.Visible = active
        tab.Button.TextColor3 = active and UI.Theme.Text or UI.Theme.TextOff
        tab.Button.BackgroundColor3 = active and Color3.fromRGB(20, 20, 22) or Color3.fromRGB(0,0,0)
        tab.Button.BackgroundTransparency = active and 0 or 1
    end
    UI.ActiveTab = name
end

-- ===== SECTION HEADER =====
function UI:AddSection(parent, text)
    local F = Instance.new("Frame")
    F.Size = UDim2.new(1, 0, 0, 22)
    F.BackgroundColor3 = UI.Theme.BG2
    F.BorderSizePixel = 0
    F.Parent = parent

    local LeftAccent = Instance.new("Frame")
    LeftAccent.Size = UDim2.new(0, 2, 1, 0)
    LeftAccent.BackgroundColor3 = UI.Theme.Accent
    LeftAccent.BorderSizePixel = 0
    LeftAccent.Parent = F

    local L = Instance.new("TextLabel")
    L.Text = text
    L.Font = Enum.Font.Code
    L.TextSize = 10
    L.TextColor3 = UI.Theme.Accent
    L.BackgroundTransparency = 1
    L.Size = UDim2.new(1, -8, 1, 0)
    L.Position = UDim2.new(0, 8, 0, 0)
    L.TextXAlignment = Enum.TextXAlignment.Left
    L.Parent = F

    local Sep = Instance.new("Frame")
    Sep.Size = UDim2.new(1, 0, 0, 1)
    Sep.Position = UDim2.new(0, 0, 1, 0)
    Sep.BackgroundColor3 = UI.Theme.Border
    Sep.BorderSizePixel = 0
    Sep.Parent = F

    return F
end

-- ===== CHECKBOX TOGGLE =====
function UI:AddToggle(parent, text, default, callback)
    local val = default or false

    local Row = Instance.new("Frame")
    Row.Size = UDim2.new(1, 0, 0, 22)
    Row.BackgroundTransparency = 1
    Row.Parent = parent

    local Pad = Instance.new("UIPadding")
    Pad.PaddingLeft = UDim.new(0, 8)
    Pad.Parent = Row

    local Check = Instance.new("Frame")
    Check.Size = UDim2.new(0, 12, 0, 12)
    Check.Position = UDim2.new(0, 0, 0.5, -6)
    Check.BackgroundColor3 = val and UI.Theme.CheckOn or UI.Theme.CheckOff
    Check.BorderColor3 = val and UI.Theme.Accent or UI.Theme.Border
    Check.BorderSizePixel = 1
    Check.Parent = Row

    local CheckMark = Instance.new("TextLabel")
    CheckMark.Text = val and "✓" or ""
    CheckMark.Font = Enum.Font.GothamBold
    CheckMark.TextSize = 9
    CheckMark.TextColor3 = Color3.fromRGB(255, 255, 255)
    CheckMark.BackgroundTransparency = 1
    CheckMark.Size = UDim2.new(1, 0, 1, 0)
    CheckMark.Parent = Check

    local Label = Instance.new("TextLabel")
    Label.Text = text
    Label.Font = Enum.Font.Code
    Label.TextSize = 10
    Label.TextColor3 = val and UI.Theme.Text or UI.Theme.TextDim
    Label.BackgroundTransparency = 1
    Label.Size = UDim2.new(1, -20, 1, 0)
    Label.Position = UDim2.new(0, 18, 0, 0)
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Row

    local Btn = Instance.new("TextButton")
    Btn.Text = ""
    Btn.BackgroundTransparency = 1
    Btn.Size = UDim2.new(1, 0, 1, 0)
    Btn.Parent = Row

    local toggle = {Value = val}

    Btn.MouseButton1Click:Connect(function()
        toggle.Value = not toggle.Value
        Check.BackgroundColor3 = toggle.Value and UI.Theme.CheckOn or UI.Theme.CheckOff
        Check.BorderColor3 = toggle.Value and UI.Theme.Accent or UI.Theme.Border
        CheckMark.Text = toggle.Value and "✓" or ""
        Label.TextColor3 = toggle.Value and UI.Theme.Text or UI.Theme.TextDim
        if callback then callback(toggle.Value) end
    end)

    return toggle
end

-- ===== SLIDER =====
function UI:AddSlider(parent, text, min, max, default, suffix, callback)
    local val = default or min
    suffix = suffix or ""

    local Container = Instance.new("Frame")
    Container.Size = UDim2.new(1, 0, 0, 38)
    Container.BackgroundTransparency = 1
    Container.Parent = parent

    local Pad = Instance.new("UIPadding")
    Pad.PaddingLeft = UDim.new(0, 8)
    Pad.PaddingRight = UDim.new(0, 8)
    Pad.Parent = Container

    local Label = Instance.new("TextLabel")
    Label.Text = text
    Label.Font = Enum.Font.Code
    Label.TextSize = 10
    Label.TextColor3 = UI.Theme.TextDim
    Label.BackgroundTransparency = 1
    Label.Size = UDim2.new(1, 0, 0, 16)
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Container

    local ValLabel = Instance.new("TextLabel")
    ValLabel.Text = tostring(val) .. "/" .. tostring(max) .. suffix
    ValLabel.Font = Enum.Font.Code
    ValLabel.TextSize = 9
    ValLabel.TextColor3 = UI.Theme.TextDim
    ValLabel.BackgroundTransparency = 1
    ValLabel.Size = UDim2.new(1, 0, 0, 16)
    ValLabel.TextXAlignment = Enum.TextXAlignment.Right
    ValLabel.Parent = Container

    local Track = Instance.new("Frame")
    Track.Size = UDim2.new(1, 0, 0, 2)
    Track.Position = UDim2.new(0, 0, 0, 28)
    Track.BackgroundColor3 = UI.Theme.Border
    Track.BorderSizePixel = 0
    Track.Parent = Container

    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new((val - min) / math.max(max - min, 1), 0, 1, 0)
    Fill.BackgroundColor3 = UI.Theme.SliderFill
    Fill.BorderSizePixel = 0
    Fill.Parent = Track

    local SliderBtn = Instance.new("TextButton")
    SliderBtn.Text = ""
    SliderBtn.BackgroundTransparency = 1
    SliderBtn.Size = UDim2.new(1, 0, 0, 20)
    SliderBtn.Position = UDim2.new(0, 0, 0, -10)
    SliderBtn.Parent = Track

    local slider = {Value = val}
    local sliding = false

    local function update(inputX)
        local rel = math.clamp((inputX - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
        local newVal = math.floor(min + rel * (max - min))
        slider.Value = newVal
        ValLabel.Text = tostring(newVal) .. "/" .. tostring(max) .. suffix
        Fill.Size = UDim2.new(rel, 0, 1, 0)
        if callback then callback(newVal) end
    end

    SliderBtn.MouseButton1Down:Connect(function() sliding = true; update(mouse.X) end)
    UserInputService.InputChanged:Connect(function(input)
        if sliding and input.UserInputType == Enum.UserInputType.MouseMovement then update(input.Position.X) end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then sliding = false end
    end)

    return slider
end

-- ===== DROPDOWN =====
function UI:AddDropdown(parent, text, options, default, callback)
    local selected = default or options[1]

    local Row = Instance.new("Frame")
    Row.Size = UDim2.new(1, 0, 0, 24)
    Row.BackgroundTransparency = 1
    Row.Parent = parent

    local Pad = Instance.new("UIPadding")
    Pad.PaddingLeft = UDim.new(0, 8)
    Pad.PaddingRight = UDim.new(0, 8)
    Pad.Parent = Row

    local Label = Instance.new("TextLabel")
    Label.Text = text
    Label.Font = Enum.Font.Code
    Label.TextSize = 10
    Label.TextColor3 = UI.Theme.TextDim
    Label.BackgroundTransparency = 1
    Label.Size = UDim2.new(0.5, 0, 1, 0)
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Row

    local DropBtn = Instance.new("TextButton")
    DropBtn.Text = selected .. " ▾"
    DropBtn.Font = Enum.Font.Code
    DropBtn.TextSize = 9
    DropBtn.TextColor3 = UI.Theme.Text
    DropBtn.BackgroundColor3 = UI.Theme.BG3
    DropBtn.BorderColor3 = UI.Theme.Border
    DropBtn.BorderSizePixel = 1
    DropBtn.Size = UDim2.new(0.5, 0, 0, 18)
    DropBtn.Position = UDim2.new(0.5, 0, 0.5, -9)
    DropBtn.Parent = Row

    local dd = {Value = selected}
    local open = false
    local dropFrame = nil

    DropBtn.MouseButton1Click:Connect(function()
        if open then
            if dropFrame then dropFrame:Destroy(); dropFrame = nil end
            open = false
            return
        end
        open = true
        local absPos = DropBtn.AbsolutePosition
        local absSize = DropBtn.AbsoluteSize

        dropFrame = Instance.new("Frame")
        dropFrame.Size = UDim2.new(0, absSize.X, 0, math.min(#options, 6) * 20)
        dropFrame.Position = UDim2.new(0, absPos.X, 0, absPos.Y + absSize.Y + 1)
        dropFrame.BackgroundColor3 = UI.Theme.BG3
        dropFrame.BorderColor3 = UI.Theme.Accent
        dropFrame.BorderSizePixel = 1
        dropFrame.ZIndex = 100
        dropFrame.Parent = gui

        local DL = Instance.new("UIListLayout")
        DL.Parent = dropFrame

        local scroll = Instance.new("ScrollingFrame")
        scroll.Size = UDim2.new(1, 0, 1, 0)
        scroll.BackgroundTransparency = 1
        scroll.BorderSizePixel = 0
        scroll.ScrollBarThickness = 2
        scroll.ScrollBarImageColor3 = UI.Theme.Accent
        scroll.CanvasSize = UDim2.new(0, 0, 0, #options * 20)
        scroll.ZIndex = 100
        scroll.Parent = dropFrame

        local SL = Instance.new("UIListLayout")
        SL.Parent = scroll

        for _, opt in ipairs(options) do
            local OptBtn = Instance.new("TextButton")
            OptBtn.Text = opt
            OptBtn.Font = Enum.Font.Code
            OptBtn.TextSize = 9
            OptBtn.TextColor3 = UI.Theme.Text
            OptBtn.BackgroundTransparency = 1
            OptBtn.Size = UDim2.new(1, 0, 0, 20)
            OptBtn.ZIndex = 101
            OptBtn.Parent = scroll

            OptBtn.MouseEnter:Connect(function()
                OptBtn.BackgroundTransparency = 0
                OptBtn.BackgroundColor3 = UI.Theme.AccentDim
            end)
            OptBtn.MouseLeave:Connect(function() OptBtn.BackgroundTransparency = 1 end)

            OptBtn.MouseButton1Click:Connect(function()
                dd.Value = opt
                DropBtn.Text = opt .. " ▾"
                if dropFrame then dropFrame:Destroy(); dropFrame = nil end
                open = false
                if callback then callback(opt) end
            end)
        end

        task.spawn(function()
            task.wait(0.05)
            local conn
            conn = UserInputService.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    task.wait(0.05)
                    if open and dropFrame then
                        dropFrame:Destroy(); dropFrame = nil; open = false
                    end
                    conn:Disconnect()
                end
            end)
        end)
    end)

    return dd
end

-- ===== BUTTON =====
function UI:AddButton(parent, text, callback)
    local Btn = Instance.new("TextButton")
    Btn.Text = text
    Btn.Font = Enum.Font.Code
    Btn.TextSize = 10
    Btn.TextColor3 = UI.Theme.TextDim
    Btn.BackgroundColor3 = UI.Theme.BG3
    Btn.BorderColor3 = UI.Theme.Border
    Btn.BorderSizePixel = 1
    Btn.Size = UDim2.new(1, -16, 0, 22)
    Btn.Parent = parent

    local Pad = Instance.new("UIPadding")
    Pad.PaddingLeft = UDim.new(0, 8)
    Pad.PaddingRight = UDim.new(0, 8)
    Pad.Parent = Btn

    Btn.MouseEnter:Connect(function()
        Btn.BackgroundColor3 = UI.Theme.AccentDim
        Btn.TextColor3 = UI.Theme.Text
    end)
    Btn.MouseLeave:Connect(function()
        Btn.BackgroundColor3 = UI.Theme.BG3
        Btn.TextColor3 = UI.Theme.TextDim
    end)
    Btn.MouseButton1Click:Connect(function()
        if callback then callback() end
    end)
    return Btn
end

-- ===== COLOR PICKER (RGB sliders) =====
function UI:AddColorPicker(parent, text, default, callback)
    local col = default or Color3.fromRGB(255, 255, 255)
    local r, g, b = math.floor(col.R*255), math.floor(col.G*255), math.floor(col.B*255)

    local Container = Instance.new("Frame")
    Container.Size = UDim2.new(1, 0, 0, 22)
    Container.BackgroundTransparency = 1
    Container.Parent = parent

    local Pad = Instance.new("UIPadding")
    Pad.PaddingLeft = UDim.new(0, 8)
    Pad.PaddingRight = UDim.new(0, 8)
    Pad.Parent = Container

    local Label = Instance.new("TextLabel")
    Label.Text = text
    Label.Font = Enum.Font.Code
    Label.TextSize = 10
    Label.TextColor3 = UI.Theme.TextDim
    Label.BackgroundTransparency = 1
    Label.Size = UDim2.new(1, -40, 1, 0)
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Container

    local Preview = Instance.new("Frame")
    Preview.Size = UDim2.new(0, 30, 0, 14)
    Preview.Position = UDim2.new(1, -30, 0.5, -7)
    Preview.BackgroundColor3 = col
    Preview.BorderColor3 = UI.Theme.Border
    Preview.BorderSizePixel = 1
    Preview.Parent = Container

    local cp = {Value = col}
    local editOpen = false
    local editFrame = nil

    local PvBtn = Instance.new("TextButton")
    PvBtn.Text = ""
    PvBtn.BackgroundTransparency = 1
    PvBtn.Size = UDim2.new(1, 0, 1, 0)
    PvBtn.Parent = Preview

    PvBtn.MouseButton1Click:Connect(function()
        if editOpen then
            if editFrame then editFrame:Destroy(); editFrame = nil end
            editOpen = false
            return
        end
        editOpen = true
        local abs = Preview.AbsolutePosition

        editFrame = Instance.new("Frame")
        editFrame.Size = UDim2.new(0, 160, 0, 90)
        editFrame.Position = UDim2.new(0, abs.X - 130, 0, abs.Y + 18)
        editFrame.BackgroundColor3 = UI.Theme.BG3
        editFrame.BorderColor3 = UI.Theme.Accent
        editFrame.BorderSizePixel = 1
        editFrame.ZIndex = 200
        editFrame.Parent = gui

        local EL = Instance.new("UIListLayout")
        EL.Padding = UDim.new(0, 2)
        EL.Parent = editFrame

        local EP = Instance.new("UIPadding")
        EP.PaddingTop = UDim.new(0, 6)
        EP.PaddingLeft = UDim.new(0, 8)
        EP.PaddingRight = UDim.new(0, 8)
        EP.Parent = editFrame

        local function addChan(lname, getV, setV)
            local CF = Instance.new("Frame")
            CF.Size = UDim2.new(1, 0, 0, 20)
            CF.BackgroundTransparency = 1
            CF.ZIndex = 200
            CF.Parent = editFrame

            local CL = Instance.new("TextLabel")
            CL.Text = lname
            CL.Font = Enum.Font.Code
            CL.TextSize = 9
            CL.TextColor3 = UI.Theme.TextDim
            CL.BackgroundTransparency = 1
            CL.Size = UDim2.new(0, 12, 1, 0)
            CL.ZIndex = 201
            CL.Parent = CF

            local CV = Instance.new("TextLabel")
            CV.Text = tostring(getV())
            CV.Font = Enum.Font.Code
            CV.TextSize = 9
            CV.TextColor3 = UI.Theme.Text
            CV.BackgroundTransparency = 1
            CV.Size = UDim2.new(0, 26, 1, 0)
            CV.Position = UDim2.new(1, -26, 0, 0)
            CV.TextXAlignment = Enum.TextXAlignment.Right
            CV.ZIndex = 201
            CV.Parent = CF

            local CT = Instance.new("Frame")
            CT.Size = UDim2.new(1, -42, 0, 2)
            CT.Position = UDim2.new(0, 14, 0.5, -1)
            CT.BackgroundColor3 = UI.Theme.Border
            CT.BorderSizePixel = 0
            CT.ZIndex = 201
            CT.Parent = CF

            local CF2 = Instance.new("Frame")
            CF2.Size = UDim2.new(getV()/255, 0, 1, 0)
            CF2.BackgroundColor3 = UI.Theme.Accent
            CF2.BorderSizePixel = 0
            CF2.ZIndex = 202
            CF2.Parent = CT

            local CTB = Instance.new("TextButton")
            CTB.Text = ""
            CTB.BackgroundTransparency = 1
            CTB.Size = UDim2.new(1, 0, 0, 14)
            CTB.Position = UDim2.new(0, 0, 0.5, -7)
            CTB.ZIndex = 203
            CTB.Parent = CT

            local sl2 = false
            local function upd(mx)
                local rel = math.clamp((mx - CT.AbsolutePosition.X) / CT.AbsoluteSize.X, 0, 1)
                setV(math.floor(rel * 255))
                CF2.Size = UDim2.new(rel, 0, 1, 0)
                CV.Text = tostring(getV())
                cp.Value = Color3.fromRGB(r, g, b)
                Preview.BackgroundColor3 = cp.Value
                if callback then callback(cp.Value) end
            end

            CTB.MouseButton1Down:Connect(function() sl2 = true; upd(mouse.X) end)
            UserInputService.InputChanged:Connect(function(i)
                if sl2 and i.UserInputType == Enum.UserInputType.MouseMovement then upd(i.Position.X) end
            end)
            UserInputService.InputEnded:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 then sl2 = false end
            end)
        end

        addChan("R", function() return r end, function(v) r = v end)
        addChan("G", function() return g end, function(v) g = v end)
        addChan("B", function() return b end, function(v) b = v end)

        local CloseEF = Instance.new("TextButton")
        CloseEF.Text = "APPLIQUER"
        CloseEF.Font = Enum.Font.Code
        CloseEF.TextSize = 9
        CloseEF.TextColor3 = UI.Theme.Text
        CloseEF.BackgroundColor3 = UI.Theme.AccentDim
        CloseEF.BorderSizePixel = 0
        CloseEF.Size = UDim2.new(1, -16, 0, 18)
        CloseEF.ZIndex = 201
        CloseEF.Parent = editFrame

        CloseEF.MouseButton1Click:Connect(function()
            cp.Value = Color3.fromRGB(r, g, b)
            Preview.BackgroundColor3 = cp.Value
            if callback then callback(cp.Value) end
            if editFrame then editFrame:Destroy(); editFrame = nil end
            editOpen = false
        end)
    end)

    return cp
end

-- ===== KEYBIND =====
function UI:AddKeybind(parent, text, default, callback)
    local key = default or Enum.KeyCode.Unknown
    local listening = false

    local Row = Instance.new("Frame")
    Row.Size = UDim2.new(1, 0, 0, 22)
    Row.BackgroundTransparency = 1
    Row.Parent = parent

    local Pad = Instance.new("UIPadding")
    Pad.PaddingLeft = UDim.new(0, 8)
    Pad.PaddingRight = UDim.new(0, 8)
    Pad.Parent = Row

    local Label = Instance.new("TextLabel")
    Label.Text = text
    Label.Font = Enum.Font.Code
    Label.TextSize = 10
    Label.TextColor3 = UI.Theme.TextDim
    Label.BackgroundTransparency = 1
    Label.Size = UDim2.new(0.6, 0, 1, 0)
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Row

    local KeyBtn = Instance.new("TextButton")
    KeyBtn.Text = key.Name
    KeyBtn.Font = Enum.Font.Code
    KeyBtn.TextSize = 9
    KeyBtn.TextColor3 = UI.Theme.Accent
    KeyBtn.BackgroundColor3 = UI.Theme.BG3
    KeyBtn.BorderColor3 = UI.Theme.Border
    KeyBtn.BorderSizePixel = 1
    KeyBtn.Size = UDim2.new(0.4, 0, 0, 16)
    KeyBtn.Position = UDim2.new(0.6, 0, 0.5, -8)
    KeyBtn.Parent = Row

    local kb = {Value = key}

    KeyBtn.MouseButton1Click:Connect(function()
        listening = true
        KeyBtn.Text = "..."
        KeyBtn.TextColor3 = Color3.fromRGB(255, 200, 50)
    end)

    UserInputService.InputBegan:Connect(function(input)
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

-- ===== LABEL =====
function UI:AddLabel(parent, text)
    local L = Instance.new("TextLabel")
    L.Text = text
    L.Font = Enum.Font.Code
    L.TextSize = 9
    L.TextColor3 = UI.Theme.TextOff
    L.BackgroundTransparency = 1
    L.Size = UDim2.new(1, -16, 0, 0)
    L.AutomaticSize = Enum.AutomaticSize.Y
    L.TextWrapped = true
    L.TextXAlignment = Enum.TextXAlignment.Left
    L.Parent = parent

    local Pad = Instance.new("UIPadding")
    Pad.PaddingLeft = UDim.new(0, 8)
    Pad.PaddingRight = UDim.new(0, 8)
    Pad.Parent = L

    return L
end

-- ===== SPACER =====
function UI:AddSpacer(parent, height)
    local S = Instance.new("Frame")
    S.Size = UDim2.new(1, 0, 0, height or 4)
    S.BackgroundTransparency = 1
    S.Parent = parent
    return S
end

-- ===== NOTIFICATION =====
function UI:Notify(title, desc, duration)
    duration = duration or 3
    local N = Instance.new("Frame")
    N.Size = UDim2.new(0, 220, 0, 50)
    N.Position = UDim2.new(1, -230, 1, -60)
    N.BackgroundColor3 = UI.Theme.BG2
    N.BorderColor3 = UI.Theme.Accent
    N.BorderSizePixel = 1
    N.Parent = gui

    local NAccent = Instance.new("Frame")
    NAccent.Size = UDim2.new(0, 2, 1, 0)
    NAccent.BackgroundColor3 = UI.Theme.Accent
    NAccent.BorderSizePixel = 0
    NAccent.Parent = N

    local NT = Instance.new("TextLabel")
    NT.Text = title
    NT.Font = Enum.Font.Code
    NT.TextSize = 11
    NT.TextColor3 = UI.Theme.Text
    NT.BackgroundTransparency = 1
    NT.Size = UDim2.new(1, -10, 0, 20)
    NT.Position = UDim2.new(0, 8, 0, 4)
    NT.TextXAlignment = Enum.TextXAlignment.Left
    NT.Parent = N

    local ND = Instance.new("TextLabel")
    ND.Text = desc
    ND.Font = Enum.Font.Code
    ND.TextSize = 9
    ND.TextColor3 = UI.Theme.TextDim
    ND.BackgroundTransparency = 1
    ND.Size = UDim2.new(1, -10, 0, 20)
    ND.Position = UDim2.new(0, 8, 0, 24)
    ND.TextXAlignment = Enum.TextXAlignment.Left
    ND.TextWrapped = true
    ND.Parent = N

    TweenService:Create(N, TweenInfo.new(0.25), {Position = UDim2.new(1, -230, 1, -70)}):Play()
    task.delay(duration, function()
        TweenService:Create(N, TweenInfo.new(0.25), {Position = UDim2.new(1, 240, 1, -70)}):Play()
        task.delay(0.3, function() N:Destroy() end)
    end)
end

UI.ScreenGui = gui
return UI
