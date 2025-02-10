print("[FSF-C] Loading Config GUI")

getgenv().SecureMode = true
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local data = loadstring(game:HttpGet("https://raw.githubusercontent.com/P3nguinMinecraft/FischScripts/main/fsf-data.lua"))()

if not isfile("FischServerFinder/config.json") then
    if not isfolder("FischServerFinder") then
        makefolder("FischServerFinder")
    end
    writefile("FischServerFinder/config.json", game:GetService("HttpService"):JSONEncode(data.defaultConfig))
end
local config = game:GetService("HttpService"):JSONDecode(readfile("FischServerFinder/config.json"))

local function saveConfig()
    local encode = game:GetService("HttpService"):JSONEncode(config)
    writefile("FischServerFinder/config.json", encode)
end

local function dropdownconvert(list, options)
    for _, thing in ipairs(list) do
        thing.enabled = false
    end
    for _, option in ipairs(options) do
        for __, thing in ipairs(list) do
            if option == thing.name then
                thing.enabled = true
            end
        end
    end
    saveConfig()
end
    
local function dropdownsetup(list, dropdown)
    local allThing = {}
    local selectedThing = {}
    
    for _, thing in ipairs(list) do
        table.insert(allThing, thing.name)
        if thing.enabled then
            table.insert(selectedThing, thing.name)
        end
    end
    dropdown:Refresh(allThing)
    dropdown:Set(selectedThing)
end

local Window = Rayfield:CreateWindow({
    Name = "FischServerFinder - Penguin " .. data.version,
    Icon = 0,
    LoadingTitle = "FischServerFinder Config GUI",
    LoadingSubtitle = "by Penguin",
    Theme = "Default",
 
    DisableRayfieldPrompts = false,
    DisableBuildWarnings = false,

    ConfigurationSaving = {
       Enabled = false,
       FolderName = "FischServerFinder",
       FileName = "config"
    },
 
    Discord = {
       Enabled = false,
       Invite = "noinvitelink",
       RememberJoins = false,
    },
 
    KeySystem = false,
    KeySettings = {
       Title = "Untitled",
       Subtitle = "Key System",
       Note = "No method of obtaining the key is provided",
       FileName = "Key",
       SaveKey = true,
       GrabKeyFromSite = false,
       Key = {"Hello"}
    }
})

local HomeTab = Window:CreateTab("Home", nil)

local HomeLabel1 = HomeTab:CreateLabel("Config GUI for FischServerFinder")

local HomeLabel2 = HomeTab:CreateLabel("Explore the various Tabs to change configs!")

local HomeButton1 = HomeTab:CreateButton({
    Name = "Close GUI (Destroy)",
    Callback = function()
        Rayfield:Destroy()
    end,
})

local ScriptTab = Window:CreateTab("Script Config", nil)

local ScriptParagraph1 = ScriptTab:CreateParagraph({Title = "Auto Scan", Content = "Automatically scans the server for desired features on join"})

local ScriptToggle1 = ScriptTab:CreateToggle({
    Name = "Auto Scan",
    CurrentValue = config.autoscan,
    Flag = "ScriptToggle1",
    Callback = function(Value)
        config.autoscan = Value
        saveConfig()
    end,
})

local ScriptDivider1 = ScriptTab:CreateDivider()

local ScriptParagraph2 = ScriptTab:CreateParagraph({Title = "Auto Hop", Content = "Automatically serverhops if the current server has nothing desirable"})

local ScriptToggle2 = ScriptTab:CreateToggle({
    Name = "Auto Hop",
    CurrentValue = config.autohop,
    Flag = "ScriptToggle2",
    Callback = function(Value)
        config.autohop = Value
        saveConfig()
    end,
})

local ScriptDivider2 = ScriptTab:CreateDivider()

local ScriptParagraph3 = ScriptTab:CreateParagraph({Title = "Auto Webhook", Content = "Automatically sends a webhook to the URL below with all features on join"})

