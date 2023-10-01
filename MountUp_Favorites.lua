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
    local favoritUsable = {} -- all usable favorite mounts
    local favoritDragonRiding = {} -- all usable favorite dragon riding mounts
    local favoritFlying = {} -- all usable favorite flying mounts

    -- Determine all of the usable favorite mounts
    for _, mountID in ipairs(favorites) do
        local _, _, _, _, isUsable = C_MountJournal.GetMountInfoByID(mountID)
        if isUsable then
            table.insert(favoritUsable, {mountID = mountID})
        end
    end

    -- Determine all of the usable favorite dragon riding and flying mounts
    for _, mountData in ipairs(favoritUsable) do
        local _, _, _, _, mountTypeID, _, _, _ = C_MountJournal.GetMountInfoExtraByID(mountData.mountID)
        if mountTypeID == 402 then -- Is dragon riding mount
            table.insert(favoritDragonRiding, {mountID = mountData.mountID})
        elseif mountTypeID == 248 or mountTypeID == 424 then -- Is flying mount
            table.insert(favoritFlying, {mountID = mountData.mountID})
        end
    end

    if IsUsableSpell(368896) and #favoritDragonRiding > 0 then -- Can use dragon riding mount
        local randomIndex = math.random(1, #favoritDragonRiding)
        local randomMountID = favoritDragonRiding[randomIndex].mountID
        C_MountJournal.SummonByID(randomMountID)
    elseif IsFlyableArea() and #favoritFlying > 0 then -- Can use flying mount
        local randomIndex = math.random(1, #favoritFlying)
        local randomMountID = favoritFlying[randomIndex].mountID
        C_MountJournal.SummonByID(randomMountID)
    elseif #favoritUsable > 0 then -- Can use any mount
        local randomIndex = math.random(1, #favoritUsable)
        local randomMountID = favoritUsable[randomIndex].mountID
        C_MountJournal.SummonByID(randomMountID)
    else -- No usable favorite mounts
        print("No usable favorite mounts available.")
    end
end

-- Expose the MountUpFavorites table globally
_G.MountUpFavorites = MountUpFavorites