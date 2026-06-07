function InitialzeDatabase()

    sql.Query([[
        CREATE TABLE IF NOT TABLE EXISTS crp_playerdata (
        steamid TEXT PRIMARY KEY,
        money INTEGER,
        inventory TEXT
        )    
    ]])

    print("[CRP DB] База данных успешно инициализирована.")
end
hook.Add("Initialize", "DatabaseInitialize", InitialzeDatabase)