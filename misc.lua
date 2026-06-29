-- ==================== MISC ====================
local Misc = {}
local Players       = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService   = game:GetService("HttpService")
local lp            = Players.LocalPlayer

Misc.Config = {
    UnlockAll   = false,
    AntiRagdoll = false,
    FakeServer  = false,
    AutoRespawn = false,
    HideGUI     = false,
    InfiniteAmmo = false,
    NoDeath     = false,
    CustomName  = false,
    CustomNameText = "player",
}

-- ===== UNLOCK ALL =====
function Misc.LoadUnlockAll()
    -- Ton code unlock all intégré directement
    local ok, err = pcall(function()
        local UnlockScript = loadstring(game:HttpGet(
            "https://raw.githubusercontent.com/snozgit/Rivals/main/unlockall.lua", true
        ))()
    end)
    if ok then
        if _G.RivalsUI then
            _G.RivalsUI:Notify("UnlockAll", "Tous les cosmétiques débloqués !", 3)
        end
    else
        warn("UnlockAll error: " .. tostring(err))
    end
end

-- ===== AUTO RESPAWN =====
lp.CharacterAdded:Connect(function(char)
    if Misc.Config.AutoRespawn then
        local hum = char:WaitForChild("Humanoid")
        hum.Died:Connect(function()
            task.wait(0.5)
            lp:LoadCharacter()
        end)
    end
end)

-- ===== ANTI RAGDOLL =====
RunService = game:GetService("RunService")
RunService.Stepped:Connect(function()
    if not Misc.Config.AntiRagdoll then return end
    local char = lp.Character
    if not char then return end
    for _, v in ipairs(char:GetDescendants()) do
        if v:IsA("BallSocketConstraint") or v:IsA("HingeConstraint") then
            v.Enabled = false
        end
    end
end)

-- ===== HIDE GUI =====
function Misc.ToggleHideGUI(enabled)
    for _, gui in ipairs(lp.PlayerGui:GetChildren()) do
        if gui.Name ~= "RivalsCheat" then
            gui.Enabled = not enabled
        end
    end
end

-- ===== INFINITE AMMO =====
local ammoConn
function Misc.SetInfiniteAmmo(enabled)
    if ammoConn then ammoConn:Disconnect() end
    if not enabled then return end
    ammoConn = game:GetService("RunService").Heartbeat:Connect(function()
        local char = lp.Character
        if not char then return end
        -- Hook les valeurs d'ammo communes dans Rivals
        for _, v in ipairs(char:GetDescendants()) do
            if v:IsA("IntValue") or v:IsA("NumberValue") then
                local n = v.Name:lower()
                if n:find("ammo") or n:find("bullet") or n:find("clip") then
                    if v.Value < 999 then v.Value = 999 end
                end
            end
        end
    end)
end

return Misc
