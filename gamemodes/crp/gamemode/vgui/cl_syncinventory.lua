net.Receive("CRP_SyncInventory", function(len) 

    local invTable = util.JSONToTable( net.ReadString() )

    LocalPlayer().LocalInventory = invTable

    if IsValid(CRP_InventoryFrame) then
        CRP_InventoryFrame:Refresh()
    end

end)