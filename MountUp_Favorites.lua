-------------------------------------------------------------------------------
-- Title: MountUp Favorites
-- Order: 2
-- Author: Miles Breman
-- Description: This file contains all of the functions related to the 
-- favorites feature (/MountUpFav)
-------------------------------------------------------------------------------

-- Get registration with Ace3 defined in MountUp_Config.lua
local name = ... or "MountUp";
---@class MountUp : AceAddon
local MountUp = LibStub("AceAddon-3.0"):GetAddon(name);
if not MountUp then return; end

-- Table to hold all of the favorite mounts
local MountUpFavorites = {}

-- Determines if a mount is a favorite
function MountUpFavorites:IsFavorite(mountID)
    return MountUp.db.profile.favorites[mountID] or false
end

-- Sets a mount as a favorite
function MountUpFavorites:SetFavorite(mountID, value)
    MountUp.db.profile.favorites[mountID] = value or nil
end

-- Gets a list of all favorite mounts
function MountUpFavorites:GetFavorites()
    local favoritesList = {}
    for mountID, isFavorite in pairs(MountUp.db.profile.favorites) do
        if isFavorite then
            table.insert(favoritesList, mountID)
        end
    end
    return favoritesList
end

-------------------------------------------------------------------------------
-- Function to mount player on a favorite mount with zone precendence 
-------------------------------------------------------------------------------

function MountUpFavorites:MountPlayerOnSuitableFavorite()
    local favorites = self:GetFavorites() -- all favorite mounts
    local favoriteUsable = {} -- all usable favorite mounts
    local favoriteFlying = {} -- all usable favorite flying mounts

    if #favorites == 0 then -- No favorites
        print("You have not selected any favorite mounts for the current profile.")
        return
    end

    -- Determine all of the usable favorite mounts
    for _, mountID in ipairs(favorites) do
        local _, _, _, _, isUsable = C_MountJournal.GetMountInfoByID(mountID)
        if isUsable then
            table.insert(favoriteUsable, {mountID = mountID})
        end
    end

    -- Determine all of the favorite dragon riding and flying mounts
    for _, mountID in ipairs(favorites) do
        local _, _, _, _, mountTypeID, _, _, _ = C_MountJournal.GetMountInfoExtraByID(mountID)
        if mountTypeID == 248 or mountTypeID == 424 or mountTypeID == 402 then -- Is flying mount
            table.insert(favoriteFlying, {mountID = mountID})
        end
    end

    if not IsFlyableArea() and #favoriteUsable > 0 then
        local randomMount = favoriteUsable[math.random(#favoriteUsable)]
        C_MountJournal.SummonByID(randomMount.mountID)
    end

    if IsFlyableArea() and #favoriteFlying > 0 then -- Can use flying mount
        local randomMount = favoriteFlying[math.random(#favoriteFlying)]
        C_MountJournal.SummonByID(randomMount.mountID)
    elseif #favoriteUsable > 0 then -- Can use any mount
        local randomMount = favoriteUsable[math.random(#favoriteUsable)]
        C_MountJournal.SummonByID(randomMount.mountID)
    end
end

-- Expose the MountUpFavorites table globally
_G.MountUpFavorites = MountUpFavorites