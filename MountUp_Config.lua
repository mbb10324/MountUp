local name = ... or "MountUp";
---@class MountUp : AceAddon
local MountUp = LibStub("AceAddon-3.0"):NewAddon(name, "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0");
if not MountUp then return; end

local allMountIDs = C_MountJournal.GetMountIDs() -- Get all mounts in player's collection
local allOwnedMounts = {}
_G.MountUpAllMountIDs = allMountIDs

local count = 1
local function increment()
    count = count + 1
    return count
end

function MountUp:GetOptions()
    if self.options then return self.options end 
    local options = {
        type = "group",
        childGroups = "tab",
        args = {
            optionsTab = {
                order = increment(),
                name = "Info",
                type = "group",
                args = {
                    description1 = {
                        order = increment(),
                        type = "description",
                        name = "|cFFFFD100The MountUp addon provides various methods for summoning mounts, including random mounts, favorites, and more.|r",
                        fontSize = "large",
                    },
                    spacer1 = {
                        order = increment(),
                        type = "description",
                        name = " ",
                        fontSize = "large",
                    },
                    description2 = {
                        order = increment(),
                        type = "description",
                        name = "|cFFFFD100/MountUp|r - Summon a random mount based off zone priority. If your in a dragon riding zone, you will mount on a random dragon riding mount, if your in a flying zone, you will mount on a random flying mount, and if your in a ground zone, you will mount on a random ground or flying mount.",
                    },
                    spacer2 = {
                        order = increment(),
                        type = "description",
                        name = " ",
                        fontSize = "large",
                    },
                    description3 = {
                        order = increment(),
                        type = "description",
                        name = "|cFFFFD100/MountUpFav|r - Summon a random favorite mount with zone priority. Select your favorites from the tab above. Favorites are saved by profile, so you can have unique favorites for each character, or just multiple different set ups.",
                    },
                    spacer3 = {
                        order = increment(),
                        type = "description",
                        name = " ",
                        fontSize = "large",
                    },
                    description4 = {
                        order = increment(),
                        type = "description",
                        name = "|cFFFFD100/MountUpFlying|r - Summon a random flying mount.",
                    },
                    spacer4 = {
                        order = increment(),
                        type = "description",
                        name = " ",
                        fontSize = "large",
                    },
                    description5 = {
                        order = increment(),
                        type = "description",
                        name = "|cFFFFD100/MountUpGround|r - Summon a random ground mount.",
                    },
                    spacer5 = {
                        order = increment(),
                        type = "description",
                        name = " ",
                        fontSize = "large",
                    },
                    description6 = {
                        order = increment(),
                        type = "description",
                        name = "|cFFFFD100/MountUpRandom|r - Summon a random usable mount.",
                    },
                    spacer6 = {
                        order = increment(),
                        type = "description",
                        name = " ",
                        fontSize = "large", 
                    },
                    description7 = {
                        order = increment(),
                        type = "description",
                        name = "|cFFFFD100/MountUpDragon|r - Summon a random dragon riding mount.",
                    },
                    spacer7 = {
                        order = increment(),
                        type = "description",
                        name = " ",
                        fontSize = "large", 
                    },
                    description8 = {
                        order = increment(),
                        type = "description",
                        name = "|cFFFFD100/MountUpOptions|r - Opens the options menu for MountUp. (What your seeing now)",
                    },
                    spacer8 = {
                        order = increment(),
                        type = "description",
                        name = " ",
                        fontSize = "large", 
                    },
                    description9 = {
                        order = increment(),
                        type = "description",
                        name = "|cFFFFD100/MountUpHelp|r - Prints all of the avaliable MountUp commands to the chat window.",
                    },
                    spacer9 = {
                        order = increment(),
                        type = "description",
                        name = " ",
                        fontSize = "large", 
                    },
                    description10 = {
                        order = increment(),
                        type = "description",
                        name = "You can set up macros to turn these slash commands into usable buttons on your action bar! The process is simple, just follow the steps below.",
                        fontSize = "large", 
                    },
                    description11 = {
                        order = increment(),
                        type = "description",
                        name = "From the 'Game Menu' click on 'Macros'. Next click 'New'. Then give the macro a name, choose an icon, and press 'Okay'. In the 'Enter Macro Commands' window; paste the slash command you want to use from above. Click 'save', and your macro is complete! Finally, drag the macro to your action bar.", 
                    },
                },
            },
            favoritesTab = {
                order = increment(),
                name = "Favorites",
                type = "group",
                args = {
                    searchBox = {
                        order = 1,
                        type = "input",
                        name = "Search",
                        desc = "Search for a mount",
                        get = function() return "" end, -- Return empty string, as this will be overwritten by user input
                        set = function(_, value) MountUp:FilterMounts(value) end, -- Calls function to filter mounts
                        width = "full",
                    },
                    showAll = {
                        order = 2,
                        type = "execute",
                        name = "Show All",
                        desc = "Show all of the mounts in your collection",
                        func = function() MountUp:ShowAll() end,
                    },
                    showFavorites = {
                        order = 3,
                        type = "execute",
                        name = "Show Favorites",
                        desc = "Show only your favorite mounts",
                        func = function() MountUp:ShowFavorites() end,
                    },
                    totalMounts = {
                        order = 4,
                        type = "description",
                        name = function() return "You own " .. #allOwnedMounts .. " mounts! Search through them, and select your favorites. Favorites are saved by profile, and can be summoned using /MountUpFav." end,
                    },
                },
            },
        },
    }
    self.options = options
    return options
