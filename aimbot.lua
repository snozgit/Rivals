-- ==================== AIMBOT ====================
local Aimbot = {}
local Players       = game:GetService("Players")
local RunService    = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService  = game:GetService("TweenService")
local Camera        = workspace.CurrentCamera
local lp            = Players.LocalPlayer
local mouse         = lp:GetMouse()

-- ===== CONFIG =====
Aimbot.Config = {
    -- Legit
    Legit_Enabled       = false,
    Legit_HoldKey       = Enum.UserInputType.MouseButton2,
    Legit_FOV           = 120,
    Legit_Smoothness    = 0.18,
    Legit_TargetPart    = "Head",
    Legit_TeamCheck     = true,
    Legit_WallCheck     = true,
    Legit_VisCheck      = true,
    Legit_PredictBullet = true,
    Legit_BulletSpeed   = 300,
    Legit_Jitter        = false,
    Legit_JitterStrength = 1.5,
    Legit_RandomizeSmooth = false,
    Legit_SmoothMin     = 0.10,
    Legit_SmoothMax     = 0.25,
    Legit_FOVVisible    = true,
    Legit_FOVColor      = Color3.fromRGB(255, 255, 255),
    Legit_TargetLocked  = false,

    -- Silent
    Silent_Enabled      = false,
    Silent_HoldKey      = Enum.UserInputType.MouseButton1,
    Silent_FOV          = 200,
    Silent_TargetPart   = "HumanoidRootPart",
    Silent_TeamCheck    = true,
    Silent_WallCheck    = false,
    Silent_Chance       = 100, -- % de chance de silencer
    Silent_Predict      = true,
    Silent_BulletSpeed  = 300,
    Silent_MultiTarget  = false,

    -- Rage
    Rage_Enabled        = false,
    Rage_HoldKey        = Enum.UserInputType.MouseButton1,
    Rage_FOV            = 999,
    Rage_TargetPart     = "HumanoidRootPart",
    Rage_TeamCheck      = false,
    Rage_WallCheck      = false,
    Rage_NoRecoil       = true,
    Rage_NoSpread       = true,
    Rage_AutoShoot      = false,
    Rage_SpinBot        = false,
    Rage_SpinSpeed      = 10,
    Rage_JitterAA       = false,
    Rage_TriggerBot     = false,
    Rage_TriggerDelay   = 0.05,

    -- NoRecoil / NoSpread standalone
    NoRecoil_Enabled    = false,
    NoSpread_Enabled    = false,
    NoRecoil_Scale      = 1.0,
}

-- ===== UTILS =====
local function getCharacter(p)
    return p and p.Character
end

local function getRootPart(char)
    return char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso"))
end

local function getHumanoid(char)
    return char and char:FindFirstChildOfClass("Humanoid")
end

local function isAlive(p)
    local char = getCharacter(p)
    if not char then return false end
    local hum = getHumanoid(char)
    return hum and hum.Health > 0
end

local function sameTeam(p)
    return lp.Team ~= nil and p.Team == lp.Team
end

local function raycastWall(origin, target)
    local dir = (target - origin)
    local params = RaycastParams.new()
    params.FilterDescendantsInstances = {getCharacter(lp), workspace:FindFirstChild("Ignore")}
    params.FilterType = Enum.RaycastFilterType.Exclude
    local result = workspace:Raycast(origin, dir, params)
    return result == nil or result.Distance >= dir.Magnitude * 0.95
end

local function getClosestPlayer(fov, targetPart, teamCheck, wallCheck)
    local closest, closestDist = nil, fov
    local camPos = Camera.CFrame.Position

    for _, p in ipairs(Players:GetPlayers()) do
        if p == lp then continue end
        if teamCheck and sameTeam(p) then continue end
        if not isAlive(p) then continue end

        local char = getCharacter(p)
        local part = char:FindFirstChild(targetPart) or getRootPart(char)
        if not part then continue end

        local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
        if not onScreen then continue end

        local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
        local dist = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude

        if dist < closestDist then
            if wallCheck and not raycastWall(camPos, part.Position) then continue end
            closest = p
            closestDist = dist
        end
    end

    return closest
