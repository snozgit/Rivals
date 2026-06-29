-- ==================== WORLD ====================
local World = {}
local RunService    = game:GetService("RunService")
local Players       = game:GetService("Players")
local Camera        = workspace.CurrentCamera
local lp            = Players.LocalPlayer

World.Config = {
    -- Pickups / Items ESP
    Item_ESP        = false,
    Item_Color      = Color3.fromRGB(255, 200, 50),
    Item_MaxDist    = 500,
    Item_TextSize   = 10,

    -- No fog
    NoFog           = false,

    -- Full bright
    FullBright      = false,
    FullBright_Val  = 3,

    -- No grass
    NoGrass         = false,

    -- Inf Jump
    InfJump         = false,
    InfJump_Power   = 50,

    -- High jump
    HighJump        = false,
    HighJump_Power  = 80,

    -- Speed hack
    Speed           = false,
    Speed_Value     = 24,

    -- Fly
    Fly             = false,
    Fly_Speed       = 60,

    -- Noclip
    Noclip          = false,

    -- TP to closest
    TP_Closest      = false,

    -- Fake lag
    FakeLag         = false,
    FakeLag_Frames  = 5,

    -- Anti-AFK
    AntiAFK         = true,

    -- Third Person
    ThirdPerson     = false,
    ThirdPerson_Dist = 8,
}

-- ===== ITEMS ESP =====
local itemDrawings = {}

local function getItems()
    local items = {}
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") or obj:IsA("MeshPart") then
            local name = obj.Name:lower()
            if name:find("pickup") or name:find("item") or name:find("ammo") 
            or name:find("weapon") or name:find("powerup") or name:find("orb")
            or name:find("drop") or name:find("loot") then
                table.insert(items, obj)
            end
        end
    end
    return items
end

-- ===== NO FOG =====
local originalFog = {
    Density = game:GetService("Lighting").FogEnd,
    End = game:GetService("Lighting").FogEnd
}

local function setNoFog(enabled)
    local Lighting = game:GetService("Lighting")
    if enabled then
        Lighting.FogEnd = 100000
        Lighting.FogStart = 100000
    else
        Lighting.FogEnd = originalFog.End
    end
end

-- ===== FULL BRIGHT =====
local function setFullBright(enabled)
    local Lighting = game:GetService("Lighting")
    if enabled then
        Lighting.Brightness = World.Config.FullBright_Val
        Lighting.ClockTime = 14
        Lighting.GlobalShadows = false
        for _, effect in ipairs(Lighting:GetChildren()) do
            if effect:IsA("ColorCorrectionEffect") then effect.Brightness = 0 end
            if effect:IsA("BloomEffect") then effect.Enabled = false end
            if effect:IsA("BlurEffect") then effect.Enabled = false end
        end
    else
        Lighting.GlobalShadows = true
    end
end

-- ===== INF JUMP =====
local jumpConn
local function setupInfJump()
    if jumpConn then jumpConn:Disconnect() end
    local char = lp.Character or lp.CharacterAdded:Wait()
    local hum = char:FindFirstChildOfClass("Humanoid")
    jumpConn = hum and hum.StateChanged:Connect(function(_, new)
        if not World.Config.InfJump then return end
        if new == Enum.HumanoidStateType.Landed then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end)
end

lp.CharacterAdded:Connect(setupInfJump)
pcall(setupInfJump)

-- ===== SPEED =====
local speedConn
local function setupSpeed()
    if speedConn then speedConn:Disconnect() end
    speedConn = RunService.RenderStepped:Connect(function()
        if not World.Config.Speed then return end
        local char = lp.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = World.Config.Speed_Value end
    end)
end
setupSpeed()

-- ===== HIGH JUMP =====
local function setupHighJump()
    RunService.RenderStepped:Connect(function()
        if not World.Config.HighJump then return end
        local char = lp.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum.JumpPower = World.Config.HighJump_Power end
    end)
end
setupHighJump()

-- ===== FLY =====
local flyBody = nil
local function setupFly()
    RunService.RenderStepped:Connect(function()
        local char = lp.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        if World.Config.Fly then
            if not flyBody then
                flyBody = Instance.new("BodyVelocity")
                flyBody.MaxForce = Vector3.new(1e5, 1e5, 1e5)
                flyBody.Velocity = Vector3.zero
                flyBody.Parent = hrp
            end
            local dir = Vector3.zero
            local UIS = game:GetService("UserInputService")
            local cam = Camera
            local cf = cam.CFrame
            if UIS:IsKeyDown(Enum.KeyCode.W) then dir = dir + cf.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.S) then dir = dir - cf.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.A) then dir = dir - cf.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.D) then dir = dir + cf.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0,1,0) end
            if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then dir = dir - Vector3.new(0,1,0) end
            flyBody.Velocity = dir.Magnitude > 0 and dir.Unit * World.Config.Fly_Speed or Vector3.zero
        else
            if flyBody then flyBody:Destroy() flyBody = nil end
        end
    end)
end
setupFly()

-- ===== NOCLIP =====
RunService.Stepped:Connect(function()
    if not World.Config.Noclip then return end
    local char = lp.Character
    if not char then return end
    for _, p in ipairs(char:GetDescendants()) do
        if p:IsA("BasePart") then p.CanCollide = false end
    end
end)

-- ===== THIRD PERSON =====
RunService.RenderStepped:Connect(function()
    if World.Config.ThirdPerson then
        Camera.CameraType = Enum.CameraType.Custom
        lp.CameraMaxZoomDistance = World.Config.ThirdPerson_Dist
        lp.CameraMinZoomDistance = World.Config.ThirdPerson_Dist
    else
        lp.CameraMaxZoomDistance = 400
        lp.CameraMinZoomDistance = 0.5
    end
end)

-- ===== ANTI-AFK =====
local VirtualUser = game:GetService("VirtualUser")
game:GetService("Players").LocalPlayer.Idled:Connect(function()
    if World.Config.AntiAFK then
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end
end)

-- ===== ITEM ESP LOOP =====
RunService.RenderStepped:Connect(function()
    -- Clean old drawings
    for part, d in pairs(itemDrawings) do
        if not part or not part.Parent then
            pcall(function() d:Remove() end)
            itemDrawings[part] = nil
        end
    end

    if not World.Config.Item_ESP then
        for _, d in pairs(itemDrawings) do pcall(function() d.Visible = false end) end
        return
    end

    local items = getItems()
    for _, item in ipairs(items) do
        local dist = (Camera.CFrame.Position - item.Position).Magnitude
        if dist > World.Config.Item_MaxDist then
            if itemDrawings[item] then itemDrawings[item].Visible = false end
            continue
        end

        local s, v = Camera:WorldToViewportPoint(item.Position)
        if not v then
            if itemDrawings[item] then itemDrawings[item].Visible = false end
            continue
        end

        if not itemDrawings[item] then
            local d = Drawing.new("Text")
            d.Size = World.Config.Item_TextSize
            d.Font = Drawing.Fonts.UI
            d.Outline = true
            itemDrawings[item] = d
        end

        local d = itemDrawings[item]
        d.Text = item.Name .. string.format(" [%.0f]", dist)
        d.Position = Vector2.new(s.X, s.Y)
        d.Color = World.Config.Item_Color
        d.Visible = true
    end
end)

-- Expose les setters
World.ApplyFog = setNoFog
World.ApplyBright = setFullBright

return World