local ScriptToggle3 = ScriptTab:CreateToggle({
    Name = "Auto Webhook",
    CurrentValue = config.autowebhook,
    Flag = "ScriptToggle3",
    Callback = function(Value)
        config.autowebhook = Value
        saveConfig()
    end,
})

local ScriptInput1 = ScriptTab:CreateInput({
    Name = "Webhook Url",
    CurrentValue = config.webhookUrl,
    PlaceholderText = "discord.com/api/webhooks/#/#",
    RemoveTextAfterFocusLost = false,
    Flag = "ScriptInput1",
    Callback = function(Text)
        config.webhookUrl = Text
        saveConfig()
    end,
})

local ScriptDivider3 = ScriptTab:CreateDivider()

local ScriptParagraph4 = ScriptTab:CreateParagraph({Title = "Servers Filename", Content = "The script caches servers to serverhop to if the Roblox API is down. The name of file is [FischServerFinder > '{filename}.json']"})

local resetFilename

local ScriptInput2 = ScriptTab:CreateInput({
    Name = "Servers Filename",
    CurrentValue = config.filename,
    PlaceholderText = "{filename}.json",
    RemoveTextAfterFocusLost = false,
    Flag = "ScriptInput2",
    Callback = function(Text)
        if not Text == "" then
            config.filename = Text
            saveConfig()
        else
            Rayfield:Notify({
                Title = "Servers Filename",
                Content = "The name cannot be blank!",
                Duration = 5,
                Image = nil,
            })
            resetFilename()
        end
    end,
})

resetFilename = function()
    ScriptInput2:Set(config.filename)
end

local ScriptDivider4 = ScriptTab:CreateDivider()

local ScriptSection1 = ScriptTab:CreateSection("Auto Display")

local ScriptParagraph5 = ScriptTab:CreateParagraph({Title = "Auto Uptime", Content = "Automatically displays the server's uptime when you scan"})

local ScriptToggle4 = ScriptTab:CreateToggle({
    Name = "Auto Uptime",
    CurrentValue = config.infoList.autouptime,
    Flag = "ScriptToggle4",
    Callback = function(Value)
        config.infoList.autouptime = Value
        saveConfig()
    end,
})

local ScriptDivider5 = ScriptTab:CreateDivider()

local ScriptParagraph6 = ScriptTab:CreateParagraph({Title = "Auto Webhook", Content = "Automatically displays the server's ingame Fisch version when you scan"})

local ScriptToggle5 = ScriptTab:CreateToggle({
    Name = "Auto Version",
    CurrentValue = config.infoList.autoversion,
    Flag = "ScriptToggle5",
    Callback = function(Value)
        config.infoList.autoversion = Value
        saveConfig()
    end,
})

local ScriptDivider6 = ScriptTab:CreateDivider()

local ScriptParagraph7 = ScriptTab:CreateParagraph({Title = "Auto Webhook", Content = "Automatically displays the server's Roblox PlaceVersion when you scan"})

local ScriptToggle6 = ScriptTab:CreateToggle({
    Name = "Auto PlaceVersion",
    CurrentValue = config.infoList.autoplaceversion,
    Flag = "ScriptToggle6",
    Callback = function(Value)
        config.infoList.autoplaceversion = Value
        saveConfig()
    end,
})

local ServerTab = Window:CreateTab("Server Config", nil)

local ServerParagraph1 = ServerTab:CreateParagraph({Title = "Weather", Content = "Select weathers that are desirable"})

local ServerDropdown1 = ServerTab:CreateDropdown({
    Name = "Weather",
    Options = {},
    CurrentOption = {},
    MultipleOptions = true,
    Flag = "ServerDropdown1",
    Callback = function(Options)
        dropdownconvert(config.weatherList, Options)
    end,
})

dropdownsetup(config.weatherList, ServerDropdown1)

local ServerDivider1 = ServerTab:CreateDivider()

local ServerParagraph2 = ServerTab:CreateParagraph({Title = "Events", Content = "Select events that are desirable"})

