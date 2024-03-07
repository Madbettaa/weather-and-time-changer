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
        }
    })

    window.addEventListener('message', function(event) {
        if (event.data.type === "main") {
            $('#time').text(event.data.time);
            $('#weather').text(event.data.weather);
        }
    })

});