$(function () {
    $(".container").hide();
    function display(bool) {
        if (bool) {
            $(".container").fadeIn(1000);
            $(".system-actions").hide();
        } else {
            $(".container").fadeOut(500);
        }
    }

    display(false)

    window.addEventListener('message', function(event) {
        if (event.data.type === "ui") {
            if (event.data.status == true) {
                display(true)
            } else {
                display(false)
            }
            

            var selectElement = document.getElementById("ChooseWeather");
            selectElement.innerHTML = "";
                event.data.weathers.forEach(function(weather) {
                    var option = document.createElement("option");
                    option.text = weather;
                    selectElement.appendChild(option);
                });
            var selectElement = document.getElementById("ChooseTime");
            selectElement.innerHTML = "";
                event.data.times.forEach(function(time) {
                        var option = document.createElement("option");
                        option.text = time;
                        selectElement.appendChild(option);
            });
      }})

    window.addEventListener('message', function(event) {
        if (event.data.type === "main") {
            $('#time').text(event.data.time);
        }
    })

    async function emitNui(event, data = {}) {
        const url = `https://${GetParentResourceName()}/${event}`;
        try {
            const res = await fetch(url, {
                method: "POST",
                headers: {
                    "Content-Type": "application/json; charset=UTF-8",
                },
                body: JSON.stringify(data),
            });
            const responseData = await res.json();
            return responseData;
        } catch (error) {
            console.error(error);
        }
    }

    $('#CChanges').on('click', function() {
        var selectedWeather = document.getElementById("ChooseWeather").value;
        var selectedTime = document.getElementById("ChooseTime").value;
        console.log("Selected Weather:", selectedWeather);
        console.log("Selected Time:", selectedTime);
        emitNui("setWeatherAndTime", { weather: selectedWeather, time: selectedTime });
    });
    

});