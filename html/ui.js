$(function () {
    const container = $(".container");

    container.hide();

    function display(bool) {
        if (bool) {
            container.fadeIn(1000);
            $(".system-actions").hide();
        } else {
            container.fadeOut(500);
        }
    }

    display(false);

    window.addEventListener('message', function (event) {
        if (event.data.type === "ui") {
            display(event.data.status);

            document.onkeyup = function (data) {
                if (data.which === 27) {
                    emitNui("closeUi");
                }
            };

            const chooseWeatherElement = $("#ChooseWeather");
            const chooseTimeElement = $("#ChooseTime");

            chooseWeatherElement.empty();
            chooseTimeElement.empty();

            event.data.weathers.forEach(function (weather) {
                chooseWeatherElement.append($("<option>", { text: weather }));
            });

            event.data.times.forEach(function (time) {
                chooseTimeElement.append($("<option>", { text: time }));
            });
        } else if (event.data.type === "main") {
            $('#time').text(event.data.time);
        }
    });

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
            console.error("Error:", error);
        }
    }

    $('#CChanges').on('click', function () {
        const selectedWeather = $("#ChooseWeather").val();
        const selectedTime = $("#ChooseTime").val();

        console.log("Selected Weather:", selectedWeather);
        console.log("Selected Time:", selectedTime);

        emitNui("setWeatherAndTime", { weather: selectedWeather, time: selectedTime });
    });
});
