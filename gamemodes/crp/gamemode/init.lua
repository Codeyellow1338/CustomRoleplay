-- VGUI
AddCSLuaFile("vgui/cl_hide.lua")
AddCSLuaFile("vgui/cl_customhud.lua")
AddCSLuaFile("vgui/cl_syncinventory.lua")

include("vgui/customhud.lua")
-- PlayerData
AddCSLuaFile("playerdata/playermeta.lua")

include("playerdata/datainitializer.lua")
include("playerdata/playermeta.lua")
-- Mechanics
include("mechanics/hunger.lua")
-- Anticheat
include("anticheat/inventory.lua")
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

util.AddNetworkString("CRP_InitializeInventory")
util.AddNetworkString("CRP_SyncInventory")