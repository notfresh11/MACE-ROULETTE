-- A simple proxy to overwrite the default Roblox Animate script IDs
local character = script.Parent
local humanoid = character:WaitForChild("Humanoid")

local MACE_FALL_ANIM_ID = "rbxassetid://136105914659826"
local maceFallTrack = nil

local animator = humanoid:WaitForChild("Animator")
if animator then
    local maceFallAnim = Instance.new("Animation")
    maceFallAnim.AnimationId = MACE_FALL_ANIM_ID
    maceFallTrack = animator:LoadAnimation(maceFallAnim)
end

humanoid.StateChanged:Connect(function(oldState, newState)
    if newState == Enum.HumanoidStateType.Freefall then
        -- Check if mace is equipped
        local tool = character:FindFirstChildOfClass("Tool")
        if tool and tool.Name ~= "BeachBall" and tool.Name ~= "HotPotatoTool" then
            if maceFallTrack then
                maceFallTrack:Play()
            end
        end
    elseif newState == Enum.HumanoidStateType.Landed or newState == Enum.HumanoidStateType.Running then
        if maceFallTrack and maceFallTrack.IsPlaying then
            maceFallTrack:Stop()
        end
    end
end)

-- Also check when equipping tool while in air
character.ChildAdded:Connect(function(child)
    if child:IsA("Tool") and child.Name ~= "BeachBall" and child.Name ~= "HotPotatoTool" then
        if humanoid:GetState() == Enum.HumanoidStateType.Freefall then
            if maceFallTrack then
                maceFallTrack:Play()
            end
        end
    end
end)

character.ChildRemoved:Connect(function(child)
    if child:IsA("Tool") and child.Name ~= "BeachBall" and child.Name ~= "HotPotatoTool" then
        if maceFallTrack and maceFallTrack.IsPlaying then
            maceFallTrack:Stop()
        end
    end
end)

-- Find the default Animate script that Roblox injects
local animateScript = character:WaitForChild("Animate", 5)
if animateScript then
    local walk = animateScript:FindFirstChild("walk")
    if walk and walk:FindFirstChild("WalkAnim") then
        walk.WalkAnim.AnimationId = "rbxassetid://102254450488960"
    end

    local run = animateScript:FindFirstChild("run")
    if run and run:FindFirstChild("RunAnim") then
        run.RunAnim.AnimationId = "rbxassetid://102254450488960"
    end

    local idle = animateScript:FindFirstChild("idle")
    if idle and idle:FindFirstChild("Animation1") then
        idle.Animation1.AnimationId = "rbxassetid://121110781169232"
    end
    if idle and idle:FindFirstChild("Animation2") then
        idle.Animation2.AnimationId = "rbxassetid://121110781169232"
    end
end
