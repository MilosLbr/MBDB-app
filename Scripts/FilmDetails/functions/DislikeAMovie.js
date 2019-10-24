// Event handler for dislike button

function dislikeMovie() {
    $.ajax({
        url: "/api/films/dislike/" + movieId,
    })
        .done(data => {
            toastr.success(data.message);
            $("#numOfLikes").text(data.filmLikes);
            $("#numOfDislikes").text(data.filmDislikes);
        })
        .fail(msg => {
            toastr.error(msg.responseJSON.message);
        })
}