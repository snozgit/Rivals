-- ==================== ESP ====================
local ESP = {}
local Players    = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera     = workspace.CurrentCamera
local lp         = Players.LocalPlayer

ESP.Config = {
    Enabled         = false,
    Boxes           = true,
    Boxes3D         = false,
    Names           = true,
    Distance        = true,
    Health          = true,
    HealthBar       = true,
    Tracers         = false,
    Tracers_From    = "Bottom", -- Bottom / Center / Top
    Skeleton        = false,
    HeadDot         = false,
    Chams           = false,
    Chams_FillColor = Color3.fromRGB(255, 60, 60),
    Chams_Outline   = true,
    TeamCheck       = true,
    MaxDistance     = 2000,
    TextSize        = 11,
    Font            = Drawing.Fonts.UI,

    -- Couleurs
    Color_Visible   = Color3.fromRGB(100, 255, 100),
    Color_Hidden    = Color3.fromRGB(255, 60, 60),
    Color_Team      = Color3.fromRGB(60, 120, 255),
    Color_Box       = Color3.fromRGB(255, 255, 255),
    Color_Tracer    = Color3.fromRGB(255, 255, 255),
    Color_Skeleton  = Color3.fromRGB(200, 200, 200),
    Color_Name      = Color3.fromRGB(255, 255, 255),
    Color_Dist      = Color3.fromRGB(180, 180, 180),
    Color_Health    = Color3.fromRGB(80, 255, 80),
    Color_HeadDot   = Color3.fromRGB(255, 80, 80),

    -- World ESP
    World_Enabled   = false,
    World_Items     = true,
    World_Pickups   = true,
    World_Color     = Color3.fromRGB(255, 200, 50),

    -- Misc ESP
    Crosshair       = false,
    Crosshair_Size  = 10,
    Crosshair_Color = Color3.fromRGB(255, 255, 255),
    Crosshair_Gap   = 4,

    FovCircle       = false,
    FovCircle_Size  = 120,
    FovCircle_Color = Color3.fromRGB(255, 255, 255),
}

-- ===== DRAWING OBJECTS PAR JOUEUR =====
local playerDrawings = {}

local Bones = {
    {"Head", "UpperTorso"},
    {"UpperTorso", "LowerTorso"},
    {"UpperTorso", "RightUpperArm"},
    {"RightUpperArm", "RightLowerArm"},
    {"RightLowerArm", "RightHand"},
    {"UpperTorso", "LeftUpperArm"},
    {"LeftUpperArm", "LeftLowerArm"},
    {"LeftLowerArm", "LeftHand"},
    {"LowerTorso", "RightUpperLeg"},
    {"RightUpperLeg", "RightLowerLeg"},
    {"RightLowerLeg", "RightFoot"},
    {"LowerTorso", "LeftUpperLeg"},
    {"LeftUpperLeg", "LeftLowerLeg"},
    {"LeftLowerLeg", "LeftFoot"},
}

local function newText(size, font)
    local d = Drawing.new("Text")
    d.Size = size or 11
    d.Font = font or Drawing.Fonts.UI
    d.Outline = true
    d.Visible = false
    return d
end

local function newLine(thickness)
    local d = Drawing.new("Line")
    d.Thickness = thickness or 1
    d.Visible = false
    return d
end

local function newQuad()
    local d = Drawing.new("Quad")
    d.Thickness = 1
    d.Filled = false
    d.Visible = false
    return d
end

local function newCircle(filled)
    local d = Drawing.new("Circle")
    d.Thickness = 1
    d.Filled = filled or false
    d.NumSides = 32
    d.Visible = false
    return d
end

local function createDrawingsForPlayer(p)
    playerDrawings[p] = {
        Box         = newLine(1),
        BoxLines    = {newLine(1), newLine(1), newLine(1), newLine(1)}, -- 2D box
        Box3D       = {newLine(1), newLine(1), newLine(1), newLine(1), newLine(1), newLine(1), newLine(1), newLine(1), newLine(1), newLine(1), newLine(1), newLine(1)},
        Name        = newText(11),
        Distance    = newText(10),
        Health      = newText(10),
        HealthBarBG = newLine(3),
        HealthBar   = newLine(3),
        Tracer      = newLine(1),
        Skeleton    = {},
        HeadDot     = newCircle(true),
        Chams       = {},
    }
    -- Squelette
    for _ = 1, #Bones do
        table.insert(playerDrawings[p].Skeleton, newLine(1))
    end
end

