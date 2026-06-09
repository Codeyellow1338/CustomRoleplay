-- Materials
local healthMaterial = Material("vgui/heart.png", "nocull smooth")
local armorMaterial = Material("vgui/armor.png", "nocull smooth")
local foodMaterial = Material("vgui/food.png", "nocull smooth")

-- Font
local textSize = ScrH() * .025
surface.CreateFont("HUD_Default", {
    font = "Arial",
    size = textSize,
    weight = 800,
    antialias = true
})

surface.CreateFont("HUD_Ammo", {
    font = "Arial",
    size = textSize * 1.25,
    weight = 800,
    antialias = true,
    shadow = true
})

surface.CreateFont("HUD_Shadow", {
    font = "Arial",
    size = textSize,
    weight = 600,
    antialias = true,
    shadow = true,
})

surface.CreateFont("HUD_Inventory", {
    font = "Arial",
    size = textSize / 1.25,
    weight = 600,
    antialias = true,
    shadow = true
})

hook.Add("OnScreenSizeChanged", "ChangeTextSize", function() 
    textSize = ScrH() * .025

    surface.CreateFont("HUD_Default", {
        font = "Arial",
        size = textSize,
        weight = 800,
        antialias = true
    })

    surface.CreateFont("HUD_Ammo", {
        font = "Arial",
        size = textSize * 1.25,
        weight = 800,
        antialias = true,
        shadow = true
    })

    surface.CreateFont("HUD_Shadow", {
        font = "Arial",
        size = textSize,
        weight = 600,
        antialias = true,
        shadow = true,
    })

    surface.CreateFont("HUD_Inventory", {
        font = "Arial",
        size = textSize / 1.25,
        weight = 600,
        antialias = true,
        shadow = true
    })
end)

-- Others
function GetSortedWeapons()

    local weps = LocalPlayer():GetWeapons()

    table.sort(weps, function(a, b)
        if !IsValid(a) or !IsValid(b) then return end
        
        local slotA, slotB = a:GetSlot(), b:GetSlot()
        if slotA ~= slotB then
            return slotA < slotB
        end

        return a:GetSlotPos() < b:GetSlotPos()
    end)

    return weps
end

function BuildWeaponGrid()

    local grid = {}
    local weps = GetSortedWeapons()

    local weaponsBySlot = {}
    for _, wep in ipairs(weps) do
        local slot = wep:GetSlot()
        weaponsBySlot[slot] = weaponsBySlot[slot] or {}
        table.insert(weaponsBySlot[slot], wep)
    end

    local activeSlots = table.GetKeys(weaponsBySlot)
    table.sort(activeSlots)

    for virtualCIndex, realSlot in ipairs(activeSlots) do
        local cIndex = virtualCIndex - 1

        for rIndex, wep in ipairs(weaponsBySlot[realSlot]) do
            table.insert(grid, {
                wep = wep,
                cIndex = cIndex,
                rIndex = rIndex - 1,
                name = wep:GetPrintName()
            })
        end
    end

    return grid
end

-- Weapon Selection Logic
local selectedC = 0
local selectedR = 0
local WSVisible = false
local WSLastInput = nil
local WSHideTime = 0

