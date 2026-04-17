local UIFactory = require(script.Parent.Parent.UIFactory)

local ShopPanel = {}

function ShopPanel.Create(parentGui)
    local panel = UIFactory.CreateFrame({
        Name = "ShopPanel",
        Size = UDim2.new(0.8, 0, 0.8, 0),
        Position = UDim2.new(0.1, 0, 0.1, 0),
        BackgroundColor3 = Color3.fromRGB(40, 40, 40),
        BackgroundTransparency = 0.1,
        Visible = false,
        Parent = parentGui
    })

    UIFactory.ApplyUICorner(panel, UDim.new(0, 12))

    local title = UIFactory.CreateTextLabel({
        Name = "Title",
        Size = UDim2.new(1, 0, 0.1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1,
        Text = "SHOP",
        TextColor3 = Color3.new(1, 1, 1),
        TextScaled = true,
        Parent = panel
    })

    local scroll = UIFactory.CreateScrollingFrame({
        Name = "ItemsScroll",
        Size = UDim2.new(0.9, 0, 0.8, 0),
        Position = UDim2.new(0.05, 0, 0.15, 0),
        BackgroundTransparency = 1,
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Parent = panel
    })

    UIFactory.ApplyUIListLayout(scroll, {
        Padding = UDim.new(0, 10),
        HorizontalAlignment = Enum.HorizontalAlignment.Center
    })

    return {
        Panel = panel,
        Scroll = scroll,
        Title = title,
        Toggle = function()
            panel.Visible = not panel.Visible
        end
    }
end

return ShopPanel