end

function MountUp:FilterMounts(searchQuery)
    searchQuery = searchQuery:lower()

    local options = self.options
    local noResultsFound = true

    for _, mountInfo in ipairs(allOwnedMounts) do
        local creatureName = mountInfo.name
        local mountID = mountInfo.mountID
        local key = "mount_"..mountID
        
        if searchQuery == "" or creatureName:lower():find(searchQuery) then
            if options.args.favoritesTab.args[key] then
                options.args.favoritesTab.args[key].hidden = false
                noResultsFound = false
            end
        else
            if options.args.favoritesTab.args[key] then
                options.args.favoritesTab.args[key].hidden = true
            end
        end
    end

    if noResultsFound then
        options.args.favoritesTab.args.noResults = {
            type = "description",
            name = "No results found",
            order = increment() + 4
        }
    end
end

function MountUp:ShowAll()
    local options = self.options
    if options and options.controls and options.controls.searchBox then
        options.controls.searchBox:SetText("")
    end
    MountUp:FilterMounts("")
end

function MountUp:ShowFavorites()
    local options = self.options
    if options and options.controls and options.controls.searchBox then
        options.controls.searchBox:SetText("")
    end
    MountUp:FilterMounts("")
    for _, mountInfo in ipairs(allOwnedMounts) do
        local mountID = mountInfo.mountID
        local key = "mount_"..mountID

        -- Hide the mount if it's not a favorite
        if not MountUpFavorites:IsFavorite(mountID) and options.args.favoritesTab.args[key] then
            options.args.favoritesTab.args[key].hidden = true
        end
    end
end

local defaults = {
    profile = {
        favorites = {}
    }
}


function MountUp:OnInitialize()
    local frame = CreateFrame("FRAME", "SavedVarsFrame");
    frame:RegisterEvent("PLAYER_LOGIN")
    frame:SetScript("OnEvent", function(self, event, arg1)
        self:UnregisterEvent("PLAYER_LOGIN")
        MountUp.db = LibStub("AceDB-3.0"):New("MountUpDB", defaults, true)
        MountUp.db.RegisterCallback(MountUp, "OnProfileChanged", "OnProfileChanged")
        local profileName = MountUp.db.keys.profile
        print("|cFFFF69B4MountUp profile successfully loaded: " .. profileName .. "|r")
        print("|cFFFF69B4Use /MountUpHelp for a list of available commands.|r")
        local options = MountUp:GetOptions()
        for _, mountID in ipairs(allMountIDs) do
            local creatureName, _, _, _, _, _, _, _, _, _, isCollected, _ = C_MountJournal.GetMountInfoByID(mountID)
            if isCollected then
                local key = "mount_"..mountID
                table.insert(allOwnedMounts, {name = creatureName, mountID = mountID})
                options.args.favoritesTab.args[key] = {
                    type = "toggle",
                    name = creatureName,
                    desc = "Add this mount to favorites",
                    order = increment() + 4,
                    get = function() return MountUpFavorites:IsFavorite(mountID) end,
                    set = function(_, value) MountUpFavorites:SetFavorite(mountID, value) end,
                    hidden = false
                }
            end
        end
        options.args.profiles = LibStub("AceDBOptions-3.0"):GetOptionsTable(MountUp.db)
        LibStub("AceConfig-3.0"):RegisterOptionsTable("MountUp", options)
        self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("MountUp", "MountUp")
    end)   
end

function MountUp:OnProfileChanged(event, database, newProfileKey)
    local profileName = database.keys.profile
    print("|cFFFF69B4MountUp profile successfully loaded: " .. profileName .. "|r")
end

-- local f = CreateFrame("Frame")
-- f:RegisterEvent("PLAYER_LOGIN")
-- f:SetScript("OnEvent", function(f, event)
--     if event == "PLAYER_LOGIN" then
--         local profileName = MountUp.db.keys.profile
--         print("|cFFFF69B4MountUp profile successfully loaded: " .. profileName .. "|r")
--         print("|cFFFF69B4Use /MountUpHelp for a list of available commands.|r")
--     end
-- end)


SLASH_MountUpOptions1 = "/MountUpOptions"
SlashCmdList["MountUpOptions"] = function() 
    InterfaceOptionsFrame_OpenToCategory("MountUp")
    InterfaceOptionsFrame_OpenToCategory("MountUp")
end

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


