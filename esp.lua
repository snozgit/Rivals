-- ==================== ESP OPTIMISÉ ====================
local ESP = {}
local Players    = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera     = workspace.CurrentCamera
local lp         = Players.LocalPlayer

ESP.Config = {
    Enabled         = false,
    Boxes           = true,
    BoxStyle        = "Corners", -- Corners / Full
    CornerLen       = 8,
    Boxes3D         = false,
    Names           = true,
    Distance        = true,
    Health          = true,
    HealthBar       = true,
    HealthBarWidth  = 3,
    Tracers         = false,
    TracerFrom      = "Bottom",
    Skeleton        = false,
    HeadDot         = false,
    Chams           = false,
    Chams_FillColor = Color3.fromRGB(255, 30, 30),
    TeamCheck       = true,
    MaxDistance     = 2000,
    TextSize        = 11,
    FadeDistance    = true,
    FadeStart       = 800,

    -- Couleurs
    Color_Visible   = Color3.fromRGB(0, 255, 65),
    Color_Hidden    = Color3.fromRGB(200, 20, 20),
    Color_Team      = Color3.fromRGB(60, 120, 255),
    Color_Tracer    = Color3.fromRGB(0, 207, 255),
    Color_Skeleton  = Color3.fromRGB(255, 96, 96),
    Color_Name      = Color3.fromRGB(255, 255, 255),
    Color_Dist      = Color3.fromRGB(170, 170, 170),
    Color_Health    = Color3.fromRGB(68, 255, 136),
    Color_HeadDot   = Color3.fromRGB(255, 221, 68),

    -- Crosshair
    Crosshair       = false,
    CrosshairSize   = 10,
    CrosshairGap    = 4,
    CrosshairColor  = Color3.fromRGB(255, 255, 255),
    CrosshairAnimated = false,

    -- FOV Circle
    FovCircle       = false,
    FovCircleSize   = 120,
    FovCircleColor  = Color3.fromRGB(200, 20, 20),
    FovCircleFilled = false,

    -- Arrows (hors écran)
    Arrows          = false,
    ArrowColor      = Color3.fromRGB(255, 50, 50),
    ArrowSize       = 12,

    -- Update rate (fps)
    UpdateFPS       = 30,
}

local Bones = {
    {"Head","UpperTorso"},{"UpperTorso","LowerTorso"},
    {"UpperTorso","RightUpperArm"},{"RightUpperArm","RightLowerArm"},{"RightLowerArm","RightHand"},
    {"UpperTorso","LeftUpperArm"},{"LeftUpperArm","LeftLowerArm"},{"LeftLowerArm","LeftHand"},
    {"LowerTorso","RightUpperLeg"},{"RightUpperLeg","RightLowerLeg"},{"RightLowerLeg","RightFoot"},
    {"LowerTorso","LeftUpperLeg"},{"LeftUpperLeg","LeftLowerLeg"},{"LeftLowerLeg","LeftFoot"},
}

-- ===== DRAWING POOL =====
local function newLine(t)
    local d = Drawing.new("Line"); d.Thickness = t or 1; d.Visible = false; return d
end
local function newText(s)
    local d = Drawing.new("Text"); d.Size = s or 11; d.Font = Drawing.Fonts.UI
    d.Outline = true; d.OutlineColor = Color3.fromRGB(0,0,0); d.Visible = false; return d
end
local function newCircle(filled)
    local d = Drawing.new("Circle"); d.Thickness = 1; d.Filled = filled or false
    d.NumSides = 32; d.Visible = false; return d
end
local function newTriangle()
    local d = Drawing.new("Triangle"); d.Filled = true; d.Visible = false; return d
end

local playerDrawings = {}

local function createDrawings(p)
    local d = {
        BoxFull    = {newLine(1.5), newLine(1.5), newLine(1.5), newLine(1.5)},
        BoxCorners = {newLine(2), newLine(2), newLine(2), newLine(2),
                      newLine(2), newLine(2), newLine(2), newLine(2)},
        Box3D      = {},
        Name       = newText(11),
        Dist       = newText(10),
        HpBG       = newLine(5),
        HpBar      = newLine(3),
        HpText     = newText(9),
        Tracer     = newLine(1),
        HeadDot    = newCircle(true),
        Skeleton   = {},
        Arrow      = newTriangle(),
    }
    for i = 1, 12 do d.Box3D[i] = newLine(1) end
    for i = 1, #Bones do d.Skeleton[i] = newLine(1.2) end
    playerDrawings[p] = d
