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
    local info = spawnPlatform:FindFirstChild("Info")
    if not info then return nil end
    local frame = info:FindFirstChild("Frame")
    if not frame then return nil end
    local infoInner = frame:FindFirstChild("Info")
    if not infoInner then return nil end
    return infoInner:FindFirstChildWhichIsA("SurfaceGui")
end

function MatchInfoManager.UpdateSurfaceUI()
    local sGui = getSurfaceGui()
    if not sGui then return end

    local roundLbl = sGui:FindFirstChild("Round")
    local staticRound = sGui:FindFirstChild("StaticRounds")

    local playersLbl = sGui:FindFirstChild("PlayersRemaining")
    local staticPlayers = sGui:FindFirstChild("StaticPlayersRemaining")

    local modifiersLbl = sGui:FindFirstChild("ModifiersList")
    local staticModifiers = sGui:FindFirstChild("StaticModifiers")

    local hasRounds = currentMatchData.Rounds > 0
    if roundLbl then roundLbl.Text = hasRounds and tostring(currentMatchData.Rounds) or "" end
    if staticRound then staticRound.Visible = hasRounds end

    local hasPlayers = currentMatchData.PlayersAlive > 0
    if playersLbl then playersLbl.Text = hasPlayers and tostring(currentMatchData.PlayersAlive) or "" end
    if staticPlayers then staticPlayers.Visible = hasPlayers end

    local hasModifiers = currentMatchData.ModifierList ~= ""
    if modifiersLbl then modifiersLbl.Text = hasModifiers and currentMatchData.ModifierList or "" end
    if staticModifiers then staticModifiers.Visible = hasModifiers end
end

function MatchInfoManager.SyncToClients(targetPlayers)
    if targetPlayers then
        for _, plr in ipairs(targetPlayers) do
            updateMatchInfoEvent:FireClient(plr, currentMatchData)
        end
    else
        -- Only fire to players IN MATCH for the ScreenGui
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr:GetAttribute("InMatch") then
                updateMatchInfoEvent:FireClient(plr, currentMatchData)
            end
        end
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