function WeaponSelection(ply, bind, pressed)

    if !pressed then return end
    local isHUDACtive = CurTime() < WSHideTime

    local weaponsPerColumn = {
        [-1] = 0,
        [0] = 0,
        [1] = 0,
        [2] = 0,
        [3] = 0,
        [4] = 0,
        [5] = 0,
        [6] = 0,
        [7] = 0,
        [8] = 0,
        [9] = 0,
    }
    local grid = BuildWeaponGrid()
    for i,v in pairs(grid) do
        local currentColumn = v["cIndex"]
        weaponsPerColumn[currentColumn] = weaponsPerColumn[currentColumn] + 1
    end

    if string.find(bind, "slot") then -- Selecting Slot

        WSHideTime = CurTime() + 3

        if !isHUDACtive then
            WSLastInput = nil
        end

        if WSLastInput ~= bind then
            if weaponsPerColumn[tonumber(bind[-1]) - 1] == 0 then return end
            selectedC = tonumber(bind[-1]) - 1
            selectedR = 0
            WSVisible = true
        else
            selectedR = selectedR + 1
            if selectedR >= weaponsPerColumn[selectedC] then selectedR = 0 end
        end
        WSLastInput = bind
        surface.PlaySound("common/wpn_moveselect.wav")

        return true

    end

    if string.find(bind, "+attack") and WSLastInput and isHUDACtive then
    
        WSLastInput = nil
        WSVisible = false
        for i, v in pairs(grid) do
            if selectedC == v["cIndex"] and selectedR == v["rIndex"] then
                net.Start("WSEquip")
                    net.WriteEntity(v["wep"])
                net.SendToServer()
                surface.PlaySound("common/wpn_select.wav")
            end
        end
        return true

    end

end
hook.Add("PlayerBindPress", "WSActivate", WeaponSelection)