local function removeDrawingsForPlayer(p)
    if not playerDrawings[p] then return end
    for _, d in pairs(playerDrawings[p]) do
        if typeof(d) == "table" then
            for _, v in pairs(d) do
                pcall(function() v:Remove() end)
            end
        else
            pcall(function() d:Remove() end)
        end
    end
    playerDrawings[p] = nil
end

-- Init joueurs existants
for _, p in ipairs(Players:GetPlayers()) do
    if p ~= lp then createDrawingsForPlayer(p) end
end

Players.PlayerAdded:Connect(function(p)
    if p == lp then return end
    createDrawingsForPlayer(p)
end)

Players.PlayerRemoving:Connect(function(p)
    removeDrawingsForPlayer(p)
end)

-- ===== HELPERS WORLD TO SCREEN =====
local function w2s(pos)
    local s, v = Camera:WorldToViewportPoint(pos)
    return Vector2.new(s.X, s.Y), v
end

local function getCharBounds(char)
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    local pos = hrp.Position

    local topPos = pos + Vector3.new(0, 3.5, 0)
    local botPos = pos - Vector3.new(0, 3, 0)

    local top, topVis = w2s(topPos)
    local bot, botVis = w2s(botPos)

    if not topVis then return nil end

    local height = math.abs(top.Y - bot.Y)
    local width = height * 0.55
    return {
        Top   = top,
        Bot   = bot,
        Width = width,
        Height = height,
        Center = Vector2.new((top.X + bot.X) / 2, (top.Y + bot.Y) / 2)
    }
end

-- ===== CHAMS (hilighting via SelectionBox) =====
local function setupChams(p)
    local char = p.Character
    if not char then return end
    local sel = Instance.new("SelectionBox")
    sel.Color3 = ESP.Config.Chams_FillColor
    sel.LineThickness = 0.05
    sel.SurfaceTransparency = 0.6
    sel.SurfaceColor3 = ESP.Config.Chams_FillColor
    sel.Adornee = char
    sel.Parent = workspace
    if playerDrawings[p] then
        playerDrawings[p].ChamBox = sel
    end
end

local function removeChams(p)
    if playerDrawings[p] and playerDrawings[p].ChamBox then
        playerDrawings[p].ChamBox:Destroy()
        playerDrawings[p].ChamBox = nil
    end
end

-- ===== CROSSHAIR =====
local crosshairLines = {
    Drawing.new("Line"), Drawing.new("Line"),
    Drawing.new("Line"), Drawing.new("Line"),
}
for _, l in ipairs(crosshairLines) do
    l.Color = Color3.fromRGB(255, 255, 255)
    l.Thickness = 1
    l.Visible = false
end

-- ===== FOV DRAWING =====
local fovDrawing = Drawing.new("Circle")
fovDrawing.Filled = false
fovDrawing.NumSides = 64
fovDrawing.Thickness = 1
fovDrawing.Visible = false

