function Hunger(ply)

    if !(IsValid(ply)) then return end
    if !(ply:Alive()) or (ply:IsBot()) then return end

    local hungerAmount = 2.5
    if ply:GetHunger() - hungerAmount < 0 then
        ply:TakeDamage(15)
    else
        ply:SetHunger( ply:GetHunger() - hungerAmount )
    end

    local timeDelay = math.random(60, 120)
    timer.Simple(timeDelay, function() 
        Hunger(ply)
    end)

end

hook.Add("PlayerSpawn", "HungerStart", function(ply, trans) 
    ply:SetHunger(100)
    timer.Simple(math.random(60, 120), function() Hunger(ply) end)
end)