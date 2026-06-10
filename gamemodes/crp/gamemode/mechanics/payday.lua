function Payday(ply)

    if !IsValid(ply) or !ply:Alive() then return end

    local salary = ply:GetSalary()
    ply:SetMoney( ply:GetMoney() + salary )
    net.Start("CRP_Notification")
        net.WriteString("Начислена зарплата: " .. tostring(salary))
    net.Send(ply)

    timer.Simple(600, function() Payday(ply) end)

end
hook.Add("PlayerSpawn", "StartSalaryTimer", function(ply, trans) 

    timer.Simple(600, function() Payday(ply) end)

end)