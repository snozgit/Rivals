-- ====================================================
-- UwU - Rivals LOADER
-- ====================================================

task.spawn(function()
    local BASE = "https://raw.githubusercontent.com/snozgit/Rivals/main/"
    local function Load(m)
        local ok, result = pcall(function()
            return loadstring(game:HttpGet(BASE .. m .. ".lua", true))()
        end)
        if not ok then warn("[UwU] Erreur " .. m .. ": " .. tostring(result)) end
        return result
    end

    local UI = Load("ui")
    _G.RivalsUI = UI
    task.wait(0.3)

    local Aimbot, ESP_, World, Misc

    task.spawn(function() Aimbot = Load("aimbot") end); task.wait(0.4)
    task.spawn(function() ESP_   = Load("esp")    end); task.wait(0.4)
    task.spawn(function() World  = Load("world")  end); task.wait(0.4)
    task.spawn(function() Misc   = Load("misc")   end); task.wait(0.8)

    -- ====================================================
    -- ONGLET COMBAT
    -- ====================================================
    local CombatTab = UI:CreateTab("Combat")
    local CL = CombatTab.Left
    local CR = CombatTab.Right

    -- COLONNE GAUCHE
    UI:AddSection(CL, "Silent Aim")
    UI:AddToggle(CL, "Silent Aim Enabled",   false, function(v) Aimbot.Config.Silent_Enabled = v end)
    UI:AddToggle(CL, "Wall Check",           false, function(v) Aimbot.Config.Silent_WallCheck = v end)
    UI:AddSlider(CL, "Prediction",           0, 100, 35, "", function(v) Aimbot.Config.Silent_BulletSpeed = v * 10 end)
    UI:AddDropdown(CL, "Target Part",        {"Head","UpperTorso","HumanoidRootPart"}, "Head", function(v) Aimbot.Config.Silent_TargetPart = v end)
    UI:AddSlider(CL, "Hit Cooldown (ms)",    0, 500, 50, " ms", function(v) end)
    UI:AddToggle(CL, "Show FOV Circle",      true,  function(v) Aimbot.Config.Legit_FOVVisible = v end)
    UI:AddToggle(CL, "Filled FOV Circle",    false, function(v) end)
    UI:AddColorPicker(CL, "FOV Circle Color", Color3.fromRGB(200,20,20), function(c) Aimbot.Config.Legit_FOVColor = c end)
    UI:AddToggle(CL, "Rainbow FOV Color",    false, function(v) end)
    UI:AddSlider(CL, "FOV Radius Size",      10, 800, 150, "", function(v) Aimbot.Config.Silent_FOV = v end)
    UI:AddSlider(CL, "Max Distance (Studs)", 50, 2000, 500, "", function(v) Aimbot.Config.Silent_BulletSpeed = v end)
    UI:AddToggle(CL, "Projectile Prediction",true, function(v) Aimbot.Config.Silent_Predict = v end)
    UI:AddSpacer(CL, 4)

    UI:AddSection(CL, "Gun Mods")
    UI:AddToggle(CL, "Enable Gun Mods",      false, function(v) end)
    UI:AddToggle(CL, "No Recoil",            false, function(v) Aimbot.Config.NoRecoil_Enabled = v end)
    UI:AddToggle(CL, "No Spread / Perfect Accuracy", false, function(v) Aimbot.Config.NoSpread_Enabled = v end)
    UI:AddToggle(CL, "Infinite Ammo",        false, function(v) Misc.Config.InfiniteAmmo = v; Misc.SetInfiniteAmmo(v) end)

    -- COLONNE DROITE
    UI:AddSection(CR, "Rage Mode")
    UI:AddToggle(CR, "Rage Bot Enable",      false, function(v) Aimbot.Config.Rage_Enabled = v end)
    UI:AddToggle(CR, "Auto Shoot",           false, function(v) Aimbot.Config.Rage_AutoShoot = v end)
    UI:AddToggle(CR, "Show FOV Circle",      false, function(v) end)
    UI:AddToggle(CR, "Filled FOV Circle",    false, function(v) end)
    UI:AddColorPicker(CR, "FOV Circle Color (Rage)", Color3.fromRGB(200,20,20), function(c) end)
    UI:AddToggle(CR, "Rainbow FOV Color",    false, function(v) end)
    UI:AddSlider(CR, "Rage FOV Radius",      10, 1000, 250, "", function(v) Aimbot.Config.Rage_FOV = v end)
    UI:AddToggle(CR, "Wallbang",             false, function(v) Aimbot.Config.Rage_WallCheck = not v end)
    UI:AddSpacer(CR, 4)

    UI:AddSection(CR, "Aimbot")
    UI:AddToggle(CR, "Aimbot Enabled",       false, function(v) Aimbot.Config.Legit_Enabled = v end)
    UI:AddToggle(CR, "Use Keybind (Hold to Aim)", true, function(v) end)
    UI:AddToggle(CR, "Use Smoothing",        true,  function(v) end)
    UI:AddSlider(CR, "Smoothing Value",      1, 100, 18, "", function(v) Aimbot.Config.Legit_Smoothness = v / 100 end)
    UI:AddToggle(CR, "Movement Prediction",  false, function(v) Aimbot.Config.Legit_PredictBullet = v end)
    UI:AddToggle(CR, "Wall Check",           true,  function(v) Aimbot.Config.Legit_WallCheck = v end)
    UI:AddDropdown(CR, "Target Part",        {"Head","UpperTorso","HumanoidRootPart","Neck"}, "Head", function(v) Aimbot.Config.Legit_TargetPart = v end)
    UI:AddSlider(CR, "FOV Radius Size",      10, 600, 150, "", function(v) Aimbot.Config.Legit_FOV = v end)
    UI:AddSpacer(CR, 4)

    UI:AddSection(CR, "Trigger Bot")
    UI:AddToggle(CR, "Enable Trigger Bot",   false, function(v) Aimbot.Config.Rage_TriggerBot = v end)
    UI:AddSlider(CR, "Trigger Delay (ms)",   0, 500, 50, " ms", function(v) Aimbot.Config.Rage_TriggerDelay = v / 1000 end)
    UI:AddToggle(CR, "Wall Check",           true, function(v) end)

    -- ====================================================
    -- ONGLET ESP
    -- ====================================================
    local ESPTab = UI:CreateTab("ESP")
    local EL = ESPTab.Left
    local ER = ESPTab.Right

    UI:AddSection(EL, "ESP Switches")
    UI:AddToggle(EL, "ESP Enabled",         false, function(v) ESP_.Config.Enabled = v end)
    UI:AddToggle(EL, "ESP Box Outlines",     true,  function(v) ESP_.Config.Boxes = v end)
    UI:AddToggle(EL, "Modern Filled Boxes",  false, function(v) ESP_.Config.BoxStyle = v and "Full" or "Corners" end)
    UI:AddToggle(EL, "ESP Line Tracers",     false, function(v) ESP_.Config.Tracers = v end)
    UI:AddToggle(EL, "ESP Health Bars",      true,  function(v) ESP_.Config.HealthBar = v end)
    UI:AddToggle(EL, "ESP Names",            true,  function(v) ESP_.Config.Names = v end)
    UI:AddToggle(EL, "ESP Distance",         true,  function(v) ESP_.Config.Distance = v end)
    UI:AddToggle(EL, "Neon Chams",           false, function(v) ESP_.Config.Chams = v end)
    UI:AddToggle(EL, "Skeleton ESP",         false, function(v) ESP_.Config.Skeleton = v end)
    UI:AddToggle(EL, "Head Dot",             false, function(v) ESP_.Config.HeadDot = v end)
    UI:AddToggle(EL, "Arrows (Off-Screen)",  false, function(v) ESP_.Config.Arrows = v end)
    UI:AddToggle(EL, "3D Box",               false, function(v) ESP_.Config.Boxes3D = v end)
    UI:AddSlider(EL, "Max ESP Distance",     100, 2000, 400, "", function(v) ESP_.Config.MaxDistance = v end)
    UI:AddToggle(EL, "Team Check ESP",       true, function(v) ESP_.Config.TeamCheck = v end)
    UI:AddToggle(EL, "Fade Distance",        true, function(v) ESP_.Config.FadeDistance = v end)
    UI:AddSlider(EL, "Fade Start",           100, 2000, 800, "", function(v) ESP_.Config.FadeStart = v end)
    UI:AddSlider(EL, "Update FPS",           5, 60, 30, "", function(v) ESP_.Config.UpdateFPS = v end)

    UI:AddSection(ER, "ESP Appearance")
    UI:AddDropdown(ER, "Box Style",          {"Corners","Full"}, "Corners", function(v) ESP_.Config.BoxStyle = v end)
    UI:AddSlider(ER, "Corner Length",        2, 20, 8, "", function(v) ESP_.Config.CornerLen = v end)
    UI:AddSlider(ER, "Box Line Thickness",   1, 5, 2, "", function(v)
        -- update thickness sur tous les drawings existants
    end)
    UI:AddSlider(ER, "HP Bar Width",         1, 8, 3, "", function(v) ESP_.Config.HealthBarWidth = v end)
    UI:AddSpacer(ER, 4)
    UI:AddSection(ER, "Couleurs ESP")
    UI:AddColorPicker(ER, "Box / Visible",   Color3.fromRGB(0,255,65),    function(c) ESP_.Config.Color_Visible = c end)
    UI:AddColorPicker(ER, "Box / Caché",     Color3.fromRGB(200,20,20),   function(c) ESP_.Config.Color_Hidden = c end)
    UI:AddColorPicker(ER, "Tracers",         Color3.fromRGB(0,207,255),   function(c) ESP_.Config.Color_Tracer = c end)
    UI:AddColorPicker(ER, "Skeleton",        Color3.fromRGB(255,96,96),   function(c) ESP_.Config.Color_Skeleton = c end)
    UI:AddColorPicker(ER, "Head Dot",        Color3.fromRGB(255,221,68),  function(c) ESP_.Config.Color_HeadDot = c end)
    UI:AddColorPicker(ER, "Noms",            Color3.fromRGB(255,255,255), function(c) ESP_.Config.Color_Name = c end)
    UI:AddColorPicker(ER, "Distance",        Color3.fromRGB(170,170,170), function(c) ESP_.Config.Color_Dist = c end)
    UI:AddColorPicker(ER, "HP Bar",          Color3.fromRGB(68,255,136),  function(c) ESP_.Config.Color_Health = c end)
    UI:AddColorPicker(ER, "Chams Color",     Color3.fromRGB(255,30,30),   function(c) ESP_.Config.Chams_FillColor = c end)
    UI:AddColorPicker(ER, "Arrow Color",     Color3.fromRGB(255,50,50),   function(c) ESP_.Config.ArrowColor = c end)

    -- ====================================================
    -- ONGLET VISUALS
    -- ====================================================
    local VisTab = UI:CreateTab("Visuals")
    local VL = VisTab.Left
    local VR = VisTab.Right

    UI:AddSection(VL, "Visual Customization")
    UI:AddToggle(VL, "Animated Crosshair",   false, function(v) ESP_.Config.Crosshair = v end)
    UI:AddColorPicker(VL, "Crosshair Color", Color3.fromRGB(255,255,255), function(c) ESP_.Config.CrosshairColor = c end)
    UI:AddSlider(VL, "Crosshair Size",       2, 30, 10, "", function(v) ESP_.Config.CrosshairSize = v end)
    UI:AddSlider(VL, "Crosshair Gap",        0, 20, 4, "", function(v) ESP_.Config.CrosshairGap = v end)
    UI:AddSpacer(VL, 4)
    UI:AddSection(VL, "FOV")
    UI:AddToggle(VL, "Show FOV Circle",      false, function(v) ESP_.Config.FovCircle = v end)
    UI:AddToggle(VL, "Filled FOV",           false, function(v) ESP_.Config.FovCircleFilled = v end)
    UI:AddSlider(VL, "FOV Circle Size",      10, 800, 120, "", function(v) ESP_.Config.FovCircleSize = v end)
    UI:AddColorPicker(VL, "FOV Color",       Color3.fromRGB(200,20,20), function(c) ESP_.Config.FovCircleColor = c end)

    UI:AddSection(VR, "Sky Color Override")
    UI:AddToggle(VR, "Sky Color Override",   false, function(v)
        if v then game:GetService("Lighting").FogEnd = 100000; game:GetService("Lighting").FogStart = 100000 end
    end)
    UI:AddSlider(VR, "Sky & Ambient Brightness", 0, 5, 1, "", function(v)
        game:GetService("Lighting").Brightness = v
    end)
    UI:AddSlider(VR, "Time of Day",          0, 24, 12, "h", function(v)
        game:GetService("Lighting").ClockTime = v
    end)
    UI:AddSpacer(VR, 4)
    UI:AddSection(VR, "Misc Visuals")
    UI:AddToggle(VR, "Full Bright",          false, function(v)
        World.Config.FullBright = v; World.ApplyBright(v)
    end)
    UI:AddToggle(VR, "No Fog",               false, function(v)
        World.Config.NoFog = v; World.ApplyFog(v)
    end)
    UI:AddToggle(VR, "No Grass",             false, function(v)
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("Decal") and obj.Name:lower():find("grass") then obj.Transparency = v and 1 or 0 end
        end
    end)

    -- ====================================================
    -- ONGLET PLAYER
    -- ====================================================
    local PlayerTab = UI:CreateTab("Player")
    local PL = PlayerTab.Left
    local PR = PlayerTab.Right

    UI:AddSection(PL, "Movement")
    UI:AddToggle(PL, "Custom Walk Speed",    false, function(v) World.Config.Speed = v end)
    UI:AddSlider(PL, "Walk Speed",           8, 200, 50, "", function(v) World.Config.Speed_Value = v end)
    UI:AddButton(PL, "Reset Walk Speed", function()
        local char = game:GetService("Players").LocalPlayer.Character
        if char then local hum = char:FindFirstChildOfClass("Humanoid"); if hum then hum.WalkSpeed = 16 end end
    end)
    UI:AddToggle(PL, "Custom Jump Power",    false, function(v) World.Config.HighJump = v end)
    UI:AddSlider(PL, "Jump Power",           10, 300, 50, "", function(v) World.Config.HighJump_Power = v end)
    UI:AddSlider(PL, "Gravity",              0, 400, 196, "", function(v) workspace.Gravity = v end)
    UI:AddSpacer(PL, 4)
    UI:AddSection(PL, "Teleport")
    UI:AddButton(PL, "Save Position", function()
        local char = game:GetService("Players").LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then _G.SavedPos = hrp.CFrame; UI:Notify("Position", "Sauvegardée !", 2) end
    end)
    UI:AddButton(PL, "Load Position", function()
        if not _G.SavedPos then return end
        local char = game:GetService("Players").LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then hrp.CFrame = _G.SavedPos; UI:Notify("Position", "Chargée !", 2) end
    end)

    UI:AddSection(PR, "Toggles & Emergency")
    UI:AddToggle(PR, "Infinite Jump",        false, function(v) World.Config.InfJump = v end)
    UI:AddToggle(PR, "Noclip (Walk Through Walls)", false, function(v) World.Config.Noclip = v end)
    UI:AddToggle(PR, "Fullbright",           false, function(v) World.Config.FullBright = v; World.ApplyBright(v) end)
    UI:AddToggle(PR, "Anti-AFK",             true,  function(v) World.Config.AntiAFK = v end)
    UI:AddToggle(PR, "Anti-Ragdoll",         false, function(v) Misc.Config.AntiRagdoll = v end)
    UI:AddSpacer(PR, 4)
    UI:AddSection(PR, "Fly")
    UI:AddToggle(PR, "Fly",                  false, function(v) World.Config.Fly = v end)
    UI:AddSlider(PR, "Fly Speed",            10, 300, 80, "", function(v) World.Config.Fly_Speed = v end)
    UI:AddSpacer(PR, 4)
    UI:AddSection(PR, "Server")
    UI:AddButton(PR, "Server Hop", function()
        game:GetService("TeleportService"):Teleport(game.PlaceId)
    end)
    UI:AddButton(PR, "Rejoin", function()
        game:GetService("TeleportService"):Teleport(game.PlaceId)
    end)
    UI:AddButton(PR, "Copy Position", function()
        local char = game:GetService("Players").LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then
            local p = hrp.Position
            setclipboard(string.format("%.2f, %.2f, %.2f", p.X, p.Y, p.Z))
            UI:Notify("Clipboard", "Position copiée !", 2)
        end
    end)

    -- ====================================================
    -- ONGLET DIVERS
    -- ====================================================
    local DiversTab = UI:CreateTab("Divers")
    local DL = DiversTab.Left
    local DR = DiversTab.Right

    UI:AddSection(DL, "Skin Changer")
    UI:AddToggle(DL, "Skin Changer (Unlock All Cosmetics)", false, function(v)
        if v then Misc.LoadUnlockAll() end
    end)
    UI:AddButton(DL, "Reload Cosmetics", function() Misc.LoadUnlockAll() end)
    UI:AddButton(DL, "Clear Saved Cosmetics", function() UI:Notify("Cosmetics", "Cache effacé.", 2) end)
    UI:AddSpacer(DL, 4)
    UI:AddSection(DL, "Misc Gameplay")
    UI:AddToggle(DL, "Auto Respawn",         false, function(v) Misc.Config.AutoRespawn = v end)
    UI:AddToggle(DL, "Hide GUI",             false, function(v)
        Misc.Config.HideGUI = v; Misc.ToggleHideGUI(v)
    end)
    UI:AddToggle(DL, "Infinite Ammo",        false, function(v)
        Misc.Config.InfiniteAmmo = v; Misc.SetInfiniteAmmo(v)
    end)
    UI:AddSpacer(DL, 4)
    UI:AddSection(DL, "Utilitaires")
    UI:AddButton(DL, "Respawn maintenant", function()
        game:GetService("Players").LocalPlayer:LoadCharacter()
    end)

    UI:AddSection(DR, "Team Debug")
    UI:AddButton(DR, "Show My Team Info", function()
        local t = game:GetService("Players").LocalPlayer.Team
        UI:Notify("Team Info", t and t.Name or "No Team", 3)
    end)
    UI:AddButton(DR, "Show All Players Teams", function()
        local str = ""
        for _, p in ipairs(game:GetService("Players"):GetPlayers()) do
            str = str .. p.Name .. ": " .. (p.Team and p.Team.Name or "none") .. "\n"
        end
        print(str)
        UI:Notify("Teams", "Check console (F9)", 3)
    end)

    -- ====================================================
    -- ONGLET UI SETTINGS
    -- ====================================================
    local UITab = UI:CreateTab("UI Settings")
    local UL = UITab.Left
    local UR = UITab.Right

    UI:AddSection(UL, "Menu")
    UI:AddLabel(UL, "INSERT = Toggle Menu")
    UI:AddSpacer(UL, 4)
    UI:AddSection(UL, "Themes")
    UI:AddColorPicker(UL, "Background color",  Color3.fromRGB(10,10,11),   function(c) UI.Theme.BG = c end)
    UI:AddColorPicker(UL, "Main color",        Color3.fromRGB(14,14,15),   function(c) UI.Theme.BG2 = c end)
    UI:AddColorPicker(UL, "Accent color",      Color3.fromRGB(200,20,20),  function(c)
        UI.Theme.Accent = c
        UI.Theme.SliderFill = c
        UI.Theme.CheckOn = c
        UI.Theme.Section = c
    end)
    UI:AddColorPicker(UL, "Font color",        Color3.fromRGB(230,230,230), function(c) UI.Theme.Text = c end)

    UI:AddSection(UR, "Configuration")
    UI:AddButton(UR, "Save Config", function()
        UI:Notify("Config", "Sauvegardé !", 2)
    end)
    UI:AddButton(UR, "Destroy UI", function()
        UI.ScreenGui:Destroy()
    end)
    UI:AddSpacer(UR, 4)
    UI:AddSection(UR, "Infos")
    UI:AddLabel(UR, "UwU - Rivals v2.0\nDev: SnoZ\nINSERT = Toggle")

    -- Notif finale
    UI:Notify("UwU - Rivals", "Chargé avec succès  •  INSERT pour cacher", 4)
end)
