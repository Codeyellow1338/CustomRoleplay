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
    info.maxhp          = info.maxhp || 100
    info.maxarmor       = info.maxarmor || 100
    info.armor          = info.armor || 0

    CRP_JobList[id] = info

end

if SERVER then

    function CRP_InitializePlayerOnJob(ply)

        local job = CRP_JobList[ply:GetJob()]

        for _, wep in pairs(job.weapons) do
            ply:Give(wep)
        end

        for ammoType, amount in pairs(job.ammo) do
            ply:GiveAmmo(amount, ammoType, true)
        end

        ply:SetSalary(job.salary)
        ply:SetMaxHealth(job.maxhp)
        ply:SetMaxArmor(job.maxarmor)
        ply:SetArmor(job.armor)
        ply:SetHealth(ply:GetMaxHealth())
        
        if #job.spawnpoints > 0 then
            local spawnpoint = job.spawnpoints[math.random(1, #job.spawnpoints)]
            ply:SetPos(spawnpoint)
        end

        ply:SetModel(job.models[math.random(1, #job.models)])
        if IsValid(ply) and ply:Alive() then
            timer.Simple(.1, function() if IsValid(ply) and ply:Alive() then ply:SetupHands() end end)
        end

    end
    hook.Add("PlayerSpawn", "SetJobOnRespawn", CRP_InitializePlayerOnJob)

    util.AddNetworkString("CRP_JobChangeRequest")
    net.Receive("CRP_JobChangeRequest", function(len, ply) 
        local prevJob = CRP_JobList[ply:GetJob()]
        for _, wep in pairs(prevJob["weapons"]) do
            ply:StripWeapon(wep)
        end
        for ammoType, amount in pairs(prevJob["ammo"]) do
            ply:SetAmmo( math.max( 0, ply:GetAmmoCount(ammoType) - amount ), ammoType )
        end
        local newJobId = net.ReadString()
        local curPpl = 0
        for _, ppl in ipairs(player.GetAll()) do
            if ppl:GetJob() == newJobId then curPpl = curPpl + 1 end
        end

        if curPpl >= CRP_JobList[newJobId]["max"] and CRP_JobList[newJobId]["max"] ~= -1 then return end
        ply:SetJob(newJobId)
    end)

end

-- Jobs
CRP_CreateJob("TEAM_CITIZEN", {
    ["name"]            = "Гражданин",
    ["description"]     = "Обычный житель города. У вас нет особых обязанностей, вы можете зарабатывать на жизнь легальными или не очень способами.",
    ["color"]           = Color(85,189,0,168),
    ["salary"]          = 45,
    ["models"]          = { "models/player/Group01/male_02.mdl", "models/player/Group01/male_07.mdl", "models/player/Group01/female_02.mdl", "models/player/Group01/female_01.mdl" }
})

CRP_CreateJob("TEAM_POLICE", {
    ["name"]            = "Полицейский",
    ["description"]     = "TEST",
    ["color"]           = Color(48,48,255, 168),
    ["salary"]          = 100,
    ["models"]          = { "models/player/police.mdl", "models/player/police_fem.mdl" },
    ["police"]          = true,
    ["weapons"]         = { "weapon_pistol", "weapon_stunstick" },
    ["ammo"]            = { ["Pistol"] = 75 },
    ["spawnpoints"]     = { Vector(1179.697632, 801.096252, 128.031250) },
    ["armor"]           = 100
})