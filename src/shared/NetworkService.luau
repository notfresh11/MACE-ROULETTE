local NetworkService = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local remotesFolder = ReplicatedStorage:FindFirstChild("Remotes")
if not remotesFolder then
    remotesFolder = Instance.new("Folder")
    remotesFolder.Name = "Remotes"
    remotesFolder.Parent = ReplicatedStorage
end

local eventsList = {
    {Name = "AbilityRequestEvent", Type = "RemoteEvent"},
    {Name = "AbilityStateEvent", Type = "RemoteEvent"},
    {Name = "AbilityUseEvent", Type = "RemoteEvent"},
    {Name = "BeachBallThrowEvent", Type = "RemoteEvent"},
    {Name = "ClientModifierEvent", Type = "RemoteEvent"},
    {Name = "DashVelocityEvent", Type = "RemoteEvent"},
    {Name = "FetchFriendsFunction", Type = "RemoteFunction"},
    {Name = "HideTextEvent", Type = "RemoteEvent"},
    {Name = "HotPotatoPassEvent", Type = "RemoteEvent"},
    {Name = "HotPotatoTimerEvent", Type = "RemoteEvent"},
    {Name = "KnockbackClickEvent", Type = "RemoteEvent"},
    {Name = "NotificationAnswerEvent", Type = "RemoteEvent"},
    {Name = "NotificationReceivedEvent", Type = "RemoteEvent"},
    {Name = "PartyActionEvent", Type = "RemoteEvent"},
    {Name = "PartyUpdateEvent", Type = "RemoteEvent"},
    {Name = "SendNotificationEvent", Type = "RemoteEvent"},
    {Name = "ShockwaveVfxEvent", Type = "RemoteEvent"},
    {Name = "ShowCountdownEvent", Type = "RemoteEvent"},
    {Name = "ShowTextEvent", Type = "RemoteEvent"},
    {Name = "ToggleAFKEvent", Type = "RemoteEvent"},
    {Name = "ToggleMainUIEvent", Type = "RemoteEvent"},
    {Name = "UpdateMatchmakingUIEvent", Type = "RemoteEvent"},
    {Name = "UpdateModifiersUIEvent", Type = "RemoteEvent"},
    {Name = "UpdateStatsEvent", Type = "RemoteEvent"},
    {Name = "VfxEvent", Type = "RemoteEvent"},

    -- Legacy events kept just in case
    {Name = "MatchmakingEvent", Type = "RemoteEvent"},
    {Name = "UpdateNotificationEvent", Type = "RemoteEvent"},
    {Name = "AbilityInputEvent", Type = "RemoteEvent"},
    {Name = "RequestTeleportEvent", Type = "RemoteEvent"},
    {Name = "MaceAttackEvent", Type = "RemoteEvent"},
}

function NetworkService.Init()
    for _, eventData in ipairs(eventsList) do
        if not remotesFolder:FindFirstChild(eventData.Name) then
            local remote = Instance.new(eventData.Type)
            remote.Name = eventData.Name
            remote.Parent = remotesFolder
        end
    end
    print("[DEBUG] NetworkService: Toate instantele de rețea au fost pre-instanțiate.")
end

function NetworkService.GetEvent(eventName)
    local event = remotesFolder:FindFirstChild(eventName)
    if not event then
        if RunService:IsClient() then
            -- Pe client, asteptam ca serverul sa creeze si sa replice event-ul
            event = remotesFolder:WaitForChild(eventName, 15)
            if not event then
                warn(string.format("[CRITICAL WARNING] NetworkService Client: Event-ul '%s' nu a fost gasit in folderul Remotes in timp util!", eventName))
            end
        else
            warn(string.format("[CRITICAL WARNING] NetworkService Server: Event-ul '%s' nu a fost pre-instanțiat! Creăm unul pe loc (Lazy Load) pentru a preveni crash-ul.", eventName))

            -- Fallback: Caută tipul dorit în lista hardcodată
            local eventType = "RemoteEvent"
            for _, eventData in ipairs(eventsList) do
                if eventData.Name == eventName then
                    eventType = eventData.Type
                    break
                end
            end

            -- Dacă se termină în Function, asigură-te că e RemoteFunction
            if string.match(eventName, "Function$") then
                eventType = "RemoteFunction"
            end

            event = Instance.new(eventType)
            event.Name = eventName
            event.Parent = remotesFolder
        end
    end
    return event
end

return NetworkService
