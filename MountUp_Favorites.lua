local name = ... or "MountUp";
---@class MountUp : AceAddon
local MountUp = LibStub("AceAddon-3.0"):GetAddon(name);
if not MountUp then return; end

local MountUpFavorites = {}

function MountUpFavorites:IsFavorite(mountID)
    return MountUp.db.profile.favorites[mountID] or false
end

function MountUpFavorites:SetFavorite(mountID, value)
    MountUp.db.profile.favorites[mountID] = value or nil
end

function MountUpFavorites:GetFavorites()
    local favoritesList = {}
    for mountID, isFavorite in pairs(MountUp.db.profile.favorites) do
        if isFavorite then
            table.insert(favoritesList, mountID)
        end
    end
    return favoritesList
end

function MountUpFavorites:MountPlayerOnSuitableFavorite()
    local favorites = self:GetFavorites()
    local favoritUsable = {}
    local favoritDragonRiding = {}
    local favoritFlying = {}

    for _, mountID in ipairs(favorites) do
        local _, _, _, _, isUsable = C_MountJournal.GetMountInfoByID(mountID)
        if isUsable then
            table.insert(favoritUsable, {mountID = mountID})
        end
    end

    for _, mountData in ipairs(favoritUsable) do
        local _, _, _, _, mountTypeID, _, _, _ = C_MountJournal.GetMountInfoExtraByID(mountData.mountID)
        if mountTypeID == 402 then
            table.insert(favoritDragonRiding, {mountID = mountData.mountID})
        elseif mountTypeID == 248 or mountTypeID == 424 then
            table.insert(favoritFlying, {mountID = mountData.mountID})
        end
    end

    if IsUsableSpell(368896) and #favoritDragonRiding > 0 then -- Check if can use dragon riding mount
        local randomIndex = math.random(1, #favoritDragonRiding)
        local randomMountID = favoritDragonRiding[randomIndex].mountID
        C_MountJournal.SummonByID(randomMountID)
    elseif IsFlyableArea() and #favoritFlying > 0 then -- Check if can use flying mount
        local randomIndex = math.random(1, #favoritFlying)
        local randomMountID = favoritFlying[randomIndex].mountID
        C_MountJournal.SummonByID(randomMountID)
    elseif #favoritUsable > 0 then -- Check if can use any mount
        local randomIndex = math.random(1, #favoritUsable)
        local randomMountID = favoritUsable[randomIndex].mountID
        C_MountJournal.SummonByID(randomMountID)
    else
        print("No usable favorite mounts available.")
    end
end

_G.MountUpFavorites = MountUpFavorites

SLASH_MountUpFav1 = "/MountUpFav"
SlashCmdList["MountUpFav"] = function()
    MountUpFavorites:MountPlayerOnSuitableFavorite()
end