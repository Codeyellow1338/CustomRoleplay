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