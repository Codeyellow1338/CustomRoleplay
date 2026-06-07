function Initialize(ply)

    local steamid = ply:SteamID64()
    local dbResponse = sql.QueryRow("SELECT * FROM crp_playerdata WHERE steamid = " .. sql.SQLStr(steamid))

    local initialMoney, initialInventory

    if dbResponse then
        initialMoney = tonumber(dbResponse.money)
        initialInventory = util.JSONToTable(dbResponse.inventory)
    else
        initialMoney = 5000
        initialInventory = {}
    end
    ply.CRPData = {
        Money           = initialMoney,
        Salary          = 45,
        Job             = "Гражданин",
        Hunger          = 100,
        Inventory       = initialInventory,

    }

    ply:SetNW2Int("CRP_Money", ply.CRPData.Money)
    ply:SetNW2Int("CRP_Salary", ply.CRPData.Salary)
    ply:SetNW2String("CRP_Job", ply.CRPData.Job)
    ply:SetNW2Int("CRP_Hunger", ply.CRPData.Hunger)

    print("[CRP] Данные для игрока " .. ply:Nick() .. " были успешно инициализированы.")

end
hook.Add("PlayerInitialSpawn", "PlayerDataInitialize", Initialize)