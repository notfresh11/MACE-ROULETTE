local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local player = Players.LocalPlayer

local abilityUseEvent = ReplicatedStorage:WaitForChild("AbilityUseEvent", 10)

local dashVelocityEvent = ReplicatedStorage:WaitForChild("DashVelocityEvent", 10)

if abilityUseEvent then
    UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
        -- Do not trigger if typing in chat
        if gameProcessedEvent then return end

        -- 'Q' key for activating abilities
        if input.KeyCode == Enum.KeyCode.Q then
            local character = player.Character
            if character and character:FindFirstChild("Humanoid") and character.Humanoid.Health > 0 then
                local direction = "Forward"
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                    direction = "Back"
                elseif UserInputService:IsKeyDown(Enum.KeyCode.A) then
                    direction = "Left"
                elseif UserInputService:IsKeyDown(Enum.KeyCode.D) then
                    direction = "Right"
                end

                -- The visual cooldown is now handled in GameUI.client.luau based on local input
                abilityUseEvent:FireServer(direction)
            end
        end
    end)
else
    warn("AbilityInput: Nu am putut găsi AbilityUseEvent în ReplicatedStorage.")
end

local dashAnimForwardIds = {"rbxassetid://99980097234641", "rbxassetid://95366129387683"}
local dashAnimBackId = "rbxassetid://83645634111421"
local dashAnimLeftId = "rbxassetid://102416618280187"
local dashAnimRightId = "rbxassetid://80430289856845"

-- Pre-load animations to prevent memory leaks
local loadedDashAnims = {}
local function getDashTrack(animator, animId)
    if not loadedDashAnims[animator] then
        loadedDashAnims[animator] = {}
        -- Setup cleanup for this animator
        local conn
        conn = animator.AncestryChanged:Connect(function(_, parent)
            if not parent then
                loadedDashAnims[animator] = nil
                conn:Disconnect()
            end
        end)
    end
    if not loadedDashAnims[animator][animId] then
        local anim = Instance.new("Animation")
        anim.AnimationId = animId
        local track = animator:LoadAnimation(anim)
        track.Looped = false
        loadedDashAnims[animator][animId] = track
    end
    return loadedDashAnims[animator][animId]
end

if dashVelocityEvent then
    dashVelocityEvent.OnClientEvent:Connect(function(dashVelocity, direction)
        local character = player.Character
        if character then
            local rootPart = character:FindFirstChild("HumanoidRootPart")
            if rootPart then
                -- Play Dash Animation
                local humanoid = character:FindFirstChild("Humanoid")
                if humanoid then
                    local animator = humanoid:FindFirstChild("Animator")
                    if animator then
                        local animId = dashAnimForwardIds[math.random(1, #dashAnimForwardIds)]
                        if direction == "Back" then
                            animId = dashAnimBackId
                        elseif direction == "Left" then
                            animId = dashAnimLeftId
                        elseif direction == "Right" then
                            animId = dashAnimRightId
                        end

                        local track = getDashTrack(animator, animId)
                        -- Stop other dash tracks if they are somehow playing
                        for id, t in pairs(loadedDashAnims[animator]) do
                            if id ~= animId and t.IsPlaying then
                                t:Stop(0.1)
                            end
                        end
                        track:Play()
                        -- Ensure it doesn't get stuck
                        task.delay(0.5, function()
                            if track and track.IsPlaying then
                                track:Stop(0.2)
                            end
                        end)
                    end
                end

                -- Apply a LinearVelocity for a short duration to make it feel like a real dash
                local attachment = Instance.new("Attachment", rootPart)

                local linearVelocity = Instance.new("LinearVelocity")
                linearVelocity.Attachment0 = attachment
                linearVelocity.MaxForce = 100000 -- Putere mare ca să învingă fricțiunea și greutatea
                linearVelocity.VelocityConstraintMode = Enum.VelocityConstraintMode.Vector
                linearVelocity.VectorVelocity = Vector3.new(dashVelocity.X, 0, dashVelocity.Z)
                linearVelocity.RelativeTo = Enum.ActuatorRelativeTo.World
                linearVelocity.Parent = rootPart

                -- Distruge după 0.18 secunde (durata dash-ului scurtată)
                task.delay(0.18, function()
                    if linearVelocity then linearVelocity:Destroy() end
                    if attachment then attachment:Destroy() end

                    -- Oprește inerția ca să nu alunece mai departe
                    if rootPart and rootPart.Parent then
                        -- Nu tăia complet Y-ul, altfel îl oprești din cădere/bounce
                        rootPart.AssemblyLinearVelocity = Vector3.new(0, rootPart.AssemblyLinearVelocity.Y, 0)
                    end
                end)
            end
        end
    end)
end
