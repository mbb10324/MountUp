-------------------------------------------------------------------------------
-- Title: MountUp Configuration Settings
-- Order: 1
-- Author: Miles Breman
-- Description: This file sets up registration with Ace3, the options 
-- menu, and the initialization for MountUp.
-------------------------------------------------------------------------------

-- Register with Ace3
local name = ... or "MountUp";
---@class MountUp : AceAddon
local MountUp = LibStub("AceAddon-3.0"):NewAddon(name, "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0");
if not MountUp then return; end

-- Get all mount IDs in the game and store them in a global variable
local allMountIDs = C_MountJournal.GetMountIDs()
_G.MountUpAllMountIDs = allMountIDs -- Expose allMountIDs globally

-- Local Table to store all owned mounts
local allOwnedMounts = {}

-- Increment function for ordering options
local count = 1
local function increment()
    count = count + 1
    return count
end

-------------------------------------------------------------------------------
-- Build Options Menu Using Ace3 
-------------------------------------------------------------------------------

function MountUp:GetOptions()
    if self.options then return self.options end -- If options already exist, exit function
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
                        get = function() return "" end, -- Default to empty string
                        set = function(_, value) MountUp:FilterMounts(value) end, -- Calls function to filter mounts
                        width = "full",
                    },
                    showAll = {
                        order = 2,
                        type = "execute",
                        name = "Show All",
                        desc = "Show all of the mounts in your collection",
                        func = function() MountUp:ShowAll() end, -- Calls function to show all mounts
                    },
                    showFavorites = {
                        order = 3,
                        type = "execute",
                        name = "Show Favorites",
                        desc = "Show only your favorite mounts",
                        func = function() MountUp:ShowFavorites() end, -- Calls function to show only favorites
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

-------------------------------------------------------------------------------
-- Favorites tab helper functions 
-------------------------------------------------------------------------------

-- Filter mounts based on search query
function MountUp:FilterMounts(searchQuery)
    -- Set search query to lower case
    searchQuery = searchQuery:lower()

    -- Get options 
    local options = self.options

    -- Set no results found to true by default
    local noResultsFound = true

    -- Loop through all owned mounts
    for _, mountInfo in ipairs(allOwnedMounts) do
        local creatureName = mountInfo.name
        local mountID = mountInfo.mountID
        -- Set up a key for each mount
        local key = "mount_"..mountID
        
        if searchQuery == "" or creatureName:lower():find(searchQuery) then -- Match found
            if options.args.favoritesTab.args[key] then
                options.args.favoritesTab.args[key].hidden = false -- Show the matches
                noResultsFound = false -- We found a match, so set no results found to false
            end
        else -- Doesnt Match
            if options.args.favoritesTab.args[key] then 
                options.args.favoritesTab.args[key].hidden = true -- Hide non-matches
            end
        end
    end

    if noResultsFound then  
        -- If no results found, display a message
        options.args.favoritesTab.args.noResults = {
            type = "description",
            name = "No results found",
            order = increment() + 4,
            hidden = false
        }
    end

    if not noResultsFound and options.args.favoritesTab.args.noResults then
        options.args.favoritesTab.args.noResults.hidden = true -- Or use the appropriate method to remove the entry
    end
end

-- Show all mounts
function MountUp:ShowAll()
    local options = self.options
    if options and options.controls and options.controls.searchBox then
        options.controls.searchBox:SetText("") -- Clear search box
    end
    MountUp:FilterMounts("") -- Call the filter function with an empty string to show all mounts
end

-- Show only favorites
function MountUp:ShowFavorites()
    -- Start by showing all of the mounts to clear whatever state the user was in
    local options = self.options
    if options and options.controls and options.controls.searchBox then
        options.controls.searchBox:SetText("")
    end
    MountUp:FilterMounts("")
    -- Loop through all owned mounts
    for _, mountInfo in ipairs(allOwnedMounts) do
        local mountID = mountInfo.mountID
        -- Set up a key for each mount
        local key = "mount_"..mountID

        -- Hide the mount if it's not a favorite
        if not MountUpFavorites:IsFavorite(mountID) and options.args.favoritesTab.args[key] then
            options.args.favoritesTab.args[key].hidden = true
        end
    end
end

-- Update the owned mounts table and the favorites tab
function MountUp:UpdateOwnedMounts()
    wipe(allOwnedMounts) -- Clear the allOwnedMounts table
    local options = self.options -- Get the current options

    -- Loop through all mounts, and for each owned mount, add a toggle option to the favorites tab 
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
end

-------------------------------------------------------------------------------
-- Initialization function
-------------------------------------------------------------------------------

function MountUp:OnInitialize()
    -- Defined defaults for AceDB
    local defaults = {
        profile = {
            favorites = {}
        }
    }
    -- Player login event to fire our initializations 
    local frame = CreateFrame("FRAME", "SavedVarsFrame");
    local events = {
        "PLAYER_LOGIN",
        "NEW_MOUNT_ADDED",
    }
    for _, event in ipairs(events) do
        frame:RegisterEvent(event)
    end
    frame:SetScript("OnEvent", function(self, event, arg1)
        if event == "NEW_MOUNT_ADDED" then
            MountUp:UpdateOwnedMounts()
        elseif event == "PLAYER_LOGIN" then
            self:UnregisterEvent("PLAYER_LOGIN") -- Unregister the event so it doesn't fire again

            MountUp.db = LibStub("AceDB-3.0"):New("MountUpDB", defaults, true) -- Define the database using AceDB
            MountUp.db.RegisterCallback(MountUp, "OnProfileChanged", "OnProfileChanged") -- Register callback for profile changes

            -- Print the current profile name to the chat window on login
            local profileName = MountUp.db.keys.profile
            print("|cFFFF69B4MountUp profile successfully loaded: " .. profileName .. "|r")
            print("|cFFFF69B4Use /MountUpHelp for a list of available commands.|r")

            local options = MountUp:GetOptions() -- Get the options table
            MountUp:UpdateOwnedMounts() -- Update the owned mounts table

            -- Execute Ace3 to do the things
            if not self.optionsFrame then
                options.args.profiles = LibStub("AceDBOptions-3.0"):GetOptionsTable(MountUp.db) -- Add profile options
                LibStub("AceConfig-3.0"):RegisterOptionsTable("MountUp", options) -- Register options table
                self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("MountUp", "MountUp") -- Add options to blizzard options menu
            end
        end
    end)   
end

-- Callback function that was registered in the OnInitialize function to print a message when the profile is changed
function MountUp:OnProfileChanged(event, database, newProfileKey)
    local profileName = database.keys.profile
    print("|cFFFF69B4MountUp profile successfully loaded: " .. profileName .. "|r")
end