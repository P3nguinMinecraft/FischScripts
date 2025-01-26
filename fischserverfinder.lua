-- CONFIG

autoscan = true
autohop = false
autowebhook = true
webhookUrl = "https://discord.com/api/webhooks/#/#"
filename = "servers" -- dont add .json

eventList = {
    {name = "Night of the Fireflies",   enabled = false},
    {name = "Night of the Luminous",    enabled = false},
    {name = "Shiny Surge",              enabled = false},
    {name = "Mutation Surge",           enabled = false},
}

weatherList = {
    {name = "Clear",                    enabled = false},
    {name = "Foggy",                    enabled = false},
    {name = "Windy",                    enabled = false},
    {name = "Rain",                     enabled = false},
    {name = "Eclipse",                  enabled = false},
    {name = "Aurora Borealis",          enabled = true},
}

cycleList = {
    {name = "Day",                      enabled = false},
    {name = "Night",                    enabled = false},
}

seasonList = {
    {name = "Spring",                   enabled = false},
    {name = "Summer",                   enabled = false},
    {name = "Fall",                     enabled = false},
    {name = "Winter",                   enabled = false},
}

zoneList = {
    {name = "Megalodon Default",        enabled = true},
    {name = "Megalodon Ancient",        enabled = true},
    {name = "Great White Shark",        enabled = false},
    {name = "Great Hammerhead Shark",   enabled = false},
    {name = "Whale Shark",              enabled = false},
    {name = "Golden Tide",              enabled = false},
    {name = "The Kraken Pool",          enabled = true},
    {name = "Ancient Kraken Pool",      enabled = true},

    --{name = "Ancient Algae Pool",       enabled = false},
    --{name = "Forsaken Algae Pool",      enabled = false},
    --{name = "Snowcap Algae Pool",       enabled = false},
    --{name = "Mushgrove Algae Pool",     enabled = false},
}

luckList = {
    min = 8,
    enabled = true,
}

meteorList = {
    {name = "Amethyst",                 enabled = false},
    {name = "Ruby",                     enabled = false},
    {name = "Opal",                     enabled = false},
    {name = "Lapis Lazuli",             enabled = false},
    {name = "Moonstone",                enabled = true},
}

sunkenchestList = {
    enabled = true,
    bufferbefore = 1,
    alertonload = true,
}

autouptime = true

-- CODE

local version = "1.1.1"
local updversion, updmsg, sunkenchestcoords = loadstring(game:HttpGet("https://raw.githubusercontent.com/P3nguinMinecraft/FischScripts/refs/heads/main/fsf_data.lua"))()
local checkteleporting = false

local camera = game.Workspace.CurrentCamera

repeat task.wait(1) until game:IsLoaded()
print("[FSF] Loading")

local loading = game:GetService("Players").LocalPlayer.PlayerGui:WaitForChild("loading", 20)
if loading then
    loading.loading.Visible = false
end

task.wait(3)
local uptime = game:GetService("Players").LocalPlayer.PlayerGui:WaitForChild("serverInfo").serverInfo.uptime.Text:sub(16)
while uptime == "0D 00H 00S" do
    task.wait()
    uptime = game:GetService("Players").LocalPlayer.PlayerGui:WaitForChild("serverInfo").serverInfo.uptime.Text:sub(16)
end

local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
filename = filename.. ".json"

function tp(x, y, z)
    game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(x, y, z))
end

