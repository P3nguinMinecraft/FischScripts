-- CONFIG

autoscan = true
autohop = true
autowebhook = true
webhookUrl = "https://discord.com/api/webhooks/*/*"
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
    {name = "Whale Shark",              enabled = true},
    {name = "Golden Tide",              enabled = false},
    {name = "Ancient Algae Pool",       enabled = false},
    {name = "Forsaken Algae Pool",      enabled = false},
    {name = "Snowcap Algae Pool",       enabled = false},
    {name = "Mushgrove Algae Pool",     enabled = false},
}

luckList = {
    min = 2,
    enabled = true,
}

meteorList = {
    {name = "Amethyst", enabled = true},
    {name = "Ruby", enabled = true},
    {name = "Opal", enalbed = true},
    {name = "Lapis Lazuli", enabled = true},
    {name = "Moonstone", enabled = true},
}

sunkenchestList = {
    enabled = true,
    alertonload = true,
}

-- CODE

repeat task.wait(1) until game:IsLoaded()

local loading = game:GetService("Players").LocalPlayer.PlayerGui:WaitForChild("loading", 20)
loading.loading.Visible = false

task.wait(3)
local uptime = game:GetService("Players").LocalPlayer.PlayerGui:WaitForChild("serverInfo").serverInfo.uptime.Text:sub(16)
while uptime == "0D 00H 00S" do
    task.wait()
    uptime = game:GetService("Players").LocalPlayer.PlayerGui:WaitForChild("serverInfo").serverInfo.uptime.Text:sub(16)
end

local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
filename = filename.. ".json"

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
    screenGui.Name = "NotificationGui"
    screenGui.Parent = playerGui

    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "DragFrame"
    mainFrame.Size = UDim2.new(0, 350, 0, 400)
    mainFrame.Position = UDim2.new(0.1, 0, 0.2, 0)
    mainFrame.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.Parent = screenGui
    mainFrame.ZIndex = 101

    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Name = "NotificationContainer"
    scrollFrame.Size = UDim2.new(1, -20, 1, -60)
    scrollFrame.Position = UDim2.new(0.5, 0, 0, 55)
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
    closeGUI.Size = UDim2.new(0, 20, 0, 20)
    closeGUI.Position = UDim2.new(0, 10, 0.05, 0)
    closeGUI.BackgroundColor3 = Color3.new(1, 0, 0)
    closeGUI.Text = "X"
    closeGUI.TextColor3 = Color3.new(1, 1, 1)
    closeGUI.TextScaled = true
    closeGUI.Font = Enum.Font.SourceSans
    closeGUI.Parent = mainFrame
    closeGUI.ZIndex = 101

    local Hop = Instance.new("TextButton")
    Hop.Name = "Hop"
    Hop.Size = UDim2.new(0, 80, 0, 20)
    Hop.Position = UDim2.new(0, 40, 0.05, 0)
    Hop.BackgroundColor3 = Color3.new(0, 1, 1)
    Hop.Text = "Server Hop"
    Hop.TextColor3 = Color3.new(0.3, 0.3, 0.3)
    Hop.TextScaled = true
    Hop.Font = Enum.Font.SourceSans
    Hop.Parent = mainFrame
    Hop.ZIndex = 101

    local rescan = Instance.new("TextButton")
    rescan.Name = "rescan"
    rescan.Size = UDim2.new(0, 60, 0, 20)
    rescan.Position = UDim2.new(0.37, 0, 0.05, 0)
    rescan.BackgroundColor3 = Color3.new(0.42, 0.75, 0.82)
    rescan.Text = "Rescan"
    rescan.TextColor3 = Color3.new(0, 0, 0)
    rescan.TextScaled = true
    rescan.Font = Enum.Font.SourceSans
    rescan.Parent = mainFrame
    rescan.ZIndex = 101

    local JobId = Instance.new("TextButton")
    JobId.Name = "JobId"
    JobId.Size = UDim2.new(0, 90, 0, 20)
    JobId.Position = UDim2.new(0.58, 0, 0.05, 0)
    JobId.BackgroundColor3 = Color3.new(0.11, 0.81, 0.15)
    JobId.Text = "Copy JobId"
    JobId.TextColor3 = Color3.new(0, 0, 0)
    JobId.TextScaled = true
    JobId.Font = Enum.Font.SourceSans
    JobId.Parent = mainFrame
    JobId.ZIndex = 101

    closeGUI.MouseButton1Click:Connect(function()
        screenGui:Destroy()
        --loading.Visible = true
    end)

    Hop.MouseButton1Click:Connect(function()
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
end

function notifygui(text, r, g, b)
    if not r then r = 255 end
    if not g then g = 255 end
    if not b then b = 255 end
    print(text)

    local playerGui = game.Players.LocalPlayer.PlayerGui
    local screenGui = playerGui:FindFirstChild("NotificationGui")

    if not screenGui then
        creategui()
        screenGui = playerGui:FindFirstChild("NotificationGui")
    end

    local mainFrame = screenGui:FindFirstChild("DragFrame")
    local scrollFrame = mainFrame:FindFirstChild("NotificationContainer")
    local uiListLayout = scrollFrame:FindFirstChild("UIList")

    local frame = Instance.new("Frame")
    frame.Name = "NotificationFrame"
    frame.Size = UDim2.new(1, -10, 0, 50)
    frame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    frame.BorderSizePixel = 0
    frame.Parent = scrollFrame
    frame.ZIndex = 101

    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 20, 0, 20)
    closeButton.Position = UDim2.new(0, 5, 0.5, -10)
    closeButton.BackgroundColor3 = Color3.new(1, 0, 0)
    closeButton.Text = "X"
    closeButton.TextColor3 = Color3.new(1, 1, 1)
    closeButton.TextScaled = true
    closeButton.Font = Enum.Font.SourceSans
    closeButton.Parent = frame
    closeButton.ZIndex = 101

    local textLabel = Instance.new("TextLabel")
    textLabel.Name = "NotificationText"
    textLabel.Size = UDim2.new(1, -30, 1, 0)
    textLabel.Position = UDim2.new(0, 30, 0, 0)
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
        meteorTP.Size = UDim2.new(0, 20, 0, 20)
        meteorTP.Position = UDim2.new(0, 25, 0.5, -10)
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

