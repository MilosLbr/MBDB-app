// Load comments for current Film

function loadComments() {
    $.ajax({
        url: commentsUrl + movieId
    }).then(data => {
        let numberOfComments = data.length;
        $("#numberOfComments").html(numberOfComments);

        $(data).each((ind, elem) => {

            let comment = $("<div>", { "class": "comment" });
            let date = formatDate(new Date(elem.dateAdded));

            let commentAuthor = $("<span>", { "class": "commentAuthor" }).text(elem.userName);
            let dateAdded = $("<span>", { "class": "dateAdded" }).text(date);
            let authorAndDate = $("<div>", { "class": "flex-column authorAndDate" });
            authorAndDate.append(commentAuthor, dateAdded);

            let commentContent = $("<p>", { "class": "commentContent" }).text(elem.commentContent);
            comment.append(authorAndDate, commentContent);

            commentsContainer.append(comment);
        })
    });
}