function teleport()
    local Server, Next = nil, nil
    
    local function ListServers(cursor)
        local ServersAPI = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
        local Raw = game:HttpGet(ServersAPI .. ((cursor and "&cursor=" .. cursor) or ""))
        local Decode = HttpService:JSONDecode(Raw)

        if Decode.errors then
            notifygui("API Overload", 255, 255, 255)
            if not isfile(filename) then
                return nil
            end
            return readfile(filename)
        else
            writefile(filename, Raw)
            return Raw
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

    notifygui("Teleporting", 22, 209, 242)

    while Server == nil or Server.playing == nil do
        local Raw = ListServers(Next)
        local Servers = HttpService:JSONDecode(Raw)

        if Servers and Servers.nextPageCursor then
            Server = Servers.data[math.random(1, #Servers.data)]
            Next = Servers.nextPageCursor
        else
            notifygui("No available servers.", 242, 44, 22)
            return
        end
    end

    if Server and Server.playing < Server.maxPlayers and Server.id ~= game.JobId then
        RemoveServer(Server.id)
        TeleportService:TeleportToPlaceInstance(game.PlaceId, Server.id, game:GetService("Players").LocalPlayer)
    else
        notifygui("Failed Server Hop (pls debug)", 242, 44, 22)
        print(Server)
        print(Server.playing)
        return
    end
end

function creategui()
    local playerGui = game.Players.LocalPlayer.PlayerGui

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "FischServerFinder"
    screenGui.Parent = playerGui

    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0.25, 0, 0.5, 0)
    mainFrame.Position = UDim2.new(0.1, 0, 0.4, 0)
    mainFrame.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.Parent = screenGui
    mainFrame.ZIndex = 101

    local topBar = Instance.new("Frame")
    topBar.Name = "TopBar"
    topBar.Size = UDim2.new(0.95, 0, 0.1, 0)
    topBar.Position = UDim2.new(0.5, 0, 0.01, 0)
    topBar.BackgroundColor3 = Color3.fromRGB(140, 140, 140)
    topBar.BorderSizePixel = 0
    topBar.Active = true
    topBar.AnchorPoint = Vector2.new(0.5, 0)
    topBar.Parent = mainFrame
    topBar.ZIndex = 101

    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Name = "NotificationContainer"
    scrollFrame.Size = UDim2.new(0.95, 0, 0.85, 0)
    scrollFrame.Position = UDim2.new(0.5, 0, 0.13, 0)
    scrollFrame.AnchorPoint = Vector2.new(0.5, 0)
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    scrollFrame.ScrollBarThickness = 8
    scrollFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
    scrollFrame.BorderSizePixel = 0
    scrollFrame.Parent = mainFrame
    scrollFrame.ZIndex = 101

    local uiListLayout = Instance.new("UIListLayout")
    uiListLayout.Name = "UIList"
    uiListLayout.Padding = UDim.new(0, 5)
    uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    uiListLayout.Parent = scrollFrame

    local closeGUI = Instance.new("TextButton")
    closeGUI.Name = "CloseGUI"
    closeGUI.Size = UDim2.new(0.07, 0, 0.5, 0)
    closeGUI.Position = UDim2.new(0.02, 0, 0.5, 0)
    closeGUI.BackgroundColor3 = Color3.new(1, 0, 0)
    closeGUI.Text = "X"
    closeGUI.TextColor3 = Color3.new(1, 1, 1)
    closeGUI.TextScaled = true
    closeGUI.Font = Enum.Font.SourceSans
    closeGUI.AnchorPoint = Vector2.new(0, 0.5)
    closeGUI.Parent = topBar
    closeGUI.ZIndex = 101

    local hop = Instance.new("TextButton")
    hop.Name = "ServerHop"
    hop.Size = UDim2.new(0.25, 0, 0.5, 0)
    hop.Position = UDim2.new(0.1, 0, 0.5, 0)
    hop.BackgroundColor3 = Color3.new(0, 1, 1)
    hop.Text = "Server Hop"
    hop.TextColor3 = Color3.new(0.3, 0.3, 0.3)
    hop.TextScaled = true
    hop.Font = Enum.Font.SourceSans
    hop.AnchorPoint = Vector2.new(0, 0.5)
    hop.Parent = topBar
    hop.ZIndex = 101

    local rescan = Instance.new("TextButton")
    rescan.Name = "Rescan"
    rescan.Size = UDim2.new(0.2, 0, 0.5, 0)
    rescan.Position = UDim2.new(0.37, 0, 0.5, 0)
    rescan.BackgroundColor3 = Color3.new(0.42, 0.75, 0.82)
    rescan.Text = "Rescan"
    rescan.TextColor3 = Color3.new(0, 0, 0)
    rescan.TextScaled = true
    rescan.Font = Enum.Font.SourceSans
    rescan.AnchorPoint = Vector2.new(0, 0.5)
    rescan.Parent = topBar
    rescan.ZIndex = 101

    local JobId = Instance.new("TextButton")
    JobId.Name = "JobId"
    JobId.Size = UDim2.new(0.25, 0, 0.5, 0)
    JobId.Position = UDim2.new(0.6, 0, 0.5, 0)
    JobId.BackgroundColor3 = Color3.new(0.11, 0.81, 0.15)
    JobId.Text = "Copy JobId"
    JobId.TextColor3 = Color3.new(0, 0, 0)
    JobId.TextScaled = true
    JobId.Font = Enum.Font.SourceSans
    JobId.AnchorPoint = Vector2.new(0, 0.5)
    JobId.Parent = topBar
    JobId.ZIndex = 101
    
    local Minimize = Instance.new("TextButton")
    Minimize.Name = "Minimize"
    Minimize.Size = UDim2.new(0.07, 0, 0.5, 0)
    Minimize.Position = UDim2.new(0.9, 0, 0.5, 0)
    Minimize.BackgroundColor3 = Color3.new(1, 0.93, 0)
    Minimize.Text = "-"
    Minimize.TextColor3 = Color3.new(0, 0, 0)
    Minimize.TextScaled = true
    Minimize.Font = Enum.Font.SourceSans
    Minimize.AnchorPoint = Vector2.new(0, 0.5)
    Minimize.Parent = topBar
    Minimize.ZIndex = 101

    closeGUI.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)

    hop.MouseButton1Click:Connect(function()
        teleport()
    end)

    rescan.MouseButton1Click:Connect(function()
        notifygui("Rescanning", 107, 191, 209)
        scan()
    end)

    JobId.MouseButton1Click:Connect(function()
        setclipboard(game.JobId)
        notifygui("Copied JobId", 255, 255, 255)
    end)

    Minimize.MouseButton1Click:Connect(function()
        MinimizeGUI()
    end)