local ServerDropdown2 = ServerTab:CreateDropdown({
    Name = "Events",
    Options = {},
    CurrentOption = {},
    MultipleOptions = true,
    Flag = "ServerDropdown2",
    Callback = function(Options)
        dropdownconvert(config.eventList, Options)
    end,
})

dropdownsetup(config.eventList, ServerDropdown2)

local ServerDivider2 = ServerTab:CreateDivider()

local ServerParagraph3 = ServerTab:CreateParagraph({Title = "Seasons", Content = "Select seasons that are desirable"})

local ServerDropdown3 = ServerTab:CreateDropdown({
    Name = "Season",
    Options = {},
    CurrentOption = {},
    MultipleOptions = true,
    Flag = "ServerDropdown3",
    Callback = function(Options)
        dropdownconvert(config.seasonList, Options)
    end,
})

dropdownsetup(config.seasonList, ServerDropdown3)

local ServerDivider3 = ServerTab:CreateDivider()

local ServerParagraph4 = ServerTab:CreateParagraph({Title = "Daytime Cycle", Content = "Select daytime cycles that are desirable"})

local ServerDropdown4 = ServerTab:CreateDropdown({
    Name = "Daytime Cycle",
    Options = {},
    CurrentOption = {},
    MultipleOptions = true,
    Flag = "ServerDropdown4",
    Callback = function(Options)
        dropdownconvert(config.cycleList, Options)
    end,
})

dropdownsetup(config.cycleList, ServerDropdown4)

local ServerDivider4 = ServerTab:CreateDivider()

local ServerParagraph5 = ServerTab:CreateParagraph({Title = "Server Luck", Content = "Toggle and select minimum amount of server luck desired (Robux Luck Multiplier)"})

local ServerToggle1 = ServerTab:CreateToggle({
    Name = "Luck Toggle",
    CurrentValue = config.luckList.enabled,
    Flag = "ServerToggle1",
    Callback = function(Value)
        config.luckList.enabled = Value
        saveConfig()
    end,
})

local resetLuckMin

local ServerInput1 = ServerTab:CreateInput({
    Name = "Minimum Multiplier",
    CurrentValue = config.luckList.min,
    PlaceholderText = "",
    RemoveTextAfterFocusLost = false,
    Flag = "ServerInput1",
    Callback = function(Text)
        if tonumber(Text) and tonumber(Text) > 0 then
            config.filename = tonumber(Text)
            saveConfig()
        else
            Rayfield:Notify({
                Title = "Minimum Multiplier",
                Content = "The input has to be a positive integer!",
                Duration = 5,
                Image = nil,
            })
            resetLuckMin()
        end
    end,
})

resetLuckMin = function()
    ServerInput1:Set(config.luckList.min)
end

local ServerDivider5 = ServerTab:CreateDivider()

local ServerParagraph6 = ServerTab:CreateParagraph({Title = "Server Version", Content = "Toggle and select the desired ingame Fisch version in the form x.x.x"})

local ServerToggle2 = ServerTab:CreateToggle({
    Name = "Version Toggle",
    CurrentValue = config.versionList.enabled,
    Flag = "ServerToggle2",
    Callback = function(Value)
        config.luckList.enabled = Value
        saveConfig()
    end,
})

local ServerInput2 = ServerTab:CreateInput({
    Name = "Version",
    CurrentValue = config.versionList.version,
    PlaceholderText = "x.x.x",
    RemoveTextAfterFocusLost = false,
    Flag = "ServerInput2",
    Callback = function(Text)
        config.versionList.version = Text
    end,
})

local ServerDivider6 = ServerTab:CreateDivider()

local ServerParagraph7 = ServerTab:CreateParagraph({Title = "PlaceVersion", Content = "Toggle and select the desired Roblox PlaceVersion (game.PlaceVersion)"})

local ServerToggle3 = ServerTab:CreateToggle({
    Name = "PlaceVersion Toggle",
    CurrentValue = config.placeVersionList.enabled,
    Flag = "ServerToggle3",
    Callback = function(Value)
        config.placeVersionList.enabled = Value
        saveConfig()
    end,
})

