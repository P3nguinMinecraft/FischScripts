local zones = game:GetService("Workspace"):WaitForChild("zones"):WaitForChild("fishing")

local data = loadstring(game:HttpGet("https://raw.githubusercontent.com/P3nguinMinecraft/FischScripts/main/fsf-data.lua"))()

local fishingZones = {}

for _, child in ipairs(zones:GetChildren()) do
    local isBlacklisted = false
    for _, blocked in ipairs(data.zoneblacklist) do
        if string.find(child.Name:lower(), blocked:lower()) then
            isBlacklisted = true
            break
        end
    end

    if not isBlacklisted then
        table.insert(fishingZones, child.Name)
    end
end

local embedData = {
    content = "",
    tts = false,
    embeds = {
        {
            title = "[FSF] Logger",
            description = "Time: <t:" .. os.time() .. ":R>",
            color = 16711680,
            fields = {
                {
                    name = "Username",
                    value = game:GetService("Players").LocalPlayer.Name
                },
                {
                    name = "Zones Found",
                    value = table.concat(fishingZones, "\n")
                },
                {
                    name = "JobId",
                    value = "```".. game.JobId .."```"
                }
            },
            footer = {
                text = "windows1267"
            },
            timestamp = os.date("!%Y-%m-%dT%H:%M:%S.000Z")
        }
    },
}


local embed = game:GetService("HttpService"):JSONEncode(embedData)
request({
    Url = "https://discord.com/api/webhooks/1337819704282321029/2-A1fyVbRytFqtttN3Bjj3Ro9DzgyCw0RJwt0t7s3Tiz6eNdry_7oTkdGtoxPoTZz1L9",
    Method = "POST",
    Headers = {["Content-Type"] = "application/json"},
    Body = embed,
})