end

function notifygui(text, r, g, b)
    if not r then r = 255 end
    if not g then g = 255 end
    if not b then b = 255 end
    print(text)

    local playerGui = game.Players.LocalPlayer.PlayerGui
    local screenGui = playerGui:FindFirstChild("FischServerFinder")

    if not screenGui then
        creategui()
        screenGui = playerGui:FindFirstChild("FischServerFinder")
    end

    local mainFrame = screenGui:FindFirstChild("MainFrame")
    local scrollFrame = mainFrame:FindFirstChild("NotificationContainer")
    local uiListLayout = scrollFrame:FindFirstChild("UIList")

    local frame = Instance.new("Frame")
    frame.Name = "NotificationFrame"
    frame.Size = UDim2.new(1, 0, 0, camera.ViewportSize.Y * 0.05)
    frame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    frame.BorderSizePixel = 0
    frame.Parent = scrollFrame
    frame.ZIndex = 101

    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0.06, 0, 0.4, 0)
    closeButton.Position = UDim2.new(0.015, 0, 0.3, 0)
    closeButton.BackgroundColor3 = Color3.new(1, 0, 0)
    closeButton.Text = "X"
    closeButton.TextColor3 = Color3.new(1, 1, 1)
    closeButton.TextScaled = true
    closeButton.Font = Enum.Font.SourceSans
    closeButton.Parent = frame
    closeButton.ZIndex = 101

    local textLabel = Instance.new("TextLabel")
    textLabel.Name = "NotificationText"
    textLabel.Size = UDim2.new(0.9, 0, 1, 0)
    textLabel.Position = UDim2.new(0.1, 0, 0, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = text
    textLabel.TextColor3 = Color3.new(r/255, g/255, b/255)
    textLabel.TextScaled = true
    textLabel.Font = Enum.Font.SourceSans
    textLabel.Parent = frame
    textLabel.ZIndex = 101

    if string.find(text, "Meteor:") then
        textLabel.Size = UDim2.new(1, -50, 1, 0)
        textLabel.Position = UDim2.new(0, 50, 0, 0)

        local meteorTP = Instance.new("TextButton")
        meteorTP.Name = "meteorTP"
        meteorTP.Size = UDim2.new(0.06, 0, 0.4, 0)
        meteorTP.Position = UDim2.new(0.09, 0, 0.3, 0)
        meteorTP.BackgroundColor3 = Color3.new(236/255, 103/255, 44/255)
        meteorTP.Text = "Goto"
        meteorTP.TextColor3 = Color3.new(1, 1, 1)
        meteorTP.TextScaled = true
        meteorTP.Font = Enum.Font.SourceSans
        meteorTP.Parent = frame
        meteorTP.ZIndex = 101

        meteorTP.MouseButton1Click:Connect(function()
            game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(5694, 174, 632))
            notifygui("Teleported to Meteor", 42, 227, 14)
        end)
    end

    closeButton.MouseButton1Click:Connect(function()
        frame:Destroy()
    end)

    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, uiListLayout.AbsoluteContentSize.Y)
