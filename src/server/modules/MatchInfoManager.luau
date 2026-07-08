local MatchInfoManager = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local NetworkService = require(ReplicatedStorage.Shared.NetworkService)

local updateMatchInfoEvent = NetworkService.GetEvent("UpdateMatchInfoEvent")

local currentMatchData = {
    Rounds = 0,
    PlayersAlive = 0,
    MaceHolder = "",
    LastWinner = "",
    ModifierList = ""
}

local function getSurfaceGui()
    local wholeMap = Workspace:FindFirstChild("WholeMap")
    if not wholeMap then return nil end
    local spawnPlatform = wholeMap:FindFirstChild("SpawnPlatform")
    if not spawnPlatform then return nil end

    -- Recursive search starting from SpawnPlatform to be more robust against minor hierarchy changes
    local frame = spawnPlatform:FindFirstChild("Frame", true)
    if frame then
        return frame:FindFirstChildWhichIsA("SurfaceGui", true)
    end

    -- Fallback to the explicit path if recursive fails or finds the wrong thing
    local info = spawnPlatform:FindFirstChild("Info")
    if info then
        local framePart = info:FindFirstChild("Frame")
        if framePart then
            local infoInner = framePart:FindFirstChild("Info")
            if infoInner then
                return infoInner:FindFirstChildWhichIsA("SurfaceGui")
            end
        end
    end

    return nil
end

function MatchInfoManager.UpdateSurfaceUI()
    local sGui = getSurfaceGui()
    if not sGui then return end

    local roundLbl = sGui:FindFirstChild("Round", true)
    local staticRound = sGui:FindFirstChild("StaticRounds", true)

    local playersLbl = sGui:FindFirstChild("PlayersRemaining", true)
    local staticPlayers = sGui:FindFirstChild("StaticPlayersRemaining", true)

    local modifiersLbl = sGui:FindFirstChild("ModifiersList", true)
    local staticModifiers = sGui:FindFirstChild("StaticModifiers", true)

    local maceLbl = sGui:FindFirstChild("MaceHolder", true)
    local staticMace = sGui:FindFirstChild("StaticMace", true)

    local winnerLbl = sGui:FindFirstChild("LastWinner", true)
    local staticWinner = sGui:FindFirstChild("StaticWinner", true)

    local hasRounds = currentMatchData.Rounds > 0
    if roundLbl then roundLbl.Text = hasRounds and tostring(currentMatchData.Rounds) or "" end
    if staticRound then staticRound.Visible = hasRounds end

    local hasPlayers = currentMatchData.PlayersAlive > 0
    if playersLbl then playersLbl.Text = hasPlayers and tostring(currentMatchData.PlayersAlive) or "" end
    if staticPlayers then staticPlayers.Visible = hasPlayers end

    local hasModifiers = currentMatchData.ModifierList ~= ""
    if modifiersLbl then modifiersLbl.Text = hasModifiers and currentMatchData.ModifierList or "" end
    if staticModifiers then staticModifiers.Visible = hasModifiers end

    local hasMace = currentMatchData.MaceHolder ~= ""
    if maceLbl then maceLbl.Text = hasMace and currentMatchData.MaceHolder or "" end
    if staticMace then staticMace.Visible = hasMace end

    local hasWinner = currentMatchData.LastWinner ~= ""
    if winnerLbl then winnerLbl.Text = hasWinner and currentMatchData.LastWinner or "" end
    if staticWinner then staticWinner.Visible = hasWinner end
end

function MatchInfoManager.SyncToClients(targetPlayers)
    if targetPlayers then
        for _, plr in ipairs(targetPlayers) do
            updateMatchInfoEvent:FireClient(plr, currentMatchData)
        end
    else
        -- Fire to everyone so those who are eliminated can hide their HUD immediately
        updateMatchInfoEvent:FireAllClients(currentMatchData)
    end
end

function MatchInfoManager.SetData(key, value)
    if currentMatchData[key] ~= nil then
        currentMatchData[key] = value
        MatchInfoManager.UpdateSurfaceUI()
        MatchInfoManager.SyncToClients()
    end
end

function MatchInfoManager.UpdateAll(data)
    for k, v in pairs(data) do
        currentMatchData[k] = v
    end
    MatchInfoManager.UpdateSurfaceUI()
    MatchInfoManager.SyncToClients()
end

function MatchInfoManager.ResetMatch()
    currentMatchData.Rounds = 0
    currentMatchData.PlayersAlive = 0
    currentMatchData.MaceHolder = ""
    currentMatchData.ModifierList = ""
    -- LastWinner stays
    MatchInfoManager.UpdateSurfaceUI()
    MatchInfoManager.SyncToClients()
end

return MatchInfoManager
