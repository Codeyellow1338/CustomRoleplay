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

function ply:GetJob()
    return self:GetNW2String("CRP_Job")
end

function ply:SetJob(newJob)
    self:SetNW2String("CRP_Job", newJob)
end

function ply:GetHunger()
    return self:GetNW2Int("CRP_Hunger")
end

function ply:SetHunger(amount)
    self:SetNW2Int("CRP_Hunger", math.max(0, amount))
end

function ply:GetInv() -- TODO
    return self.CRPData.Inventory
end