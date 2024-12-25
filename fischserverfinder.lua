-- copy this code into your executor! then change the configs
-- CONFIG

autohop = true

eventList = {
    {name = "Night of the Fireflies",   enabled = false},
    {name = "Night of the Luminous",    enabled = true},
    {name = "Shiny Surge",              enabled = true},
    {name = "Mutation Surge",           enabled = true},
}

weatherList = {
    {name = "Clear",                    enabled = false},
    {name = "Foggy",                    enabled = false},
    {name = "Windy",                    enabled = false},
    {name = "Rain",                     enabled = false},
    {name = "Eclipse",                  enabled = false},
    {name = "Aurora Borealis",          enabled = true},
}

zoneList = {
    {name = "Megalodon Default",        enabled = true},
    {name = "Megalodon Ancient",        enabled = true},
    {name = "Great White Shark",        enabled = true},
    {name = "Great Hammerhead Shark",   enabled = true},
    {name = "Whale Shark",              enabled = true},
}

luckList = {
    min = 2,
    enabled = true,
}

meteorList = {
    enabled = true,
}

--

loadstring(game:HttpGet('https://raw.githubusercontent.com/P3nguinMinecraft/FischServerFinder/refs/heads/main/source.lua'))()