-- Drawing
function DrawCustomHud()
    
    local ply = LocalPlayer()
    if !(ply:Alive()) then return end

    -- Params

    local WSX = ScrW() * .01 -- Weapon Start X
    local WSY = ScrH() * .01 -- Weapon Start Y
    local WWidth = ScrW() * .115 -- Weapon Slot Width
    local WHeight = ScrH() * .03 -- Weapon Slot Height

    local function DrawWeaponBox(CIndex, RIndex, name) -- Column Index, Row Index, name

        -- Params
        local CPadding = WWidth / 50 -- Column Padding
        local RPadding = WHeight / 8 -- Row Padding

        local currentX = WSX + (WWidth + CPadding) * CIndex
        local currentY = WSY + (WHeight + RPadding) * RIndex

        local color
        if CIndex == selectedC and RIndex == selectedR then color = Color(0,0,0) else color = Color(255,255,255,185) end

        surface.SetDrawColor(Color(0,0,0,185))
        surface.DrawRect(currentX, currentY, WWidth, WHeight)
        surface.SetDrawColor(color)
        surface.DrawOutlinedRect(currentX, currentY, WWidth, WHeight, 3)

        draw.DrawText(
            name,
            "HUD_Default",
            currentX + WWidth / 2,
            currentY + (WHeight - textSize) / 2,
            Color(255,255,255,255),
            TEXT_ALIGN_CENTER,
            TEXT_ALIGN_BOTTOM
        )

    end
    
    local roundAmount = 6
    local barHeight = ScrH() * .03
    local barWidth = ScrW() * .08

    local iconSize = barHeight * .8
    local iconPadding = (barHeight - iconSize) / 2
    local textPadding = iconPadding * 3
    local barPadding = iconPadding * 4

    -- Health
    local hX = ScrW() * .005
    local hY = ScrH() * .96
    local healthAmount = ply:Health()
    local healthScale = math.Clamp( ( ply:Health() / ply:GetMaxHealth() ), 0, 1 )

    draw.RoundedBox(roundAmount, hX, hY, barWidth, barHeight, Color(0,0,0,138)) -- Back
    draw.RoundedBox(roundAmount, hX, hY, healthScale * barWidth, barHeight, Color(255,69,69,152)) -- Main
    draw.SimpleText( -- Text
        tostring(healthAmount),
        "HUD_Default",
        hX + iconSize + textPadding,
        hY + barHeight / 2,
        Color(255, 255, 255, 255),
        TEXT_ALIGN_LEFT,
        TEXT_ALIGN_CENTER
    )

    -- Icon
    surface.SetDrawColor(255, 255, 255, 255)
    surface.SetMaterial(healthMaterial)
    surface.DrawTexturedRect(hX + iconPadding, hY + iconPadding, iconSize, iconSize)

    -- Armor
    local aX = hX + barWidth + barPadding
    local aY = hY
    local armorAmount = ply:Armor()
    local armorScale = math.Clamp( ( ply:Armor() / ply:GetMaxArmor() ), 0, 1 )

    draw.RoundedBox(roundAmount, aX, aY, barWidth, barHeight, Color(0,0,0,138)) -- Back
    draw.RoundedBox(roundAmount, aX, aY, armorScale * barWidth, barHeight, Color(114,114,114, 152)) -- Main
    draw.SimpleText( -- Text
        tostring(armorAmount),
        "HUD_Default",
        aX + iconSize + textPadding,
        aY + barHeight / 2,
        Color(255, 255, 255, 255),
        TEXT_ALIGN_LEFT,
        TEXT_ALIGN_CENTER
    )

    -- Icon
    surface.SetDrawColor(255, 255, 255, 255)
    surface.SetMaterial(armorMaterial)
    surface.DrawTexturedRect(aX + iconPadding, aY + iconPadding, iconSize, iconSize)

    -- Food
    local fX = aX + barWidth + barPadding
    local fY = hY
    local foodAmount = ply:GetHunger()
    local foodScale = math.Clamp( ( ply:GetHunger() / 100 ), 0, 1 )

    draw.RoundedBox(roundAmount, fX, fY, barWidth, barHeight, Color(0,0,0,138)) -- Back
    draw.RoundedBox(roundAmount, fX, fY, foodScale * barWidth, barHeight, Color(204,122,45, 152)) -- Main
    draw.SimpleText( -- Text
        tostring(foodAmount),
        "HUD_Default",
        fX + iconSize + textPadding,
        fY + barHeight / 2,
        Color(255, 255, 255, 255),
        TEXT_ALIGN_LEFT,
        TEXT_ALIGN_CENTER
    )

    -- Icon
    surface.SetDrawColor(255, 255, 255, 255)
    surface.SetMaterial(foodMaterial)
    surface.DrawTexturedRect(fX + iconPadding, fY + iconPadding, iconSize, iconSize)

    -- Ammo
    local wep = ply:GetActiveWeapon()
    if IsValid(wep) then 
        if wep:GetPrimaryAmmoType() ~= -1 then 
            local ammoX = ScrW() * 0.995
            local ammoY = hY
            local currentAmmo = wep:Clip1()
            local maxAmmo = wep:GetMaxClip1()
            local ammoLeft = ply:GetAmmoCount( wep:GetPrimaryAmmoType() )
            local text
            if currentAmmo ~= -1 then text = tostring(tostring(currentAmmo) .. "/" .. tostring(maxAmmo) .. " - " .. ammoLeft) else text = tostring(ammoLeft) end

            draw.SimpleText(
                text,
                "HUD_Ammo",
                ammoX,        
                ammoY + barHeight / 2,
                Color(255, 255, 255, 255),
                TEXT_ALIGN_RIGHT,
                TEXT_ALIGN_CENTER
            )
        end
    end

    -- Money
    local mX = hX
    local mY = hY - barHeight / 1.2
    local moneyAmount = ply:GetMoney()
    local moneyText = markup.Parse("<font=HUD_Shadow><color=255,255,255>Деньги: </color><color=0,192,0>" .. "$" .. moneyAmount .. " + $" .. ply:GetSalary() ..  "</color></font>")
    moneyText:Draw(mX, mY, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

    -- Job
    local jX = mX
    local jY = mY - barHeight / 1.2
    local job = ply:GetJob()
    local jobText = markup.Parse("<font=HUD_Shadow><color=255,255,255>Профессия: " .. job .. "</color></font>")
    jobText:Draw(jX, jY, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

    -- Weapon Select
    if CurTime() < WSHideTime and WSVisible then
        local grid = BuildWeaponGrid()
        for i, v in pairs(grid) do
            local CIndex = v["cIndex"]
            local RIndex = v["rIndex"]
            local name   = v["name"]

            DrawWeaponBox(CIndex, RIndex, name)
        end
    end

end
hook.Add("HUDPaint", "DrawCustomHUD", DrawCustomHud)


-- Custom C Menu
CRP_InventoryFrame = nil
hook.Add("OnScreenSizeChanged", "ChangeInventorySize", function() 
    if IsValid(CRP_InventoryFrame) then CRP_InventoryFrame:Close() end
end)
function DrawCMenu()

    if !IsValid(CRP_InventoryFrame) then

        local BgW = ScrW() * .2
        local BgH = ScrH() * .2

        local BgX = ScrW() * .5 - BgW * .5
        local BgY = ScrH() - BgH

        -- Inv Background

        CRP_InventoryFrame = vgui.Create("DFrame")
        CRP_InventoryFrame:SetPos(BgX, BgY)
        CRP_InventoryFrame:MakePopup()
        CRP_InventoryFrame:SetDraggable(false)
        CRP_InventoryFrame:SetTitle("")
        CRP_InventoryFrame:ShowCloseButton(false)
        CRP_InventoryFrame.Paint = function(self, w, h) 
            surface.SetDrawColor(0,0,0,185)
            surface.DrawRect(0, 0, w, h)
            surface.SetDrawColor(255,255,255,185)
            surface.DrawOutlinedRect(0, 0, w, h, 3)
        end

        -- Inv Cells
        local cellsPerRow = 6
        local cellsPerColumn = 3
        local space = ScrW() * 0.0025
        local cellSize = (BgW - space * (cellsPerRow + 3)) / cellsPerRow
        local BgH = cellSize * cellsPerColumn + space * (cellsPerColumn + 1)
        CRP_InventoryFrame:SetSize(BgW,BgH)

        local InvGrid = vgui.Create("DIconLayout", CRP_InventoryFrame)
        CRP_InventoryFrame.Grid = InvGrid
        InvGrid:Dock(FILL)
        InvGrid:DockMargin(0, -28, -5, -5)
        InvGrid:SetBorder(space)
        InvGrid:SetSpaceX(space)
        InvGrid:SetSpaceY(space)

        local function DrawInvCell(i)

            local cell = InvGrid:Add("DPanel")
            cell.SlotIndex = i
            cell:SetSize(cellSize, cellSize)
            cell.Paint = function(self, w, h)
                surface.SetDrawColor(0,0,0,185)
                surface.DrawRect(0, 0, w, h)
                surface.SetDrawColor(255, 255, 255, 185)
                surface.DrawOutlinedRect(0, 0, w, h, 2)
            end
            cell:Receiver("InvItems", function(self, droppedPanels, bDoDrop, command, x, y)
                local item = droppedPanels[1]

                local fromSlot = item.SlotIndex
                local toSlot = self.SlotIndex

                if bDoDrop then
                    
                    net.Start("CRP_MoveItemRequest")
                        net.WriteInt(fromSlot, 8)
                        net.WriteInt(toSlot, 8)
                    net.SendToServer()
                end
            end)
            cell:SetVisible(true)

            return cell

        end

        CRP_InventoryFrame:SetVisible(true)

        -- Refreshing inventory
        function CRP_InventoryFrame:Refresh()

            if !(IsValid(self.Grid)) then return end
            self.Grid:Clear()

            local items = LocalPlayer().LocalInventory

            for slot, item in pairs(items) do

                local amount = item["amount"]
                local name = item["name"]
                local model = item["model"]
                local cell = DrawInvCell(slot)

                if (name ~= "empty") and (amount ~= 0) then
                    local icon = vgui.Create("SpawnIcon", cell)
                    --icon:Dock(FILL)
                    icon:SetSize(cellSize * .9, cellSize * .9)
                    icon:Center()
                    icon:SetModel(model)
                    icon.SlotIndex = slot
                    icon:Droppable("InvItems")
                    icon:SetTooltip(nil)
                    function icon:PaintOver(w, h)
                        if amount ~= 0 then
                            surface.SetFont("HUD_Inventory")
                            local ts = surface.GetTextSize("x" .. tostring(amount))

                            draw.SimpleText(
                                "x" .. tostring(amount),
                                "HUD_Inventory",
                                w - ts,
                                h - textSize / 2.5,
                                Color(255, 255, 255, 255),
                                TEXT_ALIGN_LEFT,
                                TEXT_ALIGN_CENTER
                            )
                        end
                    end

                    -- RMB Menu on click
                    local RMBMenu
                    icon.DoRightClick = function()
                        
                        if !(IsValid(RMBMenu)) then
                            RMBMenu = vgui.Create("DFrame")
                            local mW = ScrW() * .1
                            local mH = ScrH() * .2

                            local x, y = input.GetCursorPos()

                            -- Main Window
                            RMBMenu:SetSize(mW, mH)
                            RMBMenu:MakePopup()
                            RMBMenu:SetPos(x, y - mH * 1.25)
                            RMBMenu:SetDraggable(false)
                            RMBMenu:SetTitle("")
                            RMBMenu:ShowCloseButton(true)
                            RMBMenu.Paint = function(self, w, h) 
                                surface.SetDrawColor(0,0,0,185)
                                surface.DrawRect(0,0,w,h)
                                surface.SetDrawColor(255,255,255,185)
                                surface.DrawOutlinedRect(0,0,w,h,3)
                            end
                            RMBMenu.Think = function(self)
                                if !(IsValid(CRP_InventoryFrame)) or !(CRP_InventoryFrame:IsVisible()) then self:Remove() end
                            end
                            RMBMenu:SetVisible(true)

                            -- Grid
                            local buttonGrid = vgui.Create("DIconLayout", RMBMenu)
                            buttonGrid:Dock(FILL)
                            buttonGrid:SetSpaceX(space)
                            buttonGrid:SetSpaceY(space)
                            buttonGrid:DockMargin(-5, 0, -5, 0)

                            local bW = mW
                            local bH = mH * .2
                            local item = LocalPlayer().LocalInventory[icon.SlotIndex]

                            -- Making button
                            local function CreateButton(text)
                                local button = vgui.Create("DButton", buttonGrid)
                                button:SetSize(bW, bH)
                                button.Paint = function(self, w, h)
                                    surface.SetDrawColor(0,0,0,185)
                                    surface.DrawRect(0,0,w,h)
                                    surface.SetDrawColor(255,255,255,185)
                                    surface.DrawOutlinedRect(0,0,w,h,2)
                                end
                                button:SetVisible(true)
                                button:SetTextColor(Color(255,255,255,255))
                                button:SetFont("HUD_Inventory")
                                button:SetText(text)
                                button.OnCursorEntered = function()
                                    button:SetTextColor(Color(189,189,189))
                                    surface.PlaySound("buttons/lightswitch2.wav")
                                end
                                button.OnCursorExited = function()
                                    button:SetTextColor(Color(255,255,255,255))
                                end

                                return button
                            end

                            -- Drop
                            local dropB = CreateButton("Выбросить")
                            dropB.DoClick = function()
                                surface.PlaySound("buttons/button14.wav")
                                net.Start("CRP_DropItemRequest")
                                    net.WriteInt(icon.SlotIndex, 8)
                                net.SendToServer()
                            end

                            -- Use (for weapons)
                            if weapons.Get(item["item"]) then
                                local useB = CreateButton("Использовать")
                                useB.DoClick = function()
                                    surface.PlaySound("buttons/button14.wav")
                                    net.Start("CRP_UseItemRequest")
                                        net.WriteInt(icon.SlotIndex, 8)
                                    net.SendToServer()
                                end
                            end

                        end

                    end
                end
            end
        end
            
        CRP_InventoryFrame:Refresh()

    else

        CRP_InventoryFrame:SetVisible(true)
        CRP_InventoryFrame:Refresh()

    end

    return false
end
hook.Add("ContextMenuOpen", "DrawCustomCMenu", DrawCMenu)

function CloseCMenu()
    if IsValid(CRP_InventoryFrame) then
        CRP_InventoryFrame:SetVisible(false)
    end
end
hook.Add("OnContextMenuClose", "CloseCustomCMenu", CloseCMenu)