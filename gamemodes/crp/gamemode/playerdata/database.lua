function InitialzeDatabase()

    if not sql.TableExists("crp_playerdata") then
        sql.Query([[
            CREATE TABLE crp_playerdata (
            steamid TEXT PRIMARY KEY,
            money INTEGER,
            inventory TEXT
            );  
        ]])
    end

    print("[CRP DB] База данных успешно инициализирована.")
end
hook.Add("Initialize", "DatabaseInitialize", InitialzeDatabase)