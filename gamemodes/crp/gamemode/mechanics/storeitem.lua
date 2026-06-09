concommand.Add("CRP_storeitem", function(ply, cmd, args)

    local trace = util.TraceLine({
        start = ply:GetShootPos(),
        endpos = ply:GetShootPos() + ply:GetAimVector() * 100,
        filter = function(ent) return ent:IsWeapon() end
    })

    if !(IsValid(trace.Entity)) then return end
    local ent = trace.Entity

    local name = ent:GetClass()
    local model = ent:GetModel()
    ent:Remove()

    local foundIndex
    for i, v in pairs(ply.CRPData.Inventory) do
        
        if v["name"] == name then foundIndex = i break end
        if v["name"] == "empty" and !(foundIndex) then foundIndex = i end

    end

    if ply.CRPData.Inventory[foundIndex]["name"] == name then ply.CRPData.Inventory[foundIndex]["amount"] = ply.CRPData.Inventory[foundIndex]["amount"] + 1
    else ply.CRPData.Inventory[foundIndex] = {["name"] = name, ["amount"] = 1, ["model"] = model} end
    ply:SyncInventory()

end)