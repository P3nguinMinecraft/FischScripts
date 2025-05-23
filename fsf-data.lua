local version = "2.8.3"
local versid = "ZUGuSXdLaXCtwVwC"
local updmsg = "+Added LEGO Event"
local changelog = "+LEGO Event"
local settingchanged = true
local settingmsg = ""
local link = "https://discord.gg/fWncS2vFx"

local placeids = {
    sea1 = 16732694052,
    sea2 = 72907489978215,
}

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

local eggcoords1 = {
    {name = "Cozy Cabin Egg", x = 499, y = 160, z = 235},
    {name = "Arch Egg", x = 1063, y = 303, z = -1218},
    {name = "Molten Egg", x = -1914, y = 189, z = 251},
    {name = "Fossil Egg", x = 5909, y = 171, z = 461},
    {name = "Coral Cluster Egg", x = -3486, y = -100, z = 498},
    {name = "Keeper\226\128\153s Egg", x = 1375, y = -803, z = -104},
    {name = "Terrapin Egg", x = 69, y = 215, z = 2048},
    {name = "Shroom Egg", x = 2607, y = 171, z = -756},
    {name = "Vertigo Egg", x = 102, y = -706, z = 1157},
    {name = "Baby Glow Egg", x = -13848, y = -11086, z = 193},
    {name = "Volcano Burst Egg", x = -1983, y = 627, z = 262, spawns = "VolcanoBurstEggSpawns"},
    {name = "Vent Egg", x = -1802, y = 126, z = 147, spawns = "VentEggSpawns"},
    {name = "Meteor Egg", x = 5694, y = 174, z = 632, criteria = "Spawns inside a meteor"},
    {name = "Shark Frenzy Egg", x = 382, y = 135, z = 244, criteria = "Spawns during Shark Hunts (Not supported)"},
    {name = "Aurora Egg", x = 19736, y = 435, z = 5337, spawns = "AuroraEggSpawns", criteria = "Spawns during Aurora"},
}

local eggcoords2 = {
    {name = "Hidden House Egg", x = 141, y = 127, z = 639},
    {name = "Lighthouse Egg", x = 1411, y = 206, z = 488},
    {name = "Lava Egg", x = 3388, y = 184, z = 208},
    {name = "Azure Egg", x = 1599, y = 72, z = 2381},
    {name = "Lush Night Egg", x = 1522, y = 165, z = -672, spawns = "LushNightEggSpawns", criteria = "Spawn at night"},
    {name = "Summer Isle Egg", x = -532, y = 78, z = -337, spawns = "SummerIsleEggSpawns", criteria = "Spawns during summer"},
    {name = "Leviathan Egg", x = 427, y = 84, z = 779, spawns = "-", criteria = "Spawns at Leviathan Hunts (Not supported)"},
    {name = "Cursed Egg", x = -99, y = 82, z = 2112, spawns = "CursedEggSpawns", criteria = "Spawns at night during winter"},
}

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