function sunkenchesttp1()
    local playerGui = game.Players.LocalPlayer.PlayerGui
    local screenGui = playerGui:FindFirstChild("NotificationGui")

    if not screenGui then
        creategui()
        screenGui = playerGui:FindFirstChild("NotificationGui")
    end
    local mainFrame = screenGui:FindFirstChild("DragFrame")
    local scrollFrame = mainFrame:FindFirstChild("NotificationContainer")
    local uiListLayout = scrollFrame:FindFirstChild("UIList")

    local frame = Instance.new("Frame")
    frame.Name = "NotificationFrame"
    frame.Size = UDim2.new(1, -10, 0, 50)
    frame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    frame.BorderSizePixel = 0
    frame.Parent = scrollFrame
    frame.ZIndex = 101

    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 20, 0, 20)
    closeButton.Position = UDim2.new(0, 5, 0.5, -10)
    closeButton.BackgroundColor3 = Color3.new(1, 0, 0)
    closeButton.Text = "X"
    closeButton.TextColor3 = Color3.new(1, 1, 1)
    closeButton.TextScaled = true
    closeButton.Font = Enum.Font.SourceSans
    closeButton.Parent = frame
    closeButton.ZIndex = 101

    local tpButton1 = Instance.new("TextButton")
    tpButton1.Name = "tpButton1"
    tpButton1.Size = UDim2.new(0, 20, 0, 20)
    tpButton1.Position = UDim2.new(0.15, 5, 0.5, -10)
    tpButton1.BackgroundColor3 = Color3.new(0.5, 0.9, 0.65)
    tpButton1.Text = "MW"
    tpButton1.TextColor3 = Color3.new(1, 1, 1)
    tpButton1.TextScaled = true
    tpButton1.Font = Enum.Font.SourceSans
    tpButton1.Parent = frame
    tpButton1.ZIndex = 101

    local tpButton2 = Instance.new("TextButton")
    tpButton2.Name = "tpButton2"
    tpButton2.Size = UDim2.new(0, 20, 0, 20)
    tpButton2.Position = UDim2.new(0.3, 5, 0.5, -10)
    tpButton2.BackgroundColor3 = Color3.new(0.5, 0.9, 0.65)
    tpButton2.Text = "RL"
    tpButton2.TextColor3 = Color3.new(1, 1, 1)
    tpButton2.TextScaled = true
    tpButton2.Font = Enum.Font.SourceSans
    tpButton2.Parent = frame
    tpButton2.ZIndex = 101

    local tpButton3 = Instance.new("TextButton")
    tpButton3.Name = "tpButton3"
    tpButton3.Size = UDim2.new(0, 20, 0, 20)
    tpButton3.Position = UDim2.new(0.45, 5, 0.5, -10)
    tpButton3.BackgroundColor3 = Color3.new(0.5, 0.9, 0.65)
    tpButton3.Text = "SS"
    tpButton3.TextColor3 = Color3.new(1, 1, 1)
    tpButton3.TextScaled = true
    tpButton3.Font = Enum.Font.SourceSans
    tpButton3.Parent = frame
    tpButton3.ZIndex = 101
 
    local tpButton4 = Instance.new("TextButton")
    tpButton4.Name = "tpButton4"
    tpButton4.Size = UDim2.new(0, 20, 0, 20)
    tpButton4.Position = UDim2.new(0.6, 5, 0.5, -10)
    tpButton4.BackgroundColor3 = Color3.new(0.5, 0.9, 0.65)
    tpButton4.Text = "TP"
    tpButton4.TextColor3 = Color3.new(1, 1, 1)
    tpButton4.TextScaled = true
    tpButton4.Font = Enum.Font.SourceSans
    tpButton4.Parent = frame
    tpButton4.ZIndex = 101

    local tpButton5 = Instance.new("TextButton")
    tpButton5.Name = "tpButton5"
    tpButton5.Size = UDim2.new(0, 20, 0, 20)
    tpButton5.Position = UDim2.new(0.75, 5, 0.5, -10)
    tpButton5.BackgroundColor3 = Color3.new(0.5, 0.9, 0.65)
    tpButton5.Text = "MG"
    tpButton5.TextColor3 = Color3.new(1, 1, 1)
    tpButton5.TextScaled = true
    tpButton5.Font = Enum.Font.SourceSans
    tpButton5.Parent = frame
    tpButton5.ZIndex = 101

    local tpButton6 = Instance.new("TextButton")
    tpButton6.Name = "tpButton6"
    tpButton6.Size = UDim2.new(0, 20, 0, 20)
    tpButton6.Position = UDim2.new(0.9, 5, 0.5, -10)
    tpButton6.BackgroundColor3 = Color3.new(0.5, 0.9, 0.65)
    tpButton6.Text = "FS"
    tpButton6.TextColor3 = Color3.new(1, 1, 1)
    tpButton6.TextScaled = true
    tpButton6.Font = Enum.Font.SourceSans
    tpButton6.Parent = frame
    tpButton6.ZIndex = 101

    closeButton.MouseButton1Click:Connect(function()
        frame:Destroy()
    end)

    tpButton1.MouseButton1Click:Connect(function()
        game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(562, 130, 76))
    end)

    tpButton2.MouseButton1Click:Connect(function()
        game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(-1854, 165, 404))
    end)

    tpButton3.MouseButton1Click:Connect(function()
        game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(-1303, 130, -1140))
    end)

    tpButton4.MouseButton1Click:Connect(function()
        game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(312, 130, 2128))
    end)

    tpButton5.MouseButton1Click:Connect(function()
        game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(2573, 133, -974))
    end)

    tpButton6.MouseButton1Click:Connect(function()
        game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(-2460, 130, 2047))
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
    local screenGui = playerGui:FindFirstChild("NotificationGui")

    if not screenGui then
        creategui()
        screenGui = playerGui:FindFirstChild("NotificationGui")
    end
    local mainFrame = screenGui:FindFirstChild("DragFrame")
    local scrollFrame = mainFrame:FindFirstChild("NotificationContainer")
    local uiListLayout = scrollFrame:FindFirstChild("UIList")

    local frame = Instance.new("Frame")
    frame.Name = "NotificationFrame"
    frame.Size = UDim2.new(1, -10, 0, 50)
    frame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    frame.BorderSizePixel = 0
    frame.Parent = scrollFrame
    frame.ZIndex = 101

    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 20, 0, 20)
    closeButton.Position = UDim2.new(0, 5, 0.5, -10)
    closeButton.BackgroundColor3 = Color3.new(1, 0, 0)
    closeButton.Text = "X"
    closeButton.TextColor3 = Color3.new(1, 1, 1)
    closeButton.TextScaled = true
    closeButton.Font = Enum.Font.SourceSans
    closeButton.Parent = frame
    closeButton.ZIndex = 101

    local tpButton = Instance.new("TextButton")
    tpButton.Name = "tpButton"
    tpButton.Size = UDim2.new(0.8, 0, 0, 20)
    tpButton.Position = UDim2.new(0.15, 5, 0.5, -10)
    tpButton.BackgroundColor3 = Color3.new(0.4, 0.6, 1)
    tpButton.Text = "TP to Chest"
    tpButton.TextColor3 = Color3.new(1, 1, 1)
    tpButton.TextScaled = true
    tpButton.Font = Enum.Font.SourceSans
    tpButton.Parent = frame
    tpButton.ZIndex = 101

    closeButton.MouseButton1Click:Connect(function()
        frame:Destroy()
    end)

    tpButton.MouseButton1Click:Connect(function()
        game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(position)
    end)

    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, uiListLayout.AbsoluteContentSize.Y)
