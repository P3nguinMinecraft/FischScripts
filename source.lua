repeat task.wait(1) until game:IsLoaded()

local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

function teleport()
        notifygui("Teleporting", 22, 209, 242)
        local ServersAPI = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
        local Server, Next = nil, nil

        local function ListServers(cursor)
            local Raw = game:HttpGet(ServersAPI .. ((cursor and "&cursor=" .. cursor) or ""))
            local Decode = HttpService:JSONDecode(Raw)
            if Decode.errors then
                notifygui("API Overload", 255, 255, 255)
                return HttpService:JSONDecode(readfile("servers.json"))
            else
                writefile("servers.json", Raw)
                return Decode
            end
        end
        while Server == nil or Server.playing == nil do
            local Servers = ListServers(Next)
            if Servers and Servers.nextPageCursor then
                Server = Servers.data[math.random(1, 100)]
                Next = Servers.nextPageCursor
            else
            end
        end

        if Server and Server.playing < Server.maxPlayers and Server.id ~= game.JobId then
            TeleportService:TeleportToPlaceInstance(game.PlaceId, Server.id, game.Players.LocalPlayer)
        else
            notifygui("Failed Server Hop", 242, 44, 22)
            print(Server)
            print(Server.playing)
        end
end


local loading = game:GetService("Players").LocalPlayer.PlayerGui:WaitForChild("loading", 60).loading
function notifygui(text, r, g, b)
    local playerGui = game.Players.LocalPlayer.PlayerGui
    local screenGui = playerGui:FindFirstChild("NotificationGui")

    if not screenGui then
        loading.Visible = false
        screenGui = Instance.new("ScreenGui")
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
            loading.Visible = true
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

    if text == "Meteor" then
        local meteorTP = Instance.new("TextButton")
        meteorTP.Name = "meteorTP"
        meteorTP.Size = UDim2.new(0, 20, 0, 20)
        meteorTP.Position = UDim2.new(0, 5, 0.5, -10)
        meteorTP.BackgroundColor3 = Color3.new(1, 0, 0)
        meteorTP.Text = "Goto Meteor"
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

function scan()

    local event = game:GetService("ReplicatedStorage").world.event
    local weather = game:GetService("ReplicatedStorage").world.weather
    local luckServer = game:GetService("ReplicatedStorage").world.luck_Server
    local luckServerside = game:GetService("ReplicatedStorage").world.luck_ServerSide
    local luck = luckServer.Value + luckServerside.Value
    local meteor = game:GetService("ReplicatedStorage").world.meteor_active
    local zones = game:GetService("Workspace"):WaitForChild("zones"):WaitForChild("fishing")
    local notified = false


    for _, eventData in ipairs(eventList) do
        if eventData.enabled and eventData.name == event.Value then
            notifygui(eventData.name, 255, 255, 255)
            notified = true
        end
    end

    for _, weatherData in ipairs(weatherList) do
        if weatherData.enabled and weatherData.name == weather.Value then
            notifygui(weatherData.name, 255, 255, 255)
            notified = true
        end
        if weather.Value == "Aurora_Borealis" and weatherData.name == "Aurora Borealis" and weatherData.enabled then
            notifygui("Aurora Borealis", 160, 252, 180)
            notified = true
        end
    end

    if luck >= luckList.min and luckList.enabled then
        notifygui("Luck: x" .. luck, 88, 162, 91)
        notified = true
    end

    if meteor.Value == true and meteorList.enabled then
        notifygui("Meteor", 236, 103, 44)
        notified = true
    end

    for _, zoneData in ipairs(zoneList) do
        if zoneData.enabled and zones:FindFirstChild(zoneData.name) then
            if zoneData.name == "Megalodon Default" or zoneData.name == "Megalodon Ancient" then  
                notifygui(zoneData.name, 234, 51, 35)
            else
                notifygui(zoneData.name, 236, 104, 142)
            end
            notified = true
        end
    end

    if notified == false then
        notifygui("Nothing", 255, 153, 0)
        if autohop then teleport() end
    end

end

scan()