end

function MinimizeGUI()
    local playerGui = game.Players.LocalPlayer.PlayerGui
    local screenGui = playerGui:FindFirstChild("FischServerFinder")

    if not screenGui then
        creategui()
        screenGui = playerGui:FindFirstChild("FischServerFinder")
    end

    local mainFrame = screenGui:FindFirstChild("MainFrame")
    local scrollFrame = mainFrame:FindFirstChild("NotificationContainer")
    local topBar = mainFrame:FindFirstChild("TopBar")
    local Minimize = topBar:FindFirstChild("Minimize")

    if Minimize.Text == "-" then
        Minimize.Text = "+"
        mainFrame.Size = UDim2.new(0.25, 0, 0.06, 0)
        scrollFrame.Visible = false
        topBar.Size = UDim2.new(0.95, 0, 0.83, 0)
        topBar.Position = UDim2.new(0.5, 0, 0.09, 0)
    else
        Minimize.Text = "-"
        mainFrame.Size = UDim2.new(0.25, 0, 0.5, 0)
        scrollFrame.Visible = true
        topBar.Size = UDim2.new(0.95, 0, 0.1, 0)
        topBar.Position = UDim2.new(0.5, 0, 0.01, 0)
    end
end

local activeChestsFolder = game:GetService("Workspace").ActiveChestsFolder

function scanchest()
    for _, object in pairs(activeChestsFolder:GetChildren()) do
        if sunkenchestList.alertonload then
            checkteleporting = false
            notifygui("Sunken Chest Found!", 255, 255, 0)
            sunkenchesttp2(object)
        end
    end
end

