if not game:IsLoaded() then game.Loaded:Wait() end

if not writefile then print("You cannot change configs because your executor does not support files!") end

print("[FSF-G] Merging Config")

local data = loadstring(game:HttpGet("https://raw.githubusercontent.com/P3nguinMinecraft/FischScripts/main/fsf-data.lua"))()

if not isfile("FischServerFinder/config.json") and writefile then
    if not isfolder("FischServerFinder") then
        makefolder("FischServerFinder")
    end
    writefile("FischServerFinder/config.json", game:GetService("HttpService"):JSONEncode(data.defaultConfig))
end
local config
if isfile("FischServerFinder/config.json") then
    config = game:GetService("HttpService"):JSONDecode(readfile("FischServerFinder/config.json"))
else
    config = data.defaultConfig
end

local function saveConfig()
    if not writefile then return end
    local encode = game:GetService("HttpService"):JSONEncode(config)
    writefile("FischServerFinder/config.json", encode)
end

local function updateTable(default, previous)
    local updated = {}
    for key, value in pairs(default) do
        if type(value) == "table" then
            updated[key] = updateTable(value, type(previous[key]) == "table" and previous[key] or {})
        elseif previous[key] ~= nil then
            updated[key] = previous[key]
        else
            updated[key] = value
        end
    end
    return updated
end

local function mergeConfig(default, conf)
    local result = updateTable(default, conf)
    result.version = data.version
    result.versid = data.versid
    return result
end

local function dropdownconvert(conf, listName, options)
    local list = conf[listName]
    for name, _ in pairs(list) do
        list[name] = false
        for _, optionName in ipairs(options) do
            if optionName == name then
                list[name] = true
                break
            end
        end
    end
end

local function dropdownsetup(conf, listName, dropdown)
    local allThing = {}
    local selectedThing = {}
    local list = conf[listName]
    local order = data.ordered[listName]

    for _, name in ipairs(order) do
        local enabled = list[name]
        table.insert(allThing, name)
        if enabled then
            table.insert(selectedThing, name)
        end
    end

    dropdown:Refresh(allThing)
    dropdown:Set(selectedThing)
end

local af_mod = loadstring(game:HttpGet("https://raw.githubusercontent.com/P3nguinMinecraft/FischScripts/main/obfusc/fsf-af.lua"))()

local fishConfig
if isfile("FischServerFinder/fishconfig.json") then
    fishConfig = game:GetService("HttpService"):JSONDecode(readfile("FischServerFinder/fishconfig.json"))
else
    fishConfig = data.defaultFishConfig
end

local afts = tick()
local function saveFishConfig()
    writefile("FischServerFinder/fishconfig.json", game:GetService("HttpService"):JSONEncode(fishConfig))
	if tick() - afts > 0.1 then
		af_mod.init()
		afts = tick()
	end
end

local guiConfig
if isfile("FischServerFinder/guiconfig.json") then
    guiConfig = game:GetService("HttpService"):JSONDecode(readfile("FischServerFinder/guiconfig.json"))
else
    guiConfig = data.defaultGuiConfig
end

local function saveGuiConfig()
    writefile("FischServerFinder/guiconfig.json", game:GetService("HttpService"):JSONEncode(guiConfig))
end

config = mergeConfig(data.defaultConfig, config)
saveConfig()
fishConfig = mergeConfig(data.defaultFishConfig, fishConfig)
saveFishConfig()
guiConfig = mergeConfig(data.defaultGuiConfig, guiConfig)
saveGuiConfig()