local resetPlaceVersion

local ServerInput3 = ServerTab:CreateInput({
    Name = "PlaceVersion",
    CurrentValue = config.placeVersionList.version,
    PlaceholderText = "1234",
    RemoveTextAfterFocusLost = false,
    Flag = "ServerInput3",
    Callback = function(Text)
        if tonumber(Text) and tonumber(Text) > 0 then
            config.placeVersionList.version = tonumber(Text)
            saveConfig()
        else
            Rayfield:Notify({
                Title = "PlaceVersion",
                Content = "The input has to be a positive integer!",
                Duration = 5,
                Image = nil,
            })
            resetPlaceVersion()
        end
    end,
})

resetPlaceVersion = function()
    ServerInput3:Set(config.placeVersionList.version)
end

local ServerDivider7 = ServerTab:CreateDivider()

local ServerSection1 = ServerTab:CreateSection("Uptime Search")

local ServerParagraph8 = ServerTab:CreateParagraph({Title = "Before Time", Content = "Desirable server if the uptime is less than the amount below (summed)"})

local ServerToggle4 = ServerTab:CreateToggle({
    Name = "Before Time - Toggle",
    CurrentValue = config.uptimeList.beforeTime.enabled,
    Flag = "ServerToggle4",
    Callback = function(Value)
        config.uptimeList.beforeTime.enabled = Value
        saveConfig()
    end,
})

local resetBHour

local ServerInput4 = ServerTab:CreateInput({
    Name = "Before Time - Hour",
    CurrentValue = config.uptimeList.beforeTime.hour,
    PlaceholderText = "x hours",
    RemoveTextAfterFocusLost = false,
    Flag = "ServerInput4",
    Callback = function(Text)
        if tonumber(Text) and tonumber(Text) >= 0 then
            config.uptimeList.beforeTime.hour = tonumber(Text)
            saveConfig()
        else
            Rayfield:Notify({
                Title = "Before Time - Hour",
                Content = "The input has to be a valid integer!",
                Duration = 5,
                Image = nil,
            })
            resetBHour()
        end
    end,
})

resetBHour = function()
    ServerInput4:Set(config.uptimeList.beforeTime.hour)
end

local resetBMin

local ServerInput5 = ServerTab:CreateInput({
    Name = "Before Time - Min",
    CurrentValue = config.uptimeList.beforeTime.min,
    PlaceholderText = "x mins",
    RemoveTextAfterFocusLost = false,
    Flag = "ServerInput5",
    Callback = function(Text)
        if tonumber(Text) and tonumber(Text) >= 0 then
            config.uptimeList.beforeTime.min = tonumber(Text)
            saveConfig()
        else
            Rayfield:Notify({
                Title = "Before Time - Min",
                Content = "The input has to be a valid integer!",
                Duration = 5,
                Image = nil,
            })
            resetBMin()
        end
    end,
})

resetBMin = function()
    ServerInput5:Set(config.uptimeList.beforeTime.min)
end

local ServerDivider8 = ServerTab:CreateDivider()

local ServerParagraph9 = ServerTab:CreateParagraph({Title = "After Time", Content = "Desirable server if the uptime is more than the amount below (summed)"})

local ServerToggle5 = ServerTab:CreateToggle({
    Name = "After Time - Toggle",
    CurrentValue = config.uptimeList.afterTime.enabled,
    Flag = "ServerToggle5",
    Callback = function(Value)
        config.uptimeList.afterTime.enabled = Value
        saveConfig()
    end,
})

local resetAHour

local ServerInput6 = ServerTab:CreateInput({
    Name = "After Time - Hour",
    CurrentValue = config.uptimeList.afterTime.hour,
    PlaceholderText = "x hours",
    RemoveTextAfterFocusLost = false,
    Flag = "ServerInput6",
    Callback = function(Text)
        if tonumber(Text) and tonumber(Text) >= 0 then
            config.uptimeList.afterTime.hour = tonumber(Text)
            saveConfig()
        else
            Rayfield:Notify({
                Title = "After Time - Hour",
                Content = "The input has to be a valid integer!",
                Duration = 5,
                Image = nil,
            })
            resetAHour()
        end
    end,
})

