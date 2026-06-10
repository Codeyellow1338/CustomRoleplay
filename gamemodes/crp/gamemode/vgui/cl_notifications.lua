net.Receive("CRP_Notification", function(len)

    local text = net.ReadString()
    notification.AddLegacy(text,NOTIFY_HINT,1)

end)