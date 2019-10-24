let watchListUrl, addToWatchListBtn, omdbapi, commentsUrl, movieName, movieId, commentsContainer, postBtn, likeBtn, dislikeBtn;


function initializeFilmDetails(model) {

    // URLs
    watchListUrl = "/api/watchlist/";
    commentsUrl = "/api/comments/";
    omdbapi = "https://www.omdbapi.com/?apikey=e0fb59d&t=";

    // Movie data
    movieName = model.FilmName;
    movieId = model.FilmID;

    // initialize dom elements
    addToWatchListBtn = $("#addToWatchListBtn");
    likeBtn = $("#likeButton");
    dislikeBtn = $("#dislikeButton");
    commentsContainer = $("#commentsContainer");
    postBtn = $("#postComment");
        
    // Call initial functions
    addOmdbData();
    loadComments();
    
    // Add event listeners
    addToWatchListBtn.on("click", addToWatchList);
    postBtn.on("click", postNewComment);
    likeBtn.on("click", likeMovie);
    dislikeBtn.on("click", dislikeMovie);
}
