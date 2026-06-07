function Initialize(ply)

    ply.CRPData = {
        Money           = 5000,
        Salary          = 45,
        Job             = "Гражданин",
        Hunger          = 100,
        Inventory       = {},

    }

    ply:SetNW2Int("CRP_Money", ply.CRPData.Money)
    ply:SetNW2Int("CRP_Salary", ply.CRPData.Salary)
    ply:SetNW2String("CRP_Job", ply.CRPData.Job)
    ply:SetNW2Int("CRP_Hunger", ply.CRPData.Hunger)

    print("[CRP] Данные для игрока " .. ply:Nick() .. " были успешно инициализированы.")

end
hook.Add("PlayerInitialSpawn", "PlayerDataInitialize", Initialize)