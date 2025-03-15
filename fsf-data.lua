local version = "2.3.6"
local versid = "MksaNgiTlAmdYYli"
local updmsg = "+Update to new game data"
local settingchanged = true
local settingmsg = "+ Leprechaun event fish! Discord if lucky chests work (same as sunken)"
local link = "https://discord.gg/fWncS2vFx"

local sunkenchestcoords = {
-- Moosewood
    {x = 936, y = 130, z = -159},
    {x = 693, y = 130, z = -362},
    {x = 613, y = 130, z = 498},
    {x = 285, y = 130, z = 564},
    {x = 283, y = 130, z = -159},
-- Roslit Bay
    {x = -1179, y = 130, z = 565},
    {x = -1217, y = 130, z = 201},
    {x = -1967, y = 130, z = 980},
    {x = -2444, y = 130, z = 266},
    {x = -2444, y = 130, z = -37},
-- Sunstone Island
    {x = -852, y = 130, z = -1560},
    {x = -1000, y = 130, z = -751},
    {x = -1500, y = 130, z = -750},
    {x = -1547, y = 130, z = -1080},
    {x = -1618, y = 130, z = -1560},
-- Terrapin Island
    {x = 798, y = 130, z = 1667},
    {x = 562, y = 130, z = 2455},
    {x = 393, y = 130, z = 2435},
    {x = -1, y = 130, z = 1632},
    {x = -190, y = 130, z = 2450},
-- Mushgrove Swamp
    {x = 2890, y = 130, z = -997},
    {x = 2729, y = 130, z = -1098},
    {x = 2410, y = 130, z = -1110},
    {x = 2266, y = 130, z = -721},
-- Forsaken Shores
    {x = -2460, y = 130, z = 2047},
} -- coords sourced from Fisch Wiki

local codes = {
    "THEKRAKEN",
    "CARBON",
    "SORRYGUYS",
    "ATLANTEANSTORM",
    "GOLDENTIDE",
    "NewYear",
    "FISCHMASDAY",
    "NorthernExpedition",
    "MERRYFISCHMAS",
    "RFG",
    "SorryReward",
}

local zoneblacklist = {
    "Moosewood",
    "Ocean",
    "Roslit",
    "Snowcap",
    "Mushgrove",
    "Sunstone",
    "Desolate",
    "Harvesters",
    "Ancient Isle",
    "Forsaken",
    "Depths",
    "Terrapin",
    "Archives",
    "Arch",
    "Atlantean",
    "Canal",
    "Vertigo",
    "Isonade",
    "Lava",
}

local defaultConfig = {
    autoscan = true,
    autohop = false,

    autowebhook = false,
    webhookUrl = "https://discord.com/api/webhooks/#/#",

    filename = "servers",

    infoList = {
        autouptime = false,
        autoversion = false,
        autoplaceversion = false,
    },

    weatherList = {
        ["Clear"] = false,
        ["Foggy"] = false,
        ["Windy"] = false,
        ["Rain"] = false,
        ["Eclipse"] = false,
        ["Aurora Borealis"] = true,
    },

    eventList = {
        ["Night of the Fireflies"] = false,
        ["Night of the Luminous"] = false,
        ["Shiny Surge"] = false,
        ["Mutation Surge"] = false,
    },

    seasonList = {
        ["Spring"] = false,
        ["Summer"] = false,
        ["Fall"] = false,
        ["Winter"] = false,
    },

    cycleList = {
        ["Day"] = false,
        ["Night"] = false,
    },

    luckList = {
        enabled = true,
        min = 8,
    },

    versionList = {
        enabled = false,
        version = "x.x",
    },

    placeVersionList = {
        enabled = false,
        version = 1234,
    },
    
    uptimeList = {
        beforeTime = {
            enabled = false,
            hour = 0,
            minute = 0,
        },

        afterTime = {
            enabled = false,
            hour = 0,
            minute = 0,
        },

        orLogic = true,
    },

    zoneList = {
        ["Megalodon Default"] = true,
        ["Megalodon Ancient"] = true,
        ["Great White Shark"] = false,
        ["Great Hammerhead Shark"] = false,
        ["Whale Shark"] = false,
        ["The Kraken Pool"] = false,
        ["Ancient Kraken Pool"] = true,
        ["Orcas Pool"] = true,
        ["Ancient Orcas Pool"] = true,
        ["Forsaken Veil - Scylla"] = true,
        ["Whales Pool"] = false,
        ["Moby"] = true,
        ["Rowdy McCharm"] = true,
        ["O'Mango Goldgrin"] = true,
        ["Sunny O'Coin"] = true,
        ["Blarney McBreeze"] = true,
        ["Plumrick O'Luck"] = true,
    },

    meteorList = {
        ["Amethyst"] = false,
        ["Ruby"] = false,
        ["Opal"] = false,
        ["Lapis Lazuli"] = false,
        ["Moonstone"] = true,
    },

    sunkenchestList = {
        enabled = true,
        bufferbefore = 1,
        alertonload = true,
        autofarm = false,
        hopafterclaim = false,
        forcehop = false,
    },

    version = version,
    versid = versid,
}

local ordered = {
    weatherList = {"Clear", "Foggy", "Windy", "Rain", "Eclipse", "Aurora Borealis",},
    eventList = {"Night of the Fireflies", "Night of the Luminous", "Shiny Surge", "Mutation Surge",},
    seasonList = {"Spring", "Summer", "Fall", "Winter",},
    cycleList = {"Day", "Night",},
    zoneList = {
        "Megalodon Default", "Megalodon Ancient",
        "Great White Shark", "Great Hammerhead Shark", "Whale Shark", 
        "The Kraken Pool", "Ancient Kraken Pool",
        "Orcas Pool", "Ancient Orcas Pool",
        "Forsaken Veil - Scylla",
        "Whales Pool", "Moby",
        "Rowdy McCharm", "O'Mango Goldgrin", "Sunny O'Coin", "Blarney McBreeze", "Plumrick O'Luck",
    },
    meteorList = {"Amethyst", "Ruby", "Opal", "Lapis Lazuli", "Moonstone"},
}

local defaultFishConfig = {
    autocast = true,
    dropbobber = true,
    autoshake = true,
    autoreel = true,
    instantreel = false,
    castpower = 0,
    shakenav = true,
    perfectCatch = false,
    reelSelect = "None",
    reelWhitelistStr = "",
    reelBlacklistStr = "",
}

local defaultGuiConfig = {
    ToolsToggle1 = false,
    ToolsToggle2 = false,
    ToolsToggle3 = false,
}

local data = {
    version = version,
    versid = versid,
    updmsg = updmsg,
    settingchanged = settingchanged,
    settingmsg = settingmsg,
    link = link,
    sunkenchestcoords = sunkenchestcoords,
    codes = codes,
    zoneblacklist = zoneblacklist,
    defaultConfig = defaultConfig,
    ordered = ordered,
    defaultFishConfig = defaultFishConfig,
    defaultGuiConfig = defaultGuiConfig,
}

return data