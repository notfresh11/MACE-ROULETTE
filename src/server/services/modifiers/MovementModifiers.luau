local MovementModifiers = {}

function MovementModifiers.ApplySpeed(character, speedValue)
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = speedValue
    end
end

function MovementModifiers.ApplyJump(character, jumpValue)
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.JumpPower = jumpValue
        humanoid.UseJumpPower = true
    end
end

return MovementModifiers
