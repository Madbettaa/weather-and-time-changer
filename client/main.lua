local display = false

local Weathers = {
    "EXTRASUNNY",
    "CLEAR",
    "CLEARING",
    "OVERCAST",
    "SMOG",
    "FOGGY",
    "CLOUDS",
    "RAIN",
    "THUNDER",
    "SNOW",
    "BLIZZARD",
    "SNOWLIGHT",
    "XMAS",
    "HALLOWEEN",
}

local Times = {}
for i = 0, 23 do
    Times[i + 1] = string.format("%02d:00", i)
end

local function setWeather(weather)
    ClearOverrideWeather()
    ClearWeatherTypePersist()
    SetWeatherTypePersist(weather)
    SetWeatherTypeNow(weather)
    SetWeatherTypeNowPersist(weather)
end

local function openUI(bool)
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        type = "ui",
        status = bool,
        weathers = Weathers,
        times = Times,
    })
end

local function formatTime(hour, minute)
    return string.format("%02d:%02d", hour, minute)
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        local hour = GetClockHours()
        local minute = GetClockMinutes()
        SendNUIMessage({
            type = "main",
            time = formatTime(hour, minute),
        })
    end
end)

local function setTime(time)
    local hour, minute = time:match("(%d+):(%d+)")
    NetworkOverrideClockTime(tonumber(hour), tonumber(minute), 0)
end

RegisterNUICallback("setWeatherAndTime", function(data)
    print("Received data from UI:", json.encode(data))
    setWeather(data.weather)
    setTime(data.time)
end)

RegisterNUICallback("closeUi", function(data)
    openUI(false)
    display = false
end)

RegisterCommand("OpenWT", function()
    display = not display 
    openUI(display)
end, false)
