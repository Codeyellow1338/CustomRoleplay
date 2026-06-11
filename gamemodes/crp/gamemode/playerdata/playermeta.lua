local ply = FindMetaTable("Player")

function ply:GetMoney()
    return self:GetNW2Int("CRP_Money")
end

function ply:SetMoney(amount)
    self:SetNW2Int("CRP_Money", math.max(0, amount))
end

function ply:GetSalary()
    return self:GetNW2Int("CRP_Salary")
end

function ply:SetSalary(amount)
    self:SetNW2Int("CRP_Salary", amount)
end

function ply:GetJob()
    return self:GetNW2String("CRP_Job")
end

function ply:SetJob(newJob)
    if CLIENT then return end
    self:SetNW2String("CRP_Job", newJob)
    CRP_InitializePlayerOnJob(self)
end

function ply:GetHunger()
    return self:GetNW2Int("CRP_Hunger")
end

function ply:SetHunger(amount)
    self:SetNW2Int("CRP_Hunger", math.max(0, amount))
end

function ply:GetInventory() -- CALL THIS ON SERVER ONLY !!!
    return self.CRPData.Inventory
end

function ply:SyncInventory()
    local inv = self.CRPData.Inventory
    inv = util.TableToJSON(inv)

    net.Start("CRP_SyncInventory")
        net.WriteString(inv)
    net.Send(self)
end