resetAHour = function()
    ServerInput6:Set(config.uptimeList.afterTime.hour)
end

local resetAMin

local ServerInput7 = ServerTab:CreateInput({
    Name = "After Time - Min",
    CurrentValue = config.uptimeList.afterTime.min,
    PlaceholderText = "x mins",
    RemoveTextAfterFocusLost = false,
    Flag = "ServerInput7",
    Callback = function(Text)
        if tonumber(Text) and tonumber(Text) >= 0 then
            config.uptimeList.afterTime.min = tonumber(Text)
            saveConfig()
        else
            Rayfield:Notify({
                Title = "After Time - Min",
                Content = "The input has to be a valid integer!",
                Duration = 5,
                Image = nil,
            })
            resetAMin()
        end
    end,
})

resetAMin = function()
    ServerInput7:Set(config.uptimeList.afterTime.min)
end

local ServerDivider9 = ServerTab:CreateDivider()

local ServerParagraph10 = ServerTab:CreateParagraph({Title = "Or Logic", Content = "If Or Logic is on, server is desired if EITHER Before or After is satisfied. If Or Logic is off, BOTH Before and After must be satisfied (used if you need between 2 uptimes)"})

local ServerToggle6 = ServerTab:CreateToggle({
    Name = "Or Logic",
    CurrentValue = config.uptimeList.orLogic,
    Flag = "ServerToggle6",
    Callback = function(Value)
        config.uptimeList.orLogic = Value
        saveConfig()
    end,
})

local ServerDivider19 = ServerTab:CreateDivider()

local EventsTab = Window:CreateTab("Events Config", nil)

local EventsParagraph1 = EventsTab:CreateParagraph({Title = "Fishing Zones", Content = "Select the Fishing/Event Zones that are desired"})

local EventsDropdown1 = EventsTab:CreateDropdown({
    Name = "Zones",
    Options = {},
    CurrentOption = {},
    MultipleOptions = true,
    Flag = "EventsDropdown1",
    Callback = function(Options)
        dropdownconvert(config.zoneList, Options)
    end,
})

dropdownsetup(config.zoneList, EventsDropdown1)

local EventsParagraph2 = EventsTab:CreateParagraph({Title = "Meteor Items", Content = "Select the Meteor Items that are desired"})

local EventsDropdown2 = EventsTab:CreateDropdown({
    Name = "Meteor Items",
    Options = {},
    CurrentOption = {},
    MultipleOptions = true,
    Flag = "EventsDropdown2",
    Callback = function(Options)
        dropdownconvert(config.meteorList, Options)
    end,
})

dropdownsetup(config.meteorList, EventsDropdown2)

local sunkenSet

local EventsSection1 = EventsTab:CreateSection("Sunken Chests")

local EventsParagraph3 = EventsTab:CreateParagraph({Title = "Sunken Chest Toggle", Content = "Global toggle for all Sunken Chest features"})

local EventsToggle1 = EventsTab:CreateToggle({
    Name = "Sunken Chest Toggle",
    CurrentValue = config.sunkenchestList.enabled,
    Flag = "EventsToggle1",
    Callback = function(Value)
        if not Value then
            sunkenSet(2, false)
            sunkenSet(3, false)
            sunkenSet(4, false)
            sunkenSet(5, false)
        end
        config.sunkenchestList.enabled = Value
        saveConfig()
    end,
})

local EventsParagraph4 = EventsTab:CreateParagraph({Title = "Buffer Before", Content = "A server will be desirable x minutes before chests spawn"})

