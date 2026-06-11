AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName       = "Деньги"
ENT.Authot          = "CodeYellow1338"
ENT.Contact         = "N/A"
ENT.Purpose         = "gimme money"
ENT.Instructions    = "N/A"

ENT.Spawnable = false
ENT.Category  = "CRP"

if SERVER then

    function ENT:Initialize()

        self:SetModel("models/props/cs_assault/money.mdl")

        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)

        local phys = self:GetPhysicsObject()
        if IsValid(phys) then
            phys:Wake()
        end

    end

    function ENT:Use(activator, caller)
    
        if IsValid(activator) and activator:IsPlayer() then

            local amount = self:GetNW2Int("amount", 0)
            print(amount)

            activator:SetMoney( activator:GetMoney() + amount )
            self:Remove()

        end

    end

end

if CLIENT then

    function ENT:Draw() 
        
        self:DrawModel()

    end

end