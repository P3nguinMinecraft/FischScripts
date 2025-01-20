local on = true
----------------


local taskRunning = false
local gui = game.Players.LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("QuestGui")
if gui then
    gui:Destroy()
    taskRunning = false
end

if not on then return end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "QuestGui"
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Name = "DraggableFrame"
frame.Size = UDim2.new(0, 220, 0, 250)
frame.Position = UDim2.new(0.5, -110, 0.5, -100)
frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Size = UDim2.new(0, 200, 0, 40)
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.Text = "Welcome to AnglerQuest!"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Font = Enum.Font.SourceSans
titleLabel.TextScaled = true
titleLabel.BackgroundTransparency = 1
titleLabel.Parent = frame

local button1 = Instance.new("TextButton")
button1.Name = "QuestButton"
button1.Size = UDim2.new(0, 200, 0, 50)
button1.Position = UDim2.new(0, 10, 0, 50)
button1.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
button1.Text = "Depths Angler Quest"
button1.TextColor3 = Color3.fromRGB(255, 255, 255)
button1.Font = Enum.Font.SourceSans
button1.TextSize = 24
button1.Parent = frame

button1.MouseButton1Click:Connect(function()
    titleLabel.Text = "Quest Given!"
    givequest()
end)

local button2 = Instance.new("TextButton")
button2.Name = "CompleteQuestButton"
button2.Size = UDim2.new(0, 200, 0, 50)
button2.Position = UDim2.new(0, 10, 0, 110)
button2.BackgroundColor3 = Color3.fromRGB(200, 200, 100)
button2.Text = "Complete Quest"
button2.TextColor3 = Color3.fromRGB(255, 255, 255)
button2.Font = Enum.Font.SourceSans
button2.TextSize = 24
button2.Parent = frame

button2.MouseButton1Click:Connect(function()
    titleLabel.Text = "Attempted Complete Quest!"
    completequest()
end)

local button3 = Instance.new("TextButton")
button3.Name = "AutoQuestButton"
button3.Size = UDim2.new(0, 200, 0, 50)
button3.Position = UDim2.new(0, 10, 0, 170)
button3.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
button3.Text = "Auto Quest"
button3.TextColor3 = Color3.fromRGB(255, 255, 255)
button3.Font = Enum.Font.SourceSans
button3.TextSize = 24
button3.Parent = frame

button3.MouseButton1Click:Connect(function()
    toggleautoquest()
end)

local autoquest = false

function givequest()
    local angler = game:GetService("Workspace"):WaitForChild("world"):WaitForChild("npcs"):FindFirstChild("The Depths Angler")
    if angler then
       angler.angler.giveQuest:InvokeServer()
    else
       titleLabel.Text = "Angler NPC not found!"
    end
end

function completequest()
    local angler = game:GetService("Workspace"):WaitForChild("world"):WaitForChild("npcs"):FindFirstChild("The Depths Angler")
    if angler then
        angler.angler.questCompleted:InvokeServer()
    else
        titleLabel.Text = "Angler NPC not found!"
    end
end

function toggleautoquest()
    autoquest = not autoquest
    if autoquest then
        button3.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
    else
        button3.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    end
end

function getfish(fishname)
    local plrname = game:GetService("Players").LocalPlayer.Name
    local inventory = game:GetService("ReplicatedStorage").playerstats:WaitForChild(plrname).Inventory:GetChildren()

    for _, item in ipairs(inventory) do
        local itemname = item.Name
        if string.find(string.gsub(itemname, "-", ""), string.gsub(fishname, "-", "")) then
            local favorited = item:FindFirstChild("Favourited")
            if not favorited or favorited.Value == false then
                return itemname
            end
        end
    end
    print("None found in inventory")
    return nil
end

function getitem(fishname)
    local id = getfish(fishname)
    if id then
        local backpack = game:GetService("Players").LocalPlayer.Backpack:GetChildren()
        for _, item in ipairs(backpack) do
            if item.Name == fishname and item:FindFirstChild("link") then
                local linkid = tostring(item.link.Value)
                if string.match(string.gsub(linkid, "-", ""), string.gsub(id, "-", "")) then
                    return item
                end
            end
        end
    end
    print("None found in backpack")
    return nil
end

function equipfish(fishname)
    local item = getitem(fishname)
    if item then
        game:GetService("ReplicatedStorage"):WaitForChild("packages"):WaitForChild("Net"):WaitForChild("RE/Backpack/Equip"):FireServer(item)
        completequest()
        titleLabel.Text = "Completed " .. fishname
    else
        toggleautoquest()
        print("Could not find ".. fishname)
        titleLabel.Text = "Could not find " .. fishname
        print()
    end
end

local quests = game:GetService("Players").LocalPlayer.PlayerGui.hud.deviceinset.quests

function findfishreq()
    for _, quest in ipairs(quests:GetChildren()) do
        if quest:FindFirstChild("title") and quest:FindFirstChild("title").Text == "Angler Quest" then
            return tostring(quest.line1.Text)
        end
    end
    return nil
end

local taskCoroutine
function startTask()
    if taskRunning then return end
    taskRunning = true

    taskCoroutine = coroutine.create(function()
        while taskRunning do
            if autoquest then
                local fish = findfishreq()
                if fish then
                    print("Quest: " .. fish)
                    equipfish(fish)
                    givequest()
                    task.wait(1)
                end
                givequest()
            end
            task.wait(1)
        end
    end)
    coroutine.resume(taskCoroutine)
end

startTask()
