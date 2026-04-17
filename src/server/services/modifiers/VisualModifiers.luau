local VisualModifiers = {}
local ModifierService = nil -- Inject later to avoid circular dependency if needed

function VisualModifiers.ApplyGhost(character, isGhost, isMaceUser)
    if isGhost then
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                if not part:GetAttribute("OriginalTransparency") then
                    part:SetAttribute("OriginalTransparency", part.Transparency)
                end
                -- 0.99 pentru a păstra Highlight vizibil
                part.Transparency = 0.99
            elseif part:IsA("Decal") then
                if not part:GetAttribute("OriginalTransparency") then
                    part:SetAttribute("OriginalTransparency", part.Transparency)
                end
                part.Transparency = 0.99
            end
        end
    else
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") or part:IsA("Decal") then
                local orig = part:GetAttribute("OriginalTransparency")
                if orig then
                    part.Transparency = orig
                end
            end
        end
    end
end

return VisualModifiers
