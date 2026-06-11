util.AddNetworkString("CRP_DropWeaponRequest")
net.Receive("CRP_DropWeaponRequest", function(len, ply) 

    local gunToDrop = net.ReadString()
    if !(IsValid(ply:GetWeapon(gunToDrop))) then print("[CRP Anticheat] Игрок Имя: " .. ply:Nick() .. " SteamID64: " .. ply:SteamID64() .. " попытался сбросить оружие, которым не обладает") return end
    ply:StripWeapon(gunToDrop)

    local worldItem = ents.Create(gunToDrop)
    worldItem:SetPos(ply:GetPos() + ply:GetForward() * 100 + Vector(0, 0, 20))
    worldItem.WasDropped = true
    local hl2Ammo = {
        ["weapon_pistol"]     = "Pistol",
        ["weapon_smg1"]       = "SMG1",
        ["weapon_ar2"]        = "AR2",
        ["weapon_357"]        = "357",
        ["weapon_shotgun"]    = "Buckshot",
        ["weapon_crossbow"]   = "XBowBolt",
        ["weapon_rpg"]        = "RPG_Round",
        ["weapon_frag"]       = "Grenade",
        ["weapon_slam"]       = "SLAM",
    }

    local ammoType
    if hl2Ammo[gunToDrop] then
        ammoType = hl2Ammo[gunToDrop]
    else
        if weapons.GetStored(gunToDrop) then
            ammoType = weapons.GetStored(gunToDrop).Primary.Ammo
        end
    end
    if ammoType then 
        worldItem.Ammo = ply:GetAmmoCount(ammoType)
        ply:RemoveAmmo(ply:GetAmmoCount(ammoType), ammoType)
    end
    worldItem:Spawn()

end)

util.AddNetworkString("CRP_AmmoBuyRequest")
net.Receive("CRP_AmmoBuyRequest", function(len, ply) 

    local ammoType = tonumber(net.ReadString())
    local request = util.JSONToTable( net.ReadString() )
    local price, amount = tonumber(request[1]), tonumber(request[2])
    local ammoList = {
        [1] = "AR2",
        [3] = "Pistol",
        [4] = "SMG1",
        [5] = "357",
        [6] = "XBowBolt",
        [7] = "Buckshot",
        [8] = "RPG_Round"
    }
    ammoType = ammoList[ammoType]

    ply:SetMoney( ply:GetMoney() - price )
    ply:GiveAmmo(amount, ammoType)

end)

util.AddNetworkString("CRP_DropMoneyRequest")
net.Receive("CRP_DropMoneyRequest", function(len, ply) 

    local amount = net.ReadInt(32)
    if !amount then return end

    if ply:GetMoney() - amount < 0 or amount <= 0 then return end
    ply:SetMoney( ply:GetMoney() - amount )

    local worldItem = ents.Create("money")
    worldItem:SetNW2Int("amount", amount)
    worldItem:SetPos(ply:GetPos() + ply:GetForward() * 100 + Vector(0, 0, 20))
    worldItem:Spawn()

end)

util.AddNetworkString("CRP_GiveMoneyRequest")
net.Receive("CRP_GiveMoneyRequest", function(len, ply) 

    local trace = util.TraceLine({
        start = ply:GetShootPos(),
        endpos = ply:GetShootPos() + ply:GetAimVector() * 125,
        filter = function(ent) return ent:IsPlayer() end
    })

    if !(IsValid(trace.Entity)) then return end
    local ent = trace.Entity

    local amount = net.ReadInt(32)
    if !amount then return end

    if ply:GetMoney() - amount < 0 or amount <= 0 then return end
    ply:SetMoney( ply:GetMoney() - amount )

    ent:SetMoney( ent:GetMoney() + amount )

end)