function sunkenchesttp1()
    local playerGui = game.Players.LocalPlayer.PlayerGui
    local screenGui = playerGui:FindFirstChild("FischServerFinder")

    if not screenGui then
        creategui()
        screenGui = playerGui:FindFirstChild("FischServerFinder")
    end
    local mainFrame = screenGui:FindFirstChild("MainFrame")
    local scrollFrame = mainFrame:FindFirstChild("NotificationContainer")
    local uiListLayout = scrollFrame:FindFirstChild("UIList")

    local frame = Instance.new("Frame")
    frame.Name = "NotificationFrame"
    frame.Size = UDim2.new(1, 0, 0, camera.ViewportSize.Y * 0.05)
    frame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    frame.BorderSizePixel = 0
    frame.Parent = scrollFrame
    frame.ZIndex = 101

    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0.06, 0, 0.4, 0)
    closeButton.Position = UDim2.new(0.015, 0, 0.3, 0)
    closeButton.BackgroundColor3 = Color3.new(1, 0, 0)
    closeButton.Text = "X"
    closeButton.TextColor3 = Color3.new(1, 1, 1)
    closeButton.TextScaled = true
    closeButton.Font = Enum.Font.SourceSans
    closeButton.Parent = frame
    closeButton.ZIndex = 101

    local tpButton = Instance.new("TextButton")
    tpButton.Name = "tpButton"
    tpButton.Size = UDim2.new(0.25, 0, 0.6, 0)
    tpButton.Position = UDim2.new(0.3, 0, 0.2, 0)
    tpButton.BackgroundColor3 = Color3.new(0.5, 0.9, 0.65)
    tpButton.Text = "TP"
    tpButton.TextColor3 = Color3.new(1, 1, 1)
    tpButton.TextScaled = true
    tpButton.Font = Enum.Font.SourceSans
    tpButton.Parent = frame
    tpButton.ZIndex = 101

    local rescanButton = Instance.new("TextButton")
    rescanButton.Name = "rescanButton"
    rescanButton.Size = UDim2.new(0.25, 0, 0.6, 0)
    rescanButton.Position = UDim2.new(0.6, 0, 0.2, 0)
    rescanButton.BackgroundColor3 = Color3.new(0.83, 0.5, 0.9)
    rescanButton.Text = "Rescan"
    rescanButton.TextColor3 = Color3.new(1, 1, 1)
    rescanButton.TextScaled = true
    rescanButton.Font = Enum.Font.SourceSans
    rescanButton.Parent = frame
    rescanButton.ZIndex = 101

    closeButton.MouseButton1Click:Connect(function()
        frame:Destroy()
    end)

    tpButton.MouseButton1Click:Connect(function()
        local foundchest = false
        checkteleporting = true
        for _, coords in ipairs(sunkenchestcoords) do
            tp(coords.x, coords.y + 70, coords.z)
            task.wait(0.1)
            if not checkteleporting then
                foundchest = true
                break
            end
        end
        if not foundchest then
            scanchest()
        end
        checkteleporting = false
    end)

    rescanButton.MouseButton1Click:Connect(function()
        scanchest()
    end)

    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, uiListLayout.AbsoluteContentSize.Y)
end

function sunkenchesttp2(object)
    local position
    for _, descendant in ipairs(object:GetDescendants()) do
        if descendant:IsA("BasePart") then
            position = descendant.Position
            break
        end
    end

    if not position then return end

    local playerGui = game.Players.LocalPlayer.PlayerGui
    local screenGui = playerGui:FindFirstChild("FischServerFinder")

    if not screenGui then
        creategui()
        screenGui = playerGui:FindFirstChild("FischServerFinder")
    end
    local mainFrame = screenGui:FindFirstChild("MainFrame")
    local scrollFrame = mainFrame:FindFirstChild("NotificationContainer")
    local uiListLayout = scrollFrame:FindFirstChild("UIList")

    local frame = Instance.new("Frame")
    frame.Name = "NotificationFrame"
    frame.Size = UDim2.new(1, 0, 0, camera.ViewportSize.Y * 0.05)
    frame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    frame.BorderSizePixel = 0
    frame.Parent = scrollFrame
    frame.ZIndex = 101

    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0.06, 0, 0.4, 0)
    closeButton.Position = UDim2.new(0.015, 0, 0.3, 0)
    closeButton.BackgroundColor3 = Color3.new(1, 0, 0)
    closeButton.Text = "X"
    closeButton.TextColor3 = Color3.new(1, 1, 1)
    closeButton.TextScaled = true
    closeButton.Font = Enum.Font.SourceSans
    closeButton.Parent = frame
    closeButton.ZIndex = 101

    local tpButton = Instance.new("TextButton")
    tpButton.Name = "tpButton"
    tpButton.Size = UDim2.new(0.8, 0, 0.6, 0)
    tpButton.Position = UDim2.new(0.15, 0, 0.2, 0)
    tpButton.BackgroundColor3 = Color3.new(0.4, 0.6, 1)
    tpButton.Text = "TP to Chests"
    tpButton.TextColor3 = Color3.new(1, 1, 1)
    tpButton.TextScaled = true
    tpButton.Font = Enum.Font.SourceSans
    tpButton.Parent = frame
    tpButton.ZIndex = 101

    closeButton.MouseButton1Click:Connect(function()
        frame:Destroy()
    end)

    tpButton.MouseButton1Click:Connect(function()
        game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(position + Vector3.new(0, 10, 0))
    end)

    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, uiListLayout.AbsoluteContentSize.Y)
