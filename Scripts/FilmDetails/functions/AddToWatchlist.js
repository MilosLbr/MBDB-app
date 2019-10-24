// Add to watchlist event handler for addtowatchlist button

function addToWatchList() {
    $.ajax({
        url: watchListUrl + movieId,
        method: "POST",
    })
        .done(function () {
            toastr.success("Added " + movieName + " to WatchList!");
        })
        .fail(data => {
            if (data.responseJSON.message == "Film is already added to WatchList!") {
                toastr.error("Film is already added to WatchList!")
            } else {
                toastr.error("Error adding movie to WatchList")
            }
        })
}