function Hunger()

    timer.Create("Hunger", math.random(60, 90), 0, function() 
        LocalPlayer():SetHunger( LocalPlayer():GetHunger() - 2.5 )
        if LocalPlayer():GetHunger() == 0 then
            net.Start("HungerDamage")
                net.WriteInt(1.5)
            net.Send()
        end
    end)

end
Hunger()