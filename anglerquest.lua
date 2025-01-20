local gui = game.Players.LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("QuestGui")
if gui then
    gui:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "QuestGui"
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Name = "DraggableFrame"
frame.Size = UDim2.new(0, 220, 0, 140)
frame.Position = UDim2.new(0.5, -110, 0.5, -70)
frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

local button1 = Instance.new("TextButton")
button1.Name = "QuestButton"
button1.Size = UDim2.new(0, 200, 0, 50)
button1.Position = UDim2.new(0, 10, 0, 10)
button1.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
button1.Text = "Depths Angler Quest"
button1.TextColor3 = Color3.fromRGB(255, 255, 255)
button1.Font = Enum.Font.SourceSans
button1.TextSize = 24
button1.Parent = frame

button1.MouseButton1Click:Connect(function()
    workspace:WaitForChild("world"):WaitForChild("npcs"):WaitForChild("The Depths Angler"):WaitForChild("angler"):WaitForChild("giveQuest"):InvokeServer()
end)

local button2 = Instance.new("TextButton")
button2.Name = "CompleteQuestButton"
button2.Size = UDim2.new(0, 200, 0, 50)
button2.Position = UDim2.new(0, 10, 0, 70)
button2.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
button2.Text = "Complete Quest"
button2.TextColor3 = Color3.fromRGB(255, 255, 255)
button2.Font = Enum.Font.SourceSans
button2.TextSize = 24
button2.Parent = frame

button2.MouseButton1Click:Connect(function()
    workspace:WaitForChild("world"):WaitForChild("npcs"):WaitForChild("The Depths Angler"):WaitForChild("angler"):WaitForChild("questCompleted"):InvokeServer()
end)
