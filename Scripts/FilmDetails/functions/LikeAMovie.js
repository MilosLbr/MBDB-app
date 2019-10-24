// Event handler for like button

function likeMovie() {

    $.ajax({
        url: "/api/films/like/" + movieId,
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

