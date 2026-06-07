if !SERVER then return end

util.AddNetworkString("WSEquip")
net.Receive("WSEquip", function(len, ply) 

    local wep = net.ReadEntity()
    ply:SelectWeapon(wep)

end)