print("[FSF-G] Loading GUI")

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "FischServerFinder - Penguin " .. data.version,
    Icon = 0,
    LoadingTitle = "FischServerFinder GUI",
    LoadingSubtitle = "by Penguin",
    Theme = "Default",

    DisableRayfieldPrompts = false,
    DisableBuildWarnings = false,

    ConfigurationSaving = {
       Enabled = false,
       FolderName = "FischServerFinder",
       FileName = "rf_config"
    },

    Discord = {
       Enabled = true,
       Invite = "fWncS2vFx",
       RememberJoins = true,
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

local HomeLabel1 = HomeTab:CreateLabel("GUI for FischServerFinder")

local HomeLabel2 = HomeTab:CreateLabel("Explore the various Tabs to change configs!")

if not writefile then HomeLabel2:Set("You cannot change configs because your executor does not support files!") end

local HomeButton1 = HomeTab:CreateButton({
    Name = "Join discord (/fWncS2vFxn)",
    Callback = function()
        setclipboard(data.link)
        Rayfield:Notify({
            Title = "Discord",
            Content = data.link,
            Duration = 5,
            Image = nil,
        })
    end,
})

local HomeButton2 = HomeTab:CreateButton({
    Name = "Close GUI (Destroy)",
    Callback = function()
        Rayfield:Destroy()
    end,
})

local HomeButton3 = HomeTab:CreateButton({
    Name = "Load Main Script",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/P3nguinMinecraft/FischScripts/main/fischserverfinder.lua"))()
    end,
})

HomeTab:CreateDivider()

local zonecd = -1

local HomeButton4 = HomeTab:CreateButton({
    Name = "Send Zones",
    Callback = function()
        if tick() - zonecd > 60 then
            loadstring(game:HttpGet("https://raw.githubusercontent.com/P3nguinMinecraft/FischScripts/refs/heads/main/helper/sendzones.lua"))()
        else
            Rayfield:Notify({
                Title = "Send Zones",
                Content = "You can send again in " .. tostring(math.floor(tick() - zonecd)) .. " seconds!",
                Duration = 5,
                Image = nil,
            })
        end
    end,
})

local ToolsTab = Window:CreateTab("Tools", nil)

local ToolsButton1 = ToolsTab:CreateButton({
    Name = "Redeem Codes",
    Callback = function()
        for _, code in data.codes do
            game:GetService("ReplicatedStorage"):WaitForChild("events"):WaitForChild("runcode"):FireServer(code)
        end
    end,
})

local ToolsSection1 = ToolsTab:CreateSection("Rendering")

local ToolsButton2 = ToolsTab:CreateButton({
    Name = "Remove Fog (Permanent)",
    Callback = function()
        local Sky = game:GetService("Lighting"):FindFirstChild("Sky")
        if Sky then Sky:Destroy() end
    end,
})

local disablewater
local function disablewaterfunc()
    local blur = game:GetService("Lighting"):FindFirstChild("underwaterbl")
    local constrast =  game:GetService("Lighting"):FindFirstChild("underwatercc")
    blur.Enabled = false
    constrast.Enabled = false
end

local ToolsToggle1 = ToolsTab:CreateToggle({
    Name = "Disable Water Fog",
    CurrentValue = false,
    Flag = "ToolsToggle1",
    Callback = function(Value)
        guiConfig.disablewaterfog = Value
        saveGuiConfig()
        if Value then
            disablewater = game:GetService("RunService").RenderStepped:Connect(disablewaterfunc)
        else
            if not disablewater then return end
            disablewater:Disconnect()
            disablewater = nil
        end
    end,
})

ToolsToggle1:Set(guiConfig.disablewaterfog)

local fullbright

local function fullbrightfunc()
    local Lighting = game:GetService("Lighting")
    Lighting.Brightness = 2
    Lighting.ClockTime = 14
    Lighting.FogEnd = 100000
    Lighting.GlobalShadows = false
    Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
    Lighting.location.Brightness = 0
end

local ToolsToggle2 = ToolsTab:CreateToggle({
    Name = "Fullbright",
    CurrentValue = false,
    Flag = "ToolsToggle2",
    Callback = function(Value)
        guiConfig.fullbright = Value
        saveGuiConfig()
        if Value then
            fullbright = game:GetService("RunService").RenderStepped:Connect(fullbrightfunc)
        else
            if not fullbright then return end
            fullbright:Disconnect()
            fullbright = nil
        end
    end
})

ToolsToggle2:Set(guiConfig.fullbright)

local antigp

local ToolsToggle3 = ToolsTab:CreateToggle({
    Name = "Anti Game Paused",
    CurrentValue = false,
    Flag = "ToolsToggle3",
    Callback = function(Value)
        guiConfig.antigp = Value
        saveGuiConfig()
        if Value then
            antigp = game:GetService("RunService").RenderStepped:Connect(function()
                game:GetService("Players").LocalPlayer.GameplayPaused = false
            end)
        else
            if not antigp then return end
            antigp:Disconnect()
            antigp = nil
        end
    end,
})

ToolsToggle3:Set(guiConfig.antigp)

ToolsTab:CreateDivider()

local instantinteract

local ToolsToggle4 = ToolsTab:CreateToggle({
    Name = "Instant Interaction",
    CurrentValue = false,
    Flag = "ToolsToggle4",
    Callback = function(Value)
        guiConfig.instantinteract = Value
        saveGuiConfig()
        if Value then
            if fireproximityprompt then
                instantinteract = game:GetService("ProximityPromptService").PromptButtonHoldBegan:Connect(function(prompt)
                    pcall(function()
                        fireproximityprompt(prompt)
                    end)
                end)
            else
                Rayfield:Notify({
                    Title = "Instant Interaction",
                    Content = "Your executor does not support fireproximityprompt!",
                    Duration = 5,
                    Image = nil,
                })
            end
        else
            if not instantinteract then return end
            instantinteract:Disconnect()
            instantinteract = nil
        end
    end,
})

ToolsToggle4:Set(guiConfig.instantinteract)

local antiafk

local ToolsToggle5 = ToolsTab:CreateToggle({
    Name = "Disable AFK/Idle Kick",
    CurrentValue = false,
    Flag = "ToolsToggle5",
    Callback = function(Value)
        guiConfig.antiafk = Value
        saveGuiConfig()
        if Value then
            local VirtualUser = game:GetService("VirtualUser")
            antiafk = game:GetService("Players").LocalPlayer.Idled:Connect(function()
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new())
            end)
        else
            if not antiafk then return end
            antiafk:Disconnect()
            antiafk = nil
        end
    end,
})

ToolsToggle5:Set(guiConfig.antiafk)

local ServerTab = Window:CreateTab("Server", nil)

local function teleport(placeid)
    local TeleportService = game:GetService("TeleportService")
    local HttpService = game:GetService("HttpService")

    local Servers, Server, Next = nil, nil, nil
    local filename = "FischServerFinder/servers.json"

    if placeid ==  data.placeids.sea1 then
        filename = filename .. "1"
    else
        filename = filename .. "2"
    end


    local function ListServers(cursor)
        local ServersAPI = "https://games.roblox.com/v1/games/" .. tostring(placeid) .. "/servers/Public?sortOrder=Asc&limit=100&excludeFullGames=true"
        local Raw = game:HttpGet(ServersAPI .. ((cursor and "&cursor=" .. cursor) or ""))
        local Decode = HttpService:JSONDecode(Raw)

        if Decode.errors then
            if isfile(filename) then
                return HttpService:JSONDecode(readfile(filename))
            end
            return nil
        else
            if writefile then
                writefile(filename, Raw)
            end
            return HttpService:JSONDecode(Raw)
        end
    end

    local function RemoveServer(serverId)
        if not isfile(filename) then return end

        local Servers = HttpService:JSONDecode(readfile(filename))
        local NewData = {}
        for _, server in ipairs(Servers.data) do
            if server.id ~= serverId then
                table.insert(NewData, server)
            end
        end
        Servers.data = NewData
        writefile(filename, HttpService:JSONEncode(Servers))
    end

    while Server == nil do
        Servers = ListServers(Next)
        if not Servers.data then
            print("No available servers!")
            return
        end

        for _, s in ipairs(Servers.data) do
            if s.playing < s.maxPlayers
                and s.id ~= game.JobId
            then
                Server = s
                break
            end
        end

        if not Servers.nextPageCursor then
            print("No available servers!")
            return
        else
            Next = Servers.nextPageCursor
        end
    end

    if Server then
        RemoveServer(Server.id)
        TeleportService:TeleportToPlaceInstance(placeid, Server.id, game:GetService("Players").LocalPlayer)
    end
