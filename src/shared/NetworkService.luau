local NetworkService = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local remotesFolder = ReplicatedStorage:FindFirstChild("Remotes")
if not remotesFolder then
    remotesFolder = Instance.new("Folder")
    remotesFolder.Name = "Remotes"
    remotesFolder.Parent = ReplicatedStorage
end

local eventsList = {
    {Name = "UpdateModifiersUIEvent", Type = "RemoteEvent"},
    {Name = "ClientModifierEvent", Type = "RemoteEvent"},
    {Name = "KnockbackClickEvent", Type = "RemoteEvent"},
    {Name = "BeachBallThrowEvent", Type = "RemoteEvent"},
    {Name = "HotPotatoTimerEvent", Type = "RemoteEvent"},
    {Name = "VfxEvent", Type = "RemoteEvent"},
    {Name = "ShockwaveVfxEvent", Type = "RemoteEvent"},
    {Name = "MatchmakingEvent", Type = "RemoteEvent"},
    {Name = "UpdateNotificationEvent", Type = "RemoteEvent"},
    {Name = "AbilityInputEvent", Type = "RemoteEvent"},
    {Name = "RequestTeleportEvent", Type = "RemoteEvent"},
    {Name = "MaceAttackEvent", Type = "RemoteEvent"},
    {Name = "HotPotatoPassEvent", Type = "RemoteEvent"},
    {Name = "AbilityRequestEvent", Type = "RemoteEvent"},
    {Name = "AbilityUseEvent", Type = "RemoteEvent"},
    {Name = "AbilityStateEvent", Type = "RemoteEvent"},
    {Name = "DashVelocityEvent", Type = "RemoteEvent"},
    {Name = "UpdateMatchmakingUIEvent", Type = "RemoteEvent"},
    {Name = "ShowCountdownEvent", Type = "RemoteEvent"},
    {Name = "ShowTextEvent", Type = "RemoteEvent"},
    {Name = "HideTextEvent", Type = "RemoteEvent"},
    {Name = "SendNotificationEvent", Type = "RemoteEvent"},
    {Name = "NotificationAnswerEvent", Type = "RemoteEvent"},
    {Name = "ToggleAFKEvent", Type = "RemoteEvent"},
    {Name = "PartyUpdateEvent", Type = "RemoteEvent"},
    {Name = "PartyActionEvent", Type = "RemoteEvent"},
    {Name = "UpdateStatsEvent", Type = "RemoteEvent"},
    {Name = "ToggleMainUIEvent", Type = "RemoteEvent"},
    {Name = "NotificationReceivedEvent", Type = "RemoteEvent"},
    {Name = "FetchFriendsFunction", Type = "RemoteFunction"},
}

function NetworkService.Init()
    for _, eventData in ipairs(eventsList) do
        if not remotesFolder:FindFirstChild(eventData.Name) then
            local remote = Instance.new(eventData.Type)
            remote.Name = eventData.Name
            remote.Parent = remotesFolder
        end
    end
    print("[DEBUG] NetworkService: Toate RemoteEvents au fost pre-instanțiate.")
end

function NetworkService.GetEvent(eventName)
    local event = remotesFolder:FindFirstChild(eventName)
    if not event then
        warn("[WARNING] NetworkService: Event-ul " .. eventName .. " nu a fost găsit. Asigură-te că este în lista pre-instanțiată.")
    end
    return event
end

return NetworkService