end

function issunkenchest(uptime)
    local hours, minutes = uptime:match("^(%d+):(%d+):%d+$")
    hours = tonumber(hours)
    minutes = tonumber(minutes)
    
    local totalMinutes = (hours * 60) + minutes
    
    local modValue = totalMinutes % 70

    if modValue >= 60 and modValue < 70 then
        return true
    else
        return false
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

    if issunkenchest(uptime) then
        table.insert(events, {text = "Sunken Chest", r = 255, g = 255, b = 102, enabled = sunkenchestList.enabled})
    end

    return events
end

function notify(events)
    local count = 0
    for _, event in ipairs(events) do
        if event.enabled == true then
            notifygui(event.text, event.r, event.g, event.b)
            count = count + 1
            if event.text == "Sunken Chest" then
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
    local events = scanWorld()
    notify(events)
end

if autoscan then
    scan()
end

if autowebhook then
    sendwebhook()
end

local activeChestsFolder = game:GetService("Workspace").ActiveChestsFolder
local connection

function connectChildAdded()
    if connection then return end
    connection = activeChestsFolder.ChildAdded:Connect(function(object)
        if sunkenchestList.alertonload then
            sunkenchesttp2(object)
        end
    end)
end

connectChildAdded()

task.wait(20)
loading.loading.skip.Visible = true
