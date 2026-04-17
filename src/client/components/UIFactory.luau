local UIFactory = {}

function UIFactory.CreateTextLabel(props)
    local label = Instance.new("TextLabel")
    label.Name = props.Name or "TextLabel"
    label.AnchorPoint = props.AnchorPoint or Vector2.new(0, 0)
    label.Size = props.Size or UDim2.new(1, 0, 1, 0)
    label.Position = props.Position or UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = props.BackgroundTransparency or 1
    label.FontFace = props.FontFace or Font.new("rbxasset://fonts/families/FredokaOne.json")
    label.TextScaled = props.TextScaled ~= false -- defaults to true unless explicitly false
    label.TextWrapped = props.TextWrapped or false
    label.TextColor3 = props.TextColor3 or Color3.new(1, 1, 1)
    label.TextStrokeTransparency = props.TextStrokeTransparency or 0
    label.Text = props.Text or ""
    label.Visible = props.Visible ~= false
    if props.Parent then
        label.Parent = props.Parent
    end
    return label
end

function UIFactory.CreateButton(props)
    local button = Instance.new("TextButton")
    button.Name = props.Name or "Button"
    button.AnchorPoint = props.AnchorPoint or Vector2.new(0, 0)
    button.Size = props.Size or UDim2.new(0, 100, 0, 50)
    button.Position = props.Position or UDim2.new(0, 0, 0, 0)
    button.BackgroundColor3 = props.BackgroundColor3 or Color3.new(1, 1, 1)
    button.BackgroundTransparency = props.BackgroundTransparency or 0
    button.FontFace = props.FontFace or Font.new("rbxasset://fonts/families/FredokaOne.json")
    button.TextScaled = props.TextScaled ~= false
    button.TextColor3 = props.TextColor3 or Color3.new(0, 0, 0)
    button.TextStrokeTransparency = props.TextStrokeTransparency or 1
    button.Text = props.Text or ""
    button.Visible = props.Visible ~= false
    if props.Parent then
        button.Parent = props.Parent
    end
    return button
end

function UIFactory.CreateFrame(props)
    local frame = Instance.new("Frame")
    frame.Name = props.Name or "Frame"
    frame.AnchorPoint = props.AnchorPoint or Vector2.new(0, 0)
    frame.Size = props.Size or UDim2.new(1, 0, 1, 0)
    frame.Position = props.Position or UDim2.new(0, 0, 0, 0)
    frame.BackgroundColor3 = props.BackgroundColor3 or Color3.new(1, 1, 1)
    frame.BackgroundTransparency = props.BackgroundTransparency or 0
    frame.Visible = props.Visible ~= false
    if props.Parent then
        frame.Parent = props.Parent
    end
    return frame
end

function UIFactory.CreateImageLabel(props)
    local imageLabel = Instance.new("ImageLabel")
    imageLabel.Name = props.Name or "ImageLabel"
    imageLabel.AnchorPoint = props.AnchorPoint or Vector2.new(0, 0)
    imageLabel.Size = props.Size or UDim2.new(1, 0, 1, 0)
    imageLabel.Position = props.Position or UDim2.new(0, 0, 0, 0)
    imageLabel.BackgroundTransparency = props.BackgroundTransparency or 1
    imageLabel.Image = props.Image or ""
    imageLabel.Visible = props.Visible ~= false
    if props.Parent then
        imageLabel.Parent = props.Parent
    end
    return imageLabel
end

function UIFactory.CreateScrollingFrame(props)
    local scroll = Instance.new("ScrollingFrame")
    scroll.Name = props.Name or "ScrollingFrame"
    scroll.AnchorPoint = props.AnchorPoint or Vector2.new(0, 0)
    scroll.Size = props.Size or UDim2.new(1, 0, 1, 0)
    scroll.Position = props.Position or UDim2.new(0, 0, 0, 0)
    scroll.BackgroundTransparency = props.BackgroundTransparency or 1
    scroll.CanvasSize = props.CanvasSize or UDim2.new(0, 0, 0, 0)
    scroll.AutomaticCanvasSize = props.AutomaticCanvasSize or Enum.AutomaticSize.None
    scroll.ScrollBarThickness = props.ScrollBarThickness or 12
    scroll.Visible = props.Visible ~= false
    if props.Parent then
        scroll.Parent = props.Parent
    end
    return scroll
end

function UIFactory.ApplyUIStroke(parent, props)
    local stroke = Instance.new("UIStroke")
    stroke.Color = props.Color or Color3.new(0, 0, 0)
    stroke.Thickness = props.Thickness or 1
    stroke.ApplyStrokeMode = props.ApplyStrokeMode or Enum.ApplyStrokeMode.Contextual
    stroke.Parent = parent
    return stroke
end

function UIFactory.ApplyUICorner(parent, cornerRadius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = cornerRadius or UDim.new(0, 8)
    corner.Parent = parent
    return corner
end

function UIFactory.ApplyUIListLayout(parent, props)
    local layout = Instance.new("UIListLayout")
    layout.SortOrder = props.SortOrder or Enum.SortOrder.LayoutOrder
    layout.Padding = props.Padding or UDim.new(0, 0)
    layout.HorizontalAlignment = props.HorizontalAlignment or Enum.HorizontalAlignment.Left
    layout.VerticalAlignment = props.VerticalAlignment or Enum.VerticalAlignment.Top
    layout.Parent = parent
    return layout
end

return UIFactory