end

local function destroyDrawings(p)
    local d = playerDrawings[p]
    if not d then return end
    local function rem(obj)
        if type(obj) == "table" then
            for _, v in pairs(obj) do pcall(function() v:Remove() end) end
        else pcall(function() obj:Remove() end) end
    end
    for _, v in pairs(d) do rem(v) end
    playerDrawings[p] = nil
end

local function hideAll(d)
    local function h(obj)
        if type(obj) == "table" then for _, v in pairs(obj) do pcall(function() v.Visible = false end) end
        else pcall(function() d[obj] = nil end) end
    end
    for _, v in pairs(d) do
        if type(v) == "table" then for _, vv in pairs(v) do pcall(function() vv.Visible = false end) end
        else pcall(function() v.Visible = false end) end
    end
end

for _, p in ipairs(Players:GetPlayers()) do
    if p ~= lp then createDrawings(p) end
end
Players.PlayerAdded:Connect(function(p)
    if p ~= lp then createDrawings(p) end
end)
Players.PlayerRemoving:Connect(function(p)
    destroyDrawings(p)
end)

-- ===== CHAMS =====
local chamBoxes = {}
local function applyChams(p)
    if chamBoxes[p] then pcall(function() chamBoxes[p]:Destroy() end); chamBoxes[p] = nil end
    if not ESP.Config.Chams then return end
    local char = p.Character; if not char then return end
    local h = Instance.new("Highlight")
    h.FillColor = ESP.Config.Chams_FillColor
    h.FillTransparency = 0.5
    h.OutlineColor = ESP.Config.Chams_FillColor
    h.OutlineTransparency = 0
    h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    h.Adornee = char; h.Parent = char
    chamBoxes[p] = h
end

local function removeChams(p)
    if chamBoxes[p] then pcall(function() chamBoxes[p]:Destroy() end); chamBoxes[p] = nil end
end

-- ===== CROSSHAIR DRAWINGS =====
local chLines = {newLine(1.5), newLine(1.5), newLine(1.5), newLine(1.5)}
local fovDraw = Drawing.new("Circle")
fovDraw.Filled = false; fovDraw.NumSides = 64; fovDraw.Thickness = 1; fovDraw.Visible = false

-- ===== HELPERS =====
local function w2s(pos)
    local s, v = Camera:WorldToViewportPoint(pos)
    return Vector2.new(s.X, s.Y), v, s.Z
end

local function getBounds(char)
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    local top, tOn = w2s(hrp.Position + Vector3.new(0, 3.2, 0))
    local bot, bOn = w2s(hrp.Position - Vector3.new(0, 2.8, 0))
    if not tOn then return nil end
    local h = math.abs(bot.Y - top.Y)
    local w = h * 0.5
    return {
        Top = top, Bot = bot,
        Width = w, Height = h,
        Center = Vector2.new((top.X + bot.X)/2, (top.Y + bot.Y)/2),
        Left = top.X - w/2, Right = top.X + w/2,
    }
end

local visCache = {}
local visCacheTime = {}
local VIS_CACHE_DURATION = 0.2

local function checkVis(p)
    local now = tick()
    if visCacheTime[p] and (now - visCacheTime[p]) < VIS_CACHE_DURATION then
        return visCache[p]
    end
    local char = p.Character
    if not char then return false end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    local params = RaycastParams.new()
    params.FilterDescendantsInstances = {char, lp.Character or workspace}
    params.FilterType = Enum.RaycastFilterType.Exclude
    local origin = Camera.CFrame.Position
    local dir = hrp.Position - origin
    local result = workspace:Raycast(origin, dir, params)
    local vis = (result == nil)
    visCache[p] = vis
    visCacheTime[p] = now
    return vis
end

-- ===== MAIN UPDATE =====
local frameTimer = 0
local frameInterval = 0

