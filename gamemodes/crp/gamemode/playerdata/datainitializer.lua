function Initialize(ply)

    local steamid = ply:SteamID64()
    ply.CachedSteamID64 = steamid
    local dbResponse = sql.QueryRow("SELECT * FROM crp_playerdata WHERE steamid = " .. sql.SQLStr(steamid))

    local initialMoney, initialInventory

    if dbResponse then
        --print('DATA FOUND')
        initialMoney = tonumber(dbResponse.money)
        initialInventory = util.JSONToTable(dbResponse.inventory)
    else
        --print('DATA NOT FOUND')
        initialMoney = 5000
        initialInventory = {}
        for i = 1, 18 do
            if i ~= 6 then initialInventory[i] = {["name"] = "empty", ["amount"] = 0, ["model"] = "none"} continue end
        end
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

    print("[CRP DB] Данные для игрока " .. ply:Nick() .. " были успешно инициализированы.")

end
hook.Add("PlayerInitialSpawn", "PlayerDataInitialize", Initialize)

net.Receive("CRP_InitializeInventory", function(len, ply)
    ply:SyncInventory()
end)

function SyncOnExit(ply)

    local steamid = ply.CachedSteamID64 or ply:SteamID64()
    
    local money = ply.CRPData.Money
    local inventory = ply.CRPData.Inventory
    inventory = util.TableToJSON(inventory)

    local request = sql.Query( string.format( 
        "INSERT INTO crp_playerdata (steamid, money, inventory) VALUES (%s, %s, %s) ON CONFLICT(steamid) DO UPDATE SET money = %s, inventory = %s;",
        sql.SQLStr(steamid),
        sql.SQLStr(money),
        sql.SQLStr(inventory),
        sql.SQLStr(money),
        sql.SQLStr(inventory)
    ) )

end
hook.Add("PlayerDisconnect", "SyncDatabaseOnExit", SyncOnExit)

hook.Add("ShutDown", "SyncDatabaseOnShutdown", function() 
    for _, ply in ipairs(player.GetAll()) do
        SyncOnExit(ply)
    end
end)