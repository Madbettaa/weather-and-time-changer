local display = true

RegisterCommand("testw", function()
    display = not display 
    open(display)
end, false)

function open(bool)
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        type = "ui",
        status = bool,
    })
end

function GetCurrentWeather()
    local weather = GetNextWeatherTypeHashName()

    if weather == "RAIN" then
        return "Rainy"
    elseif weather == "THUNDER" then
        return "Thunderstorm"
    elseif weather == "CLEAR" then
        return "Clear"
    elseif weather == "EXTRASUNNY" then
        return "Extra Sunny"
    elseif weather == "CLOUDS" then
        return "Cloudy"
    elseif weather == "SMOG" then
        return "Smog"
    elseif weather == "FOGGY" then
        return "Foggy"
    elseif weather == "XMAS" then
        return "Christmas"
    elseif weather == "SNOWLIGHT" then
        return "Snowing Lightly"
    elseif weather == "BLIZZARD" then
        return "Blizzard"
    elseif weather == "SNOW" then
        return "Snowing"
    else
        return "Unknown"
    end
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
      local currentWeather = GetCurrentWeather()
      SendNUIMessage({
        type = "main",
        time = time,
        weather = currentWeather
      })
      Citizen.Wait(1000)
    end
  end)
  



