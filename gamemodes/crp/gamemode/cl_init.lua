-- PlayerData
include("playerdata/playermeta.lua")
-- VGUI
include("vgui/cl_hide.lua")
include("vgui/cl_customhud.lua")
include("vgui/cl_syncinventory.lua")
include("vgui/cl_notifications.lua")
-- Mechanics
include("mechanics/cl_storeitem.lua")
-- Others
include("shared.lua")

function GM:Initialize()
    
end
hook.Add("InitPostEntity", "InitializeInventory", function() 
    net.Start("CRP_InitializeInventory")
    net.SendToServer()
end)