end

local ServerButton1 = ServerTab:CreateButton({
    Name = "Teleport to AFK Mine",
    Callback = function()
        if game.PlaceId ~= data.placeids.sea1 then
            Rayfield:Notify({
                Title = "Teleport to AFK Mine",
                Content = "You are not in Fisch First Sea!",
                Duration = 5,
                Image = nil,
            })
        end
        game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(233, 140, 38)
        firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, game.Workspace.world.map.Moosewood:WaitForChild("AfkTPBuild").TpPart, 0)
    end
})

local ServerButton2 = ServerTab:CreateButton({
    Name = "Teleport Between Seas",
    Callback = function()
        if game.PlaceId == data.placeids.sea1 then
            game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(138, 150, 2031)
        else
            game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(452, 84, 797)
        end
        game:GetService("Workspace").world.npcs:WaitForChild("Sea Traveler").seatraveler.teleport:InvokeServer()
    end,
})

local ServerParagraph1 = ServerTab:CreateParagraph({Title = "TP", Content = "Teleports to the given server. Prioritizes low player count and can be used for server hopping"})

local ServerButton3 = ServerTab:CreateButton({
    Name = "TP First Sea",
    Callback = function()
        teleport(data.placeids.sea1)
    end,
})

local ServerButton4 = ServerTab:CreateButton({
    Name = "TP Second Sea",
    Callback = function()
        teleport(data.placeids.sea2)
    end,
})

local PlayerTab = Window:CreateTab("Player", nil)

PlayerTab:CreateSection("Anti Death")

local function disabledeathscript(value, name)
    local resources = game:GetService("Players").LocalPlayer.Character.Resources
    local repl_resources = game:GetService("ReplicatedStorage").client.characterScripts.Resources
    local script = resources:FindFirstChild(name)
    if script then
       script:Destroy()
    end

    if not value then
        local clone = repl_resources:FindFirstChild(name):Clone()
        clone.Parent = resources
    end
end

local PlayerToggle1 = PlayerTab:CreateToggle({
    Name = "Disable Oxygen (Water)",
    CurrentValue = false,
    Flag = "PlayerToggle1",
    Callback = function(Value)
        guiConfig.disableoxygen = Value
        saveGuiConfig()
        disabledeathscript(Value, "oxygen")
    end,
})

PlayerToggle1:Set(guiConfig.disableoxygen)

local oxygenpeaks_script

local PlayerToggle2 = PlayerTab:CreateToggle({
    Name = "Disable Oxygen (Peaks)",
    CurrentValue = false,
    Flag = "PlayerToggle2",
    Callback = function(Value)
        guiConfig.disableoxygenpeaks = Value
        saveGuiConfig()
        disabledeathscript(Value, "oxygen(peaks)")
    end,
})

PlayerToggle2:Set(guiConfig.disableoxygenpeaks)

local temperaturepeaks_script

local PlayerToggle3 = PlayerTab:CreateToggle({
    Name = "Disable Temperature (Peaks)",
    CurrentValue = false,
    Flag = "PlayerToggle3",
    Callback = function(Value)
        guiConfig.disabletemperaturepeaks = Value
        saveGuiConfig()
        disabledeathscript(Value, "temperature")
    end,
})

PlayerToggle3:Set(guiConfig.disabletemperaturepeaks)

local temperatureveil_script

local PlayerToggle4 = PlayerTab:CreateToggle({
    Name = "Disable Temperature (Veil)",
    CurrentValue = false,
    Flag = "PlayerToggle4",
    Callback = function(Value)
        guiConfig.disabletemperatureveil = Value
        saveGuiConfig()
        disabledeathscript(Value, "temperature(heat)")
    end,
})

PlayerToggle4:Set(guiConfig.disabletemperatureveil)

local blocked = {
    [game:GetService("ReplicatedStorage").events.drown] = {"FireServer", guiConfig.disabledrownremote},
    [game:GetService("ReplicatedStorage"):WaitForChild("events"):WaitForChild("clientTakeDamage")] = {"FireServer", guiConfig.disableddamage}

    --[game:GetService("ReplicatedStorage").packages.Net.RE/GasAsphyxiated] = {"FireServer", false},
}

local oldmetamethod
oldmetamethod = hookmetamethod(game, "__namecall", function(self, ...)
    local calledmethod = getnamecallmethod()
    for method, methodinfo in pairs(blocked) do
        if self == method and calledmethod == methodinfo[1] and methodinfo[2] then return end
    end
    return oldmetamethod(self, ...)
end)

local PlayerToggle5 = PlayerTab:CreateToggle({
    Name = "Disable Drown Death",
    CurrentValue = false,
    Flag = "PlayerToggle5",
    Callback = function(Value)
        guiConfig.disabledrownremote = Value
        saveGuiConfig()
    end,
})

PlayerToggle5:Set(guiConfig.disabledrownremote)

local PlayerToggle6 = PlayerTab:CreateToggle({
    Name = "Disable Damage",
    CurrentValue = false,
    Flag = "PlayerToggle6",
    Callback = function(Value)
        guiConfig.disabledamage = Value
        saveGuiConfig()
    end,
})

PlayerToggle6:Set(guiConfig.disableddamage)

PlayerTab:CreateDivider()

local function modulefunc(file, funcs, disabled)
    local blankfunc = function() end
    local moduleScriptCloneFolder = game:GetService("ReplicatedStorage"):FindFirstChild("ModuleScriptClone")
    
    if not moduleScriptCloneFolder then
        moduleScriptCloneFolder = Instance.new("Folder")
        moduleScriptCloneFolder.Name = "ModuleScriptClone"
        moduleScriptCloneFolder.Parent = game:GetService("ReplicatedStorage")
    end
    
    local clonedFile = moduleScriptCloneFolder:FindFirstChild(file.Name)
    if not clonedFile then
        clonedFile = file:Clone()
        clonedFile.Parent = moduleScriptCloneFolder
    end
    
    local originalModule = require(file)
    
    if disabled then
        for _, func in funcs do
            originalModule[func] = blankfunc
        end
    else
        local parent = file.Parent
        file:Destroy()
        file = clonedFile:Clone()
        file.Parent = parent
    end
