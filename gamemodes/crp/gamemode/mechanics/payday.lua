function Payday(ply)

    if !IsValid(ply) or !ply:Alive() then return end

    local salary = ply:GetSalary()
    ply:SetMoney( ply:GetMoney() + salary )

    timer.Simple(600, function() Payday(ply) end)

end
hook.Add("PlayerSpawn", "StartSalaryTimer", function(ply, trans) 

    timer.Simple(600, function() Payday(ply) end)

end)