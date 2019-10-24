using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using System.Data.Entity;
using AutoMapper;
using MBDBapp.DBModels;
using MBDBapp.Models.Dto;
using Microsoft.AspNet.Identity;
using System.Web.Http.Results;

namespace MBDBapp.Controllers.Api
{
    [Authorize]
    public class FilmsController : ApiController
    {
        private MoviesContext _context;

        public FilmsController()
        {
            _context = new MoviesContext();
        }

        // GET: api/Films
        public IHttpActionResult Get()
        {
            var filmsFromDb = _context.Films.Include(f => f.tblDirector)
                    .Include(f => f.tblCasts.Select(cas => cas.tblActor))
                    .ToList()
                    .Select(Mapper.Map<Film,FilmDto>);

            return Ok(filmsFromDb);
        }

        // GET: api/Films/5
        public IHttpActionResult Get(int id)
        {

            var filmFromDb = _context.Films.Include(f => f.tblDirector).Single(f => f.FilmID == id);

            return Ok(Mapper.Map<Film, FilmDto>(filmFromDb));
        }

        // GET : api/films/like/id
        [HttpGet]
        [Route("api/films/like/{Id}")]
        public IHttpActionResult LikeFilm(int Id)
        {
            var filmLikesAndDislikes = _context.FilmLikesAndDislikes1;

            var userId = User.Identity.GetUserId();
            var user = _context.AspNetUsers.Single(u => u.Id.Equals(userId));

            var filmFromDb = _context.Films.Single(f => f.FilmID.Equals(Id));

            // in db values are stored as bytes : 1 == true, 0 == false
            var userLikedFilm = user.FilmLikesAndDislikes.SingleOrDefault(f => f.FilmID.Equals(Id) && f.UserID.Equals(userId));

            byte isLiked = (byte)(userLikedFilm == null ? 0 : userLikedFilm.IsLiked);
            byte isDisliked = (byte)(userLikedFilm == null ? 0 : userLikedFilm.IsDisliked);
                       

            if (isLiked == 1)
            {
                return BadRequest("You have already liked this film!");
            }
            else if(isDisliked == 1)
            {
                // user first disliked, now wants to like this movie
                filmFromDb.FilmLikes++;
                filmFromDb.FilmDislikes--;
                userLikedFilm.IsDisliked = 0;
                userLikedFilm.IsLiked = 1;

                _context.SaveChanges();

                var filmObject = new
                {
                    filmLikes = filmFromDb.FilmLikes,
                    filmDislikes = filmFromDb.FilmDislikes,
                    message = "Liked!"
                };

                return Ok(filmObject);
            }
            else
            {
                filmFromDb.FilmLikes++;

                filmLikesAndDislikes.Add(new FilmLikesAndDislikes
                {
                    FilmID = Id,
                    UserID = userId,
                    IsLiked = 1,
                    IsDisliked = 0
                });

                _context.SaveChanges();

                var filmObject = new
                {
                    filmLikes = filmFromDb.FilmLikes,
                    filmDislikes = filmFromDb.FilmDislikes,
                    message = "Liked!"
                };

                return Ok(filmObject);
            }

        }
        
        // GET : api/films/dislike/id
        [HttpGet]
        [Route("api/films/dislike/{Id}")]
        public IHttpActionResult DislikeFilm(int Id)
        {
            var filmLikesAndDislikes = _context.FilmLikesAndDislikes1;

            var userId = User.Identity.GetUserId();
            var user = _context.AspNetUsers.Single(u => u.Id.Equals(userId));

            var filmFromDb = _context.Films.Single(f => f.FilmID.Equals(Id));

            // in db values are stored as bytes : 1 == true, 0 == false
            var userLikedFilm = user.FilmLikesAndDislikes.SingleOrDefault(f => f.FilmID.Equals(Id) && f.UserID.Equals(userId));

            byte isLiked = (byte)(userLikedFilm == null ? 0 : userLikedFilm.IsLiked);
            byte isDisliked = (byte)(userLikedFilm == null ? 0 : userLikedFilm.IsDisliked);

            if(isDisliked == 1)
            {
                return BadRequest("You have already disliked this film!");
            }
            else if(isLiked == 1)
            {
                // user first liked, now wants to dislike this movie
                filmFromDb.FilmLikes--;
                filmFromDb.FilmDislikes++;
                userLikedFilm.IsDisliked = 1;
                userLikedFilm.IsLiked = 0;

                _context.SaveChanges();

                var filmObject = new
                {
                    filmLikes = filmFromDb.FilmLikes,
                    filmDislikes = filmFromDb.FilmDislikes,
                    message = "Disliked!"
                };

                return Ok(filmObject);
            }
            else
            {
                filmFromDb.FilmDislikes++;

                filmLikesAndDislikes.Add(new FilmLikesAndDislikes
                {
                    FilmID = Id,
                    UserID = userId,
                    IsLiked = 0,
                    IsDisliked = 1
                });

                _context.SaveChanges();

                var filmObject = new
                {
                    filmLikes = filmFromDb.FilmLikes,
                    filmDislikes = filmFromDb.FilmDislikes,
                    message = "Disliked!"
                };

                return Ok(filmObject);
            }

        }
    }
}
