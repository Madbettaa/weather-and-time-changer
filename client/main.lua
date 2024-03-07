local display = true

Weathers = {
    "EXTRASUNNY" ,
    "CLEAR" ,
    "CLEARING" ,
    "OVERCAST" ,
    "SMOG" ,
    "FOGGY" ,
    "CLOUDS" ,
    "RAIN" ,
    "THUNDER" ,
    "SNOW" ,
    "BLIZZARD" ,
    "SNOWLIGHT" ,
    "XMAS" ,
    "HALLOWEEN" ,
}

Times = {
    "00:00",
    "01:00",
    "02:00",
    "03:00",
    "04:00",
    "05:00",
    "06:00",
    "07:00",
    "08:00",
    "09:00",
    "10:00",
    "11:00",
    "12:00",
    "13:00",
    "14:00",
    "15:00",
    "16:00",
    "17:00",
    "18:00",
    "19:00",
    "20:00",
    "21:00",
    "22:00",
    "23:00",
}


RegisterCommand("OpenWT", function()
    display = not display 
    open(display)
end, false)

function setWeather(weather)
    ClearOverrideWeather()
    ClearWeatherTypePersist()
    SetWeatherTypePersist(weather)
    SetWeatherTypeNow(weather)
    SetWeatherTypeNowPersist(weather)
end

function open(bool)
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        type = "ui",
        status = bool,
        weathers = Weathers,
        times = Times,
    })
end

Citizen.CreateThread(function()
    local serverid = GetPlayerServerId(PlayerId())
    while true do
        Citizen.Wait(0)

        local hour = GetClockHours()
        local minute = GetClockMinutes()

        if hour < 10 then
            hour = '0'..hour
        end
        if minute < 10 then
            minute = '0'..minute
        end
        local time = hour .. ":" .. minute
        SendNUIMessage({
            type = "main",
            time = time,
        })
        Citizen.Wait(1000)
    end
end)

function setTime(time)
    local hour, minute = time:match("([^:]+):([^:]+)")
    NetworkOverrideClockTime(tonumber(hour), tonumber(minute), 0)
end

RegisterNUICallback("setWeatherAndTime", function(data)
    print("Received data from UI:", json.encode(data))
    setWeather(data.weather)
    setTime(data.time)
end)

