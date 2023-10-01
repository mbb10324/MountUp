-------------------------------------------------------------------------------
-- Title: MountUp
-- Order: 3
-- Author: Miles Breman
-- Description: This file contains the functions that define the core 
-- features of MountUp, and defines all of the slash commands that 
-- MountUp utilizes.
-------------------------------------------------------------------------------

-- Global Tables
local allMountIDs = _G.MountUpAllMountIDs -- All mount IDs in the game from MountUp_Config.lua
local MountUpFavorites = _G.MountUpFavorites -- All favorite mounts from MountUp_Favorites.lua


-- Local Tables
local ownedUsableMounts = {} -- All usable mounts in player's collection
local ownedDragonRidingMounts = {} -- All dragon riding mounts in player's collection
local ownedFlyingMounts = {} -- All flying mounts in player's collection
local ownedGroundMounts = {} -- All ground mounts in player's collection

-------------------------------------------------------------------------------
-- Update local mount tables
-------------------------------------------------------------------------------

local function UpdateMountLists()
    -- Clear tables because we are going to repopulate them
    wipe(ownedUsableMounts)
    wipe(ownedDragonRidingMounts)
    wipe(ownedFlyingMounts)
    wipe(ownedGroundMounts)

    -- Determine all of the owned, and usable mounts in a player's collection
    for _, mountID in ipairs(allMountIDs) do
        local creatureName, spellID, _, _, isUsable = C_MountJournal.GetMountInfoByID(mountID)
        if isUsable then
            table.insert(ownedUsableMounts, {name = creatureName, spellID = spellID, mountID = mountID})
        end
    end

    -- Determine all of the owned, and usable dragon riding mounts in a player's collection
    for _, mountInfo in ipairs(ownedUsableMounts) do
        local _, _, _, _, mountTypeID, _, _, _, _ = C_MountJournal.GetMountInfoExtraByID(mountInfo.mountID)
        if mountTypeID == 402 then
            table.insert(ownedDragonRidingMounts, {mountID = mountInfo.mountID})
        end
    end

    -- Determine all of the owned, and usable flying mounts in a player's collection
    for _, mountInfo in ipairs(ownedUsableMounts) do
        local _, _, _, _, mountTypeID, _, _, _, _ = C_MountJournal.GetMountInfoExtraByID(mountInfo.mountID)
        if mountTypeID == 248 or mountTypeID == 424 then
            table.insert(ownedFlyingMounts, {mountID = mountInfo.mountID})
        end
    end

    -- Determine all of the owned, and usable ground mounts in a player's collection
    for _, mountInfo in ipairs(ownedUsableMounts) do
        local _, _, _, _, mountTypeID, _, _, _, _ = C_MountJournal.GetMountInfoExtraByID(mountInfo.mountID)
        if mountTypeID == 230 then
            table.insert(ownedGroundMounts, {mountID = mountInfo.mountID})
        end
    end

end

-- Initial mount list update
UpdateMountLists()

-------------------------------------------------------------------------------
-- Events that require a mount list update
-------------------------------------------------------------------------------

local frame = CreateFrame("Frame")
frame:RegisterEvent("ZONE_CHANGED")
frame:RegisterEvent("ZONE_CHANGED_INDOORS")
frame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
frame:RegisterEvent("PLAYER_LOGIN")
frame:RegisterEvent("PLAYER_ALIVE")
frame:RegisterEvent("PLAYER_UNGHOST")
frame:RegisterEvent("PLAYER_REGEN_ENABLED")
frame:RegisterEvent("INSTANCE_GROUP_SIZE_CHANGED")
-- Fire the update function when one of the above events is triggered
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

-------------------------------------------------------------------------------
-- Functions to mount player under different situations
-------------------------------------------------------------------------------

