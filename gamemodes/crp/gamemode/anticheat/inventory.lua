util.AddNetworkString("CRP_MoveItemRequest")
net.Receive("CRP_MoveItemRequest", function(len, ply) 

    local fromSlot = net.ReadInt(8)
    local toSlot = net.ReadInt(8)

    local nameString = "Имя: " .. ply:Nick() .. " SteamID64: " .. tostring(ply:SteamID64())
    if !(1 <= fromSlot) or !(fromSlot <= 18) or !(1 <= toSlot) or !(toSlot <= 18) then print("[CRP_Anticheat] Игрок " .. nameString  .. " прислал неверные слоты инвентаря") return end

    local plyInv = ply.CRPData.Inventory

    if !plyInv[fromSlot] then print("[CRP_Anticheat] Игрок " .. nameString .. " попытался передвинуть ничего.") return end

    local itemData = plyInv[fromSlot]
    plyInv[fromSlot] = plyInv[toSlot]
    plyInv[toSlot] = itemData

    ply:SyncInventory()

end)

 local defaultSlot = {
        ["name"]    = "empty",
        ["amount"]  = 0,
        ["model"]   = "none",
        ["item"] = "N/A"
    }

util.AddNetworkString("CRP_DropItemRequest")
net.Receive("CRP_DropItemRequest", function(len, ply) 

    local fromSlot = net.ReadInt(8)
    
    local nameString = "Имя: " .. ply:Nick() .. " SteamID64: " .. tostring(ply:SteamID64())
    if !(1 <= fromSlot) or !(fromSlot <= 18) then print("[CRP_Anticheat] Игрок " .. nameString  .. " прислал неверные слоты инвентаря") return end

    local plyInv = ply.CRPData.Inventory
    if !plyInv[fromSlot] then print("[CRP_Anticheat] Игрок " .. nameString .. " попытался выкинуть ничего.") return end

    local itemData = plyInv[fromSlot]
    itemData["amount"] = itemData["amount"] - 1
    local worldItem = ents.Create(itemData["item"])
    worldItem:SetPos(ply:GetPos() + ply:GetForward() * 100 + Vector(0, 0, 20))
    worldItem:Spawn()

    if itemData["amount"] == 0 then plyInv[fromSlot] = defaultSlot end
    ply:SyncInventory()

end)

util.AddNetworkString("CRP_UseItemRequest")
net.Receive("CRP_UseItemRequest", function(len, ply) 

    local fromSlot = net.ReadInt(8)
    
    local nameString = "Имя: " .. ply:Nick() .. " SteamID64: " .. tostring(ply:SteamID64())
    if !(1 <= fromSlot) or !(fromSlot <= 18) then print("[CRP_Anticheat] Игрок " .. nameString  .. " прислал неверные слоты инвентаря") return end

    local plyInv = ply.CRPData.Inventory
    if !plyInv[fromSlot] then print("[CRP_Anticheat] Игрок " .. nameString .. " попытался использовать ничего.") return end

    local itemData = plyInv[fromSlot]
    itemData["amount"] = itemData["amount"] - 1
    ply:Give(itemData["item"])

    if itemData["amount"] == 0 then plyInv[fromSlot] = defaultSlot end
    ply:SyncInventory()

end)