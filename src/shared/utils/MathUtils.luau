local MathUtils = {}

function MathUtils.IsValidVector3(v)
    return typeof(v) == "Vector3" and v.X == v.X and v.Y == v.Y and v.Z == v.Z
end

function MathUtils.GetDistance(v1, v2)
    return (v1 - v2).Magnitude
end

function MathUtils.IsAbove(attackerPos, victimPos, thresholdY)
    return attackerPos.Y > victimPos.Y + (thresholdY or 2.5)
end

return MathUtils