-- Mount player on a random mount based on zone precendence
function MountPlayerOnSuitableMount()
    if IsUsableSpell(368896) then -- Can use dragon riding mount
        local randomMount = ownedDragonRidingMounts[math.random(#ownedDragonRidingMounts)]
        C_MountJournal.SummonByID(randomMount.mountID)
    elseif IsFlyableArea() and #ownedFlyingMounts > 0 then -- Can use flying mount
        local randomMount = ownedFlyingMounts[math.random(#ownedFlyingMounts)]
        C_MountJournal.SummonByID(randomMount.mountID)
    elseif #ownedUsableMounts > 0 then -- Can use any mount
        local randomMount = ownedUsableMounts[math.random(#ownedUsableMounts)]
        C_MountJournal.SummonByID(randomMount.mountID)
    else -- No usable mounts
        print("No usable mounts found in your collection.")
    end
end

-- Mount player on a random dragon riding mount
function MountPlayerOnDragonRidingMount()
    if #ownedDragonRidingMounts > 0 then  -- Can use dragon riding mount
        local randomMount = ownedDragonRidingMounts[math.random(#ownedDragonRidingMounts)]
        C_MountJournal.SummonByID(randomMount.mountID)
    else
        print("No usable dragon riding mounts found in your collection.")
    end
end 

-- Mount player on a random flying mount
function MountPlayerOnFlyingMount()
    if #ownedFlyingMounts > 0 then  -- Can use flying mount
        local randomMount = ownedFlyingMounts[math.random(#ownedFlyingMounts)]
        C_MountJournal.SummonByID(randomMount.mountID)
    else
        print("No usable flying mounts found in your collection.")
    end
end

-- Mount player on a random ground mount
function MountPlayerOnGroundMount()
    if #ownedGroundMounts > 0 then  -- Can use ground mount
        local randomMount = ownedGroundMounts[math.random(#ownedGroundMounts)]
        C_MountJournal.SummonByID(randomMount.mountID)
    else
        print("No usable ground mounts found in your collection.")
    end
end

-- Mount player on a random usable mount
function MountPlayerOnRandomUsableMount()
    if #ownedUsableMounts > 0 then  -- Can use any mount
        local randomMount = ownedUsableMounts[math.random(#ownedUsableMounts)]
        C_MountJournal.SummonByID(randomMount.mountID)
    else
        print("No usable mounts found in your collection.")
    end
end

-------------------------------------------------------------------------------
-- Slash commands
-------------------------------------------------------------------------------

-- Mount player on a random favorite mount based on zone precendence
SLASH_MountUp1 = "/MountUp"
SlashCmdList["MountUp"] = MountPlayerOnSuitableMount

-- Mount player on a random dragon riding mount
SLASH_MountUpDragon1 =  "/MountUpDragon"
SlashCmdList["MountUpDragon"] = MountPlayerOnDragonRidingMount

-- Mount player on a random flying mount
SLASH_MountUpFlying1 =  "/MountUpFlying"
SlashCmdList["MountUpFlying"] = MountPlayerOnFlyingMount

-- Mount player on a random ground mount
SLASH_MountUpGround1 =  "/MountUpGround"
SlashCmdList["MountUpGround"] = MountPlayerOnGroundMount

-- Mount player on a random usable mount
SLASH_MountUpRandom1 =  "/MountUpRandom"
SlashCmdList["MountUpRandom"] = MountPlayerOnRandomUsableMount

-- Open the options menu
SLASH_MountUpOptions1 = "/MountUpOptions"
SlashCmdList["MountUpOptions"] = function() 
    -- Call it twice because blizzard is weird
    InterfaceOptionsFrame_OpenToCategory("MountUp")
    InterfaceOptionsFrame_OpenToCategory("MountUp")
end

-- Show avaliable slash commands
SLASH_MountUpHelp1 = "/MountUpHelp"
SlashCmdList["MountUpHelp"] = function()
    print("|cFFFF69B4-----------------------------------------------|r")
    print("|cFFFF69B4/MountUp|r" .. " - Summon a random mount based off zone priority.")
    print("|cFFFF69B4/MountUpFav|r" .. " - Summon a random favorite mount with zone priority.")
    print("|cFFFF69B4/MountUpFlying|r" .. " - Summon a random flying mount.")
    print("|cFFFF69B4/MountUpGround|r" .. " - Summon a random ground mount.")
    print("|cFFFF69B4/MountUpRandom|r" .. " - Summon a random usable mount.")
    print("|cFFFF69B4/MountUpDragon|r" .. " - Summon a random dragon riding mount.")
    print("|cFFFF69B4/MountUpOptions|r" .. " - Opens the options menu for MountUp.")
    print("|cFFFF69B4-----------------------------------------------|r")
end

-- Mount player on a random favorite mount based on zone precendence
SLASH_MountUpFav1 = "/MountUpFav"
SlashCmdList["MountUpFav"] = function()
    MountUpFavorites:MountPlayerOnSuitableFavorite() -- Defined in MountUp_Favorites.lua
end