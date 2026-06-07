util.AddNetworkString("HungerDamage")
net.Receive("HungerDamage", function(len, ply)
    ply:TakeDamage(net:ReadInt())
end)