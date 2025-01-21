-- CONFIG

autoscan = true
autohop = true
autowebhook = true
webhookUrl = "https://discord.com/api/webhooks/1312274005755166830/idzwoxkk4WYi9HU4RAjhalRK3T8J0uA_FsEF6kaRMlbBqpiMx8WP3O1f9lQlu2JnlUbq"
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
    {name = "Aurora Borealis",          enabled = false},
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
    {name = "Megalodon Default",        enabled = false},
    {name = "Megalodon Ancient",        enabled = false},
    {name = "Great White Shark",        enabled = false},
    {name = "Great Hammerhead Shark",   enabled = false},
    {name = "Whale Shark",              enabled = false},
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
    {name = "Amethyst", enabled = false},
    {name = "Ruby", enabled = false},
    {name = "Opal", enalbed = false},
    {name = "Lapis Lazuli", enabled = false},
    {name = "Moonstone", enabled = true},
}

sunkenchestList = {
    enabled = true,
    alertonload = true,
}

autouptime = true

loadstring(game:HttpGet("https://raw.githubusercontent.com/P3nguinMinecraft/FischScripts/refs/heads/main/fischserverfindercode"))()