end

local function predictPosition(part, speed)
    if not Aimbot.Config.Legit_PredictBullet and not Aimbot.Config.Silent_Predict then return part.Position end
    local vel = part.Velocity or Vector3.zero
    local dist = (Camera.CFrame.Position - part.Position).Magnitude
    local travelTime = dist / speed
    return part.Position + vel * travelTime
end

-- ===== FOV CIRCLE =====
local fovCircle = Drawing.new("Circle")
fovCircle.Thickness = 1
fovCircle.Filled = false
fovCircle.NumSides = 64
fovCircle.Visible = false

RunService.RenderStepped:Connect(function()
    if Aimbot.Config.Legit_Enabled and Aimbot.Config.Legit_FOVVisible then
        fovCircle.Visible = true
        fovCircle.Radius = Aimbot.Config.Legit_FOV
        fovCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
        fovCircle.Color = Aimbot.Config.Legit_FOVColor
    elseif Aimbot.Config.Silent_Enabled then
        fovCircle.Visible = true
        fovCircle.Radius = Aimbot.Config.Silent_FOV
        fovCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
        fovCircle.Color = Color3.fromRGB(255, 80, 80)
    elseif Aimbot.Config.Rage_Enabled then
        fovCircle.Visible = true
        fovCircle.Radius = Aimbot.Config.Rage_FOV >= 900 and 600 or Aimbot.Config.Rage_FOV
        fovCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
        fovCircle.Color = Color3.fromRGB(255, 40, 40)
    else
        fovCircle.Visible = false
    end
end)

-- ===== LEGIT AIMBOT =====
local legitConnection
local function startLegitAimbot()
    if legitConnection then legitConnection:Disconnect() end
    legitConnection = RunService.RenderStepped:Connect(function()
        if not Aimbot.Config.Legit_Enabled then return end

        local holding = UserInputService:IsMouseButtonPressed(Aimbot.Config.Legit_HoldKey)
        if not holding then return end

        local target = getClosestPlayer(
            Aimbot.Config.Legit_FOV,
            Aimbot.Config.Legit_TargetPart,
            Aimbot.Config.Legit_TeamCheck,
            Aimbot.Config.Legit_WallCheck
        )
        if not target then return end

        local char = getCharacter(target)
        local part = char:FindFirstChild(Aimbot.Config.Legit_TargetPart) or getRootPart(char)
        if not part then return end

        local predicted = predictPosition(part, Aimbot.Config.Legit_BulletSpeed)
        local targetCF = CFrame.new(Camera.CFrame.Position, predicted)

        local smooth = Aimbot.Config.Legit_Smoothness
        if Aimbot.Config.Legit_RandomizeSmooth then
            smooth = math.random() * (Aimbot.Config.Legit_SmoothMax - Aimbot.Config.Legit_SmoothMin) + Aimbot.Config.Legit_SmoothMin
        end

        local jX, jY = 0, 0
        if Aimbot.Config.Legit_Jitter then
            jX = (math.random() * 2 - 1) * Aimbot.Config.Legit_JitterStrength
            jY = (math.random() * 2 - 1) * Aimbot.Config.Legit_JitterStrength
        end

        Camera.CFrame = Camera.CFrame:Lerp(
            CFrame.new(Camera.CFrame.Position, predicted) * CFrame.Angles(math.rad(jY), math.rad(jX), 0),
            smooth
        )
    end)
end

startLegitAimbot()

-- ===== SILENT AIM =====
local oldCalc
local silentTarget = nil

