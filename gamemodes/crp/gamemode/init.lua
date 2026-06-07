-- VGUI
AddCSLuaFile("vgui/cl_hide.lua")
AddCSLuaFile("vgui/cl_customhud.lua")

include("vgui/customhud.lua")
-- PlayerData
AddCSLuaFile("playerdata/playermeta.lua")

include("playerdata/datainitializer.lua")
include("playerdata/playermeta.lua")
-- Mechanics
AddCSLuaFile("mechanics/cl_hunger.lua")

include("mechanincs/hunger.lua")
-- Others
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("playerdata/database.lua")
include("shared.lua")

function GM:PlayerSpawn(ply)
    ply:SetWalkSpeed(200)
    ply:SetRunSpeed(350)

    ply:Give("weapon_physgun")
    ply:Give("weapon_physcannon")
    ply:Give("weapon_fists")
    ply:Give("gmod_tool")

    ply:SetupHands()
end