-- ==================== SETTINGS ====================
-- Ce module est chargé par la UI pour exposer tous les colorpickers
-- et options globales. Il retourne les fonctions d'application.

local Settings = {}

function Settings.ApplyTheme(UI, newTheme)
    for k, v in pairs(newTheme) do
        UI.Theme[k] = v
    end
end

return Settings
