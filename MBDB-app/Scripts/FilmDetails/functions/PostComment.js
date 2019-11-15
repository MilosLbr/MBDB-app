// Post new comment

function postNewComment() {
    let textArea = $("#commentContent");

    let commentData = {
        commentFilmID: movieId,
        commentContent: textArea.val()
    };

    $.ajax({
        url: commentsUrl,
        method: "POST",
        data: commentData
    })
        .done(() => {
            toastr.success("Succesfuly posted!");
            textArea.val("");
            $("#commentsContainer").html("");
            loadComments();
        })
        .fail((msg) => {
            toastr.error(msg.responseJSON.message);
        });
}