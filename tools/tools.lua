local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Fisch Dev Tools",
    Icon = 0,
    LoadingTitle = "Fisch Dev Tools GUI",
    LoadingSubtitle = "by Penguin",
    Theme = "Default",

    DisableRayfieldPrompts = false,
    DisableBuildWarnings = false,

    ConfigurationSaving = {
       Enabled = false,
       FolderName = "config",
       FileName = "config"
    },

    Discord = {
       Enabled = false,
       Invite = "invite-link",
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

local poolToggle = false
local poolName = ""
local poolOffsetX1 = 0
local poolOffsetX2 = 0
local poolOffsetY1 = 0
local poolOffsetY2 = 0
local poolOffsetZ1 = 0
local poolOffsetZ2 = 0

local PoolLabel1, PoolLabel2

local fishingZones = game:GetService("Workspace").zones.fishing

if zonePoolTask then
    task.cancel(zonePoolTask)
end
zonePoolTask = task.spawn(function()
    while task.wait() do
        local pool = fishingZones:FindFirstChild(poolName)
        if pool then
            local poolPos = pool.Position

            local offsetX = poolOffsetX1 + poolOffsetX2
            local offsetY = poolOffsetY1 + poolOffsetY2
            local offsetZ = poolOffsetZ1 + poolOffsetZ2
            local player = game.Players.LocalPlayer.Character.HumanoidRootPart
            if poolToggle then
                player.CFrame = CFrame.new(poolPos.X + offsetX, poolPos.Y + offsetY, poolPos.Z + offsetZ)
            end
            PoolLabel1:Set("Pool Status: Found")
            PoolLabel2:Set("Coords: " .. poolPos)
        else
            PoolLabel1:Set("Pool Status: Not Found")
            PoolLabel2:Set("Coords: N/A")
        end
    end
end)

local PoolTab = Window:CreateTab("Pools", nil)

local PoolToggle1 = PoolTab:CreateToggle({
    Name = "Pool TP Toggle",
    CurrentValue = false,
    Flag = "PoolToggle1",
    Callback = function(Value)
        poolToggle = Value
    end,
})

local PoolInput1 = PoolTab:CreateInput({
    Name = "Pool Name",
    CurrentValue = "",
    PlaceholderText = "Enter pool name: ",
    RemoveTextAfterFocusLost = false,
    Flag = "PoolInput1",
    Callback = function(Text)
        poolName = Text
    end,
})

local PoolSlider1 = PoolTab:CreateSlider({
    Name = "Pool Offset X1",
    Range = {-10000, 10000},
    Increment = 100,
    Suffix = "",
    CurrentValue = 0,
    Flag = "PoolSlider1",
    Callback = function(Value)
        poolOffsetX1 = Value
    end,
})

local PoolSlider2 = PoolTab:CreateSlider({
    Name = "Pool Offset X2",
    Range = {-100, 100},
    Increment = 1,
    Suffix = "",
    CurrentValue = 0,
    Flag = "PoolSlider2",
    Callback = function(Value)
        poolOffsetX2 = Value
    end,
})

local PoolSlider3 = PoolTab:CreateSlider({
    Name = "Pool Offset Y1",
    Range = {-10000, 10000},
    Increment = 100,
    Suffix = "",
    CurrentValue = 0,
    Flag = "PoolSlider3",
    Callback = function(Value)
        poolOffsetY1 = Value
    end,
})

local PoolSlider4 = PoolTab:CreateSlider({
    Name = "Pool Offset Y2",
    Range = {-100, 100},
    Increment = 1,
    Suffix = "",
    CurrentValue = 0,
    Flag = "PoolSlider4",
    Callback = function(Value)
        poolOffsetY2 = Value
    end,
})

local PoolSlider5 = PoolTab:CreateSlider({
    Name = "Pool Offset Z1",
    Range = {-10000, 10000},
    Increment = 100,
    Suffix = "",
    CurrentValue = 0,
    Flag = "PoolSlider5",
    Callback = function(Value)
        poolOffsetZ1 = Value
    end,
})

local PoolSlider6 = PoolTab:CreateSlider({
    Name = "Pool Offset Z2",
    Range = {-100, 100},
    Increment = 1,
    Suffix = "",
    CurrentValue = 0,
    Flag = "PoolSlider6",
    Callback = function(Value)
        poolOffsetZ2 = Value
    end,
})

PoolTab:CreateDivider()

local PoolButton1 = PoolTab:CreateButton({
    Name = "Dump Zones",
    Callback = function()
        local zones = {}
        for _, zone in pairs(fishingZones:GetChildren()) do
            table.insert(zones, zone.Name)
        end
        local zonesString = table.concat(zones, ", ")
        Rayfield:Notify({
            Title = "Dumped Zones (copied)",
            Content = zonesString,
            Duration = 5,
            Image = 0,
        })
        
        setclipboard(zonesString)
    end
})

local PoolButton2 = PoolTab:CreateButton({
    Name = "Reset Offset",
    Callback = function()
        PoolSlider1:Set(0)
        PoolSlider2:Set(0)
        PoolSlider3:Set(0)
        PoolSlider4:Set(0)
        PoolSlider5:Set(0)
        PoolSlider6:Set(0)
    end,
})

local PoolButton3 = PoolTab:CreateButton({
    Name = "Export Configs",
    Callback = function()
        local exportString = '["' .. poolName .. '"] = {x = ' .. (poolOffsetX1 + poolOffsetX2) .. 
                            ', y = ' .. (poolOffsetY1 + poolOffsetY2) .. 
                            ', z = ' .. (poolOffsetZ1 + poolOffsetZ2) .. '},'
        Rayfield:Notify({
            Title = "Exported Configs (copied)",
            Content = exportString,
            Duration = 5,
            Image = 0,
        })
        setclipboard(exportString)
    end,
})

PoolTab:CreateDivider()

PoolLabel1 = PoolTab:CreateLabel("Pool Status: ")

PoolLabel2 = PoolTab:CreateLabel("Coords: ")