local zoneData = { -- Area Coords
    zones1 = {
        ["Abyssal Zenith"] = {x = -230, y = -1, z = 3},
        ["Atlantean Storm"] = {x = 20, y = 53, z = -50},
        ["Ancient Archives"] = {x = 0, y = 0, z = 20},
        ["Ancient Isle Ocean"] = {x = 0, y = 60, z = -40},
        ["Ancient Isle Pond"] = {x = 0, y = -5, z = 0},
        ["Blue Moon - First Sea"] = {x = -15, y = 10, z = 0},
        ["Brine Pool"] = {x = 0, y = 3, z = 0},
        ["Calm Zone"] = {x = 35, y = 70, z = 0},
        ["Challengers Deep"] = {x = 0, y = 65, z = 0},
        ["Cryogenic Canal"] = {x = 5, y = 0, z = 0},
        ["Deep Ocean"] = {x = 0, y = -83, z = 0},
        ["Desolate Deep"] = {x = -840, y = -10, z = 230},
        ["Ethereal Abyss"] = {x = -33, y = 0, z = 0},
        ["Forsaken Shores"] = {x = 0, y = 15, z = 0},
        ["Forsaken Shores Ocean"] = {x = 0, y = 0, z = 230},
        ["Forsaken Shores Pond"] = {x = -5, y = 5, z = 5},
        ["Forsaken Veil"] = {x = 30, y = 75, z = 30},
        ["Frigid Cavern"] = {x = 0, y = 5, z = 0},
        ["Glacial Grotto"] = {x = 0, y = 5, z = -20},
        ["Grand Reef"] = {x = 0, y = 0, z = 0},
        ["Harvesters Spike"] = {x = -65, y = 90, z = -140},
        ["Keepers Altar"] = {x = 50, y = 93, z = 30},
        ["Kraken Pool"] = {x = 45, y = 40, z = 0},
        ["Lava"] = {x = -150, y = 65, z = 122},
        ["Moosewood Docks"] = {x = 0, y = 50, z = 0},
        ["Moosewood Ocean"] = {x = 0, y = 10, z = 0},
        ["Moosewood Ocean Mythical"] = {x = 0, y = 50, z = 0},
        ["Mosoewood Pond"] = {x = 15, y = 5, z = 5},
        ["Mushgrove Water"] = {x = 0, y = 65, z = -10},
        ["Ocean"] = {x = 2100, y = -35, z = 4000},
        ["Overgrowth Caves"] = {x = 0, y = 0, z = -20},
        ["Poseidon Pool"] = {x = 0, y = 0, z = 0},
        ["Roslit Bay"] = {x = 15, y = 0, z = 0},
        ["Roslit Bay Clam"] = {x = -35, y = 60, z = 0},
        ["Roslit Bay Ocean"] = {x = -55, y = 0, z = 0},
        ["Roslit Pond"] = {x = 10, y = 0, z = 0},
        ["Roslit Pond Seaweed"] = {x = 0, y = -8, z = 0},
        ["Scallop Ocean"] = {x = 0, y = -80, z = 0},
        ["Snowcap Ocean"] = {x = 150, y = 22, z = 0},
        ["Snowcap Pond"] = {x = 0, y = -6, z = 0},
        ["Sunken's Depth"] = {x = 20, y = 0, z = 10},
        ["Sunstone"] = {x = 25, y = 100, z = 0},
        ["Sunstone Hidden"] = {x = 0, y = 90, z = 5},
        ["Terrapin Ocean"] = {x = -75, y = 100, z = 0},
        ["Terrapin Olm"] = {x = 20, y = 30, z = 0},
        ["The Arch"] = {x = 95, y = 100, z = 25},
        ["The Depths"] = {x = -260, y = 30, z = 105},
        ["Vertigo"] = {x = 5, y = 70, z = 30},
        ["Volcanic Vents"] = {x = -50, y = 83, z = 65},
        ["Zeus Pool"] = {x = -10, y = 10, z = 10},
    },
    eventzones1 = {
        ["Megalodon Default"] = {x = 0, y = -20, z = 0},
        ["Megalodon Ancient"] = {x = 0, y = -20, z = 0},
        ["Forsaken Veil - Scylla"] = {x = 0, y = 75, z = -140},
        ["The Kraken Pool"] = {x = 0, y = 60, z = 0},
        ["Ancient Kraken Pool"] = {x = 0, y = 60, z = 0},
        ["Isonade"] = {x = 0, y = 85, z = 0},
        ["Great White Shark"] = {x = 0, y = 85, z = 0}, -- Needs Testing
        ["Great Hammerhead Shark"] = {x = 0, y = 85, z = 0}, -- Needs Testing
        ["Whale Shark"] = {x = 0, y = 85, z = 0}, -- Needs Testing
        ["The Depths - Serpent"] = {x = 0, y = -10, z = 0}, -- Needs testing
        ["Orcas Pool"] = {x = 0, y = 60, z = 0},
        ["Ancient Orcas Pool"] = {x = 0, y = 60, z = 0},
        ["Whales Pool"] = {x = 0, y = 60, z = 0},
        ["Notes Island Pool"] = {x = 0, y = 10, z = 0},
        ["LEGO"] = {x = 0, y = 0, z = 0},
        ["LEGO - Studolodon"] = {x = 0, y = 0, z = 0},
    },

    zones2 = {
        ["Azure Lagoon"] = {x = -45, y = 10, z = -10},
        ["Blue Moon - Second Sea"] = {x = 0, y = 0, z = 0}, -- Need Data
        ["Emberreach"] = {x = -730, y = 0, z = 0},
        ["Emberreach Lava"] = {x = -110, y = 20, z = -80},
        ["Emberreach Ponds"] = {x = 0, y = 10, z = 110},
        ["Isle of New Beginnings"] = {x = -10, y = 10, z = 0},
        ["Lushgrove"] = {x = -20, y = 10, z = 0},
        ["Open Ocean"] = {x = 0, y = 0, z = 0},
        ["Pine Shoal"] = {x = -115, y = 20, z = 10},
        ["The Cursed Shores"] = {x = 0, y = 20, z = 10},
        ["Waveborne"] = {x = 0, y = 20, z = 5},
    },
    eventzones2 = {
        ["Open Ocean - Sea Leviathan"] = {x = 0, y = 0, z = 0}, -- I AM PURELY GUESSING THAT THIS EXISTS
    },
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
        ["Aurora Borealis"] = false,
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
        enabled = false,
        min = 8,
    },

    versionList = {
        enabled = false,
        version = "x.x",
    },

    placeVersionList = {
        beforeVersion = {
            enabled = false,
            version = 0,
        },

        afterVersion = {
            enabled = false,
            version = 0,
        },

        orLogic = true,
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

    zoneList = { -- Server Hopper
        ["Megalodon Default"] = false,
        ["Megalodon Ancient"] = false,
        ["Forsaken Veil - Scylla"] = false,
        ["The Kraken Pool"] = false,
        ["Ancient Kraken Pool"] = false,
        ["Isonade"] = false,
        ["Great White Shark"] = false,
        ["Great Hammerhead Shark"] = false,
        ["Whale Shark"] = false,
        ["The Depths - Serpent"] = false,
        ["Orcas Pool"] = false,
        ["Ancient Orcas Pool"] = false,
        ["Whales Pool"] = false,
        ["Moby"] = false,
        ["Open Ocean - Sea Leviathan"] = false,
        ["LEGO"] = false,
        ["LEGO - Studolodon"] = false,
    },

    meteorList = {
        ["Amethyst"] = false,
        ["Ruby"] = false,
        ["Opal"] = false,
        ["Lapis Lazuli"] = false,
        ["Moonstone"] = false,
    },

    sunkenchestList = {
        enabled = false,
        bufferbefore = 1,
        alertonload = false,
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
    zoneList = { -- Server Hopper
        "Megalodon Default", "Megalodon Ancient",
        "Forsaken Veil - Scylla",
        "The Kraken Pool", "Ancient Kraken Pool",
        "Isonade",
        "Great White Shark", "Great Hammerhead Shark", "Whale Shark",
        "The Depths - Serpent",
        "Orcas Pool", "Ancient Orcas Pool",
        "Whales Pool", "Moby",
        "Open Ocean - Sea Leviathan",
        "LEGO", "LEGO - Studolodon",
    },
    meteorList = {"Amethyst", "Ruby", "Opal", "Lapis Lazuli", "Moonstone"},

    zones1 = { -- Areas
        "Abyssal Zenith", "Atlantean Storm", "Ancient Archives", "Ancient Isle Ocean", "Ancient Isle Pond",
        "Blue Moon - First Sea", "Brine Pool", "Calm Zone", "Challengers Deep", "Cryogenic Canal", "Deep Ocean",
        "Desolate Deep", "Ethereal Abyss", "Forsaken Shores", "Forsaken Shores Ocean", "Forsaken Shores Pond",
        "Forsaken Veil", "Frigid Cavern", "Glacial Grotto", "Grand Reef", "Harvesters Spike", "Keepers Altar",
        "Kraken Pool", "Lava", "Moosewood Docks", "Moosewood Ocean", "Moosewood Ocean Mythical", "Moosewood Pond",
        "Mushgrove Water", "Ocean", "Overgrowth Caves", "Poseidon Pool", "Roslit Bay", "Roslit Bay Clam",
        "Roslit Bay Ocean", "Roslit Pond", "Roslit Pond Seaweed", "Scallop Ocean", "Snowcap Ocean",
        "Snowcap Pond", "Sunken's Depth", "Sunstone", "Sunstone Hidden", "Terrapin Ocean", "Terrapin Olm",
        "The Arch", "The Depths", "Vertigo", "Volcanic Vents", "Zeus Pool",
    },
    eventzones1 = {
        "Megalodon Default", "Megalodon Ancient",
        "Forsaken Veil - Scylla",
        "The Kraken Pool", "Ancient Kraken Pool",
        "Isonade",
        "Great White Shark", "Great Hammerhead Shark", "Whale Shark",
        "The Depths - Serpent",
        "Orcas Pool", "Ancient Orcas Pool",
        "Whales Pool",
        "Notes Island Pool",
        "LEGO", "LEGO - Studolodon",
    },

    zones2 = {
        "Azure Lagoon", "Blue Moon - Second Sea",
        "Emberreach", "Emberreach Lava", "Emberreach Ponds", "Isle of New Beginnings",
        "Lushgrove", "Open Ocean", "Pine Shoal", "The Cursed Shores", "Waveborne",
    },
    eventzones2 = {
        "Open Ocean - Sea Leviathan",
        "Animal Pool - Second Sea", "Octophant Pool Without Elephant", "Octophant Pool With Elephant",
    },
}

local defaultFishConfig = {
    autocast = false,
    dropbobber = true,
    autoshake = false,
    autoreel = false,
    instantreel = false,
    castpower = 0,
    shakenav = true,
    perfectCatch = false,
    reelSelect = "None",
    reelWhitelistStr = "",
    reelBlacklistStr = "",
}

local defaultGuiConfig = {
    -- Tools
    disablewaterfog = false,
    fullbright = false,
    antigp = false,
    instantinteract = false,
    antiafk = false,

    -- Player
    disableoxygen = false,
    disableoxygenpeaks = false,
    disabletemperaturepeaks = false,
    disabletemperatureveil = false,
    disabledrownremote = false,
    disabledamage = false,
    disablecutscenes = false,
    disablevignette = false,
    antiswim = false,
    freezecharacter = false,

    -- World
    hideability = false,
    hidefishmodels = false,
    disable3drender = false,

    -- Areas
    zonetoggle = false,
    eventzonetoggle = false,
    zones1 = {
        ["Abyssal Zenith"] = false,
        ["Atlantean Storm"] = false,
        ["Ancient Archives"] = false,
        ["Ancient Isle Ocean"] = false,
        ["Ancient Isle Pond"] = false,
        ["Blue Moon - First Sea"] = false,
        ["Brine Pool"] = false,
        ["Calm Zone"] = false,
        ["Challengers Deep"] = false,
        ["Cryogenic Canal"] = false,
        ["Deep Ocean"] = false,
        ["Desolate Deep"] = false,
        ["Ethereal Abyss"] = false,
        ["Forsaken Shores"] = false,
        ["Forsaken Shores Ocean"] = false,
        ["Forsaken Shores Pond"] = false,
        ["Forsaken Veil"] = false,
        ["Frigid Cavern"] = false,
        ["Glacial Grotto"] = false,
        ["Grand Reef"] = false,
        ["Harvesters Spike"] = false,
        ["Keepers Altar"] = false,
        ["Kraken Pool"] = false,
        ["Lava"] = false,
        ["Moosewood Docks"] = false,
        ["Moosewood Ocean"] = false,
        ["Moosewood Ocean Mythical"] = false,
        ["Moosewood Pond"] = false,
        ["Mushgrove Water"] = false,
        ["Ocean"] = false,
        ["Overgrowth Caves"] = false,
        ["Poseidon Pool"] = false,
        ["Roslit Bay"] = false,
        ["Roslit Bay Clam"] = false,
        ["Roslit Bay Ocean"] = false,
        ["Roslit Pond"] = false,
        ["Roslit Pond Seaweed"] = false,
        ["Scallop Ocean"] = false,
        ["Snowcap Ocean"] = false,
        ["Snowcap Pond"] = false,
        ["Sunken's Depth"] = false,
        ["Sunstone"] = false,
        ["Sunstone Hidden"] = false,
        ["Terrapin Ocean"] = false,
        ["Terrapin Olm"] = false,
        ["The Arch"] = false,
        ["The Depths"] = false,
        ["Vertigo"] = false,
        ["Volcanic Vents"] = false,
        ["Zeus Pool"] = false,
    },
    eventzones1 = {
        ["Megalodon Default"] = false,
        ["Megalodon Ancient"] = false,
        ["Forsaken Veil - Scylla"] = false,
        ["The Kraken Pool"] = false,
        ["Ancient Kraken Pool"] = false,
        ["Isonade"] = false,
        ["Great White Shark"] = false,
        ["Great Hammerhead Shark"] = false,
        ["Whale Shark"] = false,
        ["The Depths - Serpent"] = false,
        ["Orcas Pool"] = false,
        ["Ancient Orcas Pool"] = false,
        ["Whales Pool"] = false,
        ["Notes Island Pool"] = false,
        ["LEGO"] = false,
        ["LEGO - Studolodon"] = false,
    },

    zones2 = {
        ["Azure Lagoon"] = false,
        ["Blue Moon - Second Sea"] = false,
        ["Emberreach"] = false,
        ["Emberreach Lava"] = false,
        ["Emberreach Ponds"] = false,
        ["Isle of New Beginnings"] = false,
        ["Lushgrove"] = false,
        ["Open Ocean"] = false,
        ["Pine Shoal"] = false,
        ["The Cursed Shores"] = false,
        ["Waveborne"] = false,
    },
    eventzones2 = {
        ["Open Ocean - Sea Leviathan"] = false,
    },

    -- Auto
    autosell = false,
}

local data = {
    version = version,
    versid = versid,
    updmsg = updmsg,
    changelog = changelog,
    settingchanged = settingchanged,
    settingmsg = settingmsg,
    link = link,
    placeids = placeids,
    sunkenchestcoords = sunkenchestcoords,
    codes = codes,
    zoneblacklist = {},
    --zoneblacklist = zoneblacklist,
    zoneData = zoneData,
    defaultConfig = defaultConfig,
    ordered = ordered,
    defaultFishConfig = defaultFishConfig,
    defaultGuiConfig = defaultGuiConfig,

    eggcoords = {
        [1] = eggcoords1,
        [2] = eggcoords2,
    }
}

return data