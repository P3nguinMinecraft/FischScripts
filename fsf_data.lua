local version = "1.4.1"
local versid = "NzD95YZ9eegJEElp"
local msg = "Config changes!"
local link = "https://raw.githubusercontent.com/P3nguinMinecraft/FischScripts/refs/heads/main/fischserverfinderscript"

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

local defaultConfig = {
    autoscan = true,

    autowebhook = false,
    webhookUrl = "https://discord.com/api/webhooks/#/#",

    filename = "servers",

    autohop = false,

    infoList = {
        autouptime = false,
        autoversion = false,
        autoplaceversion = false,
    },

    eventList = {
        {name = "Night of the Fireflies",   enabled = false},
        {name = "Night of the Luminous",    enabled = false},
        {name = "Shiny Surge",              enabled = false},
        {name = "Mutation Surge",           enabled = false},
    },

    weatherList = {
        {name = "Clear",                    enabled = false},
        {name = "Foggy",                    enabled = false},
        {name = "Windy",                    enabled = false},
        {name = "Rain",                     enabled = false},
        {name = "Eclipse",                  enabled = false},
        {name = "Aurora Borealis",          enabled = true},
    },

    cycleList = {
        {name = "Day",                      enabled = false},
        {name = "Night",                    enabled = false},
    },

    seasonList = {
        {name = "Spring",                   enabled = false},
        {name = "Summer",                   enabled = false},
        {name = "Fall",                     enabled = false},
        {name = "Winter",                   enabled = false},
    },

    zoneList = {
        {name = "Megalodon Default",        enabled = true},
        {name = "Megalodon Ancient",        enabled = true},
        {name = "Great White Shark",        enabled = false},
        {name = "Great Hammerhead Shark",   enabled = false},
        {name = "Whale Shark",              enabled = false},
        {name = "The Kraken Pool",          enabled = true},
        {name = "Ancient Kraken Pool",      enabled = true},
        {name = "Orcas Pool",               enabled = true},
        {name = "Ancient Orcas Pool",       enabled = true},
        {name = "Lovestorm Eel",            enabled = true},
        {name = "Lovestorm Eel Supercharged", enabled = true},
    },

    luckList = {
        min = 8,
        enabled = true,
    },

    meteorList = {
        {name = "Amethyst",                 enabled = false},
        {name = "Ruby",                     enabled = false},
        {name = "Opal",                     enabled = false},
        {name = "Lapis Lazuli",             enabled = false},
        {name = "Moonstone",                enabled = true},
    },

    sunkenchestList = {
        enabled = true,
        bufferbefore = 1,
        alertonload = true,
        autofarm = false,
        hopafterclaim = false,
        forcehop = false,
    },

    uptimeList = {
        beforeTime = {
            enabled = false,
            hour = 0,
            minute = 0,
        },

        afterTime = {
            enabled = false,
            hour = 8,
            minute = 0,
        },

        orLogic = true,
    },

    versionList = {
        enabled = false,
        version = "x.x",
    },

    placeVersionList = {
        enabled = false,
        version = 1234,
    },

    version = "1.4.1",
    versid = "NzD95YZ9eegJEElp",
}

return version, versid, msg, link, sunkenchestcoords, defaultConfig