end

local PlayerToggle7 = PlayerTab:CreateToggle({
    Name = "Disable Cutscenes",
    CurrentValue = false,
    Flag = "PlayerToggle7",
    Callback = function(Value)
        guiConfig.disablecutscenes = Value
        saveGuiConfig()
        local controller = game:GetService("ReplicatedStorage").client.legacyControllers.CutsceneController
        modulefunc(controller, {"ShowBars", "Start", "DisableAllScreens", "StartCutscene", "Fade"}, Value)
    end,
})

PlayerToggle7:Set(guiConfig.disablecutscenes)

local PlayerToggle8 = PlayerTab:CreateToggle({
    Name = "Disable Vignette",
    CurrentValue = false,
    Flag = "PlayerToggle8",
    Callback = function(Value)
        guiConfig.disablevignette = Value
        saveGuiConfig()
        game:GetService("Players").LocalPlayer.PlayerGui.over.Enabled = not Value
    end,
})

PlayerToggle8:Set(guiConfig.disablevignette)

PlayerTab:CreateDivider()

local PlayerToggle9 = PlayerTab:CreateToggle({
    Name = "Anti Swim",
    CurrentValue = false,
    Flag = "PlayerToggle9",
    Callback = function(Value)
        guiConfig.antiswim = Value
        saveGuiConfig()
        if Value then
            task.spawn(function()
                while guiConfig.antiswim do
                    pcall(function()
                        game:GetService("Players").LocalPlayer.Character.Humanoid.PlatformStand = guiConfig.antiswim
                    end)
                    task.wait()
                end
            end)
        else
            pcall(function()
                game:GetService("Players").LocalPlayer.Character.Humanoid.PlatformStand = guiConfig.antiswim
            end)
        end
    end,
})

PlayerToggle9:Set(guiConfig.antiswim)

local function characteranchor(value)
    local character = game:GetService("Players").LocalPlayer.Character
    if not character then return end
    for _, x in ipairs(character:GetDescendants()) do
        if x:IsA("BasePart") and not x.Anchored == value then
            x.Anchored = value
        end
    end
end

local PlayerToggle10 = PlayerTab:CreateToggle({
    Name = "Freeze Character",
    CurrentValue = false,
    Flag = "PlayerToggle10",
    Callback = function(Value)
        guiConfig.freezecharacter = Value
        saveGuiConfig()
        if Value then
            task.spawn(function()
                while guiConfig.freezecharacter do
                    characteranchor(guiConfig.freezecharacter)
                    task.wait()
                end
            end)
        else
            characteranchor(guiConfig.freezecharacter)
        end
    end,
})

PlayerToggle10:Set(guiConfig.freezecharacter)

local WorldTab = Window:CreateTab("World", nil)

local abcon = {}

local WorldToggle1 = WorldTab:CreateToggle({
    Name = "Hide Rod Abilities",
    CurrentValue = false,
    Flag = "WorldToggle1",
    Callback = function(Value)
        guiConfig.hideability = Value
        saveGuiConfig()
        for _, v in ipairs(abcon) do
            v:Disconnect()
        end
        abcon = {}

        local ws = game:GetService("Workspace")

        -- Seraphic
        abcon[#abcon+1] = ws.active.debrisfx.ChildAdded:Connect(function(c)
            if guiConfig.hideability then
                task.wait()
                c:Destroy()
            end
        end)

        -- Great Dreamer, Free Spirit
        abcon[#abcon+1] = ws.ChildAdded:Connect(function(c)
            if not guiConfig.hideability then return end
            if c.Name == "Cathulu" or c.Name == "Gem" then
                task.wait()
                c:Destroy()
            end
        end)
    end
})

WorldToggle1:Set(guiConfig.hideability)

local fishadded

local WorldToggle2 = WorldTab:CreateToggle({
    Name = "Hide Fish Models",
    CurrentValue = false,
    Flag = "WorldToggle2",
    Callback = function(Value)
        guiConfig.hidefishmodels = Value
        saveGuiConfig()
        if fishadded then
            fishadded:Disconnect()
            fishadded = nil
        end

        fishadded = game:GetService("Workspace").active.ChildAdded:Connect(function(child)
            if guiConfig.hidefishmodels and child:FindFirstChild("Fish") then
                child:Destroy()
            end
        end)
    end,
})

WorldToggle2:Set(guiConfig.hidefishmodels)

local WorldToggle3 = WorldTab:CreateToggle({
    Name = "Disable 3D Rendering",
    CurrentValue = false,
    Flag = "WorldToggle3",
    Callback = function(Value)
        guiConfig.disable3drender = Value
        saveGuiConfig()
        game:GetService("RunService"):Set3dRenderingEnabled(not Value)
    end,
})

WorldToggle3:Set(guiConfig.disable3drender)

local FishTab = Window:CreateTab("AutoFish", nil)

local FishSection1 = FishTab:CreateSection("Cast")

local FishToggle1 = FishTab:CreateToggle({
    Name = "Auto Cast",
    CurrentValue = fishConfig.autocast,
    Flag = "FishToggle1",
    Callback = function(Value)
        fishConfig.autocast = Value
        saveFishConfig()
    end,
})

local FishToggle2 = FishTab:CreateToggle({
    Name = "Drop Bobber",
    CurrentValue = fishConfig.dropbobber,
    Flag = "FishToggle2",
    Callback = function(Value)
        fishConfig.dropbobber = Value
        saveFishConfig()
    end,
})