-- ===== MAIN LOOP =====
RunService.Heartbeat:Connect(function()
    if not ESP.Config.Enabled and not ESP_.Config.Crosshair and not ESP_.Config.FovCircle then
        return
    end
    -- Crosshair
    if ESP.Config.Crosshair then
        local cx = Camera.ViewportSize.X / 2
        local cy = Camera.ViewportSize.Y / 2
        local sz = ESP.Config.Crosshair_Size
        local gap = ESP.Config.Crosshair_Gap
        local col = ESP.Config.Crosshair_Color
        local lines = crosshairLines
        -- left
        lines[1].From = Vector2.new(cx - sz - gap, cy)
        lines[1].To   = Vector2.new(cx - gap, cy)
        lines[1].Color = col; lines[1].Visible = true
        -- right
        lines[2].From = Vector2.new(cx + gap, cy)
        lines[2].To   = Vector2.new(cx + sz + gap, cy)
        lines[2].Color = col; lines[2].Visible = true
        -- top
        lines[3].From = Vector2.new(cx, cy - sz - gap)
        lines[3].To   = Vector2.new(cx, cy - gap)
        lines[3].Color = col; lines[3].Visible = true
        -- bottom
        lines[4].From = Vector2.new(cx, cy + gap)
        lines[4].To   = Vector2.new(cx, cy + sz + gap)
        lines[4].Color = col; lines[4].Visible = true
    else
        for _, l in ipairs(crosshairLines) do l.Visible = false end
    end

    -- FOV Circle
    if ESP.Config.FovCircle then
        fovDrawing.Visible = true
        fovDrawing.Radius = ESP.Config.FovCircle_Size
        fovDrawing.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
        fovDrawing.Color = ESP.Config.FovCircle_Color
    else
        fovDrawing.Visible = false
    end

    -- Players
    for _, p in ipairs(Players:GetPlayers()) do
        if p == lp then continue end
        local d = playerDrawings[p]
        if not d then continue end

        local function hideAll()
            for _, obj in pairs(d) do
                if typeof(obj) == "table" then
                    for _, v in pairs(obj) do pcall(function() v.Visible = false end) end
                else
                    pcall(function() obj.Visible = false end)
                end
            end
        end

        if not ESP.Config.Enabled then hideAll() continue end

        local char = p.Character
        if not char then hideAll() continue end

        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then hideAll() continue end

        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then hideAll() continue end

        local dist = (Camera.CFrame.Position - hrp.Position).Magnitude
        if dist > ESP.Config.MaxDistance then hideAll() continue end

        local bounds = getCharBounds(char)
        if not bounds then hideAll() continue end

        -- Couleur selon visibilité
        local params = RaycastParams.new()
        params.FilterDescendantsInstances = {char, getCharacter and getCharacter(lp) or lp.Character}
        params.FilterType = Enum.RaycastFilterType.Exclude
        local ray = workspace:Raycast(Camera.CFrame.Position, hrp.Position - Camera.CFrame.Position, params)
        local isVisible = (ray == nil or (ray.Instance and ray.Instance:IsDescendantOf(char)))
        local col = isVisible and ESP.Config.Color_Visible or ESP.Config.Color_Hidden
        if lp.Team and p.Team == lp.Team then col = ESP.Config.Color_Team end

        -- 2D Box
        if ESP.Config.Boxes then
            local hw = bounds.Width / 2
            local lines = d.BoxLines
            -- top
            lines[1].From = Vector2.new(bounds.Top.X - hw, bounds.Top.Y)
            lines[1].To   = Vector2.new(bounds.Top.X + hw, bounds.Top.Y)
            lines[1].Color = col; lines[1].Visible = true
            -- bottom
            lines[2].From = Vector2.new(bounds.Bot.X - hw, bounds.Bot.Y)
            lines[2].To   = Vector2.new(bounds.Bot.X + hw, bounds.Bot.Y)
            lines[2].Color = col; lines[2].Visible = true
            -- left
            lines[3].From = Vector2.new(bounds.Top.X - hw, bounds.Top.Y)
            lines[3].To   = Vector2.new(bounds.Bot.X - hw, bounds.Bot.Y)
            lines[3].Color = col; lines[3].Visible = true
            -- right
            lines[4].From = Vector2.new(bounds.Top.X + hw, bounds.Top.Y)
            lines[4].To   = Vector2.new(bounds.Bot.X + hw, bounds.Bot.Y)
            lines[4].Color = col; lines[4].Visible = true
        else
            for _, l in ipairs(d.BoxLines) do l.Visible = false end
        end

        -- 3D Box
        if ESP.Config.Boxes3D then
            local corners3D = {
                hrp.Position + Vector3.new(-2, 3.5,  2),
                hrp.Position + Vector3.new( 2, 3.5,  2),
                hrp.Position + Vector3.new( 2, 3.5, -2),
                hrp.Position + Vector3.new(-2, 3.5, -2),
                hrp.Position + Vector3.new(-2,-3, 2),
                hrp.Position + Vector3.new( 2,-3, 2),
                hrp.Position + Vector3.new( 2,-3,-2),
                hrp.Position + Vector3.new(-2,-3,-2),
            }
            local sc = {}
            local allVis = true
            for i, c in ipairs(corners3D) do
                local s, v = w2s(c)
                sc[i] = s
                if not v then allVis = false end
            end
            local edges = {{1,2},{2,3},{3,4},{4,1},{5,6},{6,7},{7,8},{8,5},{1,5},{2,6},{3,7},{4,8}}
            for i, e in ipairs(edges) do
                local l = d.Box3D[i]
                if allVis then
                    l.From = sc[e[1]]; l.To = sc[e[2]]
                    l.Color = col; l.Visible = true
                else
                    l.Visible = false
                end
            end
        else
            for _, l in ipairs(d.Box3D) do l.Visible = false end
        end

        -- Name
        if ESP.Config.Names then
            d.Name.Text = p.DisplayName
            d.Name.Position = Vector2.new(bounds.Top.X, bounds.Top.Y - 14)
            d.Name.Color = ESP.Config.Color_Name
            d.Name.Size = ESP.Config.TextSize
            d.Name.Visible = true
        else d.Name.Visible = false end

        -- Distance
        if ESP.Config.Distance then
            d.Distance.Text = string.format("%.0fm", dist)
            d.Distance.Position = Vector2.new(bounds.Bot.X, bounds.Bot.Y + 2)
            d.Distance.Color = ESP.Config.Color_Dist
            d.Distance.Size = ESP.Config.TextSize - 1
            d.Distance.Visible = true
        else d.Distance.Visible = false end

        -- Health text
        local hp = hum.Health
        local maxHp = hum.MaxHealth
        local hpPercent = hp / maxHp
        if ESP.Config.Health then
            d.Health.Text = string.format("♥ %.0f", hp)
            d.Health.Position = Vector2.new(bounds.Top.X + bounds.Width / 2 + 4, bounds.Top.Y)
            d.Health.Color = Color3.fromRGB(
                math.floor(255 * (1 - hpPercent)),
                math.floor(255 * hpPercent),
                50
            )
            d.Health.Size = ESP.Config.TextSize - 1
            d.Health.Visible = true
        else d.Health.Visible = false end

        -- Health bar
        if ESP.Config.HealthBar then
            local barX = bounds.Top.X - bounds.Width / 2 - 5
            local barTopY = bounds.Top.Y
            local barBotY = bounds.Bot.Y
            local fillY = barBotY - (barBotY - barTopY) * hpPercent

            d.HealthBarBG.From = Vector2.new(barX, barTopY)
            d.HealthBarBG.To   = Vector2.new(barX, barBotY)
            d.HealthBarBG.Color = Color3.fromRGB(0, 0, 0)
            d.HealthBarBG.Thickness = 3
            d.HealthBarBG.Visible = true

            d.HealthBar.From = Vector2.new(barX, fillY)
            d.HealthBar.To   = Vector2.new(barX, barBotY)
            d.HealthBar.Color = Color3.fromRGB(
                math.floor(255 * (1 - hpPercent)),
                math.floor(255 * hpPercent),
                50
            )
            d.HealthBar.Thickness = 3
            d.HealthBar.Visible = true
        else
            d.HealthBarBG.Visible = false
            d.HealthBar.Visible = false
        end

        -- Tracers
        if ESP.Config.Tracers then
            local fromY = Camera.ViewportSize.Y
            if ESP.Config.Tracers_From == "Center" then fromY = Camera.ViewportSize.Y / 2 end
            if ESP.Config.Tracers_From == "Top" then fromY = 0 end
            d.Tracer.From = Vector2.new(Camera.ViewportSize.X / 2, fromY)
            d.Tracer.To   = bounds.Center
            d.Tracer.Color = ESP.Config.Color_Tracer
            d.Tracer.Visible = true
        else d.Tracer.Visible = false end

        -- Squelette
        if ESP.Config.Skeleton then
            for i, bone in ipairs(Bones) do
                local p1 = char:FindFirstChild(bone[1])
                local p2 = char:FindFirstChild(bone[2])
                local l = d.Skeleton[i]
                if p1 and p2 then
                    local s1, v1 = w2s(p1.Position)
                    local s2, v2 = w2s(p2.Position)
                    if v1 and v2 then
                        l.From = s1; l.To = s2
                        l.Color = ESP.Config.Color_Skeleton
                        l.Visible = true
                    else l.Visible = false end
                else l.Visible = false end
            end
        else
            for _, l in ipairs(d.Skeleton) do l.Visible = false end
        end

        -- Head dot
        if ESP.Config.HeadDot then
            local head = char:FindFirstChild("Head")
            if head then
                local s, v = w2s(head.Position)
                if v then
                    d.HeadDot.Position = s
                    d.HeadDot.Radius = 4
                    d.HeadDot.Color = ESP.Config.Color_HeadDot
                    d.HeadDot.Visible = true
                else d.HeadDot.Visible = false end
            else d.HeadDot.Visible = false end
        else d.HeadDot.Visible = false end

        -- Chams
        if ESP.Config.Chams then
            if not playerDrawings[p].ChamBox then setupChams(p) end
            if playerDrawings[p].ChamBox then
                playerDrawings[p].ChamBox.Color3 = ESP.Config.Chams_FillColor
                playerDrawings[p].ChamBox.SurfaceColor3 = ESP.Config.Chams_FillColor
            end
        else
            removeChams(p)
        end
    end -- end players loop
end)

return ESP
