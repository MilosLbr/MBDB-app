using System;
using System.Collections.Generic;
using System.Linq;
using System.Data.Entity;
using System.Security.Principal;
using System.Text;
using System.Threading.Tasks;
using System.Web;
using MBDB_datalib;
using MBDB_datalib.Dto;
using MBDB_repositories.Interfaces;
using Microsoft.AspNet.Identity;
using AutoMapper;


namespace MBDB_repositories.Implementation
{
    public class UserRepository : Repository<AspNetUser>, IUserRepository
    {
        public UserRepository(MoviesContext context) : base(context)
        {
        }

        public LikeDislikeDto LikeAFilm(int Id)
        {
            var filmLikesAndDislikes = Dbcontext.FilmLikesAndDislikes1;

            var userId = HttpContext.Current.User.Identity.GetUserId();
            var user = Dbcontext.AspNetUsers.Single(u => u.Id.Equals(userId));

            var filmFromDb = Dbcontext.Films.Single(f => f.FilmID.Equals(Id));

            // in db values are stored as bytes : 1 == true, 0 == false
            var userLikedFilm = user.FilmLikesAndDislikes.SingleOrDefault(f => f.FilmID.Equals(Id) && f.UserID.Equals(userId));

            byte isLiked = (byte)(userLikedFilm == null ? 0 : userLikedFilm.IsLiked);
            byte isDisliked = (byte)(userLikedFilm == null ? 0 : userLikedFilm.IsDisliked);

            if (isLiked == 1)
            {
                return null;
            }
            else if (isDisliked == 1)
            {
                // user first disliked, now wants to like this movie
                filmFromDb.FilmLikes++;
                filmFromDb.FilmDislikes--;
                userLikedFilm.IsDisliked = 0;
                userLikedFilm.IsLiked = 1;

                Dbcontext.SaveChanges();

                var likeDislikeDto = new LikeDislikeDto
                {
                    FilmLikes = filmFromDb.FilmLikes,
                    FilmDislikes = filmFromDb.FilmDislikes,
                    Message = "Liked!"
                };

                return likeDislikeDto;
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

                Dbcontext.SaveChanges();

                var likeDislikeDto = new LikeDislikeDto
                {
                    FilmLikes = filmFromDb.FilmLikes,
                    FilmDislikes = filmFromDb.FilmDislikes,
                    Message = "Liked!"
                };

                return likeDislikeDto;
            }
        }

        public LikeDislikeDto DislikeAFilm(int Id)
        {
            var filmLikesAndDislikes = Dbcontext.FilmLikesAndDislikes1;

            var userId = HttpContext.Current.User.Identity.GetUserId();
            var user = Dbcontext.AspNetUsers.Single(u => u.Id.Equals(userId));

            var filmFromDb = Dbcontext.Films.Single(f => f.FilmID.Equals(Id));

            // in db values are stored as bytes : 1 == true, 0 == false
            var userLikedFilm = user.FilmLikesAndDislikes.SingleOrDefault(f => f.FilmID.Equals(Id) && f.UserID.Equals(userId));

            byte isLiked = (byte)(userLikedFilm == null ? 0 : userLikedFilm.IsLiked);
            byte isDisliked = (byte)(userLikedFilm == null ? 0 : userLikedFilm.IsDisliked);

            if (isDisliked == 1)
            {
                return null;
            }
            else if (isLiked == 1)
            {
                // user first liked, now wants to dislike this movie
                filmFromDb.FilmLikes--;
                filmFromDb.FilmDislikes++;
                userLikedFilm.IsDisliked = 1;
                userLikedFilm.IsLiked = 0;

                Dbcontext.SaveChanges();

                var likeDislikeDto = new LikeDislikeDto
                {
                    FilmLikes = filmFromDb.FilmLikes,
                    FilmDislikes = filmFromDb.FilmDislikes,
                    Message = "Disliked!"
                };

                return likeDislikeDto;
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

                Dbcontext.SaveChanges();

                var likeDislikeDto = new LikeDislikeDto
                {
                    FilmLikes = filmFromDb.FilmLikes,
                    FilmDislikes = filmFromDb.FilmDislikes,
                    Message = "Disliked!"
                };

                return likeDislikeDto;
            }
        }

        public UserDto GetUsersWatchlist()
        {
            var userId = HttpContext.Current.User.Identity.GetUserId();

            var userFromDb = Dbcontext.AspNetUsers.Include(u => u.tblFilms).SingleOrDefault(u => u.Id.Equals(userId));

            return Mapper.Map<AspNetUser, UserDto>(userFromDb);
        }

        public bool AddFilmToWatchList(int filmId)
        {
            var userId = HttpContext.Current.User.Identity.GetUserId();

            var currentUser = Dbcontext.AspNetUsers.SingleOrDefault(u => u.Id.Equals(userId));
            var filmToAdd = Dbcontext.Films.Find(filmId);

            if (currentUser.tblFilms.Contains(filmToAdd))
                return true;

            currentUser.tblFilms.Add(filmToAdd);

            return false;

        }

        public MoviesContext Dbcontext
        {
            get { return Context as MoviesContext; }
        }


    }
}
