-- TODOs: 
-- Currently isUsable fires on mount and causes bug when changing zones and mounts are now usable
-- Add more checks in bools for MountPlayerOnSuitableMount to prevent bugs

local allMountIDs = _G.MountUpAllMountIDs

local allOwnedUsableMounts = {} -- Get all usable mounts in player's collection
local ownedDragonRidingMounts = {} -- Get all dragon riding mounts in player's collection
local ownedFlyingMounts = {} -- Get all flying mounts in player's collection
local ownedGroundMounts = {} -- Get all ground mounts in player's collection

local function UpdateMountLists()
    wipe(allOwnedUsableMounts)
    wipe(ownedDragonRidingMounts)
    wipe(ownedFlyingMounts)
    wipe(ownedGroundMounts)

    for _, mountID in ipairs(allMountIDs) do
        local creatureName, spellID, _, _, isUsable = C_MountJournal.GetMountInfoByID(mountID)
        if isUsable then
            table.insert(allOwnedUsableMounts, {name = creatureName, spellID = spellID, mountID = mountID})
        end
    end

    for _, mountInfo in ipairs(allOwnedUsableMounts) do
        local _, _, _, _, mountTypeID, _, _, _, _ = C_MountJournal.GetMountInfoExtraByID(mountInfo.mountID)
        if mountTypeID == 402 then
            table.insert(ownedDragonRidingMounts, {mountID = mountInfo.mountID})
        end
    end

    for _, mountInfo in ipairs(allOwnedUsableMounts) do
        local _, _, _, _, mountTypeID, _, _, _, _ = C_MountJournal.GetMountInfoExtraByID(mountInfo.mountID)
        if mountTypeID == 248 or mountTypeID == 424 then
            table.insert(ownedFlyingMounts, {mountID = mountInfo.mountID})
        end
    end

    for _, mountInfo in ipairs(allOwnedUsableMounts) do
        local _, _, _, _, mountTypeID, _, _, _, _ = C_MountJournal.GetMountInfoExtraByID(mountInfo.mountID)
        if mountTypeID == 230 then
            table.insert(ownedGroundMounts, {mountID = mountInfo.mountID})
        end
    end

end

UpdateMountLists()

local frame = CreateFrame("Frame")
frame:RegisterEvent("ZONE_CHANGED")
frame:RegisterEvent("ZONE_CHANGED_INDOORS")
frame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
frame:RegisterEvent("PLAYER_LOGIN")
frame:RegisterEvent("PLAYER_ALIVE")
frame:RegisterEvent("PLAYER_UNGHOST")
frame:RegisterEvent("PLAYER_REGEN_ENABLED")
frame:RegisterEvent("INSTANCE_GROUP_SIZE_CHANGED")
frame:SetScript("OnEvent", function(self, event, ...)
    if event == "ZONE_CHANGED" 
    or event == "ZONE_CHANGED_INDOORS" 
    or event == "ZONE_CHANGED_NEW_AREA" 
    or event == "PLAYER_LOGIN" 
    or event == "PLAYER_ALIVE"
    or event == "PLAYER_UNGHOST"
    or event == "PLAYER_REGEN_ENABLED"
    or event == "INSTANCE_GROUP_SIZE_CHANGED"  
    then
        UpdateMountLists()
    end
end)

-- Mount player on a random mount based on precendence
function MountPlayerOnSuitableMount()
    if IsUsableSpell(368896) then -- Check if can use dragon riding mount
        local randomMount = ownedDragonRidingMounts[math.random(#ownedDragonRidingMounts)]
        C_MountJournal.SummonByID(randomMount.mountID)
    elseif IsFlyableArea() and #ownedFlyingMounts > 0 then -- Check if can use flying mount
        local randomMount = ownedFlyingMounts[math.random(#ownedFlyingMounts)]
        C_MountJournal.SummonByID(randomMount.mountID)
    elseif #allOwnedUsableMounts > 0 then -- Check if can use any mount
        local randomMount = allOwnedUsableMounts[math.random(#allOwnedUsableMounts)]
        C_MountJournal.SummonByID(randomMount.mountID)
    else -- No usable mounts
        print("No usable mounts found in your collection.")
    end
end

function MountPlayerOnDragonRidingMount()
    if #ownedDragonRidingMounts > 0 then 
        local randomMount = ownedDragonRidingMounts[math.random(#ownedDragonRidingMounts)]
        C_MountJournal.SummonByID(randomMount.mountID)
    else
        print("No usable dragon riding mounts found in your collection.")
    end
end 

function MountPlayerOnFlyingMount()
    if #ownedFlyingMounts > 0 then 
        local randomMount = ownedFlyingMounts[math.random(#ownedFlyingMounts)]
        C_MountJournal.SummonByID(randomMount.mountID)
    else
        print("No usable flying mounts found in your collection.")
    end
end

function MountPlayerOnGroundMount()
    if #ownedGroundMounts > 0 then 
        local randomMount = ownedGroundMounts[math.random(#ownedGroundMounts)]
        C_MountJournal.SummonByID(randomMount.mountID)
    else
        print("No usable ground mounts found in your collection.")
    end
end

function MountPlayerOnRandomUsableMount()
    if #allOwnedUsableMounts > 0 then 
        local randomMount = allOwnedUsableMounts[math.random(#allOwnedUsableMounts)]
        C_MountJournal.SummonByID(randomMount.mountID)
    else
        print("No usable mounts found in your collection.")
    end
end

-- Command Registration
SLASH_MountUp1 = "/MountUp"
SlashCmdList["MountUp"] = MountPlayerOnSuitableMount

SLASH_MountUpDragon1 =  "/MountUpDragon"
SlashCmdList["MountUpDragon"] = MountPlayerOnDragonRidingMount

SLASH_MountUpFlying1 =  "/MountUpFlying"
SlashCmdList["MountUpFlying"] = MountPlayerOnFlyingMount

SLASH_MountUpGround1 =  "/MountUpGround"
SlashCmdList["MountUpGround"] = MountPlayerOnGroundMount

SLASH_MountUpRandom1 =  "/MountUpRandom"
SlashCmdList["MountUpRandom"] = MountPlayerOnRandomUsableMount



