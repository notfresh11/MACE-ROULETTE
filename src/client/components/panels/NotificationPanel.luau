local UIFactory = require(script.Parent.Parent.UIFactory)

local NotificationPanel = {}

function NotificationPanel.Create(parentGui)
    local container = UIFactory.CreateFrame({
        Name = "NotificationContainer",
        Size = UDim2.new(0.3, 0, 0.4, 0),
        Position = UDim2.new(0.68, 0, 0.5, 0),
        BackgroundTransparency = 1,
        Visible = true,
        Parent = parentGui
    })

    UIFactory.ApplyUIListLayout(container, {
        Padding = UDim.new(0, 5),
        VerticalAlignment = Enum.VerticalAlignment.Bottom
    })

    return {
        Container = container,
        AddNotification = function(text, duration)
            local notif = UIFactory.CreateTextLabel({
                Name = "Notification",
                Size = UDim2.new(1, 0, 0, 40),
                BackgroundColor3 = Color3.fromRGB(30, 30, 30),
                BackgroundTransparency = 0.2,
                Text = text,
                TextColor3 = Color3.new(1, 1, 1),
                TextScaled = true,
                Parent = container
            })
            UIFactory.ApplyUICorner(notif, UDim.new(0, 8))

            task.delay(duration or 3, function()
                notif:Destroy()
            end)
        end
    }
end

return NotificationPanel