local FishSlider1 = FishTab:CreateSlider({
    Name = "Cast Power",
    Range = {0, 100},
    Increment = 1,
    Suffix = "%",
    CurrentValue = fishConfig.castpower,
    Flag = "FishSlider1",
    Callback = function(Value)
        fishConfig.castpower = Value
        saveFishConfig()
    end,
})

FishTab:CreateDivider()

local FishSection2 = FishTab:CreateSection("Shake")

local FishToggle3 = FishTab:CreateToggle({
    Name = "Auto Shake",
    CurrentValue = fishConfig.autoshake,
    Flag = "FishToggle3",
    Callback = function(Value)
        fishConfig.autoshake = Value
        saveFishConfig()
    end,
})

local shakeTable = {}
if fishConfig.shakenav then
    shakeTable = {"Navigation"}
else
    shakeTable = {"Click"}
end

local FishDropdown1 = FishTab:CreateDropdown({
    Name = "Shake Method",
    Options = {"Navigation", "Click"},
    CurrentOption = shakeTable,
    MultipleOptions = false,
    Flag = "FishDropdown1",
    Callback = function(Option)
        if Option[1] == "Navigation" then
            fishConfig.shakenav = true
        else
            fishConfig.shakenav = false
        end
        saveFishConfig()
    end,
})

FishTab:CreateDivider()

local FishSection3 = FishTab:CreateSection("Reel")

local FishToggle4 = FishTab:CreateToggle({
    Name = "Auto Reel",
    CurrentValue = fishConfig.autoreel,
    Flag = "FishToggle4",
    Callback = function(Value)
        fishConfig.autoreel = Value
        saveFishConfig()
    end,
})

local FishToggle5 = FishTab:CreateToggle({
    Name = "Instant Reel",
    CurrentValue = fishConfig.instantreel,
    Flag = "FishToggle5",
    Callback = function(Value)
        fishConfig.instantreel = Value
        saveFishConfig()
    end,
})

local FishToggle6 = FishTab:CreateToggle({
    Name = "Perfect Catch",
    CurrentValue = fishConfig.perfectCatch,
    Flag = "FishToggle6",
    Callback = function(Value)
        fishConfig.perfectCatch = Value
        saveFishConfig()
    end,
})

FishTab:CreateDivider()

local FishDropdown2 = FishTab:CreateDropdown({
    Name = "Reel Select",
    Options = {"None", "Whitelist", "Blacklist"},
    CurrentOption = {fishConfig.reelSelect},
    MultipleOptions = false,
    Flag = "FishDropdown2",
    Callback = function(Option)
        fishConfig.reelSelect = Option[1]
        saveFishConfig()
    end,
})

local FishLabel1 = FishTab:CreateLabel("Comma-separated list, NOT case-sensitive")

local FishInput1 = FishTab:CreateInput({
    Name = "Whitelist",
    CurrentValue = "",
    PlaceholderText = "Ex: 'Phantom Megalodon, The Kraken'",
    RemoveTextAfterFocusLost = false,
    Flag = "FishInput1",
    Callback = function(Text)
        fishConfig.reelWhitelistStr = Text
        saveFishConfig()
    end,
})

local FishInput2 = FishTab:CreateInput({
    Name = "Blacklist",
    CurrentValue = fishConfig.reelBlacklistStr,
    PlaceholderText = "Ex: 'Common Crate, Sardine'",
    RemoveTextAfterFocusLost = false,
    Flag = "FishInput2",
    Callback = function(Text)
        fishConfig.reelBlacklistStr = Text
        saveFishConfig()
    end,
})

local prevLocation
local zonetp
local zoneobj = nil
local offset
local stand = false
local tsmp = tick()

local function getzone()
    local fishing = game:GetService("Workspace").zones.fishing
    local zone = nil
    local coords = {x = 0, y = 0, z = 0}

    local zones
    local zonesconfig
    local zonesdata
    local eventzones
    local eventzonesconfig
    local eventzonesdata

    if game.PlaceId == data.placeids.sea1 then
        zones = data.ordered.zones1
        zonesconfig = guiConfig.zones1
        zonesdata = data.zoneData.zones1
        eventzones = data.ordered.eventzones1
        eventzonesconfig = guiConfig.eventzones1
        eventzonesdata = data.zoneData.eventzones1
    else
        zones = data.ordered.zones2
        zonesconfig = guiConfig.zones2
        zonesdata = data.zoneData.zones2
        eventzones = data.ordered.eventzones2
        eventzonesconfig = guiConfig.eventzones2
        eventzonesdata = data.zoneData.eventzones2
    end

    for i = #eventzones, 1, -1 do
        if zone or not guiConfig.eventzonetoggle then break end
        local name = eventzones[i]
        if eventzonesconfig[name] then
            zone = fishing:FindFirstChild(name)
            if zone then
                coords = eventzonesdata[name] or {x = 0, y = 0, z = 0}
                break
            end
        end
    end

    for i = #zones, 1, -1 do
        if zone or not guiConfig.zonetoggle then break end
        local name = zones[i]
        if zonesconfig[name] then
            zone = fishing:FindFirstChild(name)
            if zone then
                coords = zonesdata[name] or {x = 0, y = 0, z = 0}
                break
            end
        end
    end

    return zone, Vector3.new(coords.x, coords.y, coords.z)
end

local function zonetpfunc()
    if not zoneobj or not zoneobj.Parent or tick() - tsmp > 0.2 then
        zoneobj, offset = getzone()
        tsmp = tick()
        local character = game:GetService("Players").LocalPlayer.Character
        if not character then return end
        if zoneobj then
            stand = true
            if character:FindFirstChild("Humanoid") and not character:FindFirstChild("Humanoid").PlatformStand then
                character:FindFirstChild("Humanoid").PlatformStand = true
            end
        else
            if stand == true then
                stand = false
                if character:FindFirstChild("Humanoid") and character:FindFirstChild("Humanoid").PlatformStand then
                    character:FindFirstChild("Humanoid").PlatformStand = false
                end
            end
        end
    end
    if zoneobj then
        game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(zoneobj.Position + offset)
    end
