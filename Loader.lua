-- ====================================================
-- RIVALS CHEAT — LOADER PRINCIPAL
-- ====================================================

task.spawn(function()
    local BASE = "https://raw.githubusercontent.com/snozgit/Rivals/main/"
    local function Load(m)
        local ok, result = pcall(function()
            return loadstring(game:HttpGet(BASE .. m .. ".lua", true))()
        end)
        if not ok then warn("Erreur chargement " .. m .. ": " .. tostring(result)) end
        return result
    end

    local UI = Load("ui")
    _G.RivalsUI = UI
    task.wait(0.5)

    local Aimbot, ESP_, World, Misc

    task.spawn(function() Aimbot = Load("aimbot") end)
    task.wait(0.5)

    task.spawn(function() ESP_ = Load("esp") end)
    task.wait(0.5)

    task.spawn(function() World = Load("world") end)
    task.wait(0.5)

    task.spawn(function() Misc = Load("misc") end)
    task.wait(1)

    -- ====================================================
    -- ONGLET AIMBOT
    -- ====================================================
    local AimTab = UI:CreateTab("Aimbot", "◎")

    UI:AddSection(AimTab, "Legit Aimbot")
    UI:AddToggle(AimTab, "Activer Legit", false, function(v) Aimbot.Config.Legit_Enabled = v end)
    UI:AddSlider(AimTab, "FOV", 10, 500, 120, "px", function(v) Aimbot.Config.Legit_FOV = v end)
    UI:AddSlider(AimTab, "Smoothness", 1, 100, 18, "%", function(v) Aimbot.Config.Legit_Smoothness = v / 100 end)
    UI:AddDropdown(AimTab, "Target Part", {"Head","UpperTorso","HumanoidRootPart","Neck"}, "Head", function(v) Aimbot.Config.Legit_TargetPart = v end)
    UI:AddToggle(AimTab, "FOV Visible", true, function(v) Aimbot.Config.Legit_FOVVisible = v end)
    UI:AddToggle(AimTab, "Team Check", true, function(v) Aimbot.Config.Legit_TeamCheck = v end)
    UI:AddToggle(AimTab, "Wall Check", true, function(v) Aimbot.Config.Legit_WallCheck = v end)
    UI:AddToggle(AimTab, "Prédiction Bullet", true, function(v) Aimbot.Config.Legit_PredictBullet = v end)
    UI:AddSlider(AimTab, "Bullet Speed", 100, 1000, 300, "s", function(v) Aimbot.Config.Legit_BulletSpeed = v end)
    UI:AddToggle(AimTab, "Jitter", false, function(v) Aimbot.Config.Legit_Jitter = v end)
    UI:AddSlider(AimTab, "Jitter Strength", 1, 10, 2, "", function(v) Aimbot.Config.Legit_JitterStrength = v end)
    UI:AddToggle(AimTab, "Smooth Aléatoire", false, function(v) Aimbot.Config.Legit_RandomizeSmooth = v end)
    UI:AddColorPicker(AimTab, "Couleur FOV", Color3.fromRGB(255,255,255), function(c) Aimbot.Config.Legit_FOVColor = c end)

    UI:AddSection(AimTab, "Silent Aim")
    UI:AddToggle(AimTab, "Activer Silent", false, function(v) Aimbot.Config.Silent_Enabled = v end)
    UI:AddSlider(AimTab, "FOV Silent", 10, 800, 200, "px", function(v) Aimbot.Config.Silent_FOV = v end)
    UI:AddSlider(AimTab, "Chance (%)", 1, 100, 100, "%", function(v) Aimbot.Config.Silent_Chance = v end)
    UI:AddDropdown(AimTab, "Target Silent", {"HumanoidRootPart","Head","UpperTorso"}, "HumanoidRootPart", function(v) Aimbot.Config.Silent_TargetPart = v end)
    UI:AddToggle(AimTab, "Silent Team Check", true, function(v) Aimbot.Config.Silent_TeamCheck = v end)
    UI:AddToggle(AimTab, "Silent Wall Check", false, function(v) Aimbot.Config.Silent_WallCheck = v end)
    UI:AddToggle(AimTab, "Silent Predict", true, function(v) Aimbot.Config.Silent_Predict = v end)

    UI:AddSection(AimTab, "Rage Mode")
    UI:AddToggle(AimTab, "Activer Rage", false, function(v) Aimbot.Config.Rage_Enabled = v end)
    UI:AddSlider(AimTab, "FOV Rage", 10, 1000, 999, "px", function(v) Aimbot.Config.Rage_FOV = v end)
    UI:AddDropdown(AimTab, "Target Rage", {"HumanoidRootPart","Head","UpperTorso"}, "HumanoidRootPart", function(v) Aimbot.Config.Rage_TargetPart = v end)
    UI:AddToggle(AimTab, "Team Check Rage", false, function(v) Aimbot.Config.Rage_TeamCheck = v end)
    UI:AddToggle(AimTab, "Auto Shoot", false, function(v) Aimbot.Config.Rage_AutoShoot = v end)
    UI:AddToggle(AimTab, "SpinBot", false, function(v) Aimbot.Config.Rage_SpinBot = v end)
    UI:AddSlider(AimTab, "Spin Speed", 1, 50, 10, "", function(v) Aimbot.Config.Rage_SpinSpeed = v end)
    UI:AddToggle(AimTab, "TriggerBot", false, function(v) Aimbot.Config.Rage_TriggerBot = v end)
    UI:AddSlider(AimTab, "Trigger Delay", 0, 500, 50, "ms", function(v) Aimbot.Config.Rage_TriggerDelay = v / 1000 end)
    UI:AddToggle(AimTab, "No Recoil (Rage)", false, function(v) Aimbot.Config.Rage_NoRecoil = v end)
    UI:AddToggle(AimTab, "No Spread (Rage)", false, function(v) Aimbot.Config.Rage_NoSpread = v end)

    UI:AddSection(AimTab, "Standalone")
    UI:AddToggle(AimTab, "No Recoil", false, function(v) Aimbot.Config.NoRecoil_Enabled = v end)
    UI:AddSlider(AimTab, "Recoil Scale", 1, 100, 100, "%", function(v) Aimbot.Config.NoRecoil_Scale = v / 100 end)
    UI:AddToggle(AimTab, "No Spread", false, function(v) Aimbot.Config.NoSpread_Enabled = v end)

    -- ====================================================
    -- ONGLET ESP
    -- ====================================================
    local EspTab = UI:CreateTab("ESP", "👁")

    UI:AddSection(EspTab, "Players ESP")
    UI:AddToggle(EspTab, "Activer ESP", false, function(v) ESP_.Config.Enabled = v end)
    UI:AddToggle(EspTab, "Boxes 2D", true, function(v) ESP_.Config.Boxes = v end)
    UI:AddToggle(EspTab, "Boxes 3D", false, function(v) ESP_.Config.Boxes3D = v end)
    UI:AddToggle(EspTab, "Noms", true, function(v) ESP_.Config.Names = v end)
    UI:AddToggle(EspTab, "Distance", true, function(v) ESP_.Config.Distance = v end)
    UI:AddToggle(EspTab, "HP Texte", true, function(v) ESP_.Config.Health = v end)
    UI:AddToggle(EspTab, "Barre HP", true, function(v) ESP_.Config.HealthBar = v end)
    UI:AddToggle(EspTab, "Tracers", false, function(v) ESP_.Config.Tracers = v end)
    UI:AddDropdown(EspTab, "Tracer Origine", {"Bottom","Center","Top"}, "Bottom", function(v) ESP_.Config.Tracers_From = v end)
    UI:AddToggle(EspTab, "Squelette", false, function(v) ESP_.Config.Skeleton = v end)
    UI:AddToggle(EspTab, "Head Dot", false, function(v) ESP_.Config.HeadDot = v end)
    UI:AddToggle(EspTab, "Chams", false, function(v) ESP_.Config.Chams = v end)
    UI:AddToggle(EspTab, "Team Check", true, function(v) ESP_.Config.TeamCheck = v end)
    UI:AddSlider(EspTab, "Distance Max", 100, 5000, 2000, "m", function(v) ESP_.Config.MaxDistance = v end)

    UI:AddSection(EspTab, "Couleurs ESP")
    UI:AddColorPicker(EspTab, "Visible", Color3.fromRGB(100,255,100), function(c) ESP_.Config.Color_Visible = c end)
    UI:AddColorPicker(EspTab, "Caché", Color3.fromRGB(255,60,60), function(c) ESP_.Config.Color_Hidden = c end)
    UI:AddColorPicker(EspTab, "Team", Color3.fromRGB(60,120,255), function(c) ESP_.Config.Color_Team = c end)
    UI:AddColorPicker(EspTab, "Box", Color3.fromRGB(255,255,255), function(c) ESP_.Config.Color_Box = c end)
    UI:AddColorPicker(EspTab, "Tracer", Color3.fromRGB(255,255,255), function(c) ESP_.Config.Color_Tracer = c end)
    UI:AddColorPicker(EspTab, "Squelette", Color3.fromRGB(200,200,200), function(c) ESP_.Config.Color_Skeleton = c end)
    UI:AddColorPicker(EspTab, "Noms", Color3.fromRGB(255,255,255), function(c) ESP_.Config.Color_Name = c end)
    UI:AddColorPicker(EspTab, "Head Dot", Color3.fromRGB(255,80,80), function(c) ESP_.Config.Color_HeadDot = c end)
    UI:AddColorPicker(EspTab, "Chams Couleur", Color3.fromRGB(255,60,60), function(c) ESP_.Config.Chams_FillColor = c end)

    UI:AddSection(EspTab, "Crosshair")
    UI:AddToggle(EspTab, "Crosshair", false, function(v) ESP_.Config.Crosshair = v end)
    UI:AddSlider(EspTab, "Taille", 2, 30, 10, "px", function(v) ESP_.Config.Crosshair_Size = v end)
    UI:AddSlider(EspTab, "Gap", 0, 20, 4, "px", function(v) ESP_.Config.Crosshair_Gap = v end)
    UI:AddColorPicker(EspTab, "Couleur Crosshair", Color3.fromRGB(255,255,255), function(c) ESP_.Config.Crosshair_Color = c end)

    UI:AddSection(EspTab, "FOV Circle")
    UI:AddToggle(EspTab, "FOV Circle ESP", false, function(v) ESP_.Config.FovCircle = v end)
    UI:AddSlider(EspTab, "FOV Circle Size", 10, 800, 120, "px", function(v) ESP_.Config.FovCircle_Size = v end)
    UI:AddColorPicker(EspTab, "FOV Circle Color", Color3.fromRGB(255,255,255), function(c) ESP_.Config.FovCircle_Color = c end)

    -- ====================================================
    -- ONGLET WORLD
    -- ====================================================
    local WorldTab = UI:CreateTab("World", "🌐")

    UI:AddSection(WorldTab, "Visuels")
    UI:AddToggle(WorldTab, "No Fog", false, function(v)
        World.Config.NoFog = v
        World.ApplyFog(v)
    end)
    UI:AddToggle(WorldTab, "Full Bright", false, function(v)
        World.Config.FullBright = v
        World.ApplyBright(v)
    end)
    UI:AddSlider(WorldTab, "Brightness", 1, 10, 3, "", function(v)
        World.Config.FullBright_Val = v
        if World.Config.FullBright then World.ApplyBright(true) end
    end)

    UI:AddSection(WorldTab, "Items ESP")
    UI:AddToggle(WorldTab, "Items ESP", false, function(v) World.Config.Item_ESP = v end)
    UI:AddSlider(WorldTab, "Item Max Dist", 50, 2000, 500, "m", function(v) World.Config.Item_MaxDist = v end)
    UI:AddColorPicker(WorldTab, "Couleur Items", Color3.fromRGB(255,200,50), function(c) World.Config.Item_Color = c end)

    UI:AddSection(WorldTab, "Mouvement")
    UI:AddToggle(WorldTab, "Inf Jump", false, function(v) World.Config.InfJump = v end)
    UI:AddToggle(WorldTab, "High Jump", false, function(v) World.Config.HighJump = v end)
    UI:AddSlider(WorldTab, "Jump Power", 10, 300, 80, "", function(v) World.Config.HighJump_Power = v end)
    UI:AddToggle(WorldTab, "Speed Hack", false, function(v) World.Config.Speed = v end)
    UI:AddSlider(WorldTab, "Speed Value", 8, 200, 24, "", function(v) World.Config.Speed_Value = v end)
    UI:AddToggle(WorldTab, "Fly", false, function(v) World.Config.Fly = v end)
    UI:AddSlider(WorldTab, "Fly Speed", 10, 300, 60, "", function(v) World.Config.Fly_Speed = v end)
    UI:AddToggle(WorldTab, "Noclip", false, function(v) World.Config.Noclip = v end)
    UI:AddToggle(WorldTab, "Third Person", false, function(v) World.Config.ThirdPerson = v end)
    UI:AddSlider(WorldTab, "3rd Distance", 5, 30, 8, "", function(v) World.Config.ThirdPerson_Dist = v end)

    -- ====================================================
    -- ONGLET MISC
    -- ====================================================
    local MiscTab = UI:CreateTab("Misc", "⚙")

    UI:AddSection(MiscTab, "Cosmétiques")
    UI:AddButton(MiscTab, "🔓  Unlock All Cosmétiques", function()
        Misc.LoadUnlockAll()
    end)

    UI:AddSection(MiscTab, "Gameplay")
    UI:AddToggle(MiscTab, "Anti-AFK", true, function(v) World.Config.AntiAFK = v end)
    UI:AddToggle(MiscTab, "Auto Respawn", false, function(v) Misc.Config.AutoRespawn = v end)
    UI:AddToggle(MiscTab, "Anti Ragdoll", false, function(v) Misc.Config.AntiRagdoll = v end)
    UI:AddToggle(MiscTab, "Hide GUI", false, function(v)
        Misc.Config.HideGUI = v
        Misc.ToggleHideGUI(v)
    end)
    UI:AddToggle(MiscTab, "Infinite Ammo", false, function(v)
        Misc.Config.InfiniteAmmo = v
        Misc.SetInfiniteAmmo(v)
    end)

    UI:AddSection(MiscTab, "Utilitaires")
    UI:AddButton(MiscTab, "Respawn maintenant", function()
        game:GetService("Players").LocalPlayer:LoadCharacter()
    end)
    UI:AddButton(MiscTab, "Copier position", function()
        local char = game:GetService("Players").LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then
            local p = hrp.Position
            setclipboard(string.format("Vector3.new(%.2f, %.2f, %.2f)", p.X, p.Y, p.Z))
            UI:Notify("Clipboard", "Position copiée !", 2)
        end
    end)
    UI:AddButton(MiscTab, "Rejoin serveur", function()
        game:GetService("TeleportService"):Teleport(game.PlaceId)
    end)

    -- ====================================================
    -- ONGLET PARAMÈTRES
    -- ====================================================
    local SettingsTab = UI:CreateTab("Paramètres", "🎨")

    UI:AddSection(SettingsTab, "Thème — Couleurs UI")
    UI:AddColorPicker(SettingsTab, "Accent", Color3.fromRGB(100,60,255), function(c)
        UI.Theme.Accent = c
        UI.Theme.Toggle_On = c
        UI.Theme.Slider_Fill = c
    end)
    UI:AddColorPicker(SettingsTab, "Background", Color3.fromRGB(15,15,20), function(c)
        UI.Theme.Background = c
    end)
    UI:AddColorPicker(SettingsTab, "TopBar", Color3.fromRGB(20,20,30), function(c)
        UI.Theme.TopBar = c
    end)
    UI:AddColorPicker(SettingsTab, "Texte", Color3.fromRGB(240,240,240), function(c)
        UI.Theme.Text = c
    end)
    UI:AddColorPicker(SettingsTab, "Section BG", Color3.fromRGB(22,22,32), function(c)
        UI.Theme.Section = c
    end)
    UI:AddColorPicker(SettingsTab, "Bouton", Color3.fromRGB(30,30,42), function(c)
        UI.Theme.Button = c
    end)

    UI:AddSection(SettingsTab, "Interface")
    UI:AddKeybind(SettingsTab, "Toggle Menu", Enum.KeyCode.Insert, function(k) end)

    UI:AddSection(SettingsTab, "Infos")
    UI:AddButton(SettingsTab, "Discord : ton_discord", function()
        setclipboard("ton_discord")
        UI:Notify("Copié", "Discord copié !", 2)
    end)

    UI:Notify("Rivals Cheat", "Chargé  •  INSERT pour afficher/cacher", 4)
end)