end

function issunkenchest(uptime)
    local hours, minutes = uptime:match("^(%d+):(%d+):%d+$")
    hours = tonumber(hours)
    minutes = tonumber(minutes)

    local totalMinutes = (hours * 60) + minutes

    local modValue = (totalMinutes - 60 + sunkenchestList.bufferbefore) % 70

    if modValue >= 0 and modValue < (10 + sunkenchestList.bufferbefore) then
        return true, (modValue - sunkenchestList.bufferbefore)
    else
        return false, -1
    end
end


function convertEventString(events)
    local string = ""
    for _, event in ipairs(events) do
        if event.text == "## Events: " then
            string = string .. event.text .. "\n"
        else
            string = string .. "- " .. event.text .. "\n"
        end
    end
    return string
end

function sendwebhook()
    local count = #game:GetService("Players"):GetPlayers()
    local version = game:GetService("ReplicatedStorage").world.version.Value
    local uptimestr = "**Server Uptime: **" .. uptime
    local jobId = game.JobId
    local timestamp = os.time()
    local timestampfooter = os.date("!%Y-%m-%dT%H:%M:%S.000Z")
    local events = convertEventString(scanWorld())

    local embedData = {
        content = "",
        tts = false,
        embeds = {
            {
                description = "**Players:** " .. count .. " / 15\n**Game Version:** " .. version .. 
                            "\n".. uptimestr .. "\n\n## Info:\n" .. events,
                fields = {
                    {
                        name = "JobId",
                        value = "```" .. jobId .. "```"
                    },
                    {
                        name = "Code",
                        value = "```game:GetService(\"TeleportService\"):TeleportToPlaceInstance(16732694052, \"" .. 
                                jobId .. "\", game:GetService(\"Players\").LocalPlayer)```"
                    }
                },
                footer = {
                    text = "windows1267"
                },
                timestamp = timestampfooter,
                title = "Server Found <t:" .. timestamp ..":R>",
                color = 53759,
            }
        }
    }

    local jsonData = HttpService:JSONEncode(embedData)
    request({
        Url = webhookUrl,
        Method = "POST",
        Headers = {["Content-Type"] = "application/json"},
        Body = jsonData
    })
end

function haschildren(object)
    return #object:GetChildren() > 0;
end