end

local function toggleFreezeZone(enable)
    if zonetp then
        zonetp:Disconnect()
        zonetp = nil
    end

    local character = game:GetService("Players").LocalPlayer.Character

    if enable then
        if not prevLocation then
            prevLocation = character.HumanoidRootPart.CFrame
        end
        zonetp = game:GetService("RunService").Heartbeat:Connect(zonetpfunc)
    else
        stand = false
        if character:FindFirstChild("Humanoid") and character:FindFirstChild("Humanoid").PlatformStand then
            character:FindFirstChild("Humanoid").PlatformStand = false
        end
        if prevLocation then
            character.HumanoidRootPart.CFrame = prevLocation
            prevLocation = nil
        end
    end
end

local AreaTab = Window:CreateTab("Areas", nil)

local AreaSection1 = AreaTab:CreateSection("Zone Freeze")

local AreaToggle1 = AreaTab:CreateToggle({
    Name = "Zone Freeze",
    CurrentValue = false,
    Flag = "AreaToggle1",
    Callback = function(Value)
        guiConfig.zonetoggle = Value
        saveGuiConfig()
        toggleFreezeZone(guiConfig.zonetoggle or guiConfig.eventzonetoggle)
    end,
})

AreaToggle1:Set(guiConfig.zonetoggle)

local AreaToggle2 = AreaTab:CreateToggle({
    Name = "Event Zone Freeze",
    CurrentValue = false,
    Flag = "AreaToggle2",
    Callback = function(Value)
        guiConfig.eventzonetoggle = Value
        saveGuiConfig()
        toggleFreezeZone(guiConfig.zonetoggle or guiConfig.eventzonetoggle)
    end,
})

AreaToggle2:Set(guiConfig.eventzonetoggle)

local AreaDropdown1 = AreaTab:CreateDropdown({
    Name = "Zones",
    Options = {},
    CurrentOption = {},
    MultipleOptions = true,
    Flag = "AreaDropdown1",
    Callback = function(Options)
        if game.PlaceId == data.placeids.sea1 then
            dropdownconvert(guiConfig, "zones1", Options)
        else
            dropdownconvert(guiConfig, "zones2", Options) 
        end
        saveGuiConfig()
    end,
})

if game.PlaceId == data.placeids.sea1 then
    dropdownsetup(guiConfig, "zones1", AreaDropdown1)
else
    dropdownsetup(guiConfig, "zones2", AreaDropdown1)
end

local AreaDropdown2 = AreaTab:CreateDropdown({
    Name = "Event Zones",
    Options = {},
    CurrentOption = {},
    MultipleOptions = true,
    Flag = "AreaDropdown2",
    Callback = function(Options)
        if game.PlaceId == data.placeids.sea1 then
            dropdownconvert(guiConfig, "eventzones1", Options)
        else
            dropdownconvert(guiConfig, "eventzones2", Options) 
        end
        saveGuiConfig()
    end,
})

if game.PlaceId == data.placeids.sea1 then
    dropdownsetup(guiConfig, "eventzones1", AreaDropdown2)
else
    dropdownsetup(guiConfig, "eventzones2", AreaDropdown2)
end

local AutoTab = Window:CreateTab("Auto", nil)

local autoselltask

local AutoToggle1 = AutoTab:CreateToggle({
    Name = "Auto Sell",
    CurrentValue = false,
    Flag = "AutoToggle1",
    Callback = function(Value)
        guiConfig.autosell = Value
        saveGuiConfig()
        if autoselltask then
            task.cancel(autoselltask)
            autoselltask = nil
        end
        if Value then
            autoselltask = task.spawn(function()
                while guiConfig.autosell do
                    game:GetService("ReplicatedStorage"):WaitForChild("events"):WaitForChild("SellAll"):InvokeServer(
                    task.wait(1))
                end
            end)
        end
    end,
})

AutoToggle1:Set(guiConfig.autosell)

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

ScriptTab:CreateDivider()

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

ScriptTab:CreateDivider()

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

ScriptTab:CreateDivider()

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

ScriptTab:CreateDivider()

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

ScriptTab:CreateDivider()

local ScriptParagraph7 = ScriptTab:CreateParagraph({Title = "Auto PlaceVersion", Content = "Automatically displays the server's Roblox PlaceVersion when you scan"})

local ScriptToggle6 = ScriptTab:CreateToggle({
    Name = "Auto PlaceVersion",
    CurrentValue = config.infoList.autoplaceversion,
    Flag = "ScriptToggle6",
    Callback = function(Value)
        config.infoList.autoplaceversion = Value
        saveConfig()
    end,
})

local ServerConfigTab = Window:CreateTab("Server Config", nil)

local ServerConfigParagraph1 = ServerConfigTab:CreateParagraph({Title = "Weather", Content = "Select weathers that are desirable"})

local ServerConfigDropdown1 = ServerConfigTab:CreateDropdown({
    Name = "Weather",
    Options = {},
    CurrentOption = {},
    MultipleOptions = true,
    Flag = "ServerConfigDropdown1",
    Callback = function(Options)
        dropdownconvert(config, "weatherList", Options)
        saveConfig()
    end,
})

dropdownsetup(config, "weatherList", ServerConfigDropdown1)

ServerConfigTab:CreateDivider()

local ServerConfigParagraph2 = ServerConfigTab:CreateParagraph({Title = "Events", Content = "Select events that are desirable"})

local ServerConfigDropdown2 = ServerConfigTab:CreateDropdown({
    Name = "Events",
    Options = {},
    CurrentOption = {},
    MultipleOptions = true,
    Flag = "ServerConfigDropdown2",
    Callback = function(Options)
        dropdownconvert(config, "eventList", Options)
        saveConfig()
    end,
})

dropdownsetup(config, "eventList", ServerConfigDropdown2)

ServerConfigTab:CreateDivider()

local ServerConfigParagraph3 = ServerConfigTab:CreateParagraph({Title = "Seasons", Content = "Select seasons that are desirable"})

