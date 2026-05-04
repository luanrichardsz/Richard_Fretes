    document.addEventListener("mousemove", function (event) {
        var summary = document.querySelector(".dashboard-summary");

        if (!summary) {
            return;
        }

        var x = (window.innerWidth / 2 - event.clientX) / 70;
        var y = (window.innerHeight / 2 - event.clientY) / 70;

        summary.style.setProperty("--move-x", x + "px");
        summary.style.setProperty("--move-y", y + "px");
    });