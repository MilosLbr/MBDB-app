using System;
using System.Collections.Generic;
using System.Linq;
using System.Data.Entity;
using System.Net;
using System.Net.Http;
using System.Security.Claims;
using System.Web.Http;
using MBDBapp.Models;
using MBDBapp.Models.Dto;
using Microsoft.AspNet.Identity;
using AutoMapper;

namespace MBDBapp.Controllers.Api
{
    [Authorize]
    public class WatchListController : ApiController
    {

        private MoviesContext _context;

        public WatchListController()
        {
            _context = new MoviesContext();
        }

        // Get
        public IHttpActionResult Get()
        {

            var userIdValue = User.Identity.GetUserId();

            var userFromDb = _context.AspNetUsers.Single(u => u.Id.Equals(userIdValue));

            var usersFilms = userFromDb.tblFilms.ToList();

            var watchList = Mapper.Map<AspNetUser, UserDto>(userFromDb);


            return Ok(watchList);
                
        }

        // Add film Id to watchlist of curent user
        [HttpPost]
        public IHttpActionResult InsertFilmToWatchList(int Id)
        {
            var userId = User.Identity.GetUserId();

            var filmToAdd = _context.Films.Single(f => f.FilmID.Equals(Id));

            var currentUser = _context.AspNetUsers.Include(u => u.tblFilms).Single(u => u.Id.Equals(userId));

            if (currentUser.tblFilms.Contains(filmToAdd))
                return BadRequest("Film already added");

            currentUser.tblFilms.Add(filmToAdd);

            _context.SaveChanges();

            return Ok();
        }

        // Delete by film id 
        [HttpDelete]
        public IHttpActionResult Delete(int Id)
        {
            var usrID = User.Identity.GetUserId();

            var userFromDb = _context.AspNetUsers.Include(u => u.tblFilms).Single(u => u.Id.Equals(usrID));
            var filmToRemove = userFromDb.tblFilms.Single(f => f.FilmID == Id);

            userFromDb.tblFilms.Remove(filmToRemove);

            _context.SaveChanges();

            return Ok();
        }
    }
}