RunService.Heartbeat:Connect(function(dt)
    frameTimer = frameTimer + 1
    frameInterval = math.max(1, math.floor(60 / math.max(ESP.Config.UpdateFPS, 1)))

    -- Crosshair (toujours smooth, pas limité au FPS ESP)
    if ESP.Config.Crosshair then
        local cx = Camera.ViewportSize.X / 2
        local cy = Camera.ViewportSize.Y / 2
        local sz = ESP.Config.CrosshairSize
        local gap = ESP.Config.CrosshairGap
        local col = ESP.Config.CrosshairColor
        chLines[1].From = Vector2.new(cx-sz-gap, cy); chLines[1].To = Vector2.new(cx-gap, cy)
        chLines[1].Color = col; chLines[1].Visible = true
        chLines[2].From = Vector2.new(cx+gap, cy); chLines[2].To = Vector2.new(cx+sz+gap, cy)
        chLines[2].Color = col; chLines[2].Visible = true
        chLines[3].From = Vector2.new(cx, cy-sz-gap); chLines[3].To = Vector2.new(cx, cy-gap)
        chLines[3].Color = col; chLines[3].Visible = true
        chLines[4].From = Vector2.new(cx, cy+gap); chLines[4].To = Vector2.new(cx, cy+sz+gap)
        chLines[4].Color = col; chLines[4].Visible = true
    else
        for _, l in ipairs(chLines) do l.Visible = false end
    end

    -- FOV Circle
    if ESP.Config.FovCircle then
        fovDraw.Visible = true
        fovDraw.Radius = ESP.Config.FovCircleSize
        fovDraw.Color = ESP.Config.FovCircleColor
        fovDraw.Filled = ESP.Config.FovCircleFilled
        fovDraw.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    else fovDraw.Visible = false end

    -- ESP throttled
    if frameTimer < frameInterval then return end
    frameTimer = 0

    if not ESP.Config.Enabled then
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= lp then
                local d = playerDrawings[p]; if d then hideAll(d) end
                removeChams(p)
            end
        end
        return
    end

    local myRoot = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
    local screenCenter = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)

    for _, p in ipairs(Players:GetPlayers()) do
        if p == lp then continue end
        local d = playerDrawings[p]
        if not d then continue end

        -- Team check
        if ESP.Config.TeamCheck and lp.Team and p.Team == lp.Team then
            hideAll(d); removeChams(p); continue
        end

        local char = p.Character
        if not char then hideAll(d); continue end

        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then hideAll(d); continue end

        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then hideAll(d); continue end

        local dist = myRoot and (hrp.Position - myRoot.Position).Magnitude or 9999
        if dist > ESP.Config.MaxDistance then hideAll(d); continue end

        local bounds = getBounds(char)
        if not bounds then hideAll(d); continue end

        -- Alpha fade
        local alpha = 1
        if ESP.Config.FadeDistance and dist > ESP.Config.FadeStart then
            alpha = 1 - math.clamp((dist - ESP.Config.FadeStart) / (ESP.Config.MaxDistance - ESP.Config.FadeStart), 0, 1)
        end

        -- Couleur visibilité
        local vis = checkVis(p)
        local col = vis and ESP.Config.Color_Visible or ESP.Config.Color_Hidden
        if lp.Team and p.Team == lp.Team then col = ESP.Config.Color_Team end

        local lX, rX = bounds.Left, bounds.Right
        local tY, bY = bounds.Top.Y, bounds.Bot.Y
        local cx = bounds.Center.X

        -- 2D BOX
        if ESP.Config.Boxes then
            if ESP.Config.BoxStyle == "Full" then
                -- 4 lignes classique
                for _, l in ipairs(d.BoxCorners) do l.Visible = false end
                local bl = d.BoxFull
                bl[1].From=Vector2.new(lX,tY); bl[1].To=Vector2.new(rX,tY); bl[1].Color=col; bl[1].Transparency=alpha; bl[1].Visible=true
                bl[2].From=Vector2.new(lX,bY); bl[2].To=Vector2.new(rX,bY); bl[2].Color=col; bl[2].Transparency=alpha; bl[2].Visible=true
                bl[3].From=Vector2.new(lX,tY); bl[3].To=Vector2.new(lX,bY); bl[3].Color=col; bl[3].Transparency=alpha; bl[3].Visible=true
                bl[4].From=Vector2.new(rX,tY); bl[4].To=Vector2.new(rX,bY); bl[4].Color=col; bl[4].Transparency=alpha; bl[4].Visible=true
            else
                -- Corners
                for _, l in ipairs(d.BoxFull) do l.Visible = false end
                local cl = d.BoxCorners
                local clen = ESP.Config.CornerLen
                -- TL
                cl[1].From=Vector2.new(lX,tY); cl[1].To=Vector2.new(lX+clen,tY); cl[1].Color=col; cl[1].Transparency=alpha; cl[1].Visible=true
                cl[2].From=Vector2.new(lX,tY); cl[2].To=Vector2.new(lX,tY+clen); cl[2].Color=col; cl[2].Transparency=alpha; cl[2].Visible=true
                -- TR
                cl[3].From=Vector2.new(rX,tY); cl[3].To=Vector2.new(rX-clen,tY); cl[3].Color=col; cl[3].Transparency=alpha; cl[3].Visible=true
                cl[4].From=Vector2.new(rX,tY); cl[4].To=Vector2.new(rX,tY+clen); cl[4].Color=col; cl[4].Transparency=alpha; cl[4].Visible=true
                -- BL
                cl[5].From=Vector2.new(lX,bY); cl[5].To=Vector2.new(lX+clen,bY); cl[5].Color=col; cl[5].Transparency=alpha; cl[5].Visible=true
                cl[6].From=Vector2.new(lX,bY); cl[6].To=Vector2.new(lX,bY-clen); cl[6].Color=col; cl[6].Transparency=alpha; cl[6].Visible=true
                -- BR
                cl[7].From=Vector2.new(rX,bY); cl[7].To=Vector2.new(rX-clen,bY); cl[7].Color=col; cl[7].Transparency=alpha; cl[7].Visible=true
                cl[8].From=Vector2.new(rX,bY); cl[8].To=Vector2.new(rX,bY-clen); cl[8].Color=col; cl[8].Transparency=alpha; cl[8].Visible=true
            end
        else
            for _, l in ipairs(d.BoxFull) do l.Visible = false end
            for _, l in ipairs(d.BoxCorners) do l.Visible = false end
        end

        -- 3D BOX
        if ESP.Config.Boxes3D then
            local c3 = {
                hrp.Position+Vector3.new(-1.5,3.2,1.5), hrp.Position+Vector3.new(1.5,3.2,1.5),
                hrp.Position+Vector3.new(1.5,3.2,-1.5), hrp.Position+Vector3.new(-1.5,3.2,-1.5),
                hrp.Position+Vector3.new(-1.5,-2.8,1.5), hrp.Position+Vector3.new(1.5,-2.8,1.5),
                hrp.Position+Vector3.new(1.5,-2.8,-1.5), hrp.Position+Vector3.new(-1.5,-2.8,-1.5),
            }
            local sc3 = {}; local allV = true
            for i, c in ipairs(c3) do local s, v = w2s(c); sc3[i]=s; if not v then allV=false end end
            local edges = {{1,2},{2,3},{3,4},{4,1},{5,6},{6,7},{7,8},{8,5},{1,5},{2,6},{3,7},{4,8}}
            for i, e in ipairs(edges) do
                local l = d.Box3D[i]
                if allV then
                    l.From=sc3[e[1]]; l.To=sc3[e[2]]; l.Color=col; l.Transparency=alpha; l.Visible=true
                else l.Visible=false end
            end
        else for _, l in ipairs(d.Box3D) do l.Visible=false end end

        -- NAME
        if ESP.Config.Names then
            d.Name.Text = p.DisplayName
            d.Name.Position = Vector2.new(cx, tY - 14)
            d.Name.Color = ESP.Config.Color_Name
            d.Name.Size = ESP.Config.TextSize
            d.Name.Transparency = alpha
            d.Name.Visible = true
        else d.Name.Visible = false end

        -- DISTANCE
        if ESP.Config.Distance then
            d.Dist.Text = math.floor(dist) .. "m"
            d.Dist.Position = Vector2.new(cx, bY + 2)
            d.Dist.Color = ESP.Config.Color_Dist
            d.Dist.Size = ESP.Config.TextSize - 1
            d.Dist.Transparency = alpha
            d.Dist.Visible = true
        else d.Dist.Visible = false end

        -- HP
        local hp = hum.Health
        local maxHp = math.max(hum.MaxHealth, 1)
        local hpPct = math.clamp(hp / maxHp, 0, 1)
        local hpColor = Color3.fromRGB(math.floor(255*(1-hpPct)), math.floor(255*hpPct), 0)

        if ESP.Config.HealthBar then
            local barX = lX - 5
            d.HpBG.From = Vector2.new(barX, tY); d.HpBG.To = Vector2.new(barX, bY)
            d.HpBG.Color = Color3.fromRGB(0,0,0); d.HpBG.Thickness = ESP.Config.HealthBarWidth + 2
            d.HpBG.Transparency = alpha; d.HpBG.Visible = true

            local fillTop = bY - (bY - tY) * hpPct
            d.HpBar.From = Vector2.new(barX, fillTop); d.HpBar.To = Vector2.new(barX, bY)
            d.HpBar.Color = hpColor; d.HpBar.Thickness = ESP.Config.HealthBarWidth
            d.HpBar.Transparency = alpha; d.HpBar.Visible = true
        else d.HpBG.Visible = false; d.HpBar.Visible = false end

        if ESP.Config.Health then
            d.HpText.Text = string.format("%.0f HP", hp)
            d.HpText.Position = Vector2.new(rX + 3, tY)
            d.HpText.Color = hpColor
            d.HpText.Size = 9; d.HpText.Transparency = alpha; d.HpText.Visible = true
        else d.HpText.Visible = false end

        -- TRACERS
        if ESP.Config.Tracers then
            local fromY = (ESP.Config.TracerFrom == "Center") and Camera.ViewportSize.Y/2
                       or (ESP.Config.TracerFrom == "Top") and 0
                       or Camera.ViewportSize.Y
            d.Tracer.From = Vector2.new(Camera.ViewportSize.X/2, fromY)
            d.Tracer.To = bounds.Center
            d.Tracer.Color = ESP.Config.Color_Tracer
            d.Tracer.Transparency = alpha; d.Tracer.Visible = true
        else d.Tracer.Visible = false end

        -- SKELETON
        if ESP.Config.Skeleton then
            for i, bone in ipairs(Bones) do
                local p1 = char:FindFirstChild(bone[1])
                local p2 = char:FindFirstChild(bone[2])
                local l = d.Skeleton[i]
                if p1 and p2 then
                    local s1, v1 = w2s(p1.Position)
                    local s2, v2 = w2s(p2.Position)
                    if v1 and v2 then
                        l.From=s1; l.To=s2; l.Color=ESP.Config.Color_Skeleton; l.Transparent=alpha; l.Visible=true
                    else l.Visible=false end
                else l.Visible=false end
            end
        else for _, l in ipairs(d.Skeleton) do l.Visible=false end end

        -- HEAD DOT
        if ESP.Config.HeadDot then
            local head = char:FindFirstChild("Head")
            if head then
                local hs, hv = w2s(head.Position)
                if hv then
                    d.HeadDot.Position = hs
                    d.HeadDot.Radius = 4
                    d.HeadDot.Color = ESP.Config.Color_HeadDot
                    d.HeadDot.Transparent = alpha
                    d.HeadDot.Visible = true
                else d.HeadDot.Visible = false end
            else d.HeadDot.Visible = false end
        else d.HeadDot.Visible = false end

        -- ARROWS (off-screen)
        if ESP.Config.Arrows then
            local sp, onScreen = w2s(hrp.Position)
            if not onScreen then
                local vx = Camera.ViewportSize.X
                local vy = Camera.ViewportSize.Y
                local dir = (Vector2.new(sp.X, sp.Y) - Vector2.new(vx/2, vy/2)).Unit
                local margin = 20
                local ax = math.clamp(vx/2 + dir.X * (vx/2 - margin), margin, vx - margin)
                local ay = math.clamp(vy/2 + dir.Y * (vy/2 - margin), margin, vy - margin)
                local angle = math.atan2(dir.Y, dir.X)
                local sz = ESP.Config.ArrowSize
                d.Arrow.PointA = Vector2.new(ax + math.cos(angle)*sz, ay + math.sin(angle)*sz)
                d.Arrow.PointB = Vector2.new(ax + math.cos(angle + 2.4)*sz*0.6, ay + math.sin(angle + 2.4)*sz*0.6)
                d.Arrow.PointC = Vector2.new(ax + math.cos(angle - 2.4)*sz*0.6, ay + math.sin(angle - 2.4)*sz*0.6)
                d.Arrow.Color = ESP.Config.ArrowColor
                d.Arrow.Visible = true
            else d.Arrow.Visible = false end
        else d.Arrow.Visible = false end

        -- CHAMS
        if ESP.Config.Chams then
            if not chamBoxes[p] then applyChams(p) end
            if chamBoxes[p] then
                chamBoxes[p].FillColor = ESP.Config.Chams_FillColor
                chamBoxes[p].OutlineColor = ESP.Config.Chams_FillColor
            end
        else removeChams(p) end
    end
end)

-- Cleanup sur PlayerRemoving
Players.PlayerRemoving:Connect(function(p)
    visCache[p] = nil
    visCacheTime[p] = nil
end)

return ESP