local EventsSlider1 = EventsTab:CreateSlider({
    Name = "Buffer Before",
    Range = {0, 20},
    Increment = 1,
    Suffix = "mins",
    CurrentValue = config.sunkenchestList.bufferbefore,
    Flag = "EventsSlider1",
    Callback = function(Value)
        config.sunkenchestList.bufferbefore = Value
        saveConfig()
    end,
})

local EventsParagraph5 = EventsTab:CreateParagraph({Title = "Alert on Load", Content = "Alerts you when sunken chests are loaded. Required for Auto Farm (Recommended)"})

local EventsToggle2 = EventsTab:CreateToggle({
    Name = "Alert on Load",
    CurrentValue = config.sunkenchestList.alertonload,
    Flag = "EventsToggle2",
    Callback = function(Value)
        if not Value and config.sunkenchestList.autofarm then
            Rayfield:Notify({
                Title = "Alert on Load",
                Content = "Alert on Load is required for Auto Farm!",
                Duration = 5,
                Image = nil,
            })
        elseif Value and not config.sunkenchestList.enabled then
            Rayfield:Notify({
                Title = "Alert on Load",
                Content = "Sunken Chest Toggle is off!",
                Duration = 5,
                Image = nil,
            })
        else
            config.sunkenchestList.alertonload = Value
            saveConfig()
        end
    end,
})

local EventsParagraph6 = EventsTab:CreateParagraph({Title = "Sunken Chest Hop After Claim", Content = "Automatically server hops after you claim the sunken chest"})

local EventsToggle3 = EventsTab:CreateToggle({
    Name = "Hop After Claim",
    CurrentValue = config.sunkenchestList.hopafterclaim,
    Flag = "EventsToggle3",
    Callback = function(Value)
        if Value and not config.sunkenchestList.enabled then
            Rayfield:Notify({
                Title = "Hop After Claim",
                Content = "Sunken Chest Toggle is off!",
                Duration = 5,
                Image = nil,
            })
        else
            config.sunkenchestList.hopafterclaim = Value
            saveConfig()
        end
    end,
})

local EventsParagraph7 = EventsTab:CreateParagraph({Title = "Sunken Chest Auto Farm", Content = "Automatically searches for and opens sunken chests when you join a server (Auto Hop is recommended)"})

local EventsToggle4 = EventsTab:CreateToggle({
    Name = "Auto Farm",
    CurrentValue = config.sunkenchestList.autofarm,
    Flag = "EventsToggle4",
    Callback = function(Value)
        if Value and not config.sunkenchestList.enabled then
            Rayfield:Notify({
                Title = "Auto Farm",
                Content = "Sunken Chest Toggle is off!",
                Duration = 5,
                Image = nil,
            })
        else
            if Value then
                sunkenSet(2, true)
            else
                sunkenSet(5, false)
            end
            config.sunkenchestList.autofarm = Value
            saveConfig()
        end
    end,
})

local EventsParagraph8 = EventsTab:CreateParagraph({Title = "Sunken Chest Force Hop", Content = "Server hops even if there are other desired features, requires Auto Farm (regardless of Auto Hop)"})

local EventsToggle5 = EventsTab:CreateToggle({
    Name = "Force Hop",
    CurrentValue = config.sunkenchestList.forcehop,
    Flag = "EventsToggle4",
    Callback = function(Value)
        if Value and not config.sunkenchestList.autofarm then
            Rayfield:Notify({
                Title = "Force Hop",
                Content = "Auto Farm is off!",
                Duration = 5,
                Image = nil,
            })
        else
            config.sunkenchestList.forcehop = Value
            saveConfig()
        end
    end,
})

sunkenSet = function(thing, value)
    local object
    if thing == 0 then
        object = EventsToggle1
    elseif thing == 1 then
        object = EventsSlider1
    elseif thing == 2 then
        object = EventsToggle2
    elseif thing == 3 then
        object = EventsToggle3
    elseif thing == 4 then
        object = EventsToggle4
    elseif thing == 5 then
        object = EventsToggle5
    end

    object:Set(value)
end


config.version = data.version
config.versid = data.versid

saveConfig()

print("[FSF-C] Loaded!")