local ServerConfigDropdown3 = ServerConfigTab:CreateDropdown({
    Name = "Season",
    Options = {},
    CurrentOption = {},
    MultipleOptions = true,
    Flag = "ServerConfigDropdown3",
    Callback = function(Options)
        dropdownconvert(config, "seasonList", Options)
        saveConfig()
    end,
})

dropdownsetup(config, "seasonList", ServerConfigDropdown3)

ServerConfigTab:CreateDivider()

local ServerConfigParagraph4 = ServerConfigTab:CreateParagraph({Title = "Daytime Cycle", Content = "Select daytime cycles that are desirable"})

local ServerConfigDropdown4 = ServerConfigTab:CreateDropdown({
    Name = "Daytime Cycle",
    Options = {},
    CurrentOption = {},
    MultipleOptions = true,
    Flag = "ServerConfigDropdown4",
    Callback = function(Options)
        dropdownconvert(config, "cycleList", Options)
        saveConfig()
    end,
})

dropdownsetup(config, "cycleList", ServerConfigDropdown4)

ServerConfigTab:CreateDivider()

local ServerConfigParagraph5 = ServerConfigTab:CreateParagraph({Title = "Server Luck", Content = "Toggle and select minimum amount of server luck desired (Robux Luck Multiplier)"})

local ServerConfigToggle1 = ServerConfigTab:CreateToggle({
    Name = "Luck Toggle",
    CurrentValue = config.luckList.enabled,
    Flag = "ServerConfigToggle1",
    Callback = function(Value)
        config.luckList.enabled = Value
        saveConfig()
    end,
})

local resetLuckMin

