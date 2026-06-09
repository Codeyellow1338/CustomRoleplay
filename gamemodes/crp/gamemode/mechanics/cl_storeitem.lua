function StoreItem()

    if input.IsKeyDown(KEY_LCONTROL) and input.IsKeyDown(KEY_F) then
        RunConsoleCommand("CRP_storeitem")
    end

end
hook.Add("Tick", "AttemptStoreItem", StoreItem)