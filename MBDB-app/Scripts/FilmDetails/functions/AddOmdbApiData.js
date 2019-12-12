// Add images, poster and genre from omdb api

function addOmdbData() {
    $.ajax({
        url: omdbapi + movieName,
    }).then(data => {

        // $("#genres").html(data.Genre)

        $("#mainInfo img").attr('src', data.Poster);

        $("#ratings").children().each((ind, elem) => {
            elem.innerText += " " + data.Ratings[ind].Value;
        });

    });
}