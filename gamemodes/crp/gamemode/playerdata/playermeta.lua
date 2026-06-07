local ply = FindMetaTable("Player")

function ply:GetMoney()
    return self:GetNW2Int("CRP_Money")
end

function ply:SetMoney(amount)
    self.CRPData.Money = math.max(0, amount)
    self:SetNW2Int("CRP_Money", self.CRPData.Money)
end

function ply:GetSalary()
    return self:GetNW2Int("CRP_Salary")
end

function ply:GetJob()
    return self:GetNW2String("CRP_Job")
end

function ply:SetJob(newJob)
    self.CRPData.Job = newJob
    self:SetNW2String("CRP_Job", self.CRPData.Job)
end

function ply:GetHunger()
    return self:GetNW2Int("CRP_Hunger")
end

function ply:SetHunger(amount)
    self.CRPData.Hunger = amount
    self:SetNW2Int("CRP_Hunger", self.CRPData.Hunger)
end

function ply:GetInv() -- TODO
    return self.CRPData.Inventory
end