local function setupSilentAim()
    if not hookfunction then return end

    local function getTargetForSilent()
        return getClosestPlayer(
            Aimbot.Config.Silent_FOV,
            Aimbot.Config.Silent_TargetPart,
            Aimbot.Config.Silent_TeamCheck,
            Aimbot.Config.Silent_WallCheck
        )
    end

    -- Hook mouse position - redirige les raycast vers le joueur ciblé
    local mt = getrawmetatable(game)
    local old_index = mt.__index
    setreadonly(mt, false)
    mt.__index = newcclosure(function(self, key)
        if Aimbot.Config.Silent_Enabled then
            local holding
            pcall(function()
                holding = UserInputService:IsMouseButtonPressed(Aimbot.Config.Silent_HoldKey)
            end)
            if holding then
                if key == "Hit" and tostring(self):find("Mouse") then
                    if math.random(1, 100) <= Aimbot.Config.Silent_Chance then
                        local target = getTargetForSilent()
                        if target then
                            local char = getCharacter(target)
                            local part = char and (char:FindFirstChild(Aimbot.Config.Silent_TargetPart) or getRootPart(char))
                            if part then
                                local predicted = predictPosition(part, Aimbot.Config.Silent_BulletSpeed)
                                return CFrame.new(predicted)
                            end
                        end
                    end
                end
            end
        end
        return old_index(self, key)
    end)
    setreadonly(mt, true)
end

pcall(setupSilentAim)

-- ===== RAGE MODE =====
local rageConnection
local spinAngle = 0

local function startRageMode()
    if rageConnection then rageConnection:Disconnect() end
    rageConnection = RunService.RenderStepped:Connect(function()
        if not Aimbot.Config.Rage_Enabled then return end

        -- SpinBot
        if Aimbot.Config.Rage_SpinBot then
            local char = getCharacter(lp)
            local root = char and getRootPart(char)
            if root then
                spinAngle = (spinAngle + Aimbot.Config.Rage_SpinSpeed) % 360
                root.CFrame = CFrame.new(root.Position) * CFrame.Angles(0, math.rad(spinAngle), 0)
            end
        end

        local holding
        pcall(function()
            holding = UserInputService:IsMouseButtonPressed(Aimbot.Config.Rage_HoldKey)
        end)
        if not holding and not Aimbot.Config.Rage_AutoShoot then return end

        local target = getClosestPlayer(
            Aimbot.Config.Rage_FOV,
            Aimbot.Config.Rage_TargetPart,
            Aimbot.Config.Rage_TeamCheck,
            Aimbot.Config.Rage_WallCheck
        )
        if not target then return end

        local char = getCharacter(target)
        local part = char:FindFirstChild(Aimbot.Config.Rage_TargetPart) or getRootPart(char)
        if not part then return end

        Camera.CFrame = CFrame.new(Camera.CFrame.Position, part.Position)

        if Aimbot.Config.Rage_AutoShoot then
            mouse1click()
        end
    end)
end

startRageMode()

-- ===== NO RECOIL =====
local noRecoilConn
local function setupNoRecoil()
    if noRecoilConn then noRecoilConn:Disconnect() end
    noRecoilConn = RunService.Heartbeat:Connect(function()
        if not Aimbot.Config.NoRecoil_Enabled and not Aimbot.Config.Rage_NoRecoil then return end
        local camCF = Camera.CFrame
        local _, currentPitch, _ = camCF:ToEulerAnglesYXZ()
        if currentPitch > 0.01 then
            Camera.CFrame = camCF * CFrame.Angles(-currentPitch * Aimbot.Config.NoRecoil_Scale, 0, 0)
        end
    end)
end

setupNoRecoil()

-- ===== TRIGGERBOT =====
local triggerConn
local function setupTriggerBot()
    if triggerConn then triggerConn:Disconnect() end
    triggerConn = RunService.RenderStepped:Connect(function()
        if not Aimbot.Config.Rage_TriggerBot then return end
        local unitRay = Camera:ScreenPointToRay(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
        local params = RaycastParams.new()
        params.FilterDescendantsInstances = {getCharacter(lp)}
        params.FilterType = Enum.RaycastFilterType.Exclude
        local result = workspace:Raycast(unitRay.Origin, unitRay.Direction * 1000, params)
        if result then
            local instance = result.Instance
            local char = instance:FindFirstAncestorOfClass("Model")
            local player = char and Players:GetPlayerFromCharacter(char)
            if player and player ~= lp then
                if Aimbot.Config.Rage_TeamCheck and sameTeam(player) then return end
                task.delay(Aimbot.Config.Rage_TriggerDelay, function()
                    mouse1click()
                end)
            end
        end
    end)
end

setupTriggerBot()

return Aimbot
