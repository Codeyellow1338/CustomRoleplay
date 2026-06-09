hook.Add("PlayerCanPickupWeapon", "DisableAutoPickup", function(ply, weapon) 
    
    if !(weapon.WasDropped) then return true end
    if ply:KeyDown(IN_USE) and weapon.WasDropped then
        if weapon.Ammo then ply:GiveAmmo(weapon.Ammo, weapon:GetPrimaryAmmoType(), true) end
        return true
    end

    return false

end)