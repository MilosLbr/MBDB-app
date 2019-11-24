using System;
using System.Collections.Generic;
using System.Linq;
using System.Data.Entity;
using System.Net;
using System.Net.Http;
using System.Security.Claims;
using System.Web.Http;
using MBDB_datalib;
using MBDB_repositories.Interfaces;
using MBDB_repositories.Implementation;
using MBDB_datalib.Dto;
using Microsoft.AspNet.Identity;
using AutoMapper;

namespace MBDBapp.Controllers.Api
{
    [Authorize]
    public class WatchListController : ApiController
    {

        private readonly IUnitOfWork _unitOfWork;

        public WatchListController(IUnitOfWork unitOfWork)
        {
            _unitOfWork = unitOfWork;
        }

        // Get
        public IHttpActionResult Get()
        {

            var userIdValue = User.Identity.GetUserId();

            var userFromDb = _unitOfWork.Users.SingleOrDefault(u => u.Id.Equals(userIdValue));

            var usersFilms = userFromDb.tblFilms.ToList();

            var watchList = Mapper.Map<AspNetUser, UserDto>(userFromDb);


            return Ok(watchList);
                
        }

        // Add film Id to watchlist of curent user
        [HttpPost]
        public IHttpActionResult InsertFilmToWatchList(int Id)
        {
            var userId = User.Identity.GetUserId();

            var filmToAdd = _unitOfWork.Films.Get(Id);

            var currentUser = _unitOfWork.Users.SingleOrDefault(u => u.Id.Equals(userId));

            if (currentUser.tblFilms.Contains(filmToAdd))
                return BadRequest("Film is already added to WatchList!");

            currentUser.tblFilms.Add(filmToAdd);

            _unitOfWork.Complete();

            return Ok();
        }

        // Delete by film id 
        [HttpDelete]
        public IHttpActionResult Delete(int Id)
        {
            var userId = User.Identity.GetUserId();

            var currentUser = _unitOfWork.Users.SingleOrDefault(u => u.Id.Equals(userId));
            var filmToRemove = currentUser.tblFilms.Single(f => f.FilmID == Id);

            currentUser.tblFilms.Remove(filmToRemove);

            _unitOfWork.Complete();

            return Ok();
        }
    }
}