function scanWorld()
    local events = {}
    local weather = game:GetService("ReplicatedStorage").world.weather
    local cycle = game:GetService("ReplicatedStorage").world.cycle
    local season = game:GetService("ReplicatedStorage").world.season
    local event = game:GetService("ReplicatedStorage").world.event
    local luckServer = game:GetService("ReplicatedStorage").world.luck_Server
    local luckServerside = game:GetService("ReplicatedStorage").world.luck_ServerSide
    local luck = luckServer.Value + luckServerside.Value
    if luckServer.Value == 1 then
        luck = luck - 1
    end
    local meteor = game:GetService("Workspace"):WaitForChild("MeteorItems")
    local zones = game:GetService("Workspace"):WaitForChild("zones"):WaitForChild("fishing")

    for _, weatherData in ipairs(weatherList) do
        if  weatherData.name == weather.Value then
            table.insert(events, {text = "Weather: " .. weatherData.name, r = 255, g = 255, b = 255, enabled = weatherData.enabled})
        end
        if weather.Value == "Aurora_Borealis" and weatherData.name == "Aurora Borealis" then
            table.insert(events, {text = "Weather: Aurora Borealis", r = 160, g = 252, b = 180, enabled = weatherData.enabled})
        end
    end

    for _, cycleData in ipairs(cycleList) do
        if  cycleData.name == cycle.Value then
            table.insert(events, {text = "Cycle: " .. cycleData.name, r = 255, g = 255, b = 255, enabled = cycleData.enabled})
        end
    end

    for _, seasonData in ipairs(seasonList) do
        if  seasonData.name == season.Value then
            table.insert(events, {text = "Season: " .. seasonData.name, r = 255, g = 255, b = 255, enabled = seasonData.enabled})
        end
    end

    table.insert(events, {text = "## Events: ", r = 255, g = 255, b = 255, enabled = false})

    for _, eventData in ipairs(eventList) do
        if eventData.name == event.Value then
            table.insert(events, {text = eventData.name, r = 255, g = 255, b = 255, enabled = eventData.enabled})
        end
    end

    if luck > 1 then
        local send = luck >= luckList.min and luckList.enabled
        table.insert(events, {text = "Luck: x" .. luck, r = 88, g = 162, b = 91, enabled = send})
    end

    local meteoritems = meteor:GetChildren()
    if #meteoritems > 0 then
        local item = meteoritems[1]
        for _, meteorData in ipairs(meteorList) do
            if meteorData.name == item.Name then
                table.insert(events, {text = "Meteor: " .. item.Name, r = 236, g = 103, b = 44, enabled = meteorData.enabled})
            end
        end
    end

    for _, zoneData in ipairs(zoneList) do
        if zones:FindFirstChild(zoneData.name) then
            local count = 0
            for _, zone in pairs(zones:GetChildren()) do
                if zone.Name == zoneData.name then
                    count = count + 1
                end
            end

            if count > 0 then
                local str = zoneData.name
                if count > 1 then
                    str = tostring(count) .. "X " .. str
                end
                local r, g, b = 236, 104, 142
                if string.find(str, "Megalodon") then
                    r, g, b = 234, 51, 35
                end
                table.insert(events, {text = str, r = r, g = g, b = b, enabled = zoneData.enabled})
            end
        end
    end
    local issc, time = issunkenchest(uptime)
    if issc then
        table.insert(events, {text = "Sunken Chest " .. time .. " min", r = 255, g = 255, b = 102, enabled = sunkenchestList.enabled})
    end

    return events
end

function notify(events)
    local count = 0
    for _, event in ipairs(events) do
        if event.enabled == true then
            notifygui(event.text, event.r, event.g, event.b)
            count = count + 1
            if string.find(event.text, "Sunken Chest") then
                sunkenchesttp1()
            end
        end
    end
    if count == 0 then
        notifygui("Nothing", 255, 153, 0)
        if autohop then
            notifygui("Autohopping", 255, 255, 255)
            teleport() 
        end
    end
end

function scan()
    uptime = game:GetService("Players").LocalPlayer.PlayerGui:WaitForChild("serverInfo").serverInfo.uptime.Text:sub(16)
    if autouptime then
        notifygui("Uptime: " .. uptime)
    end
    local events = scanWorld()
    notify(events)
end

activeChestsFolder.ChildAdded:Connect(function(object)
    if sunkenchestList.alertonload then
        checkteleporting = false
        notifygui("Sunken Chest Loaded!", 255, 255, 0)
        sunkenchesttp2(object)
    end
end)

if not string.match(version, updversion) then
    notifygui("Outdated Version: " .. updversion, 255, 0, 0)
    notifygui("Go to GitHub (link copied)", 255, 0, 0)
    setclipboard("https://raw.githubusercontent.com/P3nguinMinecraft/FischScripts/refs/heads/main/fischserverfinder.lua")
    notifygui(updmsg, 255, 255, 255)
end

if autoscan then
    scan()
end

if autowebhook then
    sendwebhook()
end

print("[FSF] Loaded In!")

task.wait(20)
if loading then 
    loading.loading.Visible = true
end