local ServerConfigInput1 = ServerConfigTab:CreateInput({
    Name = "Minimum Multiplier",
    CurrentValue = config.luckList.min,
    PlaceholderText = "",
    RemoveTextAfterFocusLost = false,
    Flag = "ServerConfigInput1",
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
    ServerConfigInput1:Set(config.luckList.min)
end

ServerConfigTab:CreateDivider()

local ServerConfigParagraph6 = ServerConfigTab:CreateParagraph({Title = "Server Version", Content = "Toggle and select the desired ingame Fisch version in the form x.x.x"})

local ServerConfigToggle2 = ServerConfigTab:CreateToggle({
    Name = "Version Toggle",
    CurrentValue = config.versionList.enabled,
    Flag = "ServerConfigToggle2",
    Callback = function(Value)
        config.luckList.enabled = Value
        saveConfig()
    end,
})

local ServerConfigInput2 = ServerConfigTab:CreateInput({
    Name = "Version",
    CurrentValue = config.versionList.version,
    PlaceholderText = "x.x.x",
    RemoveTextAfterFocusLost = false,
    Flag = "ServerConfigInput2",
    Callback = function(Text)
        config.versionList.version = Text
    end,
})

ServerConfigTab:CreateDivider()

local ServerConfigSection1 = ServerConfigTab:CreateSection("PlaceVersion Search")

local ServerConfigButton1 = ServerTab:CreateButton({
    Name = "Display Current PlaceVersion",
    Callback = function()
        Rayfield:Notify({
            Title = "PlaceVersion",
            Content = "The current PlaceVersion is " .. tostring(game.PlaceVersion),
            Duration = 5,
            Image = nil,
        })
    end,
})

local ServerConfigParagraph7 = ServerConfigTab:CreateParagraph({Title = "PlaceVersion", Content = "Toggle and select the desired Roblox PlaceVersion (game.PlaceVersion)"})

local ServerConfigToggle3 = ServerConfigTab:CreateToggle({
    Name = "Before PlaceVersion - Toggle",
    CurrentValue = config.placeVersionList.beforeVersion.enabled,
    Flag = "ServerConfigToggle3",
    Callback = function(Value)
        config.placeVersionList.beforeVersion.enabled = Value
        saveConfig()
    end,
})

local resetBeforePlaceVersion

local ServerConfigParagraph8 = ServerConfigTab:CreateParagraph({Title = "Before PlaceVersion", Content = "Desirable server if the PlaceVersion is less than the amount below"})

local ServerConfigInput3 = ServerConfigTab:CreateInput({
    Name = "Before PlaceVersion",
    CurrentValue = config.placeVersionList.beforeVersion.version,
    PlaceholderText = "1234",
    RemoveTextAfterFocusLost = false,
    Flag = "ServerConfigInput3",
    Callback = function(Text)
        if tonumber(Text) and tonumber(Text) > 0 then
            config.placeVersionList.beforeVersion.version = tonumber(Text)
            saveConfig()
        else
            Rayfield:Notify({
                Title = "PlaceVersion",
                Content = "The input has to be a positive integer!",
                Duration = 5,
                Image = nil,
            })
            resetBeforePlaceVersion()
        end
    end,
})

resetBeforePlaceVersion = function()
    ServerConfigInput3:Set(config.placeVersionList.beforeVersion.version)
end

ServerConfigTab:CreateDivider()

local ServerConfigParagraph9 = ServerConfigTab:CreateParagraph({Title = "After PlaceVersion", Content = "Desirable server if the PlaceVersion is greater than the amount below"})

local ServerConfigToggle4 = ServerConfigTab:CreateToggle({
    Name = "After PlaceVersion - Toggle",
    CurrentValue = config.placeVersionList.afterVersion.enabled,
    Flag = "ServerConfigToggle4",
    Callback = function(Value)
        config.placeVersionList.afterVersion.enabled = Value
        saveConfig()
    end,
})

local resetAfterPlaceVersion

local ServerConfigInput4 = ServerConfigTab:CreateInput({
    Name = "After PlaceVersion",
    CurrentValue = config.placeVersionList.afterVersion.version,
    PlaceholderText = "1234",
    RemoveTextAfterFocusLost = false,
    Flag = "ServerConfigInput4",
    Callback = function(Text)
        if tonumber(Text) and tonumber(Text) > 0 then
            config.placeVersionList.afterVersion.version = tonumber(Text)
            saveConfig()
        else
            Rayfield:Notify({
                Title = "PlaceVersion",
                Content = "The input has to be a positive integer!",
                Duration = 5,
                Image = nil,
            })
            resetAfterPlaceVersion()
        end
    end,
})

resetAfterPlaceVersion = function()
    ServerConfigInput4:Set(config.placeVersionList.afterVersion.version)
end

ServerConfigTab:CreateDivider()

local ServerConfigParagraph10 = ServerConfigTab:CreateParagraph({Title = "Or Logic", Content = "Desirable server if either condition (Before or After PlaceVersion) is met"})

local ServerConfigToggle5 = ServerConfigTab:CreateToggle({
    Name = "Or Logic - Toggle",
    CurrentValue = config.placeVersionList.orLogic,
    Flag = "ServerConfigToggle5",
    Callback = function(Value)
        config.placeVersionList.orLogic = Value
        saveConfig()
    end,
})

ServerConfigTab:CreateDivider()

local ServerConfigSection2 = ServerConfigTab:CreateSection("Uptime Search")

local ServerConfigParagraph11 = ServerConfigTab:CreateParagraph({Title = "Before Time", Content = "Desirable server if the uptime is less than the amount below (summed)"})

local ServerConfigToggle6 = ServerConfigTab:CreateToggle({
    Name = "Before Time - Toggle",
    CurrentValue = config.uptimeList.beforeTime.enabled,
    Flag = "ServerConfigToggle6",
    Callback = function(Value)
        config.uptimeList.beforeTime.enabled = Value
        saveConfig()
    end,
})

local resetBHour

local ServerConfigInput5 = ServerConfigTab:CreateInput({
    Name = "Before Time - Hour",
    CurrentValue = config.uptimeList.beforeTime.hour,
    PlaceholderText = "x hours",
    RemoveTextAfterFocusLost = false,
    Flag = "ServerConfigInput5",
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
    ServerConfigInput5:Set(config.uptimeList.beforeTime.hour)
end

local resetBMin

local ServerConfigInput6 = ServerConfigTab:CreateInput({
    Name = "Before Time - Min",
    CurrentValue = config.uptimeList.beforeTime.min,
    PlaceholderText = "x mins",
    RemoveTextAfterFocusLost = false,
    Flag = "ServerConfigInput6",
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
    ServerConfigInput6:Set(config.uptimeList.beforeTime.min)
end

ServerConfigTab:CreateDivider()

local ServerConfigParagraph12 = ServerConfigTab:CreateParagraph({Title = "After Time", Content = "Desirable server if the uptime is more than the amount below (summed)"})

local ServerConfigToggle7 = ServerConfigTab:CreateToggle({
    Name = "After Time - Toggle",
    CurrentValue = config.uptimeList.afterTime.enabled,
    Flag = "ServerConfigToggle7",
    Callback = function(Value)
        config.uptimeList.afterTime.enabled = Value
        saveConfig()
    end,
})

local resetAHour

local ServerConfigInput7 = ServerConfigTab:CreateInput({
    Name = "After Time - Hour",
    CurrentValue = config.uptimeList.afterTime.hour,
    PlaceholderText = "x hours",
    RemoveTextAfterFocusLost = false,
    Flag = "ServerConfigInput7",
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
    ServerConfigInput7:Set(config.uptimeList.afterTime.hour)
end

local resetAMin

local ServerConfigInput8 = ServerConfigTab:CreateInput({
    Name = "After Time - Min",
    CurrentValue = config.uptimeList.afterTime.min,
    PlaceholderText = "x mins",
    RemoveTextAfterFocusLost = false,
    Flag = "ServerConfigInput8",
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
    ServerConfigInput8:Set(config.uptimeList.afterTime.min)
end

ServerConfigTab:CreateDivider()

local ServerConfigParagraph13 = ServerConfigTab:CreateParagraph({Title = "Or Logic", Content = "If Or Logic is on, server is desired if EITHER Before or After is satisfied. If Or Logic is off, BOTH Before and After must be satisfied (used if you need between 2 uptimes)"})

local ServerConfigToggle8 = ServerConfigTab:CreateToggle({
    Name = "Or Logic",
    CurrentValue = config.uptimeList.orLogic,
    Flag = "ServerConfigToggle8",
    Callback = function(Value)
        config.uptimeList.orLogic = Value
        saveConfig()
    end,
})

ServerConfigTab:CreateDivider()

local EventsTab = Window:CreateTab("Events Config", nil)

local EventsParagraph1 = EventsTab:CreateParagraph({Title = "Fishing Zones", Content = "Select the Fishing/Event Zones that are desired"})

local EventsDropdown1 = EventsTab:CreateDropdown({
    Name = "Zones",
    Options = {},
    CurrentOption = {},
    MultipleOptions = true,
    Flag = "EventsDropdown1",
    Callback = function(Options)
        dropdownconvert(config, "zoneList", Options)
        saveConfig()
    end,
})

dropdownsetup(config, "zoneList", EventsDropdown1)

local EventsParagraph2 = EventsTab:CreateParagraph({Title = "Meteor Items", Content = "Select the Meteor Items that are desired"})

local EventsDropdown2 = EventsTab:CreateDropdown({
    Name = "Meteor Items",
    Options = {},
    CurrentOption = {},
    MultipleOptions = true,
    Flag = "EventsDropdown2",
    Callback = function(Options)
        dropdownconvert(config, "meteorList", Options)
        saveConfig()
    end,
})

dropdownsetup(config, "meteorList", EventsDropdown2)

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

local EventsParagraph8 = EventsTab:CreateParagraph({Title = "Sunken Chest Force Hop", Content = "Server hops even if there are other desired features, requires Auto Farm and Auto Hop!"})

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
        elseif Value and not config.autohop then
            Rayfield:Notify({
                Title = "Force Hop",
                Content = "Auto Hop is off!",
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

print("[FSF-G] Loaded!")