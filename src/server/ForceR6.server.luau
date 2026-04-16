local Players = game:GetService("Players")

local function onPlayerAdded(player)
    player.CharacterAdded:Connect(function(character)
        local humanoid = character:WaitForChild("Humanoid", 5)
        if humanoid and humanoid.RigType == Enum.HumanoidRigType.R15 then
            -- Let the initial load finish
            task.wait(0.1)
            -- Fetch player description to maintain outfit
            local success, description = pcall(function()
                return Players:GetHumanoidDescriptionFromUserId(player.UserId)
            end)

            if success and description then
                -- Creating model and applying description to avoid T-Pose bug
                local r6Character = Players:CreateHumanoidModelFromDescription(description, Enum.HumanoidRigType.R6)
                r6Character.Name = player.Name

                -- Need to transfer standard scripts to the new character to avoid breaking mechanics
                for _, child in ipairs(character:GetChildren()) do
                    if child:IsA("LocalScript") or child:IsA("Script") then
                        child:Clone().Parent = r6Character
                    end
                end

                r6Character.HumanoidRootPart.CFrame = character.HumanoidRootPart.CFrame
                player.Character = r6Character
                r6Character.Parent = workspace
                character:Destroy()
            end
        end
    end)
end

Players.PlayerAdded:Connect(onPlayerAdded)
for _, player in ipairs(Players:GetPlayers()) do
    onPlayerAdded(player)
end
