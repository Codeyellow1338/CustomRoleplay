function HideHUD(name)
    local hide = {
        ["CHudHealth"]          = true,
        ["CHudBattery"]         = true,
        ["CHudAmmo"]            = true,
        ["CHudSecondaryAmmo"]   = true,
        ["CHudWeaponSelection"] = true
    }

    if hide[name] then
        return false
    end
end
hook.Add("HUDShouldDraw", "HideDefaulHUD", HideHUD)