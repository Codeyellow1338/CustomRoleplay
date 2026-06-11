CRP_JobList = {}

local function CRP_CreateJob(id, info)

    info.name           = info.name || "Нет названия"
    info.description    = info.description || "Нет описания"
    info.color          = info.color || Color(255, 255, 255, 255)
    info.salary         = info.salary || 45
    info.admin          = info.admin || false
    info.command        = info.command || string.lower(id)
    info.police         = info.police || false
    info.weapons        = info.weapons || {}
    info.spawnpoints    = info.spawnpoints || {}
    info.ammo           = info.ammo || {}
    info.max            = info.max || -1
    info.models         = info.models || {}

    CRP_JobList[id] = info

end

if SERVER then

    function CRP_InitializePlayerOnJob(ply)

        local job = CRP_JobList[ply:GetJob()]
        -- if !CRP_JobList[job] or #CRP_JobList == 0 then
        --     timer.Simple(0.1, function() 
        --         if IsValid(ply) then CRP_InitializePlayerOnJob(ply) end
        --     end)
        --     return
        -- end

        for _, wep in pairs(job.weapons) do
            ply:Give(wep)
        end

        for type, amount in pairs(job.ammo) do
            ply:GiveAmmo(amount, type, true)
        end

        ply:Respawn()
        ply:SetSalary(job.salary)
        
        if #job.spawnpoints > 0 then
            local spawnpoint = job.spawnpoints[math.random(1, #job.spawnpoints)]
            ply:SetPos(spawnpoint)
        end

    end

end

-- Jobs
CRP_CreateJob("TEAM_CITIZEN", {
    ["name"]            = "Гражданин",
    ["description"]     = "Обычный житель города. У вас нет особых обязанностей, вы можете зарабатывать на жизнь легальными или не очень способами.",
    ["color"]           = Color(85,189,0,168),
    ["salary"]          = 45,
    ["models"]          = { "models/player/Group01/male_02.mdl", "models/player/Group01/male_07.mdl", "models/player/Group01/female_02.mdl", "models/player/Group01/female_01